$(document).on('change', '#normal_hour_resource_type', function() {
  let selectValue = $(this).val();
  if (selectValue === 'library') {
    hide_select($('.department'));
    show_select($('.library'));
  } else {
    hide_select($('.library'));
    show_select($('.department'));
  }
});

function hide_select(elm){
  elm.hide();
  elm.find('select').hide().prop('disabled', true);
}

function show_select(elm){
  elm.show();
  elm.find('select').show().prop('disabled', false);
}

$(document).on("turbolinks:load ready", function() {
  if ($('#normal_hour_resource_type').length) {
    $('#normal_hour_resource_type').change();
  }
});
