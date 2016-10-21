$(document).on 'change', '#normal_hour_resource_type', ->
  selectValue = $(this).val()
  if selectValue == 'library'
    $('.department').hide()
    $('.library').show()
  else
    $('.library').hide()
    $('.department').show()
  return
$(document).on "turbolinks:load ready", ->
  if $('#normal_hour_resource_type').length
    $('#normal_hour_resource_type').change()
  return
