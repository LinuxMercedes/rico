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

	cov = find_covering(rel, decision_attrs, covering_attrs, max_attrs)
	p cov
	p get_partitions(rel, cov)
	p get_partitions(rel, decision_attrs)
	puts get_partitions(rel, cov) == get_partitions(rel, decision_attrs)

	rules = generate_rules(rel, cov, decision_attrs, prune)
	print_rules(rules)
end

