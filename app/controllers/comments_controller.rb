class CommentsController < ApplicationController
  before_action :authenticate_user
  before_action :set_post, only: [:create]

  def create
    @post = Post.find(params[:post_id])

    @comment = @post.comments.build(comment_params)
    @comment.post = @post
    @comment.user = @current_user
    
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy

    @comment = Comment.find(params[:comment_id])

    if @comment[:user_id]!= @current_user[:id]
               render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end

    if @comment.destroy
      render json: { message: 'comment deleted successfully' , comment: @comment}, status: :ok
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'comment not found' }, status: :not_found
  end



  
  def update

    @comment = Comment.find(params[:comment_id])
    
    if @comment[:user_id]!= @current_user[:id]
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end

    if @comment.update(comment_params)
      render json: { message: 'comment updated successfully', comment: @comment }, status: :ok
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'comment not found' }, status: :not_found
  end




  

  private

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    puts "Token received: #{token.inspect}" 
  
    if token.present?
      decoded_token = decode_jwt(token)
      puts "Decoded Token: #{decoded_token.inspect}" 
      @current_user = User.find_by(id: decoded_token["user_id"])

      puts "Current User: #{@current_user.inspect}" if @current_user 
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    else
      puts "No token found in request headers"
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  

  def decode_jwt(token)
    JWT.decode(token, "asd")[0]
  end


  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
