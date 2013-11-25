require 'rarff'
require_relative 'rico/partition.rb'
require_relative 'rico/covering.rb'
require_relative 'rico/rarff-patch.rb'

def select_attributes(rel)
	attrs = rel.attributes
	done = false
	choices = Array.new(attrs.length, :none)
	choosing = :decision

	while not done
		if choosing == :decision
			puts 'Select decision attributes:'
		else
			puts 'Select attributes to partition on:'
		end

		puts

		(1..attrs.length).zip(attrs,choices).each { |i, attr, choice|
			case choice
			when :decision
				print '-'
			when :partition
				print '*'
			else
				print ' '
			end

			puts i.to_s + ') ' + attr.name
		}

		puts "\n a) all attributes"
		if choosing == :decision
			puts ' c) clear decision choices'
			puts ' p) choose attributes to partition on'
	  else
			puts ' c) clear partition choices'
			puts ' d) choose decision attributes'
		end
		puts ' f) finished choosing attributes'
		print '> '

		input = $stdin.gets
		input.chomp!

		# Convert to a number if possible
		begin
			input = Integer(input)
		rescue ArgumentError
		end

		case input
		when 1..attrs.length
			input -= 1
			if choices[input] == choosing
				choices[input] = :none
			elsif choices[input] == :none
				choices[input] = choosing
			end
		when 'a'
			choices = choices.map { |choice| choice == :none ? choosing : choice }
		when 'c'
			choices = choices.map { |choice| choice == choosing ? :none : choice }
		when 'd'
			choosing = :decision
		when 'p'
			choosing = :partition
		when 'f'
			done = true
		else
			puts 'Not an attribute!'
		end

		puts
	end

	return choices
end

if $0 == __FILE__ then
	if ARGV[0]
		arff_file = ARGV[0]
		contents = File.open(arff_file).read

		rel = Rarff::Relation.new
		rel.parse(contents)

	else
		puts "Please specify a filename"
		exit
	end

	# test
	puts rel
	puts ""
#	p get_partitions(rel, [1, 2])
#	p get_partitions(rel, [4])
#	puts get_partitions(rel, [1,2]) == get_partitions(rel, [4])
#	testcoverings = get_coverings(rel)
#	puts testcoverings
#	choices = select_attributes(rel)

	cov = find_covering(rel, [4], [0, 1, 2])
	p cov
	p get_partitions(rel, cov)
	p get_partitions(rel, [4])
	puts get_partitions(rel, cov) == get_partitions(rel, [4])
end

