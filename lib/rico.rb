require 'rarff'

if $0 == __FILE__ then
	if ARGV[0]
		arff_file = ARGV[0]
		contents = File.open(arff_file).read

		rel = Rarff::Relation.new
		rel.parse(contents)

	else
		exit
	end

	puts rel

end
