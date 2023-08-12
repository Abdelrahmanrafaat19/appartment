import 'package:apartment_app/apartment/map_states.dart';
import 'package:apartment_app/shared/shared_theme/shared_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:apartment_app/apartment/map_controller.dart';
import '../shared_widget/field_components.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapController, MapStates>(
      bloc: MapController(),
      listenWhen: (context, state) => state is SearchLocationState,
      listener: (context, state) {
         BlocProvider.of<MapController>(context).searchLocation(searchController.text);
      },
      child: Scaffold(
            body: Column(
              children: [
                SafeArea(
                    top: true,
                    child: CustomField(FieldModel(
                        controller: searchController,
                        icon: Icons.location_on,
                        labelTxt: 'ex: Nasr City',
                        type: TextInputType.streetAddress,
                        onsumbit: () async {
                          await BlocProvider.of<MapController>(context)
                              .searchLocation(searchController.text);
                        }))),
                Flexible(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: BlocProvider.of<MapController>(context).latLng,
                      zoom: 12,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    markers: BlocProvider.of<MapController>(context).markers,
                  ),
                ),
              ],
            ),
          ),
      // builder: (context, state) {
      //   MapController mapController = BlocProvider.of<MapController>(context);
      //   if (state is MapStatusErrorState) {
      //     return Center(
      //       child: Text(
      //           'Please give us a permission or enable location service',
      //           style: SharedFonts.primaryBlackFont),
      //     );
      //   } else if (state is MapErrorState) {
      //     return Center(
      //       child: Text('Some thing went wrong',
      //           style: SharedFonts.primaryBlackFont),
      //     );
      //   } else if (state is MapLoadingState) {
      //     return Center(child: CircularProgressIndicator());
      //   } else {
      //     return Scaffold(
      //       body: Column(
      //         children: [
      //           SafeArea(
      //               top: true,
      //               child: CustomField(FieldModel(
      //                   controller: searchController,
      //                   icon: Icons.location_on,
      //                   labelTxt: 'ex: Nasr City',
      //                   type: TextInputType.streetAddress,
      //                   onsumbit: () async {
      //                     await mapController
      //                         .searchLocation(searchController.text);
      //                   }))),
      //           Flexible(
      //             child: GoogleMap(
      //               initialCameraPosition: CameraPosition(
      //                 target: mapController.latLng,
      //                 zoom: 12,
      //               ),
      //               myLocationEnabled: true,
      //               myLocationButtonEnabled: true,
      //               mapType: MapType.normal,
      //               markers: mapController.markers,
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   }
      // },
    );
  }
}
