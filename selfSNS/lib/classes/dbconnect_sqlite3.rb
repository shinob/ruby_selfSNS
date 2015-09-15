
class DBConnect
  
  @db = nil

  def initialize(host, user, pass, database)
    #@dir = dir()
    open(host, user, pass, database)
  end
  
  def open(host, user, pass, database)
    dbfile = "#{database}.db"
    debug(dbfile)
    @db = SQLite3::Database.new(dbfile)
    #@db = SQLite3::Database.new("#{database}.db")
  end
  
  def close()
    @db.close()
  end
  
  def execute(sql)
    debug(sql)
    return @db.execute2(sql)
  end
  
  def query(sql)
    debug(sql)
    return sql2array(sql)
  end
  
  def exec(sql)
    begin
      @db.execute(sql)
    rescue
      sleep 10
      retry
    end
  end
  
  def sql2array(sql)
    
    begin
      rs = @db.execute2(sql)
    rescue
      sleep 10
      retry
    end
    
    i = 0
    flg = true
    fields = []
    values = []
    
    rs.each do |row|
      if flg then
        fields = row
        flg = false
      else
        j = 0
        val = {}
        row.each do |wk|
          val[fields[j]] = wk
          j += 1
        end
        values[i] = val
        i += 1
      end
    end
    return values
  end
  
  def list_fields(table)
    fields, *rows = @db.execute2("SELECT * FROM `#{table}` limit 1")
    return fields
  end
  
  def escape_string(str)
    str = str.gsub("'","''")
    return str
  end
  
end
