# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Announcements API', type: :request do
  let(:author) { create(:user) }
  let(:non_author) { create(:user) }

  let(:author_header) { { "USER-ID" => author.id } }
  let(:non_author_header) { { "USER-ID" => non_author.id } }

  let(:expected_keys) { %w[id description status updated_at user_id created_at] }
  let(:expected_keys_with_responses) { %w[id description responses status updated_at user_id created_at] }
  let(:expected_response_keys) { %w[id announcement_id price status user_id] }

  let(:announcement) { create(:announcement, user: author) }

  before do
    create(:response, announcement: announcement, user: non_author)
    create(:response, announcement: announcement, status: :cancelled)
    create(:response, announcement: announcement)
  end

  context 'announcements list' do
    before do
      create_list(:announcement, 2, user: author)
      get url, headers: author_header
    end

    describe 'GET /api/announcements' do
      let(:url) { '/api/announcements/' }

      it 'returns announcements of author' do
        expect(json).not_to be_empty
        expect(json.first.keys).to match_array(expected_keys)
        expect(json.size).to eq(3)

        json.each do |item|
          expect(item['user_id']).to eq(author.id)
        end
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it_should_behave_like 'authenticable' do
        before { get url }
      end
    end

    describe 'GET /api/announcements/active' do
      let(:url) { '/api/announcements/active' }

      it 'returns active announcements' do
        expect(json).not_to be_empty
        expect(json.first.keys).to match_array(expected_keys)
        expect(json.size).to eq(3)

        json.each do |item|
          expect(item['status']).to eq('active')
        end
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it_should_behave_like 'authenticable' do
        before { get url }
      end
    end
  end

  describe 'GET /api/announcements/:id' do
    let(:announcement_id) { announcement.id }
    let(:url) { "/api/announcements/#{announcement_id}" }

    context 'when user is an author' do
      before do
        get url, headers: author_header
      end

      context 'when the record exists' do
        it 'returns the announcement with responses' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(announcement_id)
          expect(json.keys).to match_array(expected_keys_with_responses)

          expect(json['responses'].first.keys).to match_array(expected_response_keys)
          expect(json['responses'].first['announcement_id']).to eq(announcement_id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the record does not exist' do
        let(:announcement_id) { '100' }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Announcement/)
        end
      end
    end

    context 'when user is non author' do
      before do
        get url, headers: non_author_header
      end

      context 'when the record exists' do
        it 'returns the announcement' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(announcement_id)
          expect(json.keys).to match_array(expected_keys)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
    end

    it_should_behave_like 'authenticable' do
      before { get url }
    end
  end

  describe 'POST /api/announcements' do

    let(:url) { "/api/announcements" }
    let(:valid_attributes) { { announcement: { description: 'description', status: 'active' } } }
    let(:invalid_attributes) { { announcement: { description: '', status: 'active' } } }

    context 'when the request is valid' do
      before { post url, params: valid_attributes, headers: author_header }

      it 'creates a announcement' do
        expect(json['description']).to eq('description')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post url, params: invalid_attributes, headers: author_header }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Description can't be blank/)
      end
    end

    it_should_behave_like 'authenticable' do
      before { post url, params: valid_attributes }
    end
  end

  describe 'PUT /api/announcements/:id/cancel' do
    let(:url) { "/api/announcements/#{announcement.id}/cancel" }

    context 'when user is an author' do
      before do
        put url, headers: author_header
      end

      it 'returns the announcement id' do
        expect(json['id']).to be_present
      end

      it 'set status is cancelled' do
        announcement.reload
        expect(announcement.status).to eq('cancelled')
      end

      it 'set responses statuses is declined' do
        expect(announcement.responses.pluck(:status).uniq).to match_array(%w[declined])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user is non author' do
      it_should_behave_like 'authorizable' do
        before { put url, headers: non_author_header }
      end
    end

    it_should_behave_like 'authenticable' do
      before { put url }
    end
  end
end