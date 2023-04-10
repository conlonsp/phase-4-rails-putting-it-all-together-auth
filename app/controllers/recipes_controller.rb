class RecipesController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable

  before_action :authorize

  def index
    render json: Recipe.all, status: :ok
  end

  def create
    recipe = Recipe.create!(
      title: params[:title],
      instructions: params[:instructions],
      minutes_to_complete: params[:minutes_to_complete],
      user_id: session[:user_id]
    )
    render json: recipe, status: :created
  end

  private

  def authorize
    return render json: { errors: ["Unauthorized"] }, status: :unauthorized unless session.include? :user_id
  end

  def render_unprocessable(e)
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

end

# Be handled in the RecipesController with a create action

# In the create action, if the user is logged in (if their user_id is in the session hash):

# Save a new recipe to the database if it is valid. The recipe should belong to the logged in user, and should have title, instructions, and minutes to complete data provided from the params hash

# Return a JSON response with the title, instructions, and minutes to complete data along with a nested user object; and an HTTP status code of 201 (Created)

# If the user is not logged in when they make the request:

# Return a JSON response with an error message, and a status of 401 (Unauthorized)
# If the recipe is not valid:

# Return a JSON response with the error messages, and an HTTP status code of 422 (Unprocessable Entity)
