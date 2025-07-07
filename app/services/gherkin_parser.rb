class GherkinScenario
  attr_reader :title, :steps

  def initialize(title, steps)
    @title = title
    @steps = steps
  end
end

class GherkinParser
  def self.parse(text)
    lines = text.lines.map(&:strip)
    title = lines.find { |l| l.start_with?("Scenario:") }&.sub("Scenario:", "")&.strip
    steps = lines.select { |l| l =~ /^(Given|When|Then|And)/ }
    GherkinScenario.new(title, steps)
  end
end
