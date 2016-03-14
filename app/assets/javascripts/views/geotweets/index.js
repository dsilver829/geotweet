var scrollListen = function() {
    var container = $("#map-container");
    $(window).on("scroll", function(e) {
        if ($(window).scrollTop() > 113) {
            container.addClass("map-container-fixed");
        } else {
            container.removeClass("map-container-fixed");
        }

    });
};

$(document).ready(function() {
    if($('.geotweets-index').length > 0) {
        map = new Map();
        new SearchForm();
        scrollListen();
    }
});