require_relative 'partition.rb'

def generate_rules(rel, cov, decision_attrs, remove_unnecessary = false)
	cov_names = rel.attributes.values_at(*cov).map { |attr| attr.name }
	dec_names = rel.attributes.values_at(*decision_attrs).map { |attr| attr.name }
	get_possible_values(rel, cov + decision_attrs).each { |vals|
		print 'If ' 
		
	  (0...cov_names.length).zip(cov_names).each { |n, name|
			print name
			print ' = '
			print vals[n]
			print ', '
		}

		print 'then '
		(cov_names.length...dec_names.length + cov_names.length).zip(dec_names).each { |n, name|
			print name
			print ' = '
			print vals[n]
			print ', '
		}

		puts '.'
	}
end

