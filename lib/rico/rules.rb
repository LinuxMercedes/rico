require_relative 'partition.rb'

def generate_rules(rel, cov, decision_attrs, remove_unnecessary = false)
	cov_names = rel.attributes.values_at(*cov).map { |attr| attr.name }
	dec_names = rel.attributes.values_at(*decision_attrs).map { |attr| attr.name }

	rules = Array.new

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

