require 'benchmark'
require File.dirname(__FILE__) + '/../dumb_hash'

DumbHash::IMPLEMENTATIONS.each do |implementation|
  [10, 100, 1000, 10000].each do |n|
    puts "#{n} times DOING:"
    hash = implementation.new
    puts implementation.to_s
    Benchmark.bm do |x|
      x.report('set') {n.times { |i| hash.set(:"key#{i}", :"val#{i}") }}
      x.report('get') do 
        n.times do |i|
          val = hash.get(:"key#{i}")
          raise "Collision, k:key#{i} v:#{val}" if val  != :"val#{i}"
        end
      end
    end
  end
end