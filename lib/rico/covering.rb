require_relative 'partition.rb'

# TODO: Maybe implement?
def minimal()

end

# TODO: Actually implement
def is_less_than(c1, c2)
	
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
	# we find is guaranteed minimal.
	attr_combos.each { |idxs|
		partition = get_partitions(rel, idxs)
		return idxs if is_less_than(partition, dec_partition)
	}

	return []
end
