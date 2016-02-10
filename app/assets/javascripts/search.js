$(document).ready(function() {
    $( "#query-search" ).click(function( event ) {
        event.preventDefault();
        clearOverlays();
        var query = $('#query-input').val();
        $('#hidden-query-input').val(query);
        Map.updateGeotweets(false);
        $('#geotweet-list').empty();
    });

    $("form input#query-input").keypress(function (e) {
        if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
            $('button#query-search').click();
            return false;
        } else {
            return true;
        }
    });
});