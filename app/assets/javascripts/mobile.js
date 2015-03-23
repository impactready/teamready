// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_self


$(function() {
    $('div.mt-name').click(function() {
      $(this).parent().children('.mt-info').first().show();
    });

    $('.mt-button-i').click(function() {
      window.location = '/incivents/new'
    });

    $('.mt-button-t').click(function() {
      window.location = '/tasks/new'
    });

    $('.mt-button-m').click(function() {
      window.location = '/messages/new'
    });

    populateCoords();

});

populateCoords = function() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            function(position) {
                alert('Using your current location for the longitude and latitude fields.');
                $('.mobile-form input[id$="_latitude"]').val(position.coords.latitude);
                $('.mobile-form input[id$="_longitude"]').val(position.coords.longitude);
            },function(error) {
                alert('Could not obtain the coordinates from your device.');
            }, {
                enableHighAccuracy: true,
                timeout: 5000,
                maximumAge: 60000
            }
        );
    }
}