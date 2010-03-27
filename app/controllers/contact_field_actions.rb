module ContactFieldActions
  def self.included(base)
    base.class_eval do
      before_filter :load_contactable
      helper ContactableHelper
    end
  end

  def load_contactable
    path_component = request.path.split('/').reject(&:blank?).first.singularize
    class_name = path_component.capitalize
    @contactable = Kernel.const_get(class_name).find(params["#{path_component}_id"])
  end

  def association_name
    self.field_name.pluralize
  end

  def field_name
    self.controller_class_name.chomp("Controller").singularize.underscore
  end

  def create
    @field = @contactable.send("#{self.association_name}").new(params[self.field_name.to_sym])

    if @field.save
      flash[:notice] = t(self.association_name + '.create.notice')
      respond_to do |format|
        format.js {}
      end
    else
      # TODO: handle errors via js
    end
  end

  def update
    @field = @contactable.send("#{self.association_name}").find(params[:id])

    @field.attributes = params[self.field_name.to_sym]
    if @field.save
      flash[:notice] = t(self.association_name + '.update.notice')

      respond_to do |format|
        format.js {}
      end
    end
  end

  def destroy
    @field = @contactable.send("#{self.association_name}").find(params[:id])
    @field_dom_id = dom_id @field
    if @field.destroy
      flash[:notice] = t(self.association_name + '.destroy.notice')

      respond_to do |format|
        format.js {}
      end
    end
  end
end