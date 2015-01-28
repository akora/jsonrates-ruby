#!/usr/bin/env ruby

# The jsonrates API provides reliable, fast and free exchange rates and currency conversion for 168 currencies.
# All exchange rates are updated every 10 minutes and were collected from several providers.
# Historical rates are provided from 2002, for Bitcoin from 2010.

require 'net/http'
require 'json'

$base_url = 'http://jsonrates.com/get/'

currencies = ['GBP', 'USD', 'EUR']
rate_in = 'HUF'

def get_currency_rate(currency, rate_in)
  begin
    uri = URI("#{$base_url}?from=#{currency}&to=#{rate_in}")
    response = Net::HTTP.get_response(uri)
  rescue
    puts "Connection error. Exiting..."
    exit 1
  end
  # puts "[" + response.code + "] " + response.uri.to_s
  if response.is_a?(Net::HTTPSuccess)
    response.body = Net::HTTP.get(uri)
    parsed_body = JSON.parse(response.body)
    if parsed_body.has_key? 'error'
      puts "N/A [" + parsed_body['error'] + "]"
    else
      # puts JSON.pretty_generate(parsed_body)
      currency_rate = JSON.parse response.body
      # puts JSON.pretty_generate(currency_rate)
      puts currency + " " + format("%.2f", currency_rate["rate"]).to_s
    end
  else
    puts "N/A [" + response.code + "]"
  end
end

currencies.each do |currency|
  get_currency_rate(currency, rate_in)
end
