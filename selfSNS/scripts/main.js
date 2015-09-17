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

function show_post_note_form() {
	$("post_note").style.display = "block";
	$("post_photo").style.display = "none";
	$("find").style.display = "none";
}

function show_find_form() {
	$("post_note").style.display = "none";
	$("post_photo").style.display = "none";
	$("find").style.display = "block";
}

function hide_form() {
	$("post_note").style.display = "none";
	$("post_photo").style.display = "none";
	$("find").style.display = "none";
}

function post_like(note_id) {
	//alert(note_id);
	new Ajax.Request("index.rb", {
		method: "post",
		parameters: "mode=like&note_id=" + note_id,
		onSuccess: function(rs) {
			//alert($("like" + note_id).innerHTML);
			//alert(rs.responseText);
			$("like"+note_id).innerHTML = rs.responseText;
		},
		onFailure: function() {
			$("like"+note_id).innerHTML = "NULL";
		}
	});
}
