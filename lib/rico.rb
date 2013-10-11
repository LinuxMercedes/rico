require 'rarff'
require './rico/rarff-patch.rb'

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

		# TODO: Deuglify
		case input
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
			begin	
				idx = Integer(input)
				case idx
				when 1..attrs.length
					idx -= 1
					if choices[idx] == choosing
						choices[idx] = :none
					elsif choices[idx] == :none
						choices[idx] = choosing
					end
				else
					puts 'Not an attribute!'
				end
			rescue ArgumentError
				puts 'Not an attribute!'
			end
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
	
	choices = select_attributes(rel)

	# fucking magic
	attr_partitions = (1..3).flat_map{ |n| rel.attributes.combination(n).to_a }

#	attr_partitions.each { |attrs|
#		attrs.each { |attr|
#			print attr, ", "
#		}
#		puts 
#	}

end

