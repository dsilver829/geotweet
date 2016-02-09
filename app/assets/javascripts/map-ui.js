$(document).ready(function() {
    console.log("ready");

    var container = $("#map-container");

    $(window).on("scroll", function(e) {
        if ($(window).scrollTop() > 113) {
            container.addClass("map-container-fixed");
        } else {
            container.removeClass("map-container-fixed");
        }

    });
});