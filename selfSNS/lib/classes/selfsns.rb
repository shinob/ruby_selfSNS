class SelfSNS

  def initialize()
    @style = ""
    @page_title = "sefSNS made by Ruby"
    @title = "selSNS made by Ruby"
    @foot = "<a href='https://github.com/shinob/ruby_selfSNS' target='_blank'>ruby_selfSNS@GitHub</a>"
    @menu = ""
    @url = ENV['REQUEST_URI'][0..ENV['REQUEST_URI'].rindex("/")]
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
    html += set_photo_form()
    
    menu_logout()
    menu_profile()
    menu_reload()
    menu_left()
    
    #puts $cgi.header()
    
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
    when "set_photo"
      prof = Profiles.new()
      prof.set("photo", $_POST["set_photo_id"])
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
    when "profile"
      #puts $cgi.header()
      html += obj.show_profile($_GET["id"])
      output(html)
    when "post_profile"
      prof = Profiles.new()
      prof.update_values($_POST)
      html += "<div class='info'>プロフィールを更新しました。</div>"
      #html += "<p>"
      #$_POST.each do |key, val|
      #  html += "<p>#{key} / #{val}</p>"
      #end
      #html += "</p>"
      html += obj.show_profile($_GET["id"])
      output(html)
    else
      html += obj.show()
      output(html)
    end
    
    #html = $usr.get_logout_form()
    #html += "<p>ID = #{$usr.get_id()}</p>"
    
    #return html
    
  end
  
  def add_log()
    
    name = $session["user"]
    mode = $_POST["mode"].to_s
    
    f = File.open($currentDir + "login.log", 'a')
    f << "#{Time.now} [#{name.to_s}] #{mode}\n"
    f.close()
    
  end
  
  def output(html)
    
    #menu = "トップ"
    #html += "<div>#{@url}12345</div>"
    
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
    
    add_log()
    
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
<div class='item-right' onClick='location.href="#{@url}";'>更新</div>
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
  
  def set_photo_form()
    return load_template({},"set_photo.html")
  end
  
  
  
end
