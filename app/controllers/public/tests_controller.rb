require "openai"

class Public::TestsController < Public::ApplicationController
  def index
    # just show form
  end

  def create
    scenario = params[:scenario]
    framework = params[:framework]

    prompt = build_prompt(scenario, framework)
    client = OpenAI::Client.new(access_token: Rails.application.credentials.openai_api_key)

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          {role: "system", content: "You are an expert test automation engineer."},
          {role: "user", content: prompt}
        ],
        temperature: 0.2,
        max_tokens: 500
      }
    )

    generated_code = response.dig("choices", 0, "message", "content") || "No code generated."

    # Store generated_code and inputs in session or flash to pass to show page
    session[:generated_code] = generated_code
    session[:scenario] = scenario
    session[:framework] = framework

    redirect_to generated_path
  rescue => e
    flash[:alert] = "Error generating test code: #{e.message}"
    redirect_to root_path
  end

  def show
    @generated_code = session.delete(:generated_code)
    @scenario = session.delete(:scenario)
    @framework = session.delete(:framework)

    unless @generated_code
      flash[:alert] = "No generated code found. Please submit a test scenario first."
      redirect_to root_path
    end
  end

  private

  def build_prompt(scenario, framework)
    <<~PROMPT
      Generate a #{framework.capitalize} end-to-end test based on the following plain English scenario:

      "#{scenario}"

      Please provide only the code, no explanations.
    PROMPT
  end
end
