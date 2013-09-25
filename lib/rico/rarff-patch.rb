require 'rarff'

class Rarff::Attribute
	def to_arff
		Rarff::ATTRIBUTE_MARKER + " #{@name} #{@type}"
	end
end

