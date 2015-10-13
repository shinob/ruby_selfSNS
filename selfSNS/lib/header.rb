# encoding: utf-8

require 'cgi'
require 'cgi/session'
require 'sqlite3'
require 'exifr'
#require 'RMagick'
require 'rmagick'
require "digest/md5"

$cgi = CGI.new()
$session = CGI::Session.new($cgi)

#puts $cgi.header()

$currentDir = Dir.getwd + "/lib/"

$classDir = $currentDir + "classes/"
$templateDir = $currentDir + "templates/"
$databaseDir = $currentDir + "databases/"

classes = [
  "../config.rb",
  "tools.rb",
  "aduser.rb",
  "dbconnect_sqlite3.rb",
  "model.rb",
  "users.rb",
  "notes.rb",
  "likes.rb",
  "profiles.rb",
  "selfsns.rb"
]

classes.each do |c|
  load $classDir + c
end

$flg_debug = false
if $flg_debug then
  puts $cgi.header()
end

debug("USER : " + $session["user"].to_s)

$_GET = {}
CGI::parse($cgi.query_string).each {|key, val|
 $_GET[key] = val[0]
}

$_POST = {}
$cgi.params.each {|key, val|
  tmp = val[0]
  $_POST[key] = tmp
  debug("#{key} : #{tmp}")
}

$db_host = "localhost"
$db_user = "root"
$db_pass = "root"
$db_name = "selfSNS"

$db = DBConnect.new($db_host, $db_user, $db_pass, $databaseDir + $db_name)

$flg_ad = false

$ad_host = "0.0.0.0"
$ad_port = "389"
$ad_domain = "@domain"

$usr = Users.new()
$auth_type = ""
#set_auth_type()
