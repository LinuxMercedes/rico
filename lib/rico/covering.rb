require_relative 'partition.rb'

# TODO: Maybe implement?
def minimal()
    
end

# TODO: Actually implement
def is_less_than(p1, p2)
    # If partitions are equivalent, return true
	return true if p1 == p2
    
    # Check each element of p1 to see if it is less than p2
    p1.each { |s1|
        p2.each { |s2|
            # continue if s2 contains no attributes from s1,
            # or if s2 is equivalent to s1
            next if s2 & s1 == [] || s2 == s1
            
            # if s2 does not contain all attributes from s1,
            # then p1 is not less than p2
            return false if s1 - s2 != []
        }
    }
    
    # p1 is less than p2
    return true
end

def find_covering(rel, decision, indexes, max_attrs=0)
	# Get partition for decision attribute
	dec_partition = get_partitions(rel, decision)

	if max_attrs == 0
		max_attrs = indexes.length
	end

	# Generate all possible attribute combinations,
	# starting with combos of size 1
	attr_combos = (1..max_attrs).map { |n| indexes.combination(n).to_a }.flatten(1)

	# Determine if the chosen partition is a valid covering
	# Due to the ordering of combinations, the first combination
	# we find is guaranteed minimal
	attr_combos.each { |idxs|
		partition = get_partitions(rel, idxs)
		return idxs if is_less_than(partition, dec_partition)
	}

	return []
end
