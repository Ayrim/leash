//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require turbolinks
//= require_tree 

$(document).ready(function(){
	$(".button-collapse").sideNav();
	$('.parallax').parallax();
	$(".brand-logo").sideNav();
})

$(document).ready(function() {
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('.pagination').text("Please Wait...");

        
      return $.ajax({
            url: url,
            success: function() {
                setTimeout(function(){UpdateWallposts();}, 500);
            }});

      }
    });
    return $(window).scroll();
  }
});
