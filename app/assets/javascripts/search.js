$(document).ready(function() {
    $( "#query-search" ).click(function( event ) {
        event.preventDefault();
        clearOverlays();
        var query = $('#query-input').val();
        $('#hidden-query-input').val(query);
        Map.updateGeotweets(false);
        $('#geotweet-list').empty();
    });
});