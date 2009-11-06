module Contactable
  def self.included(base)
    base.extend ClassMethods
  end

  # This  extension provides contact information to an active record model.
  #
  # Examples:
  #
  #   class Person < ActiveRecord::Base
  #     contactable
  #   end
  module ClassMethods
    # Configuration options are:
    #
    def contactable(*args, &block)
      # default options
      options = {}
      options.merge!(args.pop) if args.last.kind_of? Hash

      class_eval <<-EOV
        def name
          [self.first_name,self.last_name].join(' ')
        end
      EOV
    end

  end
end

class ActiveRecord::Base
  include Contactable
end