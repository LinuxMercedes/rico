require 'rubygems'
require 'backports/1.9.1/kernel/require_relative'

require_relative 'rico/partition.rb'
require_relative 'rico/covering.rb'
require_relative 'rico/opts.rb'
require_relative 'rico/rules.rb'

if $0 == __FILE__ then

	rel, decision_attrs, covering_attrs, max_attrs, prune = getopts()

	# test
	puts rel
	puts ""

	coverings = find_covering(rel, decision_attrs, covering_attrs, max_attrs)
	puts "Decision attribute(s) partition:"
	p get_partitions(rel, decision_attrs)

	puts "Coverings:"
	coverings.each { |cov|
		p cov
		puts get_partitions(rel, cov) == get_partitions(rel, decision_attrs)

		rules = generate_rules(rel, cov, decision_attrs, prune)
		print_rules(rules)
		puts ""
	}
end

