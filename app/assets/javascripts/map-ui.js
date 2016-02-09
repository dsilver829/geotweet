$(document).ready(function() {
    console.log("ready");

    var container = $("#map-container");

    $(window).on("scroll", function(e) {
        console.log(this.scrollTop);

        if ($(window).scrollTop() > 113) {
            console.log('fixed');
            container.addClass("map-container-fixed");
        } else {
            console.log('scrollable');
            container.removeClass("map-container-fixed");
        }

    });
});