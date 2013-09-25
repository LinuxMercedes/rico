require 'rarff'
require './rico/rarff-patch.rb'

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

	rel.attributes.each do |attr|
		puts attr
	end

end
