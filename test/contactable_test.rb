require 'test/unit'
require 'rubygems'
gem 'activerecord'
require 'active_record'

require "#{File.dirname(__FILE__)}/../lib/contactable"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :contacts do |t|
      t.column :first_name, :string
      t.column :last_name, :string
    end
    create_table :companies do |t|
      t.column :name, :string
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Contact < ActiveRecord::Base
  contactable
end

class Company < ActiveRecord::Base
  contactable
end

class ContactableTest < Test::Unit::TestCase

  def setup
    setup_db
    Contact.create! :first_name => "Bart", :last_name => "Simpson"
    Company.create! :name => "The Leftorium"
  end

  def teardown
    teardown_db
  end

  def test_name
    contact = Contact.first
    company = Company.first

    assert_equal 'Bart Simpson', contact.name
    assert_equal 'The Leftorium', company.name
  end

  def test_initials
    contact = Contact.first

    assert_equal 'B.S.', contact.initials
  end

end 
