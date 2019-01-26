require 'json'

name = ARGV[0]
full_url = ARGV[1]
split_url = full_url.split("?")

url, query_string = split_url.first + "?", split_url.last

query_keys = query_string
  .split("&")
  .map { |pair| pair.split("=").first }

endpoint = {
  name: name,
  url: url, 
  parameters: query_keys
}

File.write("output.json", JSON.generate(endpoint))