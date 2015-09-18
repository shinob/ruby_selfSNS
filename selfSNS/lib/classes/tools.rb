$flg_debug = true

def debug(txt)
  
  if $flg_debug then
    puts "<div class='debug'>#{txt}</div>\n"
  end
  
end

def get_dir()
  
  return Dir.getwd + "/"
  
end

def get_content_type(filename)
  
  ext = File.extname(filename.downcase)
  #puts ext
  type = ""
  
  case ext
  when ".jpg", ".jpeg"
    type = "image/jpeg"
  when ".png"
    type = "image/png"
  when ".gif"
    type = "image/gif"
  else
    type = "text/html"
  end
  
  return type
  
end

def load_template(values, filename)
  
  dir = $templateDir
  debug(dir + filename)
  
  html = ""
  html = File.read(dir + filename, encoding: 'utf-8')
  
  return make_html_by_values(values, html)
  
end

def make_html_by_values(values, str)
  
  html = str
  
  values.each_pair { |key, val|
    html = html.gsub("_%#{key}%_", val.to_s)
  }
  
  return html

end

def get_login_user()
  
  wk = $session["user"].to_s
  
  return wk

end

def set_auth_type()
  
  $auth_type = $usr.get_auth_type()
  
end

def is_guest()
  
  flg = false
  if $auth_type == "guest" then
    flg = true
  end
  return flg
  
end

def is_admin()
  
  flg = false
  if $auth_type == "admin" then
    flg = true
  end
  return flg
  
end
