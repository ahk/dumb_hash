module DumbHash
  
  class Dumbest
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
  
    def set(key, value)
      @elements << [key, value]
    end
    alias_method :'[]=', :set
  
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
  
    def set(key, value)
      @elements << [key, value]
      @hashes2indexes << [key.hash, @elements.size - 1]
    end
    alias_method :'[]=', :set
  
    def get(key)
      key_hash = key.hash
      hash2index = @hashes2indexes.find {|hash,i| hash == key_hash}
      hash2index ? @elements[hash2index[1]][1] : @default_value
    end
    alias_method :'[]', :get

  end
  
  class HashedKeyTree
    def initialize(default_value=nil)
      @default_value = default_value
      @elements = []
      @hashes_tree = []
      @elements.each_with_index {|e,i| pack_hash_and_index(e[0],i)}
    end
  
    def default_value
      @default_value
    end
  
    def default_value=(default_value)
      @default_value = default_value
    end
  
    def set(key, value)
      @elements << [key, value]
      pack_key_and_index(key, @elements.size - 1)
    end
    alias_method :'[]=', :set
  
    def get(key)
      index = find_index_for_key(key)
      index ? @elements[index][1] : @default_value
    end
    alias_method :'[]', :get
    
    private
    
      def find_index_for_key(key)
        hash = key.object_id
        find_terminal_node(@hashes_tree, branch_for(hash))
      end
    
      # make a branch with an index at the end
      # build this branch onto the tree
      def pack_key_and_index(key, index)
        hash = key.object_id
        branch = branch_for(hash).push(index)
        merge_branch_with_tree(@hashes_tree, branch)
      end
      
      # nodes to traverse in order
      def branch_for(hash)
        branch = hash.to_s.split('')
        zeros = 7 - branch.size
        zeros.times {branch.unshift 0}
        branch.map {|e| e.to_i}
      end
      
      # tend the tree
      def merge_branch_with_tree(parent, branch)
        node = branch.shift
        if branch.size == 1
          parent[node] = branch[0]
          return
        else
          parent[node] ||= []
        end
        merge_branch_with_tree(parent[node], branch)
      end
      
      # find terminal value, else return nil
      def find_terminal_node(parent, branch)
        node = branch.shift
        return parent[node] unless parent[node].is_a? Array
        return nil if branch.empty?
        find_terminal_node(parent[node], branch)
      end

  end
  
  IMPLEMENTATIONS = [self::Dumbest, self::HashedKeyComparison, self::HashedKeyTree]
  
end