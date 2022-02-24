FactoryBot.define do |factory|
  factory(:clinic_taxonomy) do
    sequence(:code) { |n| (1000 + n).to_s }
    description { "taxonomy desc" }
  end
end
