require "faker"

$login = "/login"
$logout = "/logout"
$forms = {
  "/messages" => {
    :form_query => "form[action='/messages']",
    :params => lambda { 
      return {
        "message[recipient_username]" => "test",
        "message[subject]" => Faker::Commerce.product_name,
        "message[body]" => Faker::Commerce.price
      }
    }
  },
  "/stories" => {
    :form_query => "form[action='/stories']",
    :params => lambda {
      return {
        "story[url]" => Faker::Internet.url,
        "story[title]" => Faker::Book.title,
        "story[tags_a][]" => "test",
        "story[description]" => Faker::University.name
      }
    }
  },
  "/login" => {
    :form_query => "form[action='/login']",
    :params => lambda {
      return {
        "email" => "test",
        "password" => "test"
      }
    }
  }
}
