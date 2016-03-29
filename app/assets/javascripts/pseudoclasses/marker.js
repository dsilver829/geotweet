var Marker = function(id, position, title) {
     var gmarker = new google.maps.Marker({
         icon: 'http://maps.google.com/mapfiles/ms/icons/red-dot.png',
         map: map.gmap,
         position: position,
         title: title
     });
    this.gmarker = gmarker;

    var item = $('li#'+id)

    this.gmarker.addListener('click', function() {
        $('html, body').animate({
            scrollTop: item.offset().top
        }, 500);
    });

    this.gmarker.addListener('mouseover', function() {
        item.addClass('active');
        gmarker.setIcon('http://maps.google.com/mapfiles/ms/icons/green-dot.png');
    });

    this.gmarker.addListener('mouseout', function() {
        item.removeClass('active');
        gmarker.setIcon('http://maps.google.com/mapfiles/ms/icons/red-dot.png');
    });

    item.mouseover(function () {
        $(this).addClass('active');
        gmarker.setIcon('http://maps.google.com/mapfiles/ms/icons/green-dot.png');
        gmarker.setZIndex(google.maps.Marker.MAX_ZINDEX + 1);
    });

    item.mouseout(function () {
        $(this).removeClass('active');
        gmarker.setIcon('http://maps.google.com/mapfiles/ms/icons/red-dot.png');
        gmarker.setZIndex(0);
    });
};