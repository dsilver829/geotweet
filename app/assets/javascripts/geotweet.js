$(document).ready(function() {

    console.log("MAP");

    handler = Gmaps.build('Google');
    handler.buildMap({provider: {}, internal: {id: 'map'}}, function () {
        markers = handler.addMarkers([
            {
                "lat": $('#map').data('latitude'),
                "lng": $('#map').data('longitude'),
                "picture": {
                    "url": "http://people.mozilla.com/~faaborg/files/shiretoko/firefoxIcon/firefox-32.png",
                    "width": 32,
                    "height": 32
                },
                "infowindow": "hello!"
            }
        ]);
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
    });
});