$(document).on('click touchstart', '.sliding-panel-button,.sliding-panel-fade-screen,.sliding-panel-close', function (e) {
  $('.sliding-panel-content,.sliding-panel-fade-screen').toggleClass('is-visible');
  e.preventDefault();
});
