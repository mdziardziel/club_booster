module CreationHelper
  extend ActiveSupport::Concern

  private
  
  def save_and_render_json
    if new_object.save
      render json: { message: "#{model_name} created", data: new_object, errors: {}}, status: 201
    else
      render json: { message: "#{model_name} not created", data: new_object, errors: new_object.errors.messages }, status: 422
    end
  end

  def update_and_render_json
    if update_object.update(update_params)
      render json: { message: "#{model_name} updated", data: update_object, errors: {}}, status: 201
    else
      render json: { message: "#{model_name} not updated", data: update_object, errors: update_object.errors.messages }, status: 422
    end
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