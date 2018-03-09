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
http6 = Net::HTTP.new('localhost', 3006)
http7 = Net::HTTP.new('localhost', 3007)
http8 = Net::HTTP.new('localhost', 3008)
http9 = Net::HTTP.new('localhost', 3009)
http10 = Net::HTTP.new('localhost', 3010)
request = Net::HTTP::Post.new(uri.request_uri, header)
request.body = body.to_json

http = [http1, http2, http3, http4, http5, http6, http7, http8, http9, http10]
$num_transactions = 0

def batch(http, request)
  (0...5).each do |h|
    response = http.sample.request(request)
    if response.kind_of? Net::HTTPSuccess
      $num_transactions += 1
      open('transactions.log', 'a') { |f|
        f.puts "#{Time.now.utc} #{$num_transactions}\n"
      }
    end
  end
end

(0...10).map do |t|
  Thread.new do
    batch(http, request)
  end
  sleep 0.5
end

(0...10).map do |t|
  Thread.new do
    batch(http, request)
  end
  sleep 0.5
end

(0...10).map do |t|
  Thread.new do
    batch(http, request)
  end
  sleep 0.5
end

(0...10).map do |t|
  Thread.new do
    batch(http, request)
  end
  sleep 0.5
end

(0...10).map do |t|
  Thread.new do
    batch(http, request)
  end
  sleep 0.5
end

(0...10).map do |t|
  Thread.new do
    batch(http, request)
  end
  sleep 0.5
end

sleep 1000000
