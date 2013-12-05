require_relative 'partition.rb'

# Returns true if p1 is less than or equivalent to p2;
# false otherwise
def is_less_than(p1, p2)
    
    # If partitions are equivalent, return true
	return true if p1 == p2
    
    # Check each element of p1 to see if it is less than p2
    p1.each { |s1|
        p2.each { |s2|
            # Continue if s2 contains no attributes from s1,
            # or if s2 is equivalent to s1
            next if s2 & s1 == [] || s2 == s1
            
            # If s2 does not contain all attributes from s1,
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
		covering.all? { |c| part.include?(c) }
	}
end

# Calculate all possible coverings of the specified decision attributes
# by the attributes (specified by indexes), optionally limiting the max
# attributes in a covering to max_attrs.
# Returns a list of coverings, each of which is a list of indexes of attributes.
def find_covering(rel, decision, indexes, max_attrs = 0)
    
	# Get partition for decision attribute
	dec_partition = get_partition(rel, decision)

	if max_attrs == 0
		max_attrs = indexes.length
	end

	# Generate all possible attribute combinations,
	# starting with combos of size 1
	attr_combos = (1..max_attrs).flat_map { |n| indexes.combination(n).to_a }

	# Generate a list of valid partitions
	coverings = Array.new
	attr_combos.each { |idxs|
		partition = get_partition(rel, idxs)
		coverings << idxs if is_less_than(partition, dec_partition) and not is_in(idxs, coverings)
	}

	return coverings
end
