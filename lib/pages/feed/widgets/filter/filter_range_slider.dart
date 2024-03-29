import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:latlng/latlng.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'filter_title.dart';
import 'dart:math' as math;

class FilterRangeSlider extends StatefulWidget {
  const FilterRangeSlider({
    Key? key,
    required this.sliderValue,
    required this.onChanged,
  }) : super(key: key);

  final double sliderValue;
  final ValueChanged<double> onChanged;

  @override
  _FilterRangeSliderState createState() => _FilterRangeSliderState();
}

class _FilterRangeSliderState extends State<FilterRangeSlider> {
  static const sliderValues = [100, 200, 500, 1000, 5000, 10000, 15000];
  static const sliderLabels = [
    '100m',
    '200m',
    '500m',
    '1km',
    '5km',
    '10km',
    '15km'
  ];

  String getSliderLabel(double value) {
    return sliderLabels[value.round().clamp(0, sliderLabels.length - 1)];
  }

  int getSliderIndex(double value) {
    return sliderValues.indexWhere((element) => element == value.round());
  }

  String getSliderTickLabel(int value) {
    switch (value) {
      case 100:
        return '100m';
      case 200:
        return '200m';
      case 500:
        return '500m';
      case 1000:
        return '1km';
      case 5000:
        return '5km';
      case 10000:
        return '10km';
      case 15000:
        return '15km';
      default:
        return '';
    }
  }

  TextStyle? getTextStyle(int index, BuildContext context) {
    final isActive = index <= widget.sliderValue.round();
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isActive
              ? Colors.black
              : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
          fontSize: 13,
        );
  }

  @override
  Widget build(BuildContext context) {
    String range = AppLocalizations.of(context)!.range;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilterTitle(label: AppLocalizations.of(context)!.range),
                  ],
                ),
              ),
            ),
            //info icon button
            Padding(
              padding: // ledt 10
                  const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () async {
                  // Get.to MapPAge
                  final FirebaseFirestore _firestore =
                      FirebaseFirestore.instance;
                  final FirebaseAuth _auth = FirebaseAuth.instance;

                  final User? user = _auth.currentUser;

                  if (user != null) {
                    final String userId = user.uid;

                    final DocumentSnapshot<Map<String, dynamic>> snapshot =
                        await _firestore
                            .collection('users')
                            .doc(userId)
                            .collection('intern')
                            .doc('address')
                            .get();

                    final GeoPoint geoPoint = snapshot.data()!['coords'];

                    // print(sliderValues[widget.sliderValue.round()].toDouble());
                    print(sliderValues[getSliderIndex(widget.sliderValue)]);
                    Get.to(() => MapPage(
                          center: LatLng(geoPoint.latitude, geoPoint.longitude),
                          range:
                              sliderValues[getSliderIndex(widget.sliderValue)]
                                  .toDouble(),
                        ));
                  }
                },
                icon: Icon(
                  FlutterRemix.map_2_line,
                  size: 20,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                splashRadius: 18,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Slider(
            value: getSliderIndex(widget.sliderValue).toDouble(),
            max: sliderValues.length - 1.0,
            divisions: sliderValues.length - 1,
            label: getSliderTickLabel(widget.sliderValue.round()),
            onChanged: (newValue) {
              widget.onChanged(sliderValues[newValue.round()].toDouble());

              newValue;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < sliderValues.length; i++)
                Text(
                  '${getSliderTickLabel(sliderValues[i])}',
                  style: getTextStyle(i, context),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class MapPage extends StatefulWidget {
  final LatLng center;
  final double range;

  const MapPage({Key? key, required this.center, required this.range})
      : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  var _zoomLevel;
  double _maxZoomLevel = 18.0;
  double _minZoomLevel = 3.0;
  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _zoomLevel = calculateZoomLevel(widget.range);
  }

  double calculateZoomLevel(double range) {
    const double earthCircumference = 40075000;
    const double adjustmentFactor = 0.0082;
    const double tileSize = 256;

    double zoomLevel =
        math.log(earthCircumference / (range * tileSize * adjustmentFactor)) /
            math.ln2;
    return zoomLevel.clamp(_minZoomLevel, _maxZoomLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karte'),
      ),
      body: GestureDetector(
        onScaleUpdate: (details) {
          setState(() {
            print(_zoomLevel);
            _zoomLevel -= details.scale / 100;
            if (_zoomLevel > _maxZoomLevel) {
              _zoomLevel = _maxZoomLevel;
            } else if (_zoomLevel < _minZoomLevel) {
              _zoomLevel = _minZoomLevel;
            }
          });
        },
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: widget.center,
                zoom: _zoomLevel,
                interactiveFlags: InteractiveFlag.all,
              ),
              nonRotatedChildren: [
                // AttributionWidget.defaultWidget(
                //   source: 'OpenStreetMap contributors',
                //   onSourceTapped: null,
                // ),
              ],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  // userAgentPackageName: 'com.example.app',
                ),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: widget.center,
                      color: Theme.of(context).primaryColor,
                      useRadiusInMeter: false, // Änderung hier
                      radius: 3, // Radius in Pixeln
                    ),
                    CircleMarker(
                      point: widget.center,
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                      useRadiusInMeter: true,
                      radius: widget.range,
                      borderColor: Theme.of(context).primaryColor,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Column(
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.add, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        _zoomLevel = (_zoomLevel + 1)
                            .clamp(_minZoomLevel, _maxZoomLevel);
                        _mapController.move(widget.center,
                            _zoomLevel); // Fügen Sie diese Zeile hinzu
                      });
                    },
                    // ...
                  ),
                  SizedBox(height: 10),
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.remove, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        _zoomLevel = (_zoomLevel - 1)
                            .clamp(_minZoomLevel, _maxZoomLevel);
                        _mapController.move(widget.center,
                            _zoomLevel); // Fügen Sie diese Zeile hinzu
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
