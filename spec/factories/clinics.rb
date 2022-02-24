FactoryBot.define do |factory|
  factory(:clinic) do
    sequence(:number) { |n| 2000000000 + n }
  end
end
