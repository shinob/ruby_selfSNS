#!/usr/local/bin/ruby
# encoding: utf-8

load 'lib/header.rb'

begin
  
  sns = SelfSNS.new()
  sns.main()
  
rescue => ex
  
  puts ex.message
  
end
