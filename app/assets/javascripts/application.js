// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

/*$(document).ready(function () {
    // Add smooth scrolling to all links in navbar + footer link
    $(".navbar a[href='#']").on('click', function (event) {

        // Prevent default anchor click behavior
        event.preventDefault();

        // Store hash
        var hash = this.hash;

        // Using jQuery's animate() method to add smooth page scroll
        // The optional number (900) specifies the number of milliseconds it takes to scroll to the specified area
        if($(hash).offset()){
	        $('html, body').animate({
	            scrollTop: $(hash).offset().top
	            //scrollTop: 0
	        }, 900, function () {
	            // Add hash (#) to URL when done scrolling (default click behavior)
	            window.location.hash = hash;
	        });
    	}
    	else
    	{
	        $('html, body').animate({
	            //scrollTop: $(hash).offset().top
	            scrollTop: 0
	        }, 900, function () {
	            // Add hash (#) to URL when done scrolling (default click behavior)
	            window.location.hash = hash;
	        });
    	}
    });
})*/