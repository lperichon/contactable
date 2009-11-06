require 'test/unit'
require 'rubygems'
gem 'activerecord'
gem 'timecop'
require 'timecop'
require 'active_record'

require "#{File.dirname(__FILE__)}/../lib/contactable"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :contacts do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :birthday, :date
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

    # Set Time.now to September 1, 2008 10:05:00 AM (at this instant), but allow it to move forward
    t = Time.local(2009, 11, 6, 10, 5, 0)
    Timecop.travel(t)    
    Contact.create! :first_name => "Bart", :last_name => "Simpson", :birthday => Date.parse('3-3-1983')
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

  def test_age
    contact = Contact.first

    assert_equal 26, contact.age
  end

end 
