require "genny/version"

module Genny
  # Extend all the Ruby bbase classes with the `genny` method.
  #
  # @return [Array<klass>] Returns the classes which have been extended
  def self.extend_core
    self.constants.map do |k|
      genny_module = self.const_get(k)
      if Kernel.const_defined?(k) && genny_module.is_a?(Module) && genny_module.respond_to?(:genny)
        Kernel.const_get(k).include(genny_module).instance_eval do
          def genny(opts = {})
            raise NoMethodError, "#{self.name} isn't supported by Genny" unless Genny.constants.include?(self.name.to_sym)
            Genny.const_get(self.name).genny(opts)
          end
        end
        Kernel.const_get(k)
      else
        nil
      end
    end.compact
  end

  def self.symbolize(hash)
    ::Hash[hash.map { |key, val|
      [key.to_sym, val]
    }]
  end
end
