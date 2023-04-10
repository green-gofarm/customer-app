
// Domain
const String LOCAL_API_DOMAIN = 'http://localhost:8080';
const String PRODUCTION_API_DOMAIN = 'https://uat.go-farm.online';
const String ENV_DOMAIN = PRODUCTION_API_DOMAIN;
// const String ENV_DOMAIN = LOCAL_API_DOMAIN;

// Api path and version
const DOMAIN = '$ENV_DOMAIN/v1';
const DOMAIN_V2 = '$ENV_DOMAIN/v2';

// Endpoint
class ENP {
  static const String SIGN_UP = 'register';
  static const String ADMIN = 'admin';
  static const String HOST = 'hosts';
  static const String CUSTOMER = 'customers';
  static const String FARMSTAY = 'farmstays';
  static const String SERVICE_CATEGORY = 'service-categories';
  static const String ROOM_CATEGORY = 'room-categories';
  static const String FEEDBACK = 'feedback';
  static const String USER = 'users';
  static const String BOOKING = 'bookings';
  static const String DISBURSEMENT = 'disbursements';
  static const String TAG_CATEGORY = 'tag-categories';
  static const String IMAGES = 'images';
  static const String ACTIVITIES = 'activities';
  static const String ROOMS = 'rooms';
}