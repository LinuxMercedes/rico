require 'rarff'
require_relative 'rarff-patch.rb'

# Given a set of [antecedent_attr, value] pairings, 
# return the possible values for the consequents
def get_consequents_values(rel, antecedents, consequents)
	return rel.instances.map { |instance|
		instance.values_at(*consequents) if antecedents.inject(true) { |match, (idx, val)|
			match &= instance[idx] == val
		}
	}.compact.uniq
end

# Returns a list of possible values within the specified
# relation for the specified attribute indexes (returns
# possible values for all attribute indexes by default,
# i.e. - when indexes = nil)
def get_possible_values(rel, indexes=nil)

	# Handle optional values
	if indexes.nil?
		indexes = (0...rel.attributes.length)
	end

	instances = rel.instances
	values = Array.new

	# iterate over all instances and populate values array
	# with the instance values for the chosen attributes
	instances.each { |instance|
		values.push(instance.values_at(*indexes))
	}

	# uniquify the values list
	return values.uniq
end

# Returns a partition on the specified relation for the
# specified attribute indexes (returns partition on all
# attribute indexes by default, i.e. - when indexes = nil)
def get_partition(rel, indexes=nil)

	attrs = rel.attributes
	instances = rel.instances
	values = get_possible_values(rel, indexes)
	partition = Array.new

	# If no indexes were chosen, assume to partition on every attribute
	if indexes.nil?
		indexes = (0...attrs.length)
	end

	# iterate over all possible values and get
	# the instances that satisfy those values
	values.each { |value|
		partition.push(instances.select{ |x| x.values_at(*indexes) == value})
	}

	return partition
end