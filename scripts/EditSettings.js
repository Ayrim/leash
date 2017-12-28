$(document).ready(function(){
	$(".button-collapse").sideNav();
	$(".brand-logo").sideNav();
	$('.scrollspy').scrollSpy();
})
		

$('.datepicker').pickadate({
	selectMonths: true, // Creates a dropdown to control month
	selectYears: 75, // Creates a dropdown of 15 years to control year
	max: true
});

$(window).scroll(function(){
    $(".pinned").css("top",Math.max(75,450-$(this).scrollTop()));
});