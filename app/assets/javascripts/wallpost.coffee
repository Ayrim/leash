# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
	if $('#infinite-scrolling').size() > 0
		$(window).on 'scroll', ->
			more_posts_url = $('.pagination .next_page').attr('href')
			if more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - $('.page-footer').height()
				$('.pagination').html('Loading...')
				$.getScript more_posts_url
				
				$('#posts').append("#{ j render($wallposts)}")
				return $('.pagination').replaceWith("#{ j will_paginate($wallposts)}")

			return
		return