module Opstat
module Common
  def self.camelize(term)
    string = term.to_s
    string = string.sub(/^[a-z\d]*/) { $&.capitalize }
    string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
  end

  def self.constantize(class_name)
    names = class_name.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |n|
      name = Opstat::Common.camelize(n)
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end 

  def constantize(camel_cased_word)
    Opstat::Common.constantize(camel_cased_word)
  end

end
end
