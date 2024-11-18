RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  RSpec::Matchers.define_negated_matcher :not_change, :change
end
