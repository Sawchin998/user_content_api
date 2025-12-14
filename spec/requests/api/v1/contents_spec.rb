# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Contents', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  let!(:content) { create(:content, user: user) }
  let!(:other_content) { create(:content, user: other_user) }

  describe 'GET /api/v1/contents' do
    context 'when user is authenticated' do
      it 'returns paginated contents' do
        get '/api/v1/contents', headers: auth_headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json['data'].map { |c| c['id'] }).to include(content.id, other_content.id)
        expect(json['pagination']).to include(
          'page' => 1,
          'per_page' => 20,
          'count' => Content.count
        )
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        get '/api/v1/contents'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/contents/:id' do
    context 'authenticated' do
      it 'returns the content' do
        get "/api/v1/contents/#{content.id}", headers: auth_headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['data']['id']).to eq(content.id)
      end
    end

    context 'unauthenticated' do
      it 'returns unauthorized' do
        get "/api/v1/contents/#{content.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'content does not exist' do
      it 'returns not found' do
        get '/api/v1/contents/999999', headers: auth_headers
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['errors']).to include('Content not found')
      end
    end
  end

  describe 'POST /api/v1/contents' do
    context 'authenticated with valid params' do
      it 'creates a new content' do
        expect do
          post '/api/v1/contents', params: { content: { title: 'New Content', body: 'Body' } }, headers: auth_headers
        end.to change(Content, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'authenticated with invalid params' do
      it 'returns unprocessable entity' do
        post '/api/v1/contents', params: { content: { title: '', body: '' } }, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json['errors']).to include("Title can't be blank", "Body can't be blank")
      end
    end

    context 'unauthenticated' do
      it 'returns unauthorized' do
        post '/api/v1/contents', params: { content: { title: 'New', body: 'Body' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/contents/:id' do
    context 'owner user' do
      it 'updates the content successfully' do
        patch "/api/v1/contents/#{content.id}", params: { content: { title: 'Updated Title' } }, headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(content.reload.title).to eq('Updated Title')
      end
    end

    context 'non-owner user' do
      it 'returns forbidden' do
        patch "/api/v1/contents/#{other_content.id}", params: { content: { title: 'Update' } }, headers: auth_headers
        expect(response).to have_http_status(:forbidden)
        json = JSON.parse(response.body)
        expect(json['errors']).to include('You are not authorized to perform this action')
      end
    end

    context 'unauthenticated' do
      it 'returns unauthorized' do
        patch "/api/v1/contents/#{content.id}", params: { content: { title: 'Update' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/contents/:id' do
    context 'owner user' do
      it 'deletes the content' do
        expect do
          delete "/api/v1/contents/#{content.id}", headers: auth_headers
        end.to change(Content, :count).by(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'non-owner user' do
      it 'returns forbidden' do
        delete "/api/v1/contents/#{other_content.id}", headers: auth_headers
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'unauthenticated' do
      it 'returns unauthorized' do
        delete "/api/v1/contents/#{content.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
