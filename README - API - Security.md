----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
	This document explains the process of authentication/communication against the API	
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

API-methods can only be used, in combination with an AuthenticationToken.
This token can be retrieved from the API, by signing in/up via:<br />
&nbsp;&nbsp;&nbsp;&nbsp;/api/signin<br />
&nbsp;&nbsp;&nbsp;&nbsp;/api/signup

These headers should be added to the request in order to successfully log in:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Content-Type: application/json<br />
&nbsp;&nbsp;&nbsp;&nbsp;Authentication: Token

The BODY of the request should contain the credentials in JSON-format:<br />
&nbsp;&nbsp;&nbsp;&nbsp;{"email":"abc@hotmail.com","password":"abc"}

If the credentials are incorrect, this response will be returned:<br />
&nbsp;&nbsp;&nbsp;&nbsp;BODY:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{"message":"Access Denied","code":"401"}

If the credentials are correct, this response will be returned:<br />
&nbsp;&nbsp;&nbsp;&nbsp;HEADERS:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;will contain a header named 'Auth-Token', of which the value needs to be used for each next call.<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This token identifies the user and verifies if the user can call certain methods.<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The token will expire after 2 hours of inactivity, which will be extended after each new call.<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ex: Auth-Token: 8260c7e0de73c98bc689902251fbd627<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;BODY:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;will contain all user-information in JSON-format<br />
<br />
Every next call, to whatever method, should contain these headers, using the value returned by the signin/up-method:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Authentication: Token<br />
&nbsp;&nbsp;&nbsp;&nbsp;Auth-Token: 8260c7e0de73c98bc689902251fbd627
