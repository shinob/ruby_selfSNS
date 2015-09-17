class Notes < Model
  
  def initialize()
    set_value($db, "notes")
    @type = "notes"
  end
  
  def save_text()
    
    t = Time.now
    
    $_POST["id"] = 0
    $_POST["user_id"] = $usr.get_id()
    $_POST["note_type"] = "text"
    $_POST["post_date"] = t.strftime("%Y-%m-%d %H:%M:%S")
    
    return apply($_POST)
    
  end
  
  def show()
    
    vals = get_data()
    html = ""
    
    vals.each do |row|
      row["user_name"] = $usr.get_disp_name(row["user_id"])
      like = Likes.new()
      row["likeCount"] = like.count(row["id"]).to_s
      html += load_template(row, "show_note.html")
    end
    
    return html + "<br />"
    
  end
  
  def find(word)
    
    sql = "SELECT * FROM #{@table} WHERE comment LIKE '%#{word}%' ORDER BY id DESC"
    vals = @db.query(sql)
    html = ""
    
    vals.each do |row|
      row["user_name"] = $usr.get_disp_name(row["user_id"])
      html += load_template(row, "show_note.html")
    end
    
    return html + "<br />"
  
  end
  
=begin
  def edit(id)
    
    vals = get_data_by_id(id)
    $_GET["doctype_id"] = get_doctype_id(vals["docgroup_id"])
    return get_edit_form(vals)
    
  end
  
  def show(id)
    
    vals = get_data_by_id(id)
    $_GET["doctype_id"] = get_doctype_id(vals["docgroup_id"])
    return get_show_form(vals)
    
  end
  
  def add()
    
    vals = get_blank_data()
    vals["docgroup_id"] = $_GET["docgroup_id"]
    return get_edit_form(vals)
    
  end
  
  def get_edit_form(vals)
    
    grp = DocGroups.new()
    typ = DocTypes.new()
    
    vals["docgroup_id"] = grp.get_select_form("docgroup_id", vals["docgroup_id"])
    
    doctype_id = $_GET["doctype_id"]
    
    html = make_html_by_values(vals, typ.get_data_edit_form(doctype_id))
    
    return html
    
  end
  
  def get_show_form(vals)
    
    grp = DocGroups.new()
    typ = DocTypes.new()
    
    vals["docgroup_id"] = grp.get_name(vals["docgroup_id"])
    
    doctype_id = $_GET["doctype_id"]
    
    html = make_html_by_values(vals, typ.get_data_show_form(doctype_id))
    
    f = Files.new()
    html += f.get_upload_form(vals["id"])
    
    return html
    
  end
  
  def get_find_form()
    
    word = $_POST["word"].to_s
    
    html = <<EOF
<form method="post">
  <input type="hidden" name="mode" value="find_docdata" />
  <table>
    <tr>
      <td><input type="text" name="word" value="#{word}" size=10 /></td>
      <td><input type="submit" name="submit" value="検索" /></td>
    </tr>
  </table>
</form>
EOF
    return html
    
  end
  
  def get_name(id)
    return get_value_by_id("name", id)
  end
  
  def get_doctype_id(docgroup_id)
    grp = DocGroups.new()
    vals = grp.get_data_by_id(docgroup_id)
    return vals["doctype_id"]
  end
  
  def get_select_form(name, id)
    
    vals = get_data_with_order("name")
    html = "<SELECT name='#{name}'>"
    vals.each do |row|
      tmp = (row["id"].to_i==id.to_i) ? "selected" : ""
      html += "<OPTION value='#{row["id"]}' #{tmp}>#{row["name"]}</OPTION>"
    end
    html += "</SELECT>"
    return html
    
  end
  
  def list_all()
    
    opt = ""
    
    docgroup_id = $_GET["docgroup_id"].to_i
    if docgroup_id > 0 then
      sql = "SELECT * FROM #{@table} WHERE docgroup_id=#{docgroup_id} ORDER BY num DESC, id DESC;"
      vals = @db.query(sql)
    else
      sql = "SELECT * FROM #{@table} ORDER BY id DESC LIMIT 10;"
      vals = @db.query(sql)
      opt = "<h1>新着10件</h1>"
    end
    
    return opt + get_list_table(vals)
    
  end
  
  def list_by_word()
    
    docgroup_id = $_GET["docgroup_id"].to_i
    
    str = ""
    opt = ""
    
    if docgroup_id > 0 then
      str = "AND docgroup_id = #{docgroup_id}"
      grp = DocGroups.new()
      opt = grp.get_name(docgroup_id) + "内の"
    end
    
    sql = "SELECT * FROM #{@table} WHERE title LIKE '%#{$_POST["word"]}%' #{str};"
    vals = @db.query(sql)
    opt = "<h1>#{opt}「#{$_POST["word"]}」検索結果</h1>"
    return opt + get_list_table(vals)
    
  end
  
  def get_add_form()
    
    html = ""
    
    if $_GET["docgroup_id"].to_i > 0 then
      if !is_guest() then
        html = <<EOF
<form method='post'>
  <input type="hidden" name="id" value="0" />
  <input type="hidden" name="mode" value="add_#{@type}" />
  <input type="submit" name="submit" value="追加" />
</form>
EOF
      else
        html = <<EOF
<form>
  <input type="button" name="submit" value="追加" onClick='alert("利用できません");' />
</form>
EOF
      end
    end
    
    return html
    
  end
  
  def get_operation_form(id)
    
    if !is_guest() then
    
      html = <<EOF
<form method='post' name='docdata#{id}'>
  <input type="hidden" name="id" value="#{id}" />
<!--
  <input type="hidden" name="mode" value="edit_#{@type}" />
  <input type="submit" name="submit" value="編集" />
  <input type="submit" name="submit" value="表示" onclick="this.form.mode.value='show_#{@type}';" />
  <input type="submit" name="submit" value="表示" />
-->
  <input type="hidden" name="mode" value="show_#{@type}" />
  <img src="pen.png" width="24" style="cursor: pointer;" onClick="document.docdata#{id}.submit();" />
</form>
EOF
    
    else
      html = <<EOF
<!--
<input type='button' value='表示' onclick='alert("利用できません");' />
-->&nbsp;
EOF
    end
    
    return html
    
  end
  
  def get_list_table(vals)
    
    debug("doc#{@type}s.get_list_table")
    html = get_add_form()
    
    fl = Files.new()
    typ = DocTypes.new()
    grp = DocGroups.new()
    
    if vals.length > 0 then
      
      grp_vals = grp.get_data_by_id(vals[0]["docgroup_id"])
      
      html += "<table class='list'>" + typ.get_list_header(grp_vals["doctype_id"])
      
    end
    
    vals.each do |row|
      
      grp_vals = grp.get_data_by_id(row["docgroup_id"])
      grp_name = grp_vals["name"]
      typ_name = typ.get_name(grp_vals["doctype_id"])
      
      str = typ.get_list_row(grp_vals["doctype_id"])
      
      row["doctype_name"] = typ_name
      row["docgroup_name"] = grp_name
      
      row["file"] = fl.get_file_links(row["id"])
      row["form"] = get_operation_form(row["id"])
      
      html += make_html_by_values(row, str)
      
    end
    
    html += "</table>"
    
    return html
    
  end
=end
  
end
    
