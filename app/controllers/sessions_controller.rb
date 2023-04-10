class SessionsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :unauthorized

  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: user
    else
      render json: { errors: ["User not found"] }, status: :unauthorized
    end
  end

  def destroy
    if session[:user_id]
      session.delete :user_id
      head :no_content
    else 
      render json: { errors: ["User not logged in"] }, status: :unauthorized
    end
  end

end
