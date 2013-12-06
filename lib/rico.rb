require 'rubygems'
require 'backports/1.9.1/kernel/require_relative'
require 'backports/1.9.1/enumerable/each_with_object'
require 'backports/1.9.2/enumerable/flat_map'
require 'backports/1.9.2/array/keep_if'

require_relative 'rico/partition.rb'
require_relative 'rico/covering.rb'
require_relative 'rico/opts.rb'
require_relative 'rico/rules.rb'

if $0 == __FILE__ then

	rel, decision_attrs, covering_attrs, max_attrs, min_coverage, prune = getopts()

	# Print input file
	puts "Dataset:"
	puts rel
	puts ''

	# Print settings
	puts "Maximum attributes in a covering: " + max_attrs.to_s if max_attrs > 0
	puts "Minimum coverage of reported rules: " + min_coverage.to_s if min_coverage > 0
	puts "Pruning unnecessary conditions." if prune
	puts ''

	print "Attributes to partition on: " 
	p covering_attrs.map { |c| rel.attributes[c].name }
	puts ''

	# Print decision attributes
	print_decision_attr_info(rel, decision_attrs)

	coverings = find_covering(rel, decision_attrs, covering_attrs, max_attrs)

	puts "\nCoverings:"
	coverings.each { |cov|
		p cov.map { |c| rel.attributes[c].name }
		rules = generate_rules(rel, cov, decision_attrs, prune, min_coverage)
		print_compact_rules(rules)
		puts ''
	}
end

