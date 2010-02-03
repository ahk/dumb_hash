require 'benchmark'
require File.dirname(__FILE__) + '/../dumb_hash'

n = 1000
puts "#{n} times DOING:"

DumbHash::IMPLEMENTATIONS.each do |implementation|
  hash = implementation.new
  puts implementation.to_s
  Benchmark.bm do |x|
    x.report('add') {n.times { |i| hash.add("key#{i}".to_sym, "val#{i}".to_sym) }}
    x.report('get') {n.times { |i| hash.get("key#{i}".to_sym) }}
  end
end