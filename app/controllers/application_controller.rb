class ApplicationController < ActionController::API
  around_action :switch_locale
   
  private

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def respond_with(resource, params = {})
    if params[:status].nil?
      params[:status] = resource.errors.empty? ? 201 : 422
    end

    if params[:message].nil?
      params[:message] = ''
    end

    if params[:errors].nil?
      params[:errors] = resource.errors.messages
    end

    if params[:full_errors].nil?
      params[:full_errors] = resource.errors.full_messages
    end

    if params[:data].nil?
      if params[:data_attributes].nil?
        params[:data] = resource.attributes
      else
        params[:data] = resource.attributes.slice(*params[:data_attributes])
      end
    end

    if params[:additional_data].present?
      params[:data] = params[:data].merge(params[:additional_data])
    end

    if params[:translate_data_keys].present?
      params[:data] = params[:data].merge(params[:data].each_with_object({}) { |key, value| params[value] = params[key] })
    end

    render json: { 
      message: params[:message], 
      data: params[:data], 
      errors: params[:errors], 
      full_errors: params[:full_errors] }, status: params[:status]   
  end
end
