import 'package:customer_app/data/booking/booking_api.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/booking_detail/booking_detail_model.dart';
import 'package:customer_app/models/booking_model.dart';
import 'package:customer_app/models/customer_booking/CustomerBookingModel.dart';
import 'package:customer_app/models/refund_model.dart';
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
  BookingDetailModel? bookingDetail = null;

  @observable
  BookingModel? booking = null;

  @observable
  RefundDetail? refundDetail = null;

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
    loading = true;

    final result = await _api.getBookingById(id);
    await result.fold((errorMessage) {
      message = errorMessage;
      bookingDetail = null;
    }, (r) {
      bookingDetail = r;
    });

    logger.i("Get booking by id: ${bookingDetail?.toJson().toString()}");
    if (message != null) {
      logger.e("Error message Get bookingby id: $message");
    }

    loading = false;
  }

  @action
  Future<void> getBookingRefundDetail(int id) async {
    clear();
    loading = true;

    final result = await _api.getBookingRefundDetail(id);
    await result.fold((errorMessage) {
      message = errorMessage;
      refundDetail = null;
    }, (r) {
      refundDetail = r;
    });

    logger.i("Get refundDetail: $refundDetail}");
    if (message != null) {
      logger.e("Error message Get refundDetail: $message");
    }

    loading = false;
  }

  @action
  Future<bool> createFeedback(int id,
      {required double rating, required String comment}) async {
    clear();
    loading = true;

    bool created = false;
    final result = await _api.createFeedback(id, rating, comment);
    await result.fold((errorMessage) {
      message = errorMessage;
    }, (r) {
      created = r;
    });

    logger.i("Create feedback: $created}");
    if (message != null) {
      logger.e("Error message create feedback: $message");
    }

    loading = false;

    return created;
  }

  @action
  Future<bool> cancelBooking(int id) async {
    clear();
    loading = true;

    bool created = false;
    final result = await _api.cancelBooking(id);
    await result.fold((errorMessage) {
      message = errorMessage;
    }, (r) {
      created = r;
    });

    logger.i("Cancel booking: $created}");
    if (message != null) {
      logger.e("Error message Cancel booking: $message");
    }

    loading = false;

    return created;
  }
}
