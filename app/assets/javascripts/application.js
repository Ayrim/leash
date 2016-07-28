//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require turbolinks
//= require_tree 

$(document).ready(function(){
	$(".button-collapse").sideNav();
	$('.parallax').parallax();
	$(".brand-logo").sideNav();
  	$('select').material_select();
 
	$('.slider').slider();
    // will call refreshPartial every 30 seconds
    setInterval(refreshPartial, 30*1000);
})

function refreshPartial() {
  $.ajax({
    url: "update_unreadmessages"
 })
}

