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

      # contactable#name() supports 2 options:
      # If a name column exists that one is used
      # If not use first, middle and last_name columns (only if available)
      class_eval <<-EOV
        def name_part_columns
          [:first_name, :middle_name, :last_name]
        end

        def name_parts
          name_parts = []
            name_part_columns.each do |name_part|
              name_parts << self.send(name_part) if self.respond_to?(name_part)
            end
          name_parts
        end

        def name
          if self[:name]
            self[:name]
          else
            name_parts.join(' ')
          end
        end

        def initials
          if self[:name]
            self[:name].tr('-', ' ').split(' ').map { |word| word.chars.first.upcase.to_s + '.'}.join
          else
            name_parts.map {|name_part| name_part.chars.first.upcase.to_s + '.'}.join
          end
        end

        def age
          if self.respond_to?(:birthday)
            now = Time.now.utc.to_date
            now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
          end
        end
      EOV
    end

  end
end

class ActiveRecord::Base
  include Contactable
end