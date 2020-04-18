module CreationHelper
  extend ActiveSupport::Concern

  private
  
  def save_and_render_json
    new_object.save
    respond_with new_object
  end

  def update_and_render_json
    update_object.update(update_params)
    respond_with update_object
  end

  def model
    @model ||= model_name.constantize
  end

  def model_name
    @model_name ||=  controller_name.classify
  end

  def new_object
    @new_object ||= model.new(creation_params)
  end

  def update_object
    @update_object ||= model.find(params[:id])
  end

  def update_params
    creation_params
  end
end