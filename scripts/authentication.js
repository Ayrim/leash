		$(document).ready(function(){
			// the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
			$('.modal-trigger').leanModal();
			
			  $("#agreeTermsBtn").click(function () {
				document.getElementById("agree-terms").checked = true;
			  });
			  
			  $('#disagreeTermsBtn').click(function(){
				document.getElementById("agree-terms").checked = false;
			  });
			  
			/*if (window.location.pathname.endsWith('login.html')){*/
				if (window.location.hash === '#activation') {ActivationToast();}
				if (window.location.hash === '#password') {PasswordToast();}
			/*}*/
		  });
		  
        function ActivationToast () {
			Materialize.toast('Thank you for registering!<br /><br />An activation mail has been sent,<br />which can be used to activate your account.', 7000);
        }
        function PasswordToast () {
			Materialize.toast('An e-mail containing your password has been sent.', 7000);
        }