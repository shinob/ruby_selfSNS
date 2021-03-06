class Notes < Model
  
  def initialize()
    
    set_value($db, "notes")
    @type = "notes"
    
    @name = "filename"
    @dir = Dir.getwd + "/files/"
    
    @prof = Profiles.new()
    @url = ENV['REQUEST_URI'][0..ENV['REQUEST_URI'].rindex("/")]
    
    @limit = $notes_limit
    
  end
  
  def get_file_dir(id)
    return @dir + sprintf("%010d",id.to_i)
  end
  
  def get_file_link_dir(id)
    return "files/" + sprintf("%010d/", id.to_i)
  end
  
  def load_file(id)
    
    vals = get_data_by_id(id)
    filename = get_file_dir(id) + "/" + vals["comment"]
    
    #puts vals["comment"]
    #puts get_content_type(vals["comment"])
    
    puts <<EOF
Content-type: #{get_content_type(vals["comment"])}
Content-Disposition: attachment; filename="#{vals['comment']}"

EOF
    #puts $cgi.header(get_content_type(vals["comment"]))
    
    f = File.open(filename, "r+b")
    #puts f.read
    img = Magick::Image.from_blob(f.read).shift
    puts img.auto_orient.to_blob
    f.close
    
  end
  
  def load_user_photo(id)
    
    vals = get_data_by_id(id)
    filename = get_file_dir(id) + "/" + vals["comment"]
    
    #puts vals["comment"]
    #puts get_content_type(vals["comment"])
    
    puts <<EOF
Content-type: #{get_content_type(vals["comment"])}
Content-Disposition: attachment; filename="#{vals['comment']}"

EOF
    #puts $cgi.header(get_content_type(vals["comment"]))
    
    f = File.open(filename, "r+b")
    #puts f.read
    img = Magick::Image.from_blob(f.read).shift
    puts img.auto_orient.resize_to_fill(300,300).to_blob
    f.close
    
  end
  
  def save_text()
    
    t = Time.now
    
    $_POST["id"] = 0
    $_POST["user_id"] = $usr.get_id()
    $_POST["note_type"] = "text"
    $_POST["post_date"] = t.strftime("%Y-%m-%d %H:%M:%S")
    
    $_POST["tag"] = $_POST["tag"].gsub("　"," ")
    
    return apply($_POST)
    
  end
  
  def save_photo()
    
    data = $cgi.params[@name][0]
    dir, filename =  File::split(data.original_filename.force_encoding("utf-8").gsub("\\","/"))
    
    t = Time.now
    
    $_POST["id"] = 0
    $_POST["user_id"] = $usr.get_id()
    $_POST["note_type"] = "photo"
    $_POST["post_date"] = t.strftime("%Y-%m-%d %H:%M:%S")
    $_POST["comment"] = filename
    
    $_POST["tag"] = $_POST["tag"].gsub("　"," ")
    
    id = apply($_POST)
    
    file_dir = get_file_dir(id)
    FileUtils.mkdir_p(file_dir) unless FileTest.exist?(file_dir)
    
    open(file_dir + "/" + filename, "w") do |fh|
      fh.binmode
      fh.write data.read
      
      #img = Magick::Image.from_blob(data.read).shift
      #fh.write img.auto_orient.to_blob
    end
    
    return id
    
  end
  
  def show()
    
    cnt = $_GET["cnt"].to_i
    limit = @limit
    offset = 0
    
    if cnt > 0 then
      offset = cnt * limit
    end
    
    sql = "SELECT * FROM #{@table} WHERE note_id IS Null ORDER BY id DESC LIMIT #{limit} OFFSET #{offset}"
    #vals = get_data()
    vals = @db.query(sql)
    html = make_show(vals)
    
    prv = ""
    nxt = ""
    
    if cnt > 0 then
      prv = "<a href='#{@url}?cnt=#{cnt - 1}' class='nav' style='float:left'>新しい投稿</a>"
    else
      prv = ""
    end
    
    #if html != "" then
    if vals.length < @limit then
      nxt = ""
    else
      nxt = "<a href='#{@url}?cnt=#{cnt + 1}' class='nav' style='float: right'>古い投稿</a>"
    end
    
    if html != "" then
      html += "#{prv}#{nxt}"
    end
    
    #html += "<div>#{vals.length}</div>"
    
    return <<EOF
