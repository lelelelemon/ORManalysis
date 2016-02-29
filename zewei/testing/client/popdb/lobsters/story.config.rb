require "faker"


$page_path = "/stories/new"
$form_query = "form[action='/stories']"

def get_params
  params = {
    "story[url]" => Faker::Internet.url,
    "story[title]" => Faker::Book.title,
    "story[tags_a][]" => "test",
    "story[description]" => Faker::University.name
  }

  return params
end
