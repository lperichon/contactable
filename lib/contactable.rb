module Contactable
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def contactable(*args, &block)
      # default options
      options = {}
      options.merge!(args.pop) if args.last.kind_of? Hash
    end

  end
end

class ActiveRecord::Base
  include Contactable
end