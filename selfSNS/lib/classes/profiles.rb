class Profiles < Model
  
  def initialize()
    set_value($db, "profiles")
    @type = "profiles"
    @titles = {
      "org"  => "所属",
      "addr" => "地域"
    }
    
  end
  
  def set(title, value)
    
    vals = {}
    
    vals["user_id"] = $usr.get_id()
    vals["title"] = title
    vals["value"] = value
    vals["id"] = exists(vals["user_id"], title)
    
    return apply(vals)
    
  end
  
  def get(user_id, title)
    
    #user_id = $usr.get_id()
    sql = "SELECT * FROM #{@table} WHERE user_id = '#{user_id}' AND title = '#{title}'"
    vals = @db.query(sql)
    
    val = ""
    
    if vals.length > 0 then
      val = vals[0]["value"]
    end
    
    return val
    
  end
  
  def exists(user_id, title)
    
    sql = "SELECT * FROM #{@table} WHERE user_id = '#{user_id}' AND title = '#{title}'"
    vals = @db.query(sql)
    
    id = 0
    
    if vals.length > 0 then
      id = vals[0]["id"]
    end
    
    return id
    
  end
  
  def show(user_id)
    
    sql = "SELECT * FROM #{@table} WHERE user_id = '#{user_id}' AND title <> 'photo'"
    #puts sql
    vals = @db.query(sql)
    
    prof = {}
    
    vals.each do |row|
	  prof[row["title"]] = row["value"]
	end
	
    html = ""
    
    #prof.each do |key, val|
    #  html += "<p>#{key} / #{val}</p>"
    #end
    
    @titles.each do |key, val|
      row = {}
      row["title"] = val
      row["value"] = (prof.has_key?(key)) ? prof[key] : "&nbsp;"
      html += load_template(row, "show_profile_item.html")
    end
    
    return html + "&nbsp;"
    
  end
  
  def edit(user_id)
    
    html = ""
    
    @titles.each do |key, val|
      row = {}
      row["title"] = key
      row["title_disp"] = val
      row["value"] = get(user_id, key)
      html += load_template(row, "show_profile_edit.html")
    end
    
    return html + "<input type='submit' value='更新' style='margin-top: 10px;' />"
    
  end
  
  def update_values(vals)
    
    @titles.each do |key, val|
      
      title = key
      value = vals[title]
      #puts "<p>#{key}, #{value}</p>"
      
      self.set(title, value)
      
    end
    
  end
  
end
    
