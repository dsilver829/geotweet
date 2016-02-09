Map = {}

window.map;
window.markers = {};

function initAutocomplete() {
    var map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: $('#map').data('latitude'), lng: $('#map').data('longitude')},
        zoom: 13,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    window.map = map;

    // Create the search box and link it to the UI element.
    var input = document.getElementById('pac-input');
    var searchBox = new google.maps.places.SearchBox(input);
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

    // Bias the SearchBox results towards current map's viewport.
    map.addListener('bounds_changed', function() {
        searchBox.setBounds(map.getBounds());
    });

    var markers = [];
    // [START region_getplaces]
    // Listen for the event fired when the user selects a prediction and retrieve
    // more details for that place.
    searchBox.addListener('places_changed', function() {
        var places = searchBox.getPlaces();

        if (places.length == 0) {
            return;
        }

        // Clear out the old markers.
        markers.forEach(function(marker) {
            marker.setMap(null);
        });
        markers = [];

        // For each place, get the icon, name and location.
        var bounds = new google.maps.LatLngBounds();
        var place = places.shift();

            if (place.geometry.viewport) {
                // Only geocodes have viewport.
                bounds.union(place.geometry.viewport);
            } else {
                bounds.extend(place.geometry.location);
            }
        map.fitBounds(bounds);
    });
    // [END region_getplaces]

    return map;
}

function clearOverlays() {
    Object.keys(window.markers).forEach(function(key,index) {
        // key: the name of the object key
        // index: the ordinal position of the key within the object
        window.markers[key].setMap(null);
    });
}

Map.updateGeotweets = function(callback) {
    var bounds = window.map.getBounds();
    var SW = bounds.getSouthWest();
    var NE = bounds.getNorthEast();
    $.ajax({
        url: $('#map').data('geotweets-url'),
        type: "get", //send it through get method
        data: { lat0: SW.lat(), lon0: SW.lng(), lat1: NE.lat(), lon1: NE.lng(), limit: 250 - $('#geotweet-list').children().length },
        dataType: 'script'
    });

    if(callback === true) {
        setTimeout( function() {
            Map.updateGeotweets(true);
        }, 1000 );
    }
}

$(document).ready(function() {
    var map = initAutocomplete();

    var callback = true;
    google.maps.event.addListener(map, 'bounds_changed', function() {
        clearOverlays();
        Map.updateGeotweets(callback);
        callback = false;
        $('#geotweet-list').empty();
    });
});