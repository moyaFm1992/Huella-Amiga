import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenStreetMapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final Set<MapMarker> markers;

  const OpenStreetMapWidget({
    Key? key,
    required this.latitude,
    required this.longitude,
    this.markers = const {},
  }) : super(key: key);

  @override
  _OpenStreetMapWidgetState createState() => _OpenStreetMapWidgetState();
}

class MapMarker {
  final double lat;
  final double lng;
  final String? popupText;

  MapMarker({
    required this.lat,
    required this.lng,
    this.popupText,
  });
}

class _OpenStreetMapWidgetState extends State<OpenStreetMapWidget> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent);
    _loadMap();
  }

  void _loadMap() {
    final markersHtml = widget.markers.map((marker) => """
      L.marker([${marker.lat}, ${marker.lng}])
        ${marker.popupText != null ? ".bindPopup('${marker.popupText}')" : ""}
        .addTo(map);
    """).join('\n');

    final html = """
      <!DOCTYPE html>
      <html>
        <head>
          <title>OpenStreetMap</title>
          <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />
          <style>
            body { margin: 0; padding: 0; }
            #map { height: 100%; width: 100%; }
          </style>
        </head>
        <body>
          <div id="map"></div>
          <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>
          <script>
            var map = L.map('map').setView([${widget.latitude}, ${widget.longitude}], 15);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
              attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            }).addTo(map);
            $markersHtml
          </script>
        </body>
      </html>
    """;

    _controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: WebViewWidget(controller: _controller),
    );
  }
}
