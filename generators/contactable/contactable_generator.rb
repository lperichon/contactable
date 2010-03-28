require File.expand_path(File.dirname(__FILE__) + "/lib/insert_commands.rb")

class ContactableGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|
      # migration for related tables if not there already
      unless ActiveRecord::Base.connection.table_exists?(:divisions)
        m.file 'migrations/create_contactable_related_tables.rb', "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_contactable_related_tables.rb"
      end

      # migration for contactable fields
      m.migration_template 'migration:migration.rb', "db/migrate", {
        :assigns => contactable_local_assigns,
        :migration_file_name => "add_contactable_fields_to_#{custom_file_name}"
      }

      # contactable model
      contactable_model_file_path = "app/models/#{custom_file_name.singularize}.rb"
      m.insert_into(contactable_model_file_path, 'contactable')

      # contactable controller
      contactable_controller_file_path = "app/models/#{custom_file_name}_controller.rb"
      m.insert_into(contactable_model_file_path, "helper ContactableHelper")

      m.readme "README"
    end
  end

  private
  def custom_file_name
    custom_name = class_name.underscore.downcase
    custom_name = custom_name.pluralize if ActiveRecord::Base.pluralize_table_names
  end

  def contactable_local_assigns
    returning(assigns = {}) do
      assigns[:migration_action] = "add"
      assigns[:class_name] = "add_contactable_fields_to_#{custom_file_name}"
      assigns[:table_name] = custom_file_name
      assigns[:attributes] = []
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new("first_name", "string")
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new("middle_name", "string")
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new("last_name", "string")
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new("birthday", "date")
    end
  end
end
