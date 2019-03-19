# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Responses API', type: :request do
  let(:response_author) { create(:user) }
  let(:announcement_author) { create(:user) }

  let(:response_header) { { "USER-ID" => response_author.id } }
  let(:announcement_header) { { "USER-ID" => announcement_author.id } }

  let(:expected_keys) { %w[id announcement_id price status user_id] }
  let(:announcement) { create(:announcement, user: announcement_author) }

  describe 'GET /api/responses' do
    let(:url) { '/api/responses/' }

    before do
      create(:response, user: response_author, announcement: announcement, status: :cancelled)
      create(:response, user: response_author, announcement: announcement)
      get url, headers: response_header
    end

    it 'returns responses of author' do
      expect(json).not_to be_empty
      expect(json.first.keys).to match_array(expected_keys)
      expect(json.size).to eq(2)

      json.each do |item|
        expect(item['user_id']).to eq(response_author.id)
      end
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it_should_behave_like 'authenticable' do
      before { get url }
    end
  end

  describe 'POST /api/responses' do
    let(:valid_attributes) { { response: { announcement_id: announcement.id, price: 1234, status: 'pending' } } }
    let(:url) { '/api/responses' }

    context 'when the request is valid' do
      before { post url, params: valid_attributes, headers: response_header }

      it 'creates a responses' do
        expect(json['price']).to eq(1234)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { response: { announcement_id: announcement.id, price: 1, status: 'pending' } } }

      before { post url, params: invalid_attributes, headers: response_header }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Price must be greater than or equal to 100/)
      end
    end


    context 'when the announcement is non active' do
      let(:inactive_announcement) { create(:announcement, status: :cancelled) }
      let(:inactive_attributes) { { response: { announcement_id: inactive_announcement.id, price: 1234, status: 'pending' } } }

      before { post url, params: inactive_attributes, headers: response_header }

      it 'return validation message' do
        expect(json['message']).to match(I18n.t('error_messages.inactive_announcement'))
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end

    context 'when have declined response by announcement author' do
      before do
        create(:response, announcement: announcement, user: response_author, status: :declined)
        post url, params: valid_attributes, headers: response_header
      end

      it 'return validation message' do
        expect(json['message']).to match(I18n.t('error_messages.declined_response'))
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end

    context 'when have pending response of author' do
      before do
        create(:response, announcement: announcement, user: response_author)
        post url, params: valid_attributes, headers: response_header
      end

      it 'return validation message' do
        expect(json['message']).to match(I18n.t('error_messages.pending_response'))
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end

    it_should_behave_like 'authenticable' do
      before { post url, params: valid_attributes }
    end
  end

  describe 'PUT /api/responses/:id/cancel' do
    let(:response_cancel) { create(:response, user: response_author, announcement: announcement) }
    let(:url) { "/api/responses/#{response_cancel.id}/cancel" }

    context 'when user is an author' do
      before { put url, headers: response_header }

      it 'returns the response id' do
        expect(json['id']).to eq(response_cancel.id)
      end

      it 'set status is cancelled' do
        response_cancel.reload
        expect(response_cancel.status).to eq('cancelled')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user is non author' do
      it_should_behave_like 'authorizable' do
        before { put url, headers: announcement_header }
      end
    end

    it_should_behave_like 'authenticable' do
      before { put url }
    end
  end

  describe 'PUT /api/responses/:id/accept' do
    let(:response_accept) { create(:response, user: response_author, announcement: announcement) }
    let(:params) { { response: { announcement_id: announcement.id } } }
    let(:url) { "/api/responses/#{response_accept.id}/accept" }

    context 'when user is an author of announcement' do
      before do
        create_list(:response, 2, announcement: announcement)
        put url, headers: announcement_header, params: params
      end

      it 'returns the announcement id' do
        expect(json['id']).to eq(response_accept.id)
      end

      it 'set accepted status' do
        response_accept.reload
        expect(response_accept.status).to eq('accepted')
      end

      it 'set declined statuses' do
        expect(announcement.responses.where.not(status: :accepted).pluck(:status).uniq).to match_array(%w[declined])
      end

      it 'set announcement status is closed' do
        announcement.reload
        expect(announcement.status).to eq('closed')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user is non author' do
      it_should_behave_like 'authorizable' do
        before { put url, headers: response_header, params: params }
      end
    end

    it_should_behave_like 'authenticable' do
      before { put url }
    end
  end
end