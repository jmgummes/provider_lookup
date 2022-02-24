FactoryBot.define do |factory|
  factory(:physician) do
    sequence(:number) { |n| 1000000000 + n }
  end
end
