module DumbHash

  class Base
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

    def each(&block)
      @elements.each(&block)
    end

    def set(*args)
      raise NotImplementedError
    end
    
    def get(*args)
      raise NotImplementedError
    end

    def [](*args)
      self.get(*args)
    end

    def []=(*args)
      self.set(*args)
    end
  end
  
  class Dumbest < Base
    def set(key, value)
      @elements.delete_if {|e| e[0] == key }
      @elements << [key, value]
    end
  
    def get(key)
      pair = @elements.find {|k,v| k == key}
      pair ? pair.last : @default_value
    end
  end

  class HashedKeyComparison < Base
    def initialize(default_value=nil)
      super
      @hashes2indexes = []
    end
  
    def set(key, value)
      @elements.delete_if {|e| e[0] == key}
      @elements << [key, value]

      @hashes2indexes.delete_if {|e| e[0] == key.hash}
      @hashes2indexes << [key.hash, @elements.size - 1]
    end
  
    def get(key)
      key_hash = key.hash
      hash2index = @hashes2indexes.find {|hash,i| hash == key_hash}
      hash2index ? @elements[hash2index[1]][1] : @default_value
    end
  end
  
  class HashedKeyTree < Base
    MAX_OBJECT_ID_DIGITS = 7
    
    def initialize(default_value=nil)
      super
      @hashes_tree = []
    end
  
    def set(key, value)
      add_element(key, value) unless update_element_for_key(key, value)
    end
  
    def get(key)
      index = find_index_for_key(key)
      index ? @elements[index][1] : @default_value
    end
    
    private

      def update_element_for_key(key, value)
        updated = false
        index = find_index_for_key(key)
        if index
          @elements[index][1] = value
          updated = true
        end
        updated
      end

      def add_element(key, value)
        @elements << [key, value]
        pack_key_and_index(key, @elements.size - 1)
      end
    
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
        zeros = MAX_OBJECT_ID_DIGITS - branch.size
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
