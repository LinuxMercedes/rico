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
        attrvalues = values[attr.name]
        valuehash = Hash.new []
        
        # iterate over all possible values and get all
        # instances containing the attribute/value
        # combination
        
        attrvalues.each { |value|
            instancelist = Array.new(0)
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
            
            hashmap[attr.name] = valuehash
        }
    }
    return hashmap
end

def get_coverings(rel)
    
    # initialize attributes/instances arrays,
    # partitions/coverings hashmaps
    
    attrs = rel.attributes
    instances = rel.instances
    attrvalues = get_possible_values_hashmap(rel)
    partitions = get_partitions_hashmap(rel)
    coverings = Hash.new []
    
    # iterate over all attributes and get the partition
    # for each attribute
    
    attrs.each { |attr|
        values = attrvalues[attr.name]
        partition = partitions[attr.name]
        blocks = Array.new(0)
        found = Array.new(0)
        
        # iterate over all possible values for attribute
        # and assign instance numbers to blocks based on
        # value for that attribute
        
        values.each { |value|
            instancelist = partition[value]
            valueblock = Array.new(0)
            
            # iterate over all instances that match the
            # current value for this partition
            
            instancelist.each { |item|
                
                # iterate over all instances in relation
                # to match instance number to current
                # instance in partition
                
                (0...instances.length).zip(instances).each { |n, instance|
                    
                    # if relation instance matches current
                    # instance, add instance number to
                    # current block, then restart
                    
                    if item == instance && !(found.include?(n))
                        valueblock.push(n)
                        found.push(n)
                        break
                    end
                }
            }
            
            # add current block to blocks array
            blocks.push(valueblock)
        }
        
        # add current attribute's blocks array to coverings
        # hashmap
        
        coverings[attr.name] = blocks
    }
    return coverings
end
