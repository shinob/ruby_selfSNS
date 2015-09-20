var cnt = 0;
var flg_add = true;

window.onscroll = function(e)
{
	scrollTop = document.body.scrollTop + document.documentElement.clientHeight;
	height = document.body.getBoundingClientRect().height;
	//$("foot").innerHTML = scrollTop + "px / " + height + "px";
	if (scrollTop > height) {
		//addElement();
		//alert("load new pages");
	}
	//$("foot").innerHTML = scrollTop + "px / " + height + "px";
	//alert(this.scrollTop);
};

function addElement() {
	var element = document.createElement('div');
	element.className = "inner";
	cnt += 1;
	element.innerHTML = "<div class='show_note'>追加" + cnt + "</div>";
	
	var obj = $('cont');
	obj.appendChild(element);
}

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
	hide_form();
	$("post_note").style.display = "block";
}

function show_post_photo_form() {
	hide_form();
	$("post_photo").style.display = "block";
}

function show_find_form() {
	hide_form();
	$("find").style.display = "block";
}

function show_post_comment_form(id) {
	hide_form();
	$("post_comment").style.display = "block";
	
	$("note_id_for_comment").value = id;
}

function show_set_photo_form(id) {
	hide_form();
	$("set_photo").style.display = "block";
	
	$("set_photo_img").src = "/?mode=photo&id=" + id;
	$("set_photo_id").value = id;
}

function hide_form() {
	$("post_note").style.display = "none";
	$("post_photo").style.display = "none";
	$("find").style.display = "none";
	$("post_comment").style.display = "none";
	$("set_photo").style.display = "none";
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
