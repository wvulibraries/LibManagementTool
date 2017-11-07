$(document).on('change', '#special_hour_special_type', function() {
  let selectValue = $(this).val();
  if (selectValue === 'library') {
    $('.department').hide();
    $('.library').show();
  } else {
    $('.library').hide();
    $('.department').show();
  }
});

$(function() {
  if ($('#special_hour_special_type').length) {
    $('#special_hour_special_type').change();
  }
});
