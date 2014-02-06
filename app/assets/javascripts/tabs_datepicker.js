$(function() {
  $( '#group-tabs' ).tabs();
  $( '#incivent-tabs' ).tabs();
  $( '#task-tabs' ).tabs();
  $( '#message-tabs' ).tabs();
  $( 'input[id$="_due_date"]' ).datepicker({ dateFormat: 'yy-mm-dd' });
  $('.flash_success').delay(8000).slideUp('slow');
  $('.flash_notice').delay(8000).slideUp('slow');
  $('.flash_error').delay(8000).slideUp('slow');

  $('a[href^="#group-tabs"]').click(function() {
		var href = $(this).attr('href')
		if ($(href).find('div[id^="google_map_section"]').length > 0) {
			$(href).css({'display':'block'});
      $('div[id^="google_map_section"]').css('height: 500px; width: 930px;');
		}
  });

});