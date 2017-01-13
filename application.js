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
    // will call refreshPartial every 5 seconds
    setInterval(refreshPartial, 5*1000);
})

function refreshPartial() {
	if current_user()
  		$.ajax({
    		url: "update_unreadmessages"
 		})
}

