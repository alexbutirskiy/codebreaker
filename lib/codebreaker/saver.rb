require 'yaml'

# Provides some methods to save and restore data
module Codebreaker
  module Saver
    def save(arg = nil, **options)
      filename = get_filename arg
      f = File.open(filename, 'w')

      only = Array(options[:only]).map { |r| "@#{r}".to_sym }
      except = Array(options[:except]).map { |r| "@#{r}".to_sym }
      variables = instance_variables
      variables -= except unless except.empty?
      variables &= only unless only.empty?

      inst_state = {}
      variables.each do |var_name|
        inst_state[var_name] = instance_variable_get(var_name)
      end

      f.write inst_state.to_yaml
      f.close
    end

    def restore(arg = nil, **options)
      only = Array(options[:only]).map { |r| "@#{r}".to_sym }
      except = Array(options[:except]).map { |r| "@#{r}".to_sym }

      filename = get_filename arg
      f = File.open(filename, 'r')
      inst_state = YAML.load(f.read)

      inst_state.keep_if { |key, _| only.include?(key) } unless only.empty?
      inst_state.keep_if { |key, _| !except.include?(key) } unless except.empty?

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

