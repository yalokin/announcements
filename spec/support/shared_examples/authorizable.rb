# frozen_string_literal: true

RSpec.shared_examples 'authorizable' do
  it 'returns the access denied message' do
    expect(json['message']).to eq(I18n.t('status_messages.access_denied'))
  end

  it 'returns status code 401' do
    expect(response).to have_http_status(401)
  end
end