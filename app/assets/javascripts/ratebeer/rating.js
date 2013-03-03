//fAJAXRequest
//
// client function for use in scripts
//
// parameters:
//
// sTargetID		= HTML ID of target DIV in which to dump returned data
// sURL				= URL to send request to
// sPost			= POST data to send, if "" then GET request is made (NOTE: GET may cache, this is a feature, not a bug!)
// sWait			= Text to display in target DIV whilst request is being made, "" = dont change current content
// sError			= Text to display in target DIV if error occurs, "" = dont change current content
//
function fAJAXRequest( sTargetID , sURL , sPost , sWait , sError )
{
	var e = document.getElementById( sTargetID );

	if( e )
	{
		if( sWait != "" )
			e.innerHTML = sWait;

		new oAJAXRequest( e , sURL , sPost , sError );
	}
}


// THE FOLLOWING ARE THE BACK END FUNCTIONS


// AJAX object state and response tracker function
//
// my server-scripts will always send back the first line as "200\n" if succesfull
//
// parameters:
//
// hAJAXRequest		= handle to request object
//
function fAJAXStateChange( hAJAXRequest )
{
	if( hAJAXRequest && hAJAXRequest.mRequest && hAJAXRequest.mRequest.readyState == 4 )
	{
		var s = hAJAXRequest.mRequest.responseText;
		//DEBUG: alert( s );

		if( hAJAXRequest.mRequest.status == "200" && s.substr(0,3) == "200" )
		{
			hAJAXRequest.mhTarget.innerHTML = s.substring(4);
		}
		else
		if( hAJAXRequest.msError != "" )
		{
			hAJAXRequest.mhTarget.innerHTML = hAJAXRequest.msError;
		}
	}

}

// AJAX object
//
// parameters:
//
// hTarget			= handle to target div (or whatever) we want to dump the returned HTML in
// sURL				= url to make request to
// sPost			= POST form data to send (leave as "" to make GET request)
// sError			= HTML to put in target div if request failed
//
// members:
//
// mRequest			= browser's own request object
// mhTarget			= hTarget
// msError			= sError
//
function oAJAXRequest( hTarget , sURL , sPost , sError )
{
	var me = this;
	this.mRequest	= null;
	this.mhTarget	= hTarget;
	this.msError	= sError;

	//do NOT use try{}catch as it is not supported in very old browsers and the script will not compile
	if( window.XMLHttpRequest )	//FF,NS,OP,IE7
	{
		this.mRequest = new XMLHttpRequest();
	}
	else
	if( window.ActiveXObject )	//IE5 & 6
	{
		this.mRequest = new ActiveXObject("Microsoft.XMLHTTP");
	}

	if( this.mRequest )
	{
		if( sPost != "" )
		{
			this.mRequest.open( 'POST', sURL , true );
			this.mRequest.setRequestHeader('Content-type','application/x-www-form-urlencoded');
			this.mRequest.onreadystatechange = function(){ fAJAXStateChange(me); };
			this.mRequest.send( sPost );
		}
		else
		{
			this.mRequest.open( 'GET', sURL , true );
			this.mRequest.onreadystatechange = function(){ fAJAXStateChange(me); };
			this.mRequest.send( null );
		}
	}
	
}


