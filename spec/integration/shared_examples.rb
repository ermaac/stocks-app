shared_examples_for 'unauthenticated api request' do
  it do
    get endpoint_path, headers: auth_headers

    expect(response).to have_http_status(:unauthorized)
  end
end

shared_examples_for 'authenticated api request' do
  it do
    get endpoint_path, headers: auth_headers

    expect(response).to have_http_status(:ok)
  end
end
