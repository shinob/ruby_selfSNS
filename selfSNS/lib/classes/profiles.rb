class Profiles < Model
  
  def initialize()
    set_value($db, "profiles")
    @type = "profiles"
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
  
end
    
