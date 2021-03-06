var GeosearchForm = function(map) {
    var input = $('#pac-input')[0];
    var searchBox = new google.maps.places.SearchBox(input);
    map.gmap.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
    this.listen(searchBox);
};

GeosearchForm.prototype.listen = function (searchBox) {
    searchBox.addListener('places_changed', function() {
        var places = searchBox.getPlaces();

        if (places.length == 0) {
            return;
        }

        var bounds = new google.maps.LatLngBounds();
        var place = places.shift();

        if (place.geometry.viewport) {
            // Only geocodes have viewport.
            bounds.union(place.geometry.viewport);
        } else {
            bounds.extend(place.geometry.location);
        }
        map.gmap.fitBounds(bounds);
    });
};