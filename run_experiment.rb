#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'

header = {'Content-Type': 'application/json'}
body = {
         password: '1 2 3 4 5',
         confirmPassword: '1 2 3 4 5'
       }

uri = URI.parse("http://localhost:3001/rydecoin/create_account")

http1 = Net::HTTP.new('localhost', 3001)
http2 = Net::HTTP.new('localhost', 3002)
http3 = Net::HTTP.new('localhost', 3003)
http4 = Net::HTTP.new('localhost', 3004)
http5 = Net::HTTP.new('localhost', 3005)
request = Net::HTTP::Post.new(uri.request_uri, header)
request.body = body.to_json

http = [http1, http2, http3, http4, http5]
$num_transactions = 0
$num_accepted = 0
$num_rejected = 0

def batch(http, request)
  http.each do |h|
    response = h.request(request)
    $num_transactions += 1
    if response.kind_of? Net::HTTPSuccess
      $num_accepted += 1
      puts "[#{Time.now.utc}] total: #{$num_transactions}, accepted: #{$num_accepted}, rejected: #{$num_rejected}"
    else
      $num_rejected += 1
      puts "[#{Time.now.utc}] total: #{$num_transactions}, accepted: #{$num_accepted}, rejected: #{$num_rejected}"
    end
  end
end

(0...10).map do |t|
  Thread.new do
    batch(http, request)
  end
  sleep 5
end

(0...10).map do |t|
  Thread.new do
    batch(http, request)
  end
  sleep 5
end

(0...10).map do |t|
  Thread.new do
    batch(http, request)
  end
  sleep 5
end

(0...10).map do |t|
  Thread.new do
    batch(http, request)
  end
  sleep 5
end

(0...10).map do |t|
  Thread.new do
    batch(http, request)
  end
  sleep 5
end

(0...10).map do |t|
  Thread.new do
    batch(http, request)
  end
  sleep 5
end

sleep 1000000
