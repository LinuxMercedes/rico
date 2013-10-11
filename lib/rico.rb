require 'rarff'
require './rico/rarff-patch.rb'

def select_attributes(rel)
	attrs = rel.attributes
	done = false
	choices = Array.new(attrs.length, false)

	while not done
		print "Select attributes to partition on:\n\n"

		1.upto(attrs.length).zip(attrs,choices).each { |i, attr, choice|
			if choice 
				print "*"
			end

			puts i.to_s + ") " + attr.name
		}

		puts"\na) all attributes"
		puts "c) clear all choices"
		puts "d) done choosing attributes"
		print "> "

		input = $stdin.gets
		input.chomp!

		# TODO: Deuglify
		case input
		when 'a'
			choices = Array.new(attrs.length, true)
		when 'c'
			choices = Array.new(attrs.length, false)
		when 'd'
			done = true
		else
			begin	
				idx = Integer(input)
				case idx
				when 1..attrs.length
					idx -= 1
					choices[idx] = !choices[idx]
				else
					puts "Not an attribute!"
				end
			rescue ArgumentError
				puts "Not an attribute!"
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
	
	select_attributes(rel)

	# fucking magic
	attr_partitions = 1.upto(3).flat_map{ |n| rel.attributes.combination(n).to_a }

	attr_partitions.each { |attrs|
		attrs.each { |attr|
			print attr, ", "
		}
		puts 
	}

end

