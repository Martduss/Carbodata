namespace :demo do
  desc "Reset the demo account's recipes/items/posts back to their curated baseline"
  task reset: :environment do
    if DemoAccount.user
      DemoAccount.reset!
      puts "Demo account reset."
    else
      puts "No user is flagged demo: true — nothing to reset."
    end
  end
end
