require_relative 'partition.rb'

def minimal()

end

# TODO: Actually implement
def is_less_than(c1, c2)
	return c1 == c2
end

def is_in(part, coverings)
	return coverings.any? { |covering| 
		covering.length <= part.length and part[0,covering.length] == covering
	}
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

	# Generate a list of valid partitions
	coverings = Array.new
	attr_combos.each { |idxs|
		partition = get_partitions(rel, idxs)
		coverings << idxs if is_less_than(partition, dec_partition) and not is_in(idxs, coverings)
	}

	return coverings
end
