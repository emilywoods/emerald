module Emerald
  class SerialisationHelper

    def initialize
    end

    def serialise(source)
      first_node = source.first
      case first_node
        when Atom
          serialise_atom_outside_list(source)
        when Number
          serialise_number(source)
        when String
          serialise_string(source)
      end
    end

    private

    def serialise_atom_outside_list(source)
      first_node = source.first.value
      atom_args = source.slice(1..source.size)
      [first_node, atom_args]
    end

    def serialise_number(source)
      first_node = source.first.number
      rest_of_source = source.slice(1..source.size)
      [first_node.to_s, rest_of_source]
    end

    def serialise_string(source)
      first_node = source.first.string
      rest_of_source = source.slice(1..source.size)
      [first_node.to_s, rest_of_source]
    end
  end
end
