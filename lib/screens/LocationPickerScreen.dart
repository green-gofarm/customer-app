import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/SettingUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:uuid/uuid.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({Key? key}) : super(key: key);

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(10.8231, 106.6297), zoom: 13.0);

  Set<Marker> markersList = {};

  late GoogleMapController googleMapController;
  late String sessionToken;

  final Mode _mode = Mode.overlay;

  @override
  void initState() {
    super.initState();
    sessionToken = generateSessionToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: _buildAppbar(context),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markersList,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          ElevatedButton(
              onPressed: _handlePressButton, child: const Text("Search Places"))
        ],
      ),
    );
  }

  String generateSessionToken() {
    var uuid = Uuid();
    return uuid.v4();
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: SettingUtils.GOOGLE_MAP_KEY,
        onError: onError,
        mode: _mode,
        language: 'vi',
        strictbounds: false,
        types: [""],
        sessionToken: sessionToken,
        decoration: InputDecoration(
            hintText: 'Tìm kiếm',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [
          Component(Component.country, "vi"),
        ]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    logger.e(response.errorMessage);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: "Chức năng hiện không hoạt động.",
        contentType: ContentType.failure,
      ),
    ));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: SettingUtils.GOOGLE_MAP_KEY,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return appBarWidget(
      "Tìm theo vị trí",
      showBack: true,
      color: rf_primaryColor,
      textColor: Colors.white,
      textSize: 16,
      backWidget: IconButton(
        icon: Icon(Icons.close, color: white),
        onPressed: () {
          finish(context);
        },
      ),
    );
  }
}
