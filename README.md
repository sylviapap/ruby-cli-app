# Symptom Checker CLI Ruby App

A simple CLI application for checking symptoms through the Infermedica API/database of symptoms and conditions. 

Infermedica is free, but limited, so if the app is not working, it might be a result of maxed out requests. You can sign up for your own API ID/Key with Infermedica if you'd like, or notify us if the keys have expired :)

# Install Instructions

First you will need a free Infermedica API ID/key: https://developer.infermedica.com/signup

```
git clone git@github.com:sylviapap/ruby-cli-app.git
bundle install
```

Then, you will need to add your API ID/key:

```
cd ruby-cli-app
touch .env
```

In `.env`:

```
INFERMEDICA_APP_ID=your_id
INFERMEDICA_APP_KEY=your_key
```

Finally:

```
rake db:migrate
rake db:seed
ruby bin/run.rb
```

### How do I turn off my SQL logger?
```ruby
# in config/environment.rb add this line:
ActiveRecord::Base.logger = nil
```