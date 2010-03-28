class ContactableViewsGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|

      Dir[source_path("views/#{strategy}/**/**")].each do |full_path|
        source_file_name = full_path.gsub(/.*templates\//,'')
        destination_file_name = source_file_name.gsub(/.*#{strategy}\//,'app/views/') 
        if File.ftype(full_path) == "directory"
          m.directory destination_file_name
        else
          m.file source_file_name, destination_file_name
        end
      end
    end
  end

  private

  def strategy
    class_name.nil? ? 'formtastic' : class_name.underscore.downcase
  end

end
