require 'getoptlong'

def getopts()
    
	opts = GetoptLong.new(
		['--help', '-h', GetoptLong::NO_ARGUMENT],
		['--prune', '-p', GetoptLong::OPTIONAL_ARGUMENT],
		['--decision', '-d', GetoptLong::REQUIRED_ARGUMENT],
		['--covering', '-c', GetoptLong::REQUIRED_ARGUMENT],
		['--max-attrs', '-a', GetoptLong::REQUIRED_ARGUMENT],
		['--min-rule-coverage', '-r', GetoptLong::REQUIRED_ARGUMENT]
	)

	prune = nil
	max_attrs = nil
	min_coverage = nil
	decision = []
	covering = []

	opts.each { |opt, arg|
		case opt
		when '--help'
			puts <<-EOF
rico [OPTION] [DATASET]

-h, --help:
	Show this message

-d, --decision [attr_name, attr_name, ...]:
	Specify names of decision attributes

-c, --covering [attr_name, attr_name, ...]:
	Specify names of attributes to use in coverings

-m, --max-attrs x:
	Maximum number of attributes to have in a covering

-p, --prune:
	Prune unnecessary conditions from generated rules

If decision attributes or covering attributes are not specified,
you will be prompted to choose them interactively.
		EOF
		exit

		when '--prune'
			p arg.downcase
			if arg.downcase.chomp == "n"
				prune = false
			else
				prune = true
			end

		when '--decision'
			# Allow comma-separated lists
			decision.push(*arg.split(',').map {|x| x.strip})

		when '--covering'
			# Allow comma-separated lists
			covering.push(*arg.split(',').map {|x| x.strip})

		when '--max-attrs'
			max_attrs = arg.to_i

		when '--min-rule-coverage'
			min_coverage = arg.to_i

		end
	}

	# Get data filename and create relation
	arff_file = ARGV.shift
	if not arff_file
		puts "Please specify a filename:"
		arff_file = $stdin.gets
		arff_file.chomp!
	end

	contents = File.open(arff_file).read

	rel = Rarff::Relation.new
	rel.parse(contents)

	# Convert attribute names to indexes
	decision.map! { |d| rel.attributes.index{|a| a.name == d}}.compact!
	covering.map! { |c| rel.attributes.index{|a| a.name == c}}.compact!

	if decision == [] or covering == []
		# Create a choices array reflecting the command-line-chosen attributes
		choices = Array.new(rel.attributes.length, :none)
		decision.each { |d| choices[d] = :decision }
		covering.each { |c| choices[c] = :partition }

		choices = select_attributes(rel, choices)

		# Convert choices array back to indexes
		decision = (0...choices.length).zip(choices).map{ |n, c| n if c == :decision}.compact
		covering = (0...choices.length).zip(choices).map{ |n, c| n if c == :partition}.compact
	end

	if max_attrs.nil?
		puts "Maximum attributes to consider in a covering (0 = unlimited): "
		max_attrs = $stdin.gets.chomp!.to_i
	end

	if min_coverage.nil?
		puts "Minimum instance coverage for reported rules (0 = unlimited): "
		min_coverage = $stdin.gets.chomp!.to_i
	end

	if prune.nil?
		puts "Prune redundant conditions from rules? (Y/n): "
		prune = $stdin.gets.chomp!
		prune = prune.downcase != 'n'
	end

	return rel, decision, covering, max_attrs, min_coverage, prune
end

def select_attributes(rel, choices)
    
	attrs = rel.attributes
	done = false
	
	choosing = :partition

	while not done
		if choosing == :decision
			puts 'Select decision attributes:'
		else
			puts 'Select attributes to partition on:'
		end

		puts

		# Print attributes
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


