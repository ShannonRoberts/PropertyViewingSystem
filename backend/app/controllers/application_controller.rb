class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  def health
    render json: { status: 'ok', message: 'Property Viewing System API is running' }
  end
end
