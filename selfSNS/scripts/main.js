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

function show_post_note_form() {
	getDiv("post_note").style.display = "block";
	getDiv("post_photo").style.display = "none";
	getDiv("find").style.display = "none";
}

function show_find_form() {
	getDiv("post_note").style.display = "none";
	getDiv("post_photo").style.display = "none";
	getDiv("find").style.display = "block";
}

function hide_form() {
	getDiv("post_note").style.display = "none";
	getDiv("post_photo").style.display = "none";
	getDiv("find").style.display = "none";
}
