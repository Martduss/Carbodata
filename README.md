# CarboData

A full-stack web application that helps people with diabetes discover, create, and manage low-glycemic recipes — powered by an AI assistant that generates personalized meal plans.

## 🚀 Try the Live Demo 🚀

Want to explore the app without setting it up locally? You can try the live demo hosted on Heroku:

👉 **https://www.carbodata.online**

Once you're on the homepage, click **"Try the Demo"** to access a pre-configured demo account and start exploring immediately.

![Try the Demo button](docs/screenshots/try_demo.png)

> **Note:** The demo runs on a free Heroku dyno, so the first visit may take a few seconds while the application wakes up.

---

## Screenshots

...

---

## Screenshots

| Feed                               | Recipes (Carbomeals)                           | Products (CarboDucts)                                     |
|------------------------------------|------------------------------------------|------------------------------------------------|
| ![Feed](docs/screenshots/feed.png) | ![Recipes](docs/screenshots/recipes.png) | ![CarboDucts](docs/screenshots/carboducts.png) |

### SuperCarbo AI in action => Construct your own original recipe with SuperCarbo!

| 1. Pick your ingredients                                      | 2. Get a recipe instantly                                   | 3. Ask what you want to SuperCarbo
|---------------------------------------------------------------|-------------------------------------------------------------|----------------------------------------------------|
| ![Select ingredients](docs/screenshots/chat_select_items.png) | ![First response](docs/screenshots/chat_first_response.png) | ![Detailed steps](docs/screenshots/chat_steps.png) |

---

## Features

- **CarboMeals** — Create and organize recipes by glycemic index (GI) with automatic low/medium/high classification
- **AI chatbot "SuperCarbo"** — Chat with an OpenAI-powered assistant that generates diabetic-friendly recipes based on ingredients you select; responses stream in real time
- **Social feed** — Share posts with the community, comment, and vote (upvote/downvote)
- **CarboDucts** — Manage individual food items with GI and carb data to use as inputs for AI recipe generation
- **Shared recipes** — Recipes can be kept private or published to your public profile
- **Full-text search** — Search across recipes, items, and posts via PostgreSQL full-text search

---

## Tech Stack

| Layer            | Technology                                      |
| ---------------- | ----------------------------------------------- |
| Backend          | Ruby 3.3.5, Rails 7.1                           |
| Database         | PostgreSQL + PgSearch (full-text)               |
| Authentication   | Devise                                          |
| Frontend         | Hotwire (Turbo + Stimulus), Bootstrap 5         |
| AI               | OpenAI API via RubyLLM                          |
| Real-time        | Action Cable + Solid Queue (streaming LLM)      |
| File storage     | Cloudinary + Active Storage                     |
| Asset pipeline   | Sprockets + ImportMap                           |

---

## Architecture Highlights

**Real-time AI streaming** — LLM responses are generated asynchronously in a background job (`GenerateLlmResponseJob`) and streamed token by token to the browser via Turbo Streams and Action Cable, giving a ChatGPT-like experience.

**Polymorphic voting** — A single `Vote` model handles upvotes/downvotes on both posts and comments using Rails polymorphic associations, avoiding duplicated logic.

**Recipe visibility** — Recipes use an enum (`private_recipe` / `shared`) so users control what appears on their public profile. Authorization is split: anyone can read shared recipes, only the owner can edit or delete.

**GI-based classification** — Recipes and food items are classified into low/medium/high glycemic index tiers. The index page loads all recipes in a single query and partitions in Ruby, avoiding N+1 queries.

---

## Getting Started

### Prerequisites

- Ruby 3.3.5
- PostgreSQL
- A Cloudinary account (free tier works)
- An OpenAI API key

### Installation

```bash
git clone https://github.com/martduss/Carbodata.git
cd Carbodata
bundle install
```

### Environment variables

Copy the example file and fill in your own values:

```bash
cp .env.example .env
```

| Variable                  | Description                                                    |
| ------------------------- | -------------------------------------------------------------- |
| `OPENAI_API_KEY`          | Your OpenAI API key                                            |
| `CLOUDINARY_URL`          | Full Cloudinary URL (`cloudinary://key:secret@cloud_name`)     |
| `DEFAULT_RECIPE_IMAGE_URL`| Cloudinary URL for the default recipe placeholder image        |

### Database setup

```bash
bin/rails db:create db:migrate
```

### Start the app

You need two processes — the web server and the background job worker:

```bash
# Terminal 1 — web server
bin/rails server

# Terminal 2 — job worker (for AI streaming)
bin/jobs
```

Open [http://localhost:3000](http://localhost:3000).

---

## Running Tests

```bash
bin/rails test
```

Authorization and recipe visibility are covered; other controllers are stubs

---

## Project Structure

```text
app/
├── controllers/
│   ├── messages_controller.rb        # AI chat + recipe saving
│   ├── recipes_controller.rb         # Recipe CRUD with visibility
│   └── pages_controller.rb           # Feed, home, profile
├── models/
│   ├── recipe.rb                     # GI classification, markdown parsing, visibility enum
│   ├── post.rb                       # Social feed posts
│   └── vote.rb                       # Polymorphic voting
├── jobs/
│   └── generate_llm_response_job.rb  # Async AI streaming
└── javascript/controllers/
    ├── wizard_controller.js          # Multi-step recipe creation form
    └── vote_controller.js            # Real-time vote updates
```

---

## License

MIT
