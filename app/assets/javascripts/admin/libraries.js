// // Set the libraries as an array
// var Library = function(){
//   this.libraries = [];
//   this.setLibraries();
// };
//
// // get the libraries from the database and set them in the array
// Library.prototype.setLibraries = function(){
//   var self = this;
//   $.ajax({
//     url : "/admin/libraries.json",
//     type : "get",
//     async: false,
//     success : function(data) {
//         for (var i = 0; i < data.length; i++) {
//           var lib = { id: data[i].id, name: data[i].name };
//           self.libraries.push(lib);
//         }
//     },
//     error: function() {
//        console.log('failure');
//     }
//   });
// };
//
// // send the array other places if need be
// Library.prototype.getLibraries = function(){
//   return this.libraries;
// };
//
// // list the array as options for select
// Library.prototype.getSelectOptions = function(){
//   var libs = this.getLibraries();
//   var options = '';
//
//   $.each(libs, function(k,v){
//     options += '<option value="' + v.id + '">' + v.name + '</option>';
//   });
//
//   return options;
// };
