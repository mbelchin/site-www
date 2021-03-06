#!/usr/bin/env ruby

require_relative 'urls/get_all'

puts "===== Checking inbound links and redirects through HTMLProofer ====="

puts "Spawning firebase server on localhost"
pid = spawn("firebase serve --port #{$PORT}", :out => "/dev/null")
puts "..."
sleep 5

begin
  puts "Checking links"
  unreachable_urls = []
  $LOCALHOST_URLS.each do |url|
    reachable = system("./deploy/check_url.sh #{url}")
    unreachable_urls.push(url) unless reachable == true
  end
  puts "Done"

  if unreachable_urls.any?
    puts "SOME URLS FAILED"
    puts unreachable_urls
  else
    puts "SUCCESS"
  end
ensure
  puts "Killing firebase server on localhost"
  Process.kill(:SIGINT, pid)
end