require 'rarff'
require_relative 'rarff-patch.rb'

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

def get_partitions(rel, indexes=nil)

	attrs = rel.attributes
	instances = rel.instances
	values = get_possible_values(rel, indexes)
	partitions = Array.new

	# If no indexes were chosen, assume to partition on every attribute
	if indexes.nil?
		indexes = (0...attrs.length)
	end

	# iterate over all possible values and get
	# the instances that satisfy those values
	values.each { |value|
		partitions.push(instances.select{ |x| x.values_at(*indexes) == value})
	}

	return partitions
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
