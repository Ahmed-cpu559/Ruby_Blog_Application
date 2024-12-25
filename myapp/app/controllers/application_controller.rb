require_dependency 'json_web_token'

class ApplicationController < ActionController::API
  include JsonWebToken

  # before_action :authenticate_request, except: [:login, :register]

  private

  def authenticate_request
   
    puts "Start: Authenticating request"
    
    header = request.headers["Authorization"]
    
    puts "Authorization Header: #{header.inspect}"
    
    if header.present?
      token = header.split(" ").last
     
      puts "Extracted Token: #{token.inspect}"
      
      decoded = jwt_decode(token)
     
      puts "Decoded Token: #{decoded.inspect}"
      
      if decoded
        @current_user = User.find_by(id: decoded[:user_id])
       
        if @current_user
          puts "Authenticated User: #{@current_user.inspect}"
        else
          puts "User not found for ID: #{decoded[:user_id]}"
          render json: { error: "Unauthorized" }, status: :unauthorized and return
        end
      else
        puts "Decoded token is nil"
        render json: { error: "Unauthorized" }, status: :unauthorized and return
      end
    else
      puts "Authorization header is missing"
      render json: { error: "Token missing" }, status: :unauthorized and return
    end
  rescue ActiveRecord::RecordNotFound => e
    puts "Error: User not found - #{e.message}"
    render json: { error: "User not found" }, status: :unauthorized
  rescue JWT::DecodeError => e
    puts "Error: JWT Decode Error - #{e.message}"
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
