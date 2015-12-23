//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).ready(function(){
  $(".close").click(function() {
    $(".alert").hide();
    $(".msg-flash").remove();
  });
});
