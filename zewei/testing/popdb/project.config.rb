require "faker"

$page_path = "/projects/new"
$form_query = "form[action='/projects']"

def get_params
  return {
    "project[name]" => Faker::Name.name,
    "custormer[name]" => Faker::Name.name,
    "default[user]" => Faker::Name.name[0..10],
    "project[default_estimates]" => rand(10)+1,
    "project[description]" => Faker::Name.name
  }
end
