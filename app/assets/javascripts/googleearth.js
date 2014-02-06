$(function() {
  var idArray = ($("#ids-for-earth").attr("data-ids")).split(", ");
  var maps = [];
  var markers =[];
  var boundsArray = [];
  var kmlLayers= [];
  for (var i = 0; i < idArray.length; i++){
      loadMap(idArray[i]);
  };

  function loadMap(the_id) {
    var latArray = ($("#google_map_section-"+the_id).attr("data-lat")).split("%|%");
    var longArray = ($("#google_map_section-"+the_id).attr("data-long")).split("%|%");
    var nameArray = ($("#google_map_section-"+the_id).attr("data-name")).split("%|%");
    var urlArray = ($("#google_map_section-"+the_id).attr("data-url")).split("%|%");
    var kml_url = $("#google_map_section-"+the_id).attr("data-kml");
    var mylatlngs = [];
    var innerMarkers = [];

    var bounds = new google.maps.LatLngBounds();

    for(var i = 0; i < latArray.length; i++){
      mylatlngs.push(new google.maps.LatLng(
        parseFloat(latArray[i]),
        parseFloat(longArray[i]))
      );
    };

    var myOptions = {
      center: mylatlngs[mylatlngs.length-1],
      mapTypeId: google.maps.MapTypeId.SATELLITE,
      zoom: 13
    };

    var map = new google.maps.Map(document.getElementById("google_map_section-"+the_id),
      myOptions
    );

    for (var i = 0; i < mylatlngs.length; i++){
      var marker = new MarkerWithLabel({
        position: mylatlngs[i],
        map: map,
        //title: nameArray[i],
        url: urlArray[i],
        labelContent: nameArray[i],
        labelAnchor: new google.maps.Point(70, -5),
        labelClass: "map-label" // the CSS class for the label
      });
      addClickListen(marker);
      innerMarkers.push(marker);
      bounds.extend(mylatlngs[i]);
    };

    if (innerMarkers.length > 1) {
      map.fitBounds(bounds);
      boundsArray.push(bounds);
      maps.push(map);
    };
    markers.push(innerMarkers);

    if (kml_url != ""){
      var kmlLayer = new google.maps.KmlLayer(kml_url, {
      map: map,
      preserveViewport: true
      });
      kmlLayers.push(kmlLayer);
    };

    addTabListen(the_id);

  }

  function addClickListen(markerPass){
      google.maps.event.addListener(markerPass, 'click', function() {
          window.location.href = markerPass.url;
      });
  }

  function addTabListen(the_id) {
    $('a[href="#group-tabs-' + the_id + '"]').click( function() {
      //alert('click!');
      var href = $(this).attr('href');
      if ($(href).find('#google_map_section-' + the_id).length > 0) {
        loadMap(the_id);
      }
    });
  }



});