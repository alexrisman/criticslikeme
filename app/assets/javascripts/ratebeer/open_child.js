function openChild(file,window) {
    childWindow=open(file,window,'resizable=no,width=350,height=300,scrollbars=yes');
    if (childWindow.opener == null) childWindow.opener = self; childWindow.focus();
	}