require 'rails_helper'

describe Api::V1::PostsController, type: :api do
  context :index do
    before do
      user = create_and_sign_in_user
      5.times{ FactoryGirl.create(:post, user: user) }

      get api_v1_posts_path, user_id: user.id, format: :json
    end

    it_returns_status(200)

    it_returns_resources(root: 'posts', number: 5)
  end

  context :create do
    before do
      @user = create_and_sign_in_user
      @post = FactoryGirl.attributes_for(:post).merge(user_id: @user.id)

      post api_v1_posts_path, post: @post.as_json, format: :json
    end

    it_returns_status(201)

    it_returns_attributes(resource: 'post', model: '@post', only: [
      :content, :user_id
    ])

    it_returns_more_attributes(
      resource: 'post',
      model: 'Post.last!',
      only: [:updated_at, :created_at],
      modifier: 'iso8601'
    )
  end

  context :show do
    before do
      create_and_sign_in_user
      @post = FactoryGirl.create(:post)

      get api_v1_post_path(@post.id), format: :json
    end

    it_returns_status(200)

    it_returns_attributes(resource: 'post', model: '@post', only: [
      :content, :user_id
    ])

    it_returns_more_attributes(
      resource: 'post',
      model: 'Post.last!',
      only: [:updated_at, :created_at],
      modifier: 'iso8601'
    )
  end

  context :update do
    context "without ownership" do
      before do
        create_and_sign_in_user
        @post = FactoryGirl.create(:post, user: FactoryGirl.create(:user))
        @post.content = 'Another content'

        put api_v1_post_path(@post.id), post: @post.as_json, format: :json
      end

      it_returns_status(403)
    end

    context "wih ownership" do
      before do
        user = create_and_sign_in_user
        @post = FactoryGirl.create(:post, user: user)
        @post.content = 'Another content'

        put api_v1_post_path(@post.id), post: @post.as_json, format: :json
      end

      it_returns_status(200)

      it_includes_in_headers({Location: 'api_v1_post_path(@post.id)'})

      it_returns_attributes(resource: 'post', model: '@post', only: [
        :content, :user_id
      ])

      it_returns_more_attributes(
        resource: "post",
        model: 'Post.last!',
        only: [:updated_at, :created_at],
        modifier: 'iso8601'
      )
    end
  end

  context :delete do
    context 'when the resource does NOT exist' do
      before do
        create_and_sign_in_user
        @post = FactoryGirl.create(:post)
        delete api_v1_post_path(rand(100..1000)), format: :json
      end

      it_returns_status(404)
    end

    context 'when the resource does exist' do
      before do
        user = create_and_sign_in_user
        @post = FactoryGirl.create(:post, user: user)

        delete api_v1_post_path(@post.id), format: :json
      end

      it_returns_status(204)

      it 'actually deletes the resource' do
        expect(Post.find_by(id: @post.id)).to eql(nil)
      end
    end
  end
end

