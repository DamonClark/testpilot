class Public::ConverterController < Public::ApplicationController
  def index
    # just show the form
  end

  def generate
    input = params[:gherkin_input]
    scenario = GherkinParser.parse(input)
    generated_code = RspecGenerator.generate(scenario)

    # Store in session or pass via params (session easier here)
    session[:generated_code] = generated_code
    session[:gherkin_input] = input

    redirect_to converter_result_path
  end

  def result
    @generated_code = session.delete(:generated_code)
    @gherkin_input = session.delete(:gherkin_input)
  end
end
