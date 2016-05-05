# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
	if $('#infinite-scrolling').size() > 0
		$(window).on 'scroll', ->
			more_posts_url = $('.pagination .next_page').attr('href')
			if more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - $('.page-footer').height() - 35
				$('.pagination').text("Please Wait...");

				more_posts_url = more_posts_url.replace('profile', 'extendPosts');
				more_posts_url = more_posts_url.replace('wallpost', 'extendPostsAfterDelete');
				
				$.getScript more_posts_url

			return
		return