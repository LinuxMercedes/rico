require 'rarff'
require './rico/rarff-patch.rb'

def get_possible_values_hashmap(rel)
    
    # initialize hashmap and attributes/instances arrays
    
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
    return hashmap
end

def get_partitions_hashmap(rel)
    
    # initialize hashmap and attributes/instances/values
    # arrays
    
    attrs = rel.attributes
    instances = rel.instances
    values = get_possible_values_hashmap(rel)
    hashmap = Hash.new []
    
    # iterate over all attributes and get all possible
    # values for those attributes
    
    (0...attrs.length).zip(attrs).each { |i, attr|
        attrvalues = values[attr.name];
        valuehash = Hash.new []
        
        # iterate over all possible values and get all
        # instances containing the attribute/value
        # combination
        
        attrvalues.each { |value|
            instancelist = Array.new(0);
            instances.each { |instance|
                if instance[i] == value
                    instancelist.push(instance)
                end
            }
            
            # create hashmap for attribute value as key,
            # instance array as value
            
            valuehash[value] = instancelist
            
            # add valuehash to hashmap, using attribute
            # name as key, valuehash as value
            
            hashmap[attr.name] = valuehash;
        }
    }
    return hashmap
end

