import 'package:customer_app/data/booking/booking_api.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/booking_model.dart';
import 'package:customer_app/models/customer_booking/CustomerBookingModel.dart';
import 'package:mobx/mobx.dart';

part 'booking_store.g.dart';

class BookingStore = _BookingStore with _$BookingStore;

abstract class _BookingStore with Store {
  final BookingApi _api = BookingApi();

  @observable
  List<CustomerBookingModel> bookings = [];

  @observable
  String? referenceId = null;

  @observable
  BookingModel? booking = null;

  @observable
  bool loading = false;

  @observable
  String? message = null;

  void clear() {
    message = null;
  }

  @action
  Future<void> createBooking(int farmstayId) async {
    clear();
    referenceId = null;
    loading = true;

    final result = await _api.createBooking(farmstayId);
    await result.fold(
        (errorMessage) => message = errorMessage, (r) => referenceId = r);

    logger.i("Create booking: $referenceId");
    if (message != null) {
      logger.e("Error message Create booking: $message}");
    }

    loading = false;
  }

  @action
  Future<void> getBookingByReferenceId(String refId) async {
    clear();
    booking = null;
    loading = true;

    final result = await _api.getBookingByReferenceId(refId);
    await result.fold((errorMessage) => message = errorMessage, (r) {
      booking = r;
      message = null;
    });

    logger.i("Get booking by ref: ${booking?.toJson().toString()}");
    if (message != null) {
      logger.e("Error message Get booking: $message");
    }

    loading = false;
  }

  @action
  Future<void> getCustomerBookings() async {
    clear();
    booking = null;
    loading = true;

    final result = await _api.getAllCustomerBookings();
    await result.fold(
        (errorMessage) => message = errorMessage, (r) => bookings = r);

    logger.i("Get customer bookings: ${bookings}");
    if (message != null) {
      logger.e("Error message Get customer bookings: $message");
    }

    loading = false;
  }

  @action
  Future<String?> payBooking(int bookingId, String ipAddress) async {
    clear();
    loading = true;

    String? url = null;
    final result = await _api.payBooking(bookingId, ipAddress);
    await result.fold((errorMessage) => message = errorMessage, (r) => url = r);

    logger.i("Booking get pay url: $url");
    if (message != null) {
      logger.e("Error message get url failed: $message}");
    }

    loading = false;
    return url;
  }

  @action
  Future<void> getBookingById(int id) async {
    clear();
    booking = null;
    loading = true;

    final result = await _api.getBookingById(id);
    await result.fold((errorMessage) => message = errorMessage, (r) {
      booking = r;
    });

    logger.i("Get booking by id: ${booking?.toJson().toString()}");
    if (message != null) {
      logger.e("Error message Get booking: $message");
    }

    loading = false;
  }
}
