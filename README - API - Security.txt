----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----- This document explains the process of authentication/communication against the API -----
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

API-methods can only be used, in combination with an AuthenticationToken.
This token can be retrieved from the API, by signing in/up via:
	/api/signin
	/api/signup

These headers should be added to the request in order to successfully log in:
	Content-Type: application/json
	Authentication: Token

The BODY of the request should contain the credentials in JSON-format:
	{"email":"maxim.braekman@hotmail.com","password":"abc"}

If the credentials are incorrect, this response will be returned:
	BODY:
		{"message":"Access Denied","code":"401"}

If the credentials are correct, this response will be returned:
	HEADERS:
		will contain a header named 'Auth-Token', of which the value needs to be used for each next call.
		This token identifies the user and verifies if the user can call certain methods.
		The token will expire after 2 hours of inactivity, which will be extended after each new call.

		ex: Auth-Token: 8260c7e0de73c98bc689902251fbd627

	BODY:
		will contain all user-information in JSON-format

Every next call, to whatever method, should contain these headers, using the value returned by the signin/up-method:
	Authentication: Token
	Auth-Token: 8260c7e0de73c98bc689902251fbd627