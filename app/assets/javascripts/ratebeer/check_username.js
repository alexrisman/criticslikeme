// JavaScript Document
var xmlhttp

function checkUserName(str)
{
xmlhttp=GetXmlHttpObject();
if (xmlhttp==null)
  {
  alert ("Your browser does not support AJAX!");
  return;
  }

if (str.length > 0)
	{
	var url="/ajax/check_username.asp";
	url=url+"?q="+str;
	url=url+"&sid="+Math.random();
	xmlhttp.onreadystatechange=stateChanged;
	xmlhttp.open("GET",url,true);
	xmlhttp.send(null);

	}
}

function stateChanged()
{
if (xmlhttp.readyState==4)
  {
	if (xmlhttp.responseText == 'check') {
		document.getElementById("usercheck").src='/images/icons/check.gif';
		document.getElementById("username").style.backgroundColor = '#ffffff';			
	} else {
		document.getElementById("usercheck").src='/images/icons/check-no.gif';	
		document.getElementById("username").style.backgroundColor = '#ffcccc';
		// alert('That name is taken. Please choose another.')
		document.getElementById("username").focus();
	}
  }
}

function GetXmlHttpObject()
{
if (window.XMLHttpRequest)
  {
  // code for IE7+, Firefox, Chrome, Opera, Safari
  return new XMLHttpRequest();
  }
if (window.ActiveXObject)
  {
  // code for IE6, IE5
  return new ActiveXObject("Microsoft.XMLHTTP");
  }
return null;
}