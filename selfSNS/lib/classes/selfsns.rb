class SelfSNS

  def initialize()
    @style = ""
    @page_title = "sefSNS made by Ruby"
    @title = "selSNS made by Ruby"
    @foot = "<a href='https://github.com/shinob/ruby_selfSNS' target='_blank'>ruby_selfSNS@GitHub</a>"
    @menu = ""
  end
  
  def main()
    
    html = ""
    
    if $usr.is_login() then
      make_content()
    else
      html = $usr.get_login_form()
      menu_space()
      output(html)
      #@title = "ログイン"
    end
    
    if true then
      $_POST.each do |key, val|
        html += "<div>#{key} = #{val}</div>"
      end
    end
    
  end
  
  def make_content()
    
    mode = $_POST["mode"]
    if mode == "" then
      mode = $_GET["mode"]
    end
    
    obj = Notes.new()
    
    html = ""
    
    html += post_note_form()
    html += post_photo_form()
    html += post_comment_form()
    html += find_form()
    
    menu_logout()
    menu_profile()
    menu_reload()
    menu_left()
    
    case mode
    when "post_note"
      obj.save_text()
      if $_POST["note_id"].to_i > 0 then
        html += obj.show_by_id($_POST["note_id"])
      else
        html += obj.show()
      end
      output(html)
    when "post_photo"
      obj.save_photo()
      html += obj.show()
      output(html)
    when "find"
      html += obj.find($_POST["word"])
      output(html)
    when "like"
      like = Likes.new()
      like.add()
      puts $cgi.header()
      puts like.count($_POST["note_id"])
    when "photo"
      #puts $cgi.header()
      obj.load_file($_GET["id"])
    else
      html += obj.show()
      output(html)
    end
    
    #html = $usr.get_logout_form()
    #html += "<p>ID = #{$usr.get_id()}</p>"
    
    #return html
    
  end
  
  def output(html)
    
    #menu = "トップ"
    
    wk = {
      "style" => @style,
      "page_title" => @page_title,
      "title" => @title,
      "menu" => @menu,
      "cont" => html,
      "foot" => @foot
    }
    
    html = load_template(wk, "page.html")
    
    puts $cgi.header()
    puts html
    
  end
  
  def menu_space()
    @menu += "<div class='item-right'>&nbsp</div>"
  end
  
  def menu_profile()
    #@menu += "<div class='item-right'>プロファイル</div>"
  end
  
  def menu_logout()
    @menu += "<div class='item-right' onClick='snsLogout();'>ログアウト</div>"
  end
  
  def menu_reload()
    @menu += <<EOF
<div class='item-right' onClick='location.href="/";'>更新</div>
EOF
  end
  
  def menu_left()
    @menu += load_template({}, "menu_left.html")
  end
  
  def post_note_form()
    return load_template({},"post_note.html")
  end
  
  def post_photo_form()
    return load_template({},"post_photo.html")
  end
  
  def post_comment_form()
    return load_template({},"post_comment.html")
  end
  
  def find_form()
    return load_template({},"find_form.html")
  end
  
  
  
end
