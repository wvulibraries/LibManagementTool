$(function() {
  if ($('.timepicker').length) {
    return $('.timepicker').pickatime({
      interval: 60,
      format: 'h:i A'
    });
  }
});
