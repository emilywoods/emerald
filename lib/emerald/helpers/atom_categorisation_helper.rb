module Emerald
  class AtomCategorisationHelper

    def self.type_of_atom(node)
      atom_types = {
          /^[-+*\/<>=]+$/ => "num_ops",
          /(?:empty\?)|(?:nil\?)/ => "logical_ops",
          /(?:defun)/ => "function",
          /(?:let)|(?:def)/ => "variable_assignment",
          /[\w]/ => "variable"
      }
      atom_types.map { |key, val| val if key.match(node) }.compact
    end

  end
end
