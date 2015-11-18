require 'yaml'

# Provides some methods to save and restore data
module Codebreaker
  module Saver
    def save arg = nil
      filename = get_filename arg
      f = File.open(filename, 'w')

      inst_state = {}
      instance_variables.each do |var_name|
        inst_state[var_name] = instance_variable_get(var_name)
      end

      f.write inst_state.to_yaml
      f.close
    end

    def restore arg = nil
      filename = get_filename arg
      f = File.open(filename, 'r')
      inst_state = YAML.load(f.read)
      inst_state.each { |k, v| instance_variable_set(k, v) }
    end

    private

    def get_filename arg
      filename = arg || self.class.to_s.gsub(/[^A-z,1-9]/,'')
      filename += '.yml' unless filename.match(/\.yml$/)
      filename
    end
  end
end

