module JsonWebToken
  def jwt_decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
  rescue StandardError => e
    Rails.logger.error "JWT decode error: #{e.message}"
    nil
  end
end
