# frozen_string_literal: true

RSpec.shared_examples 'authenticable' do
  it 'returns an error' do
    expect(json['message']).to eq(I18n.t('status_messages.unathorized'))
  end

  it 'returns status code 401' do
    expect(response).to have_http_status(401)
  end
end