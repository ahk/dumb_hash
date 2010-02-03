require File.dirname(__FILE__) + '/spec_helper'

DumbHash::IMPLEMENTATIONS.each do |klass|
  describe klass do
    
    before(:each) do
      @hash = klass.new
    end
    
    describe "#{klass}#new" do
      it "should default to nil" do
        hash = klass.new
        hash.default_value.should be_nil
      end
  
      it "should allow setting default vals" do
        hash = klass.new(true)
        hash.default_value.should be_true
      end
    end
  
    describe "#{klass}#default=" do
      it "should set default val" do
        hash = klass.new
        hash.default_value = 'stupid'
        hash.default_value.should == 'stupid'
      end
    end
  
    describe "#{klass}#get and #{klass}#set" do

      it "should let you set and get a pair" do
        @hash.set(:key, 'val')
        @hash.get(:key).should == 'val'
      end
    
      it "should allow multiple elements in hash" do
        @hash.set(:key, 'val')
        @hash.set(:key1, 'val1')
        @hash.get(:key).should == 'val'
        @hash.get(:key1).should == 'val1'
      end
    
      it "should return default for missing keys" do
        hash = klass.new(:default)
        hash.get(:missing_key).should == :default
      end
    
      it "should allow non-string values" do
        some_obj = Object.new
        @hash.set(:key, some_obj)
        @hash.get(:key).should == some_obj
      end
    end
    
    describe "#{klass}#[] and #{klass}#[]=" do
      it "should get and set using brackets" do
        @hash[:key] = 'val'
        @hash[:key].should == 'val'
      end
    end

  end
end