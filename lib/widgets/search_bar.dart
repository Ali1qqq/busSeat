import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:untitled/controllers/home_controller.dart';
import 'package:google_places_for_flutter/google_places_for_flutter.dart';

class SearchBars extends StatelessWidget {
  const SearchBars({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SearchGooglePlacesWidget(

        placeType: PlaceType.address,
        placeholder: 'Enter the address',
        apiKey: dotenv.env['GOOGLE_MAPS_API_KEY']!,
        onSearch: (Place place) {},
        onSelected: (Place place) async {
          homeController.setDestination(place);
        },
      ),
    );
  }
}
