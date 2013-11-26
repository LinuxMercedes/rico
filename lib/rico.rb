require 'rarff'
require_relative 'rico/partition.rb'
require_relative 'rico/covering.rb'
require_relative 'rico/opts.rb'
require_relative 'rico/rarff-patch.rb'

if $0 == __FILE__ then

	rel, decision_attrs, covering_attrs = getopts()

	# test
	puts rel
	puts ""

	cov = find_covering(rel, decision_attrs, covering_attrs)
	p cov
	p get_partitions(rel, cov)
	p get_partitions(rel, decision_attrs)
	puts get_partitions(rel, cov) == get_partitions(rel, decision_attrs)
end

