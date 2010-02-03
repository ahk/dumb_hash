module DumbHash
  
  class Slow1
    def initialize(default_value=nil)
      @default_value = default_value
      @elements = []
    end
  
    def default_value
      @default_value
    end
  
    def default_value=(default_value)
      @default_value = default_value
    end
  
    def add(key, value)
      @elements << [key, value]
    end
    alias_method :'[]=', :add
  
    def get(key)
      pair = @elements.find {|k,v| k == key}
      pair ? pair.last : @default_value
    end
    alias_method :'[]', :get
  
  end

  class HashedKeyComparison
    def initialize(default_value=nil)
      @default_value = default_value
      @elements = []
      @hashes2indexes = []
      @elements.each_with_index {|e,i| @hashes2indexes << [e[0].hash,i]}
    end
  
    def default_value
      @default_value
    end
  
    def default_value=(default_value)
      @default_value = default_value
    end
  
    def add(key, value)
      @elements << [key, value]
      @hashes2indexes << [key.hash, @elements.size - 1]
    end
    alias_method :'[]=', :add
  
    def get(key)
      key_hash = key.hash
      hash2index = @hashes2indexes.find {|hash,i| hash == key_hash}
      hash2index ? @elements[hash2index[1]][1] : @default_value
    end
    alias_method :'[]', :get

  end
  
  IMPLEMENTATIONS = [self::Slow1, self::HashedKeyComparison]
  
end