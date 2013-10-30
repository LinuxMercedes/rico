require 'rarff'
require './rico/rarff-patch.rb'

def get_possible_values_hashmap(rel)
    
    # initialize hashmap and attribute/instances arrays
    
    attrs = rel.attributes
    instances = rel.instances
    hashmap = Hash.new []
    
    # iterate over all instances and populate values array
    # with each unique value for that attribute
    
    (0...attrs.length).zip(attrs).each { |i, attr|
        values = Array.new(0);
        instances.each { |instance|
            values.push(instance[i])
        }
        values = values.uniq
        hashmap[attr.name] = values
    }
    
    # return hashmap
    
    return hashmap
    
end

