require_relative 'partition.rb'

# Generate rules from a list of attributes that form a covering
# and the decision attributes, optionally pruning unnecessary
# conditions from the rules.
def generate_rules(rel, cov, decision_attrs, prune = false)
	# Get names for the covering and decision attributes
	cov_names = rel.attributes.values_at(*cov).map { |attr| attr.name }
	dec_names = rel.attributes.values_at(*decision_attrs).map { |attr| attr.name }

	rules = Array.new

	# Build a list of antecedents and consequents for each
	# possible combination of values
	get_possible_values(rel, cov + decision_attrs).each { |vals|
		antecedents = Hash.new

	  (0...cov_names.length).zip(cov_names).each { |n, name|
			antecedents[name] = vals[n]
		}

		consequents = Hash.new
		(cov_names.length...dec_names.length + cov_names.length).zip(dec_names).each { |n, name|
			consequents[name] = vals[n]
		}
		rules.push({:antecedents => antecedents, :consequents => consequents})
	}

	return rules
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

