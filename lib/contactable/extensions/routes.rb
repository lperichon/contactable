if defined?(ActionController::Routing::RouteSet)
  class ActionController::Routing::RouteSet
    def load_routes_with_contactable!
      lib_path = File.dirname(__FILE__)
      contactable_routes = File.join(lib_path, *%w[.. .. .. config contactable_routes.rb])
      unless configuration_files.include?(contactable_routes)
        add_configuration_file(contactable_routes)
      end
      load_routes_without_contactable!
    end

    alias_method_chain :load_routes!, :contactable
  end
end

module ActionController::Resources
  def contactable_resources(*entities, &block)
    options = entities.extract_options!
    resources(:phones, :addresses, :emails, :websites, :instant_messengers, :identifications, options.dup, &block)
  end
end