#{prv}
#{nxt}
#{html}
EOF
    
  end
  
  def show_by_id(id)
    
    sql = "SELECT * FROM #{@table} WHERE id = '#{id}' ORDER BY id DESC"
    #vals = get_data()
    vals = @db.query(sql)
    return make_show(vals)
    
  end
  
  def find(word)
    
    sql = "SELECT * FROM #{@table} WHERE comment LIKE '%#{word}%' OR tag LIKE '%#{word}%' ORDER BY id DESC"
    vals = @db.query(sql)
    
    html = ""
    
    if vals.length > 0 then
      html += make_show(vals)
    else
      html += "<div class='info' style='height: 350px;'>一致する検索結果がありませんでした。</div>"
    end
    
    return html
  
  end
  
  def tag(word)
    
    html = ""
    
    if word.to_s == "" then
      html += tag_list_all()
    else
      html += tag_filter(word)
    end
    
    return html
    
  end
  
  def tag_filter(word)
    
    sql = "SELECT * FROM #{@table} WHERE tag LIKE '%#{word}%' ORDER BY id DESC"
    vals = @db.query(sql)
    
    html = ""
    
    if vals.length > 0 then
      html += make_show(vals)
    else
      html += "<div class='info' style='height: 350px;'>一致する検索結果がありませんでした。</div>"
    end
    
    return html
  
  end
  
  def tag_list()
    
    sql = "SELECT tag, COUNT(*) AS num FROM #{@table} GROUP BY tag ORDER BY num DESC LIMIT 5"
    vals = @db.query(sql)
    
    html = ""
    tags = []
    
    #puts $cgi.header()
    vals.each do |row|
      #puts row["tag"].to_s.class #.split(" ")
      row["tag"].to_s.split(" ").each do |tag|
        if tags.include?(tag) then
        
        else
          tags.push(tag)
          html += "<a href='#{@url}?mode=tag&word=#{tag}'>#{tag}</a>"
        end
        
      end
      
    end
    
    html += "<a href='#{@url}?mode=tag' style='text-align: right;'>[一覧表示]</a>"
    return html
  
  end
  
  def tag_list_all()
    
    sql = "SELECT tag, COUNT(*) AS num FROM #{@table} GROUP BY tag ORDER BY num DESC"
    vals = @db.query(sql)
    
    html = ""
    tags = []
    
    #puts $cgi.header()
    vals.each do |row|
      #puts row["tag"].to_s.class #.split(" ")
      row["tag"].to_s.split(" ").each do |tag|
        if tags.include?(tag) then
        
        else
          tags.push(tag)
          html += "<a href='#{@url}?mode=tag&word=#{tag}'>#{tag}</a>"
        end
        
      end
      
    end
    
    return "<div class='tag_list'>#{html}</div>"
  
  end
  
  def make_show(vals)
    
    html = ""
    
    ids = []
    
    vals.each do |row|
      
      flg = true
      
      if row["note_id"].to_i > 0 then
        row = get_data_by_id(row["note_id"])
      end
      
      if ids.include?(row["id"]) then
        
      else
        ids.push(row["id"])
        
        row["user_name"] = $usr.get_disp_name(row["user_id"])
        row["user_name"] = "<a href='#{@url}?mode=profile&id=#{row["user_id"]}' class='user_name'>#{row["user_name"]}</a>"
        row["user_photo"] = get_user_photo(row["user_id"])
        
        like = Likes.new()
        row["likeCount"] = like.count(row["id"]).to_s
        
        row["add_comment"] = ""
        
        if row["note_type"] == "text" then
          #html += load_template(row, "show_note.html")
          row["comment"].gsub!("\n", "<br />")
        else
          #filename = get_file_link_dir(row["id"]) + row["comment"]
          #deg = get_image_orientation(filename)
          #row["comment"] = "<img src='#{get_file_link_dir(row["id"]) + row["comment"]}' width=100% />"
          row["comment"] = "<img src='#{@url}?mode=photo&id=#{row["id"]}' width=100% onClick='show_set_photo_form(#{row["id"]})'/>"
          #row["comment"] += filename
          #row["comment"] += get_image_orientation(filename).to_s
          #html += load_template(row, "show_photo.html")
        end
        
        row["add_comment"] += show_comments(row["id"])
        
        html += load_template(row, "show_note.html")
        
      end
      
    end
    
    #return html + "<br />";
    return html;
    
  end
  
  def show_comments(id)
    
    sql = "SELECT * FROM #{@table} WHERE note_id = '#{id}'"
    vals = @db.query(sql)
    
    html = ""
    
    i = 0
    color = ["#FAFAFA", "#FFF"]
    
    vals.each do |row|
      row["bgcolor"] = color[i % 2]
      #html += "<div>#{row['comment']}</div>"
      row["user_name"] = $usr.get_disp_name(row["user_id"])
      row["user_name"] = "<a href='#{@url}?mode=profile&id=#{row["user_id"]}' class='user_name'>#{row["user_name"]}</a>"
      row["user_photo"] = get_user_photo(row["user_id"])
      row["comment"].gsub!("\n", "<br />")
      
      html += load_template(row, "show_comment.html")
      i += 1
    end
    
    return html
    #return sql
    
  end
  
  def get_user_photo(user_id)
    
    id = @prof.get(user_id, "photo")
    
    if id.to_i > 0 then
      #img = "<img src='#{@url}?mode=photo&id=#{id}' />"
      img = "<img src='#{@url}?mode=user_photo&id=#{id}' />"
    else
      img = "&nbsp;"
    end
    
    return img
    
  end
  
  def show_profile(user_id)
    
    vals = {}
    
    vals["user_photo"] = get_user_photo(user_id)
    vals["user_name"] = $usr.get_disp_name(user_id)
    
    if $usr.get_id() == user_id then
      vals["items"] = @prof.edit(user_id)
    else
      vals["items"] = @prof.show(user_id)
    end
    
    html = load_template(vals, "show_profile.html")
    
    return html
    
  end
  
  def edit_profile(user_id)
    
    
    
  end
  
end
    
