$(document).ready(function() {
    handler = Gmaps.build('Google');
    handler.buildMap({
        provider: {
            zoom:      15,
            center:    new google.maps.LatLng(0,0),

            //center:    new google.maps.LatLng($('#map').data('latitude'), $('#map').data('longitude')),
        },
        internal: {id: 'map'}},
        function () {
            if(navigator.geolocation)
                navigator.geolocation.getCurrentPosition(displayOnMap);
    });

    google.maps.event.addListener(handler.getMap(), 'idle', function() {
        console.log(handler.getMap().getBounds().toString());
    });

    function displayOnMap(position) {
        handler.map.centerOn([position.coords.latitude, position.coords.longitude]);
    }
});