require_relative 'partition.rb'

# Generate rules from a list of attributes that form a covering
# and the decision attributes, optionally pruning unnecessary
# conditions from the rules.
def generate_rules(rel, cov, decision_attrs, prune = false, min_coverage = 0)
    
	# Get names for the decision attributes
	dec_names = rel.attributes.values_at(*decision_attrs).map { |attr| attr.name }

	rules = Hash.new (0)

	# Build a list of antecedents and consequents for each
	# possible combination of values
	get_value_distribution(rel, cov + decision_attrs).each { |vals, coverage|
		# Build consequents hash
		consequents = (cov.length...decision_attrs.length + cov.length).zip(dec_names).map { |n, name|
			[name, vals[n]]
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

		antecedents = min_cov.map { |n, val|
			if n.nil?
				['_','_']
			else
				[rel.attributes[n].name, val]
			end
		}

		rules[{:antecedents => antecedents, :consequents => consequents}] += coverage
	}

	return rules.keep_if { |r, cov| cov >= min_coverage }
end

# Prune unnecessary antecedents by looking at the
# values for the decision attributes generated by
# the specific values of the antecedents and seeing if
# removing any result in the same set of decision attributes.
# Guaranteed to produce a minimal condition list.
def _prune_antecedents(rel, cov, decision_attrs, vals)
    
	consequents_vals = [vals[cov.length, cov.length + decision_attrs.length]]

	# Check each possible combination of the covering attributes
	(1..cov.length).flat_map { |n| cov.zip(vals[0, cov.length]).combination(n).to_a }.each { |min_cov|
		if consequents_vals == get_consequents_values(rel, min_cov, decision_attrs)
			return cov.zip(min_cov).each_with_object([[], []]) { |(c, m), (fcov, last)|
				last << m
				if not last.first.nil? and last.first.first == c
					fcov << last.shift
				else
					fcov << nil
				end
			}.first
		end
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

# Prints the information for the decision attributes corresponding
# to the specified attribute indexes
def print_decision_attr_info(rel, indexes)
    
    # Print specified decision attributes
    dec_attrs = rel.attributes.values_at(*indexes)
    print 'Decision attributes: '
    p dec_attrs
    
    # Print values and number of occurrences for each value
    value_dist = get_value_distribution(rel, indexes)
    value_dist.each { |value, count|
        print '\tValue: '
        print value
        print '\tOccurrences: '
        puts count
    }
end

# Print generated rules, compactly.
def print_compact_rules(rules)
    
    rules_array = Array.new
    
    # Iterate over all rules in the specified rules set
    rules.each { |rule, coverage|
        rule_tuple = Array.new
        
        # Get the values of antecedents/consequents for current rule
        rule_values = Array.new
        rule[:antecedents].each { |name, value|
            rule_values << value
        }
        rule[:consequents].each { |name, value|
            rule_values << value
        }
        
        # Combine values of antecedents/consequents with coverage
        # for current rule
        rule_tuple << rule_values
        rule_tuple << coverage
        
        # Add current rule tuple to rules array
        rules_array << rule_tuple
    }
    
    # Print compact rules
    p rules_array
end

# Print generated rules, prettily.
def print_rules(rules, covering)
    
	rules.each { |rule, coverage|
		print 'If '
		rule[:antecedents].each { |name, value|
			print name
			print ' = '
			print value
			print ', '
		}

		print 'then '
		rule[:consequents].each { |name, value|
			print name
			print ' = '
			print value
			print ', '
		}

		print "\b\b. ("

		print coverage
		puts ')'
	}
end

