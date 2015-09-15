function snsLogout() {
	
	var form = document.createElement('form');
	document.body.appendChild(form);
	
	var input = document.createElement('input');
	
	input.setAttribute('type', 'hidden');
	input.setAttribute('name', 'mode');
	input.setAttribute('value', 'logout');
	
	form.appendChild(input)
	form.setAttribute('method', 'post');
	form.submit();

}

function getDiv(name) {
	return document.getElementById(name);
}

