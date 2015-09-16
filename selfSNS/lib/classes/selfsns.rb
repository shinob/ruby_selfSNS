class SelfSNS

  def initialize()
    @style = ""
    @page_title = "SELF SNS"
    @title = "TITLE"
    @foot = "<a href='https://github.com/shinob/ruby_selfSNS' target='_blank'>ruby_selfSNS@GitHub</a>"
    @menu = ""
  end
  
  def main()
    
    html = ""
    
    if $usr.is_login() then
      html += make_content()
    else
      html = $usr.get_login_form()
      menu_space()
      #@title = "ログイン"
    end
    
    $_POST.each do |key, val|
      html += "<div>#{key} = #{val}</div>"
    end
    
    output(html)
    
  end
  
  def make_content()
    
    mode = $_POST["mode"]
    
    html = ""
    
    case mode
    when "post_note"
      obj = Notes.new()
      obj.save_text()
    else
      
    end
    
    #html = $usr.get_logout_form()
    html += post_note_form()
    html += post_photo_form()
    html += "<p>ID = #{$usr.get_id()}</p>"
    
    menu_logout()
    menu_profile()
    
    return html
      
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
    puts html
    
  end
  
  def menu_space()
    @menu += "<div class='item'>&nbsp</div>"
  end
  
  def menu_profile()
    @menu += "<div class='item'>プロファイル</div>"
  end
  
  def menu_logout()
    @menu += "<div class='item' onClick='snsLogout();'>ログアウト</div>"
  end
  
  def post_note_form()
    return load_template({},"post_note.html")
  end
  
  def post_photo_form()
    return load_template({},"post_photo.html")
  end
  
  
  
end
