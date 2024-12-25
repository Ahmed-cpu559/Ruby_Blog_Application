class PostsController < ApplicationController
  before_action :authenticate_request # JWT authentication
  before_action :find_post, only: [:update_tag] 

  def create

    @post = @current_user.posts.new(post_params)

    if post_params[:tag_ids].blank?
      render json: { errors: 'At least one tag must be provided' }, status: :unprocessable_entity
      return
    end

    @post.tags = Tag.find(post_params[:tag_ids])

    if @post.save
      render json: @post.as_json(include: { tags: { only: [:id, :title] } }), status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy

    @post = Post.find(params[:id])

    if @post[:author_id]!= @current_user[:id]
               render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end

    if @post.destroy
      render json: { message: 'Post deleted successfully' }, status: :ok
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post not found' }, status: :not_found
  end




  def update

    @post = Post.find(params[:id])
    
    if @post[:author_id]!= @current_user[:id]
               render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end

    if @post.update(post_params)
      render json: { message: 'Post updated successfully', post: @post }, status: :ok
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post not found' }, status: :not_found
  end








  def update_tag
    @tag_path = TagPath.find_by(post_id: params[:post_id], tag_id: params[:tag_id])

    if @tag_path.nil?
      render json: { error: 'Tag path not found' }, status: :not_found
      return
    end

    if @post.author_id != @current_user.id
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end

    if @tag_path.update(tag_path_params)
      render json: { message: 'Tag updated successfully', tag_path: @tag_path.as_json }, status: :ok
    else
      render json: { errors: @tag_path.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post not found' }, status: :not_found
  end















  private



def tag_path_params
  params.require(:tag_path).permit(:tag_id)
end

  def authenticate_request
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last if auth_header

    begin
      decoded_token = JWT.decode(token,"asd")
      @current_user = User.find(decoded_token[0]['user_id'])
      
    rescue JWT::DecodeError => e
      Rails.logger.error "JWT Decode Error: #{e.message}"
      render json: { error: 'Invalid token' }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :unauthorized
    end
  end


  def tag_path_params
    params.require(:tag_path).permit(:tag_id)
  end





  def find_post
    @post = Post.find(params[:post_id])
  end

  def tag_path_params
    params.require(:tag_path).permit(:tag_id)
  end





  def post_params
    params.require(:post).permit(:title, :body, tag_ids: [])
  end
end
