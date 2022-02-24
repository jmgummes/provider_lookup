FactoryBot.define do |factory|
  factory(:physician_taxonomy_edge) do
    sequence(:license) { |n| (10000 + n).to_s }
  end
end
