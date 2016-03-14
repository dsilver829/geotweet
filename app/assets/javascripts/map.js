var Map = function() {
    this.map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: $('#map').data('latitude'), lng: $('#map').data('longitude')},
        zoom: 9,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        minZoom: 2
    });

    this.markers = {};

    // Create the search box and link it to the UI element.
    var input = document.getElementById('pac-input');
    var searchBox = new google.maps.places.SearchBox(input);
    this.map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

    // Bias the SearchBox results towards current map's viewport.
    this.map.addListener('bounds_changed', function() {
        searchBox.setBounds(this.map.getBounds());
    }.bind(this));

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
        this.map.fitBounds(bounds);
    }.bind(this));
    // [END region_getplaces]

    var callback = true;
    google.maps.event.addListener(this.map, 'bounds_changed', function() {
        this.clearMarkers();
        this.updateGeotweets(callback);
        callback = false;
        $('#geotweet-list').empty();
    }.bind(this));
};

Map.prototype.clearMarkers = function() {
    Object.keys(this.markers).forEach(function(key,index) {
        // key: the name of the object key
        // index: the ordinal position of the key within the object
        this.markers[key].setMap(null);
        delete this.markers[key];
    }.bind(this));
};

Map.prototype.updateGeotweets = function(callback) {
    var bounds = this.map.getBounds();
    var SW = bounds.getSouthWest();
    var NE = bounds.getNorthEast();
    $.ajax({
        url: $('#map').data('geotweets-url'),
        type: "get", //send it through get method
        data: { lat0: SW.lat(), lon0: SW.lng(), lat1: NE.lat(), lon1: NE.lng(), limit: 250 - $('#geotweet-list').children().length, query: $('#hidden-query-input').val() },
        dataType: 'script'
    });

    if(callback === true) {
        setTimeout( function() {
            this.updateGeotweets(true);
        }.bind(this), 1000 );
    }
};