class Api::V1::PostsController < Api::V1::BaseController
  before_filter :authenticate_user!

  def index

    # ember optimization
    # we could have another point for the feed but then we would have some posts
    # 2 times in browser's memory
     if params[:feed]
      return api_error(status: 422) if params[:feed_user_id].blank?
     
      return unauthorized! unless current_user.id == params[:feed_user_id].to_i

      posts = User.find_by(id: params[:feed_user_id]).feed
    else
      posts = Post.where(user_id: params[:user_id])
    end

    posts = apply_filters(posts, params)

    posts = paginate(posts)

    posts = policy_scope(posts)

    render(
      json: ActiveModel::ArraySerializer.new(
        posts,
        each_serializer: Api::V1::PostSerializer,
        root: 'posts',
        meta: meta_attributes(posts)
      )
    )
  end

  def show
    post = Post.find(params[:id])
    authorize post

    render json: Api::V1::PostSerializer.new(post).to_json
  end

  def create
    post = Post.new(create_params)
    return api_error(status: 422, errors: post.errors) unless post.valid?

    post.save!

    render(
      json: Api::V1::PostSerializer.new(post).to_json,
      status: 201,
      location: api_v1_post_path(post.id),
      serializer: Api::V1::PostSerializer
    )
  end

  def update
    post = Post.find(params[:id])

    authorize post

    if !post.update_attributes(update_params)
      return api_error(status: 422, errors: post.errors)
    end

    render(
      json: Api::V1::PostSerializer.new(post).to_json,
      status: 200,
      location: api_v1_post_path(post.id),
      serializer: Api::V1::PostSerializer
    )
  end

  def destroy
    post = Post.find(params[:id])

    authorize post

    if !post.destroy
      return api_error(status: 500)
    end

    head status: 204
  end

  private

  def create_params
     params.require(:post).permit(
       :content, :picture, :user_id
     )
  end

  def update_params
    create_params
  end
end

