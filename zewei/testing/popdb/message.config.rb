require "faker"


$page_path = "/messages"
$form_query = "form[action='/messages']"

def get_params
  params = {
    "message[recipient_username]" => "test",
    "message[subject]" => Faker::Commerce.product_name,
    "message[body]" => Faker::Commerce.price
  }

  return params
end
