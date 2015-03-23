$(function() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            function(position) {
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
});