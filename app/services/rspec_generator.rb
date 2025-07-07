class RspecGenerator
  def self.generate(scenario)
    return "Invalid scenario" unless scenario

    code = []
    code << "scenario \"#{scenario.title}\" do"
    scenario.steps.each do |step|
      code << "  " + step_to_code(step)
    end
    code << "end"
    code.join("\n")
  end

  def self.step_to_code(step)
    case step
    when /Given I am on the (.+) page/i
      "visit #{Regexp.last_match(1).strip.gsub(" ", "_")}_path"
    when /When I fill in my (.+) and (.+)/i
      "fill_in \"#{Regexp.last_match(1).capitalize}\", with: #{Regexp.last_match(2).inspect}"
    when /And I (click|press) the (.+)/i
      "click_button #{Regexp.last_match(2).inspect}"
    when /Then I should see (.+)/i
      "expect(page).to have_content(#{Regexp.last_match(1).inspect})"
    else
      "# TODO: Unrecognized step: #{step}"
    end
  end
end
