require 'benchmark'
require File.dirname(__FILE__) + '/../dumb_hash'

DumbHash::IMPLEMENTATIONS.each do |implementation|
  [1000_000].each do |n|
    puts "#{n} times DOING:"
    hash = implementation.new
    puts implementation.to_s
    Benchmark.bm do |x|
      x.report('set') {n.times { |i| hash.set("key#{i}".to_sym, "val#{i}".to_sym) }}
      x.report('get') {n.times { |i| hash.get("key#{i}".to_sym) }}
    end
  end
end