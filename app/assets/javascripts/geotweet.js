$(document).ready(function() {

    console.log("MAP");

    handler = Gmaps.build('Google');
    handler.buildMap({
        provider: {
            zoom:      15,
            center:    new google.maps.LatLng($('#map').data('latitude'), $('#map').data('longitude')),
        },
        internal: {id: 'map'}},
        function () {}
    );
});