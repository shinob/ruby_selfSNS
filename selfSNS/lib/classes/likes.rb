class Likes < Model
  
  def initialize()
    set_value($db, "likes")
    @type = "likes"
  end
  
  def add()
    
    t = Time.now
    
    $_POST["id"] = 0
    $_POST["user_id"] = $usr.get_id()
    $_POST["post_date"] = t.strftime("%Y-%m-%d %H:%M:%S")
    
    if exist($_POST["note_id"]) then
      rs = 0
    else
      rs = apply($_POST)
    end
    
    return rs
    
  end
  
  def count(note_id)
    
    vals = get_data_by_value("note_id", note_id)
    return vals.length
    
  end
  
  def exist(note_id)
    user_id = $usr.get_id()
    sql = "SELECT * FROM #{@table} WHERE user_id=#{user_id} AND note_id=#{note_id}"
    return (@db.query(sql).length > 0)
  end
end
    
