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
      html += make_content()
    else
      html = $usr.get_login_form()
      menu_space()
      #@title = "ログイン"
    end
    
    if true then
      $_POST.each do |key, val|
        html += "<div>#{key} = #{val}</div>"
      end
    end
    
    output(html)
    
  end
  
  def make_content()
    
    mode = $_POST["mode"]
    obj = Notes.new()
    
    html = ""
    
    html += post_note_form()
    html += post_photo_form()
    html += find_form()
    
    case mode
    when "post_note"
      obj.save_text()
      html += obj.show()
    when "find"
      html += obj.find($_POST["word"])
    else
      html += obj.show()
    end
    
    #html = $usr.get_logout_form()
    #html += "<p>ID = #{$usr.get_id()}</p>"
    
    menu_logout()
    menu_profile()
    menu_reload()
    menu_left()
    
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
<div class='item-right' onClick='location.href="/";'>最新に更新</div>
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
  
  def find_form()
    return load_template({},"find_form.html")
  end
  
  
  
end
