var SearchForm = function() {
    $( "#query-submit" ).click(function( event ) {
        event.preventDefault();
        this.submit();
    }.bind(this));
    this.listenKeyboardSubmit();
};

SearchForm.prototype.submit = function() {
    map.clearMarkers();
    var query = $('#query-input').val();
    $('#hidden-query-input').val(query);
    map.updateGeotweets(false);
    $('#geotweet-list').empty();
};

SearchForm.prototype.listenKeyboardSubmit = function() {
    $("form input#query-input").keypress(function (e) {
        if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
            $('button#query-submit').click();
            return false;
        } else {
            return true;
        }
    });
}