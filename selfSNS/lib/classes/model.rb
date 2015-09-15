
class Model
  
  def initialize(db, table)
    set_value(db, table)
  end
  
  def set_value(db, table)
    @db = db
    @table = table
  end
  
  def count()
    sql = "SELECT COUNT(*) AS num FROM `#{@table}`"
    rs = @db.query(sql)
    return rs[0]["num"]
  end
  
  def get_max_id()
    
    sql = "SELECT MAX(id) AS id FROM `#{@table}`"
    #debug(sql)
    rs = @db.query(sql)
    #debug("count = #{rs.length}")
    return rs[0]["id"].to_i
    
  end
  
  def get_ids()
    sql = "SELECT id FROM `#{@table}`"
    return @db.query(sql)
  end
  
  def get_value_by_id(field,id)
    vals = get_data_by_id(id)
    return vals[field]
    #return "T_T"
  end
  
  def get_random_data()
    ids = get_ids()
    cnt = ids.length
    rs = get_data_by_id(ids[rand(cnt)]["id"])
    return rs
  end
  
  def get_data_by_id(id)
    sql = "SELECT * FROM #{@table} WHERE id=#{id}"
    return @db.query(sql)[0]
  end
  
  def get_data()
    sql = "SELECT * FROM #{@table} ORDER BY id DESC"
    return @db.query(sql)
  end
  
  def get_data_with_order(column)
    sql = "SELECT * FROM #{@table} ORDER BY #{column}"
    return @db.query(sql)
  end
  
  def get_data_by_value(column, value)
    sql = "SELECT * FROM #{@table} WHERE #{column}=#{value}"
    return @db.query(sql)
  end
  
  def get_data_by_str(column, value)
    sql = "SELECT * FROM #{@table} WHERE #{column}='#{value}'"
    return @db.query(sql)
  end
  
  def get_blank_data()
    
    vals = {}
    @db.list_fields(@table).each do |f|
      vals[f] = ""
    end
    return vals
    
  end
  
  def apply(values)
    
    debug("<div>#{values.to_s}</div>")
    
    if values.has_key?('id') then
      id = values['id'].to_s
    else
      id = 0
    end
    
    if 1 > id.to_i
      values["id"] = get_max_id() + 1
      debug(values["id"])
	  #print "#{values["id"]}<br>"
      sql = insert(values)
    else
      sql = update(values, id)
    end
    
    #print sql
    debug(sql)
    @db.exec(sql)
    
    return values["id"]
    
  end
  
  def insert(values)
  
    sql = "INSERT INTO `#{@table}` "
    
    col = ""
    val = ""
    fields = @db.list_fields(@table)
    #debug_print rs.num_fields()
    
    fields.each do |fd|
      #debug_print fd.name + "<br />"
      if values.has_key?(fd) then
        if col != "" then
          col += ","
          val += ","
        end
        col += fd
        val += "'" + @db.escape_string(values[fd].to_s) + "'"
      end
    end
    
    sql += "(#{col}) VALUES (#{val})"
    return sql
    
  end
  
  def update(values, id)
    
    sql = "UPDATE `#{@table}` SET "
    col = ""
    
    rs = @db.list_fields(@table)
    #debug_print "#{table}<br />"
    
    rs.each do |fd|
      #debug_print fd.name + "<br />"
      #print values[fd] + "<br />"
      if values.has_key?(fd) then
        if col != "" then
          col += ","
        end
        col += "#{fd}='" + @db.escape_string(values[fd].to_s) + "'"
      end
    end
    
    sql += "#{col} WHERE id=#{id}"
    return sql
    
  end
  
  def delete(id)
    
    sql = "DELETE FROM `#{@table}` WHERE id=#{id}"
    #print sql
    exec(sql)
    
  end
  
  def setup()
    
    sql = "DROP TABLE `persons`"
    #@db.execute(sql)
    
    sql = <<EOF
CREATE TABLE `persons`(
  id integer primary key,
  name text,
  year text,
  country text,
  note text,
  photo text
)
EOF
    #@db.execute(sql)
    
    sql = "ALTER TABLE `persons` ADD COLUMN photo text"
    #@db.execute(sql)
    
    sql = "DROP TABLE `words`"
    #@db.execute(sql)
    
    sql = <<EOF
CREATE TABLE `words`(
  id integer primary key,
  person_id integer,
  japanese text,
  english text
)
EOF
    #@db.execute(sql)
    
    sql = "DROP TABLE `logs`"
    #@db.execute(sql)
    
    sql = <<EOF
CREATE TABLE `logs`(
  id integer primary key,
  time integer,
  ip text
)
EOF
    #@db.execute(sql)
    
  end
  
end
