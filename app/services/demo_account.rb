# Owns the curated content shown to recruiters via "Try the Demo".
# `reset!` only ever touches the single User flagged demo: true — it never
# touches any other user's data, so it's safe to run in production directly
# (heroku run rails demo:reset) as well as on a recurring schedule.
class DemoAccount
  BASELINE_RECIPES = [
    {
      name: "Quinoa & Black Bean Salad",
      description: "A simple, low-GI salad using complex carbs and fresh vegetables.",
      steps: "1. Cook quinoa. 2. Rinse black beans. 3. Chop bell pepper and cilantro. 4. Mix all ingredients with lime juice and a dash of olive oil.",
      difficulty: 1,
      indice_gly: 35,
      ratio_glucide: 18
    },
    {
      name: "Homemade Chicken Curry",
      description: "A rich and flavorful curry, designed to be served with a small amount of brown rice or cauli-rice for a moderate GI.",
      steps: "1. Chop chicken and vegetables. 2. Sauté onions and garlic. 3. Add curry paste and spices. 4. Simmer chicken and veggies in coconut milk until cooked through.",
      difficulty: 2,
      indice_gly: 52,
      ratio_glucide: 12
    }
  ].freeze

  BASELINE_ITEMS = [
    { name: "Oats (Rolled)", brand: "Quaker", category: "Grains & Legumes", indice_gly: 55, ratio_glucide: 66 },
    { name: "Lentils (Brown)", brand: "Generic", category: "Grains & Legumes", indice_gly: 32, ratio_glucide: 11 }
  ].freeze

  WELCOME_POST = {
    title: "Welcome to the Carbodata demo!",
    content: "You're signed in as our demo account, pre-loaded with recipes, products, and posts. " \
      "Feel free to browse the community feed, check out glycemic-index-ranked recipes and products " \
      "in the dashboard, or try the AI recipe assistant. Profile editing and logout are disabled on this " \
      "account — just head back to the homepage when you're done exploring.",
    up: 0,
    down: 0
  }.freeze

  def self.user
    User.demo.first
  end

  def self.reset!
    user = self.user
    return unless user

    user.chats.destroy_all
    user.posts.destroy_all
    user.recipes.destroy_all
    user.items.destroy_all

    BASELINE_RECIPES.each { |attrs| user.recipes.create!(attrs) }
    BASELINE_ITEMS.each { |attrs| user.items.create!(attrs) }
    user.posts.create!(WELCOME_POST.merge(created_at: Time.current))
  end
end
