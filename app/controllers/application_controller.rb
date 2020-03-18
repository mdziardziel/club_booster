class ApplicationController < ActionController::API

  protected

  def save_and_render_json
    if new_object.save
      render json: { message: "#{model_name} created", data: new_object, errors: {}}, status: 201
    else
      render json: { message: "#{model_name} not created", data: new_object, errors: new_object.errors.messages }, status: 422
    end
  end

  private

  def model
    @model ||= model_name.constantize
  end

  def model_name
    @model_name ||=  controller_name.classify
  end

  def new_object
    @new_object ||= model.new(creation_params)
  end
end
