var Map = function() {
    this.gmap = new google.maps.Map($('#map')[0], {
        center: {lat: $('#map').data('latitude'), lng: $('#map').data('longitude')},
        zoom: 9,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        minZoom: 2
    });

    this.markers = {};

    new GeosearchForm(this);

    google.maps.event.addListenerOnce(this.gmap, 'idle', function() {
        this.updateGeotweets(true);
    }.bind(this));
    google.maps.event.addListener(this.gmap, 'bounds_changed', function() {
        this.clearMarkers();
        this.updateGeotweets(false);
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
    var bounds = this.gmap.getBounds();
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