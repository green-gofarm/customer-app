// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BookingStore on _BookingStore, Store {
  late final _$bookingsAtom =
      Atom(name: '_BookingStore.bookings', context: context);

  @override
  List<CustomerBookingModel> get bookings {
    _$bookingsAtom.reportRead();
    return super.bookings;
  }

  @override
  set bookings(List<CustomerBookingModel> value) {
    _$bookingsAtom.reportWrite(value, super.bookings, () {
      super.bookings = value;
    });
  }

  late final _$referenceIdAtom =
      Atom(name: '_BookingStore.referenceId', context: context);

  @override
  String? get referenceId {
    _$referenceIdAtom.reportRead();
    return super.referenceId;
  }

  @override
  set referenceId(String? value) {
    _$referenceIdAtom.reportWrite(value, super.referenceId, () {
      super.referenceId = value;
    });
  }

  late final _$bookingAtom =
      Atom(name: '_BookingStore.booking', context: context);

  @override
  BookingModel? get booking {
    _$bookingAtom.reportRead();
    return super.booking;
  }

  @override
  set booking(BookingModel? value) {
    _$bookingAtom.reportWrite(value, super.booking, () {
      super.booking = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_BookingStore.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$messageAtom =
      Atom(name: '_BookingStore.message', context: context);

  @override
  String? get message {
    _$messageAtom.reportRead();
    return super.message;
  }

  @override
  set message(String? value) {
    _$messageAtom.reportWrite(value, super.message, () {
      super.message = value;
    });
  }

  late final _$createBookingAsyncAction =
      AsyncAction('_BookingStore.createBooking', context: context);

  @override
  Future<void> createBooking(int farmstayId) {
    return _$createBookingAsyncAction
        .run(() => super.createBooking(farmstayId));
  }

  late final _$getBookingByReferenceIdAsyncAction =
      AsyncAction('_BookingStore.getBookingByReferenceId', context: context);

  @override
  Future<void> getBookingByReferenceId(String refId) {
    return _$getBookingByReferenceIdAsyncAction
        .run(() => super.getBookingByReferenceId(refId));
  }

  late final _$getCustomerBookingsAsyncAction =
      AsyncAction('_BookingStore.getCustomerBookings', context: context);

  @override
  Future<void> getCustomerBookings() {
    return _$getCustomerBookingsAsyncAction
        .run(() => super.getCustomerBookings());
  }

  late final _$payBookingAsyncAction =
      AsyncAction('_BookingStore.payBooking', context: context);

  @override
  Future<String?> payBooking(int bookingId, String ipAddress) {
    return _$payBookingAsyncAction
        .run(() => super.payBooking(bookingId, ipAddress));
  }

  late final _$getBookingByIdAsyncAction =
      AsyncAction('_BookingStore.getBookingById', context: context);

  @override
  Future<void> getBookingById(int id) {
    return _$getBookingByIdAsyncAction.run(() => super.getBookingById(id));
  }

  @override
  String toString() {
    return '''
bookings: ${bookings},
referenceId: ${referenceId},
booking: ${booking},
loading: ${loading},
message: ${message}
    ''';
  }
}
