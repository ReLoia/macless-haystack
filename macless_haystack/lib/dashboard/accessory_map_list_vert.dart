import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:provider/provider.dart';
import 'package:macless_haystack/accessory/accessory_list.dart';
import 'package:macless_haystack/accessory/accessory_registry.dart';
import 'package:macless_haystack/location/location_model.dart';
import 'package:macless_haystack/map/map.dart';
import 'package:latlong2/latlong.dart';

import '../accessory/accessory_model.dart';
import '../callbacks.dart';

class AccessoryMapListVertical extends StatefulWidget {
  final LoadLocationUpdatesCallback loadLocationUpdates;
  final SaveOrderUpdatesCallback saveOrderUpdatesCallback;

  /// Displays a map view and the accessory list in a vertical alignment.
  const AccessoryMapListVertical({
    super.key,
    required this.loadLocationUpdates,
    required this.saveOrderUpdatesCallback,
  });

  @override
  State<AccessoryMapListVertical> createState() =>
      _AccessoryMapListVerticalState();
}

class _AccessoryMapListVerticalState extends State<AccessoryMapListVertical> {
  final MapController _mapController = MapController();

  Accessory? _followedAccessory;

  void _setFollowedAccessory(Accessory? accessory) {
    setState(() {
      if (_followedAccessory != accessory) {
        _followedAccessory = accessory;
      } else {
        _followedAccessory = null;
      }
    });
  }

  void _centerPoint(LatLng point) {
    _mapController
        .fitCamera(CameraFit.bounds(bounds: LatLngBounds.fromPoints([point])));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AccessoryRegistry, LocationModel>(
      builder: (BuildContext context, AccessoryRegistry accessoryRegistry,
          LocationModel locationModel, Widget? child) {
        return Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: AccessoryMap(
                mapController: _mapController,
                followedAccessory: _followedAccessory,
                onMapMoved: _setFollowedAccessory
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: AccessoryList(
                loadLocationUpdates: widget.loadLocationUpdates,
                saveOrderUpdatesCallback: widget.saveOrderUpdatesCallback,
                centerOnPoint: _centerPoint,
                onAccessorySelected: _setFollowedAccessory,
              ),
            ),
          ],
        );
      },
    );
  }
}
