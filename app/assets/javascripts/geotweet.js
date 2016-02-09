$(document).ready(function() {

    handler = Gmaps.build('Google');
    handler.buildMap({
        provider: {
            zoom:      15,
            center:    new google.maps.LatLng($('#map').data('latitude'),$('#map').data('longitude')),

            //center:    new google.maps.LatLng($('#map').data('latitude'), $('#map').data('longitude')),
        },
        internal: {id: 'map'}},
        function () {

    });

    google.maps.event.addListener(handler.getMap(), 'idle', function() {
        console.log(handler.getMap().getBounds().toString());
    });
});