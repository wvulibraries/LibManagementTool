$(document).on "turbolinks:load ready", ->
  if $('.datepicker').length
    $('.datepicker').pickadate
      format: 'mmmm dd, yyyy',
      formatSubmit: 'mm/dd/yy'
