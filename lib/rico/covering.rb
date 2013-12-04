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

# Determine if a partition is already in coverings
# or if a covering is a subset of the partition
def is_in(part, coverings)
	return coverings.any? { |covering| 
		covering.length <= part.length and part[0,covering.length] == covering
	}
end

# Calculate all possible coverings of the specified decision attributes
# by the attributes (specified by indexes), optionally limiting the max
# attributes in a covering to max_attrs.
# Returns a list of coverings, each of which is a list of indexes of attributes.
def find_covering(rel, decision, indexes, max_attrs=0)
	# Get partition for decision attribute
	dec_partition = get_partitions(rel, decision)

	if max_attrs == 0
		max_attrs = indexes.length
	end

	# Generate all possible attribute combinations,
	# starting with combos of size 1
	attr_combos = (1..max_attrs).map { |n| indexes.combination(n).to_a }.flatten(1)

	# Generate a list of valid partitions
	coverings = Array.new
	attr_combos.each { |idxs|
		partition = get_partitions(rel, idxs)
		coverings << idxs if is_less_than(partition, dec_partition) and not is_in(idxs, coverings)
	}

	return coverings
end
