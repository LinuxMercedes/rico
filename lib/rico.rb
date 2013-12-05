require 'rubygems'
require 'backports/1.9.1/kernel/require_relative'
require 'backports/1.9.1/enumerable/each_with_object'
require 'backports/1.9.2/enumerable/flat_map'

require_relative 'rico/partition.rb'
require_relative 'rico/covering.rb'
require_relative 'rico/opts.rb'
require_relative 'rico/rules.rb'

if $0 == __FILE__ then

	rel, decision_attrs, covering_attrs, max_attrs, min_coverage, prune = getopts()

	# test
	puts rel
	puts ""
    
	coverings = find_covering(rel, decision_attrs, covering_attrs, max_attrs)
	puts "Decision attribute(s) partition:"
   
	p get_partition(rel, decision_attrs)

	puts "\nCoverings:"
	coverings.each { |cov|
		p cov
		rules = generate_rules(rel, cov, decision_attrs, prune, min_coverage)
		print_compact_rules(rules)
		puts ""
	}
end

