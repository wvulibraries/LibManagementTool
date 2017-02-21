$(document).on("load turbolinks:load",function(){
  if($('table').length){
    $('table').cardtable();
  }
});
