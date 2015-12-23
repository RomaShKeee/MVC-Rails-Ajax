//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery.offline
//= require jquery.tmpl.min
//= require json
//= require_tree .

$(document).ready(function(){
  $(".close").click(function() {
    $(".alert").hide();
    $(".msg-flash").remove();
  });
});
