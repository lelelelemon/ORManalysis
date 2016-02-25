require "faker"

$page_path = "/tasks/new"
$form_query = "form[action='/tasks/create']"

def get_params
  return {
    "task[name]" => Faker::Name.name,
    "todo[name]" => Faker::Name.name,
    "task[duration]" => rand(10).to_s + "h " + rand(60).to_s + "m",
    "task[due_at]" => rand(28).to_s + "/" + (rand(12)+1).to_s + "/" + "2016",
    "task[set_tags]" => Faker::Name.name,
    "customer[name]" => Faker::Name.name,
  }
end
