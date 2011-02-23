require 'benchmark'
require File.dirname(__FILE__) + '/../dumb_hash'

[10, 100, 1000, 10_000].each do |n|
  
  puts "#{n} times DOING:"
  
  DumbHash::IMPLEMENTATIONS.each do |implementation|
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

  hash = Hash.new
  puts "Hash"
  Benchmark.bm do |x|
    x.report('set') {n.times { |i| hash[:"key#{i}"] = :"val#{i}" }}
    x.report('get') do 
      n.times do |i|
        val = hash[:"key#{i}"]
        raise "Collision, k:key#{i} v:#{val}" if val  != :"val#{i}"
      end
    end
  end
  
  puts
  puts
end
  
