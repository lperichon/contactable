class ContactableGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.migration_template 'migration:migration.rb', "db/migrate", {:assigns => contactable_local_assigns,
        :migration_file_name => "add_contactable_fields_to_#{custom_file_name}"
       }
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