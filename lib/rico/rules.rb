require_relative 'partition.rb'

# Generate rules from a list of attributes that form a covering
# and the decision attributes, optionally pruning unnecessary
# conditions from the rules.
def generate_rules(rel, cov, decision_attrs, prune = false)
	# Get names for the decision attributes
	dec_names = rel.attributes.values_at(*decision_attrs).map { |attr| attr.name }

	rules = Array.new

	# Build a list of antecedents and consequents for each
	# possible combination of values
	get_possible_values(rel, cov + decision_attrs).each { |vals|
		# Build consequents hash
		consequents = Hash.new
		(cov.length...decision_attrs.length + cov.length).zip(dec_names).each { |n, name|
			consequents[name] = vals[n]
		}

		# Building antecedents hash
		# Since we can't always guarantee that we can cheat and slice the vals array
		# we build a list of [covering_attribute_index, covering_attribute_value] pairs
		# optionally pruning unnecessary conditions
		if prune
			min_cov = _prune_antecedents(rel, cov, decision_attrs, vals)
		else
			min_cov = cov.zip(vals[0, cov.length])
		end

		antecedents = Hash.new
		min_cov.each { |n, val|
			antecedents[rel.attributes[n].name] = val
		}

		rules.push({:antecedents => antecedents, :consequents => consequents})
	}

	return rules
end

# Prune unnecessary antecedents by looking at the
# values for the decision attributes generated by
# the specific values of the antecedents and seeing if
# removing any result in the same set of decision attributes.
# Guaranteed to produce a minimal condition list.
def _prune_antecedents(rel, cov, decision_attrs, vals)
	consequents_vals = [vals[cov.length, cov.length + decision_attrs.length]]

	# Check each possible combination of the covering attributes
	(1..cov.length).map { |n| cov.zip(vals[0, cov.length]).combination(n).to_a }.flatten(1).each { |min_cov|
		return min_cov if consequents_vals == get_consequents_values(rel, min_cov, decision_attrs)
	}
end

# Returns a hash map using the following format:
# <key = attribute value(s), value = # of occurences in relation>
# using the specified relation and attribute indexes
def get_value_distribution(rel, indexes)
    value_dist = Hash.new(0)
    instances = rel.instances
    instances.each { |instance|
        value_dist[instance.values_at(*indexes)] += 1
    }
    return value_dist
end

# Print generated rules, prettily.
def print_rules(rules)
	rules.each { |rule|
		print 'If '
		rule[:antecedents].each{ |name, value|
			print name
			print ' = '
			print value
			print ', '
		}

		print 'then '
		rule[:consequents].each{ |name, value|
			print name
			print ' = '
			print value
			print ', '
		}

		puts "\b\b."
	}
end

