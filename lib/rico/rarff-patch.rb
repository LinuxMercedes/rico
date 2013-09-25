require 'rarff'

# Rarff sometimes has a type that is just a string, 
# even if it's nominal.
# so we hotpatch it so it's not broken
class Rarff::Attribute
	def to_arff
		if @type_is_nominal && @type.respond_to?("join")
			Rarff::ATTRIBUTE_MARKER + " #{@name} #{@type.join(',')}"
		else
			Rarff::ATTRIBUTE_MARKER + " #{@name} #{@type}"
		end
	end
end

