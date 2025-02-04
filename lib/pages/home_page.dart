import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/controllers/home_controller.dart';
import 'package:untitled/controllers/navigation_controller.dart';
import 'package:untitled/widgets/directions_status_bar.dart';
import 'package:untitled/utils/constants.dart';
import 'package:untitled/widgets/bottom_bar.dart';
import 'package:untitled/widgets/destination_box.dart';

import '../widgets/search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    Get.put(NavigationController());
    return Obx(() => Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: homeController.initialCameraPosition,
                myLocationEnabled: homeController.mapStatus.value != Constants.onDestination,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: homeController.markers.values.toSet(),
                polylines: Set<Polyline>.of(homeController.polyline),
                onMapCreated: (GoogleMapController controller) async {
                  homeController.googleMapsController.complete(controller);
                  Position position =
                      await homeController.getMyCurrentLocation();
                  homeController.mapStatus.value = Constants.idle;
                  homeController.moveMapCamera(LatLng(position.latitude, position.longitude));
                },
              ),
              Visibility(
                visible: homeController.mapStatus.value != Constants.onDestination,
                child:  const Positioned(
                    top: 30,
                    left: 0,
                    child: SearchBars(),
                ),
              ),
              Visibility(
                visible: homeController.mapStatus.value == Constants.route,
                child: const Positioned(
                  top: 0,
                  left: 0,
                  child: DestinationBox(),
                ),
              ),
              Visibility(
                visible: homeController.mapStatus.value == Constants.onDestination,
                child: const Positioned(
                  top: 31,
                  left:0,
                  child:  DirectionsStatusBar()
                  ),
              ),
              Visibility(
                visible: homeController.mapStatus.value == Constants.idle,
                child: Positioned(
                    bottom: 30,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: () async {
                        Position position =
                            await homeController.getMyCurrentLocation();
                        homeController.moveMapCamera(LatLng(
                            position.latitude, position.longitude));
                      },
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        Constants.locateMeIcon,
                        scale: 4,
                      ),
                    )),
              ),
              Visibility(
                visible: homeController.mapStatus.value != Constants.idle,
                child: const Positioned(
                  bottom: 0,
                  left: 0,
                  child:  BottomBar(),
                ),
              )
            ],
          ),
        ));
  }
}
