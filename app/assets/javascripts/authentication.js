		$(document).ready(function(){
			// the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
			$('.modal-trigger').leanModal();
			
			  $("#agreeTermsBtn").click(function () {
				document.getElementById("terms_of_service").checked = true;
				$('.lean-overlay').remove();
			  });
			  
			  $('#disagreeTermsBtn').click(function(){
				document.getElementById("terms_of_service").checked = false;
				$('.lean-overlay').remove();
			  });

			  $('#closeTermsBtn').click(function(){
				$('.lean-overlay').remove();
			  })
			  
			/*if (window.location.pathname.endsWith('login.html')){*/
				if (window.location.hash === '#activation') {ActivationToast();}
				if (window.location.hash === '#activated') {ActivatedToast();}
				if (window.location.hash === '#invalidactivation') {InvalidActivationToast();}
				if (window.location.hash === '#password') {PasswordToast();}
				if (window.location.hash === '#passwordreset') {PasswordResetToast();}
				if (window.location.hash === '#complete_profile') {CompleteProfileToast();}

			/*}*/
		  });
		  
        function ActivationToast () {
			Materialize.toast('Thank you for registering!<br /><br />An activation mail has been sent,<br />which can be used to activate your account.', 7000);
        }
        function ActivatedToast () {
			Materialize.toast('Your account has been activated!', 7000);
        }
        function InvalidActivationToast () {
			Materialize.toast('Account could not be activated.<br />The provided activation link is invalid.', 7000);
        }
        function PasswordToast () {
			Materialize.toast('An e-mail has been sent, so you will be able to reset your password.', 7000);
        }
        function PasswordResetToast () {
			Materialize.toast('Your password has been successfully reset.', 7000);
        }
        function CompleteProfileToast () {
			Materialize.toast('Please, complete your account to get the best possible experience.', 7000);
        }
