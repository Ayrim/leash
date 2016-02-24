		$(document).ready(function(){
			// the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
			$('.modal-trigger').leanModal();
			
			  $("#agreeTermsBtn").click(function () {
				document.getElementById("agree-terms").checked = true;
			  });
			  
			  $('#disagreeTermsBtn').click(function(){
				document.getElementById("agree-terms").checked = false;
			  });
		  });