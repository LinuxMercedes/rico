require_relative 'partition.rb'

def minimal()
    
end

# TODO: Actually implement
def is_less_than(c1, c2)
	return c1 == c2	    
end

def find_covering(rel, decision, indexes, max_attrs=0)
	  dec_partition = get_partitions(rel, decision)
		
		if max_attrs == 0
				max_attrs = rel.attributes.length
		end

		attr_combos = (1..max_attrs).flat_map { |n| indexes.combination(n).to_a }

		attr_combos.each { |idxs|
			  partition = get_partitions(rel, idxs)
				return idxs if is_less_than(partition, dec_partition)
		}
	
		return []
end
