import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyAzOfrQGju20FYzM609EeMbEEHmpUh2MQM";

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  Future<void> _handlePressButton() async {
    try {
      Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.overlay, // or Mode.fullscreen
        language: "en",
        components: [Component(Component.country, "us")],
        // onError: (PlacesAutocompleteResponse response) {
        //   print("Autocomplete error: ${response.errorMessage}");
        // },
      );

      if (p != null) {
        setState(() {
          _searchController.text = p.description ?? "";
        });
      }
    } catch (e) {
      print("Error occurred in autocomplete: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location Search')),
      body: Column(
        children: <Widget>[
          TextFormField(
            controller: _searchController,
            readOnly: true, // Prevent the keyboard from showing up
            onTap: _handlePressButton,
            decoration: InputDecoration(
              icon: Container(
                margin: EdgeInsets.only(left: 20),
                width: 10,
                height: 10,
                child: Icon(Icons.location_on),
              ),
              hintText: "Search for location",
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            ),
          ),
          // Other widgets...
        ],
      ),
    );
  }
}
