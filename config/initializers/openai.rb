if openai_enabled?
  OpenAI.configure do |config|
    config.access_token = Rails.application.credentials.openai_api_key
    config.organization_id = Rails.application.credentials.openai_organization_id if openai_organization_exists?

    # Set request timeout. Default is 120 seconds.
    # config.request_timeout = 25
  end
end
