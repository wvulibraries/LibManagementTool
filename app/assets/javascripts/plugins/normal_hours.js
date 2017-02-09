$(document).on('change', '#normal_hour_resource_type', function() {
  let selectValue = $(this).val();
  if (selectValue === 'library') {
    $('.department').hide();
    $('.library').show();
  } else {
    $('.library').hide();
    $('.department').show();
  }
});

$(document).on("turbolinks:load ready", function() {
  if ($('#normal_hour_resource_type').length) {
    $('#normal_hour_resource_type').change();
  }
});
