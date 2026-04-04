class ApplicationController < ActionController::API
  def current_user
    token = request.headers["Authorization"]&.split(" ")&.last
    decoded = JsonWebToken.decode(token)

    @current_user ||= User.find(decoded["user_id"]) if decoded
  end

  def authorize!
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end
end
