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

        # contactable#name() supports 2 options:
        # If a name column exists that one is used
        # If not use first, middle and last_name columns (only if available)
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
          if self.respond_to?(:birthday) && !self.birthday.nil?
            now = Time.now.utc.to_date
            now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
          end
        end

        has_many                      :addresses,           :as => :owner
        has_many                      :emails,              :as => :owner
        has_many                      :instant_messengers,  :as => :owner
        has_many                      :phones,              :as => :owner
        has_many                      :websites,            :as => :owner
        has_many                      :identifications,     :as => :owner

        accepts_nested_attributes_for :addresses,
          :reject_if => proc { |attributes| attributes['address'].blank? }, :allow_destroy => true
        accepts_nested_attributes_for :emails,
          :reject_if => proc { |attributes| attributes['address'].blank? }, :allow_destroy => true
        accepts_nested_attributes_for :instant_messengers,
          :reject_if => proc { |attributes| attributes['nick'].blank? }, :allow_destroy => true
        accepts_nested_attributes_for :phones,
          :reject_if => proc { |attributes| attributes['number'].blank? }, :allow_destroy => true
        accepts_nested_attributes_for :websites,
          :reject_if => proc { |attributes| attributes['address'].blank? }, :allow_destroy => true
        accepts_nested_attributes_for :identifications,
          :reject_if => proc { |attributes| attributes['address'].blank? }, :allow_destroy => true
      EOV
    end

  end
end

class ActiveRecord::Base
  include Contactable
end