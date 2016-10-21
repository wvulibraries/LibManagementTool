$(document).on 'change', '#special_hour_special_type', ->
  selectValue = $(this).val()
  if selectValue == 'library'
    $('.department').hide()
    $('.library').show()
  else
    $('.library').hide()
    $('.department').show()
  return
$(document).on "turbolinks:load ready", ->
  if $('#special_hour_special_type').length
    $('#special_hour_special_type').change()
  return
