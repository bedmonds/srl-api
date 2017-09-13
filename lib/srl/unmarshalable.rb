module SRL
  # = Summary
  # Extension class method to allow easy instantiation of objects from
  # a hash, such as the ones returned in JSON form from the SRL API.
  # 
  # = Notes
  # Any "id" key is converted to "oid" to not overwrite the default
  # Ruby Object.id behavior.
  # 
  # = Usage
  # Simply include this module in any class to add a `.from_hash` class
  # method to instantiate it from a hash.
  #
  # So long as the hash passed to `from_hash` has keys, in string or 
  # symbol form, that match the name of methods that an instance of 
  # the class responds to, instance variables with that same name will 
  # be assigned the value pointed at in this hash.
  #
  # = Example
  #
  #   class Player
  #     include SRL::Unmarshalable
  #
  #     attr_reader :name
  #     attr_reader :rank
  #     attr_reader :trueskill
  #   end
  #
  #   p = Player.from_hash({
  #     name: "Foobar", 
  #     trueskill: 0xDEADBEEF, 
  #     rank: 9001
  #   })
  #   
  #   puts "It's over 9000!" if p.rank > 9000 # => outputs "It's over 9000!"
  module Unmarshalable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def from_hash(hash = {})
        obj = new

        hash.each do |k, v|
          # Be a good boy and do not overwrite the standard ruby Object.id
          k = :oid if k.intern == :id
          next unless obj.respond_to?(k)

          if obj.respond_to?("#{k}=")
            obj.send("#{k}=", v)
          else
            obj.instance_variable_set(:"@#{k}", v) 
          end
        end

        obj
      end
    end
  end
end
