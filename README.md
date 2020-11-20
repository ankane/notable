# Notable

:star2: :star2: :star2:

Notable tracks notable requests and background jobs and stores them in your database.  What makes a request or job notable? There are a number of default situations, but ultimately you decide what interests you.

By default, Notable tracks:

- errors
- 404s
- slow requests and jobs
- timeouts
- validation failures
- CSRF failures
- unpermitted parameters
- blocked and throttled requests

You can track custom notes as well.

:tangerine: Battle-tested at [Instacart](https://www.instacart.com/opensource)

[![Build Status](https://github.com/ankane/notable/workflows/build/badge.svg?branch=master)](https://github.com/ankane/notable/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'notable'
```

And run:

```sh
rails generate notable:requests
rails generate notable:jobs
rails db:migrate
```

To explore the data, check out [Blazer](https://github.com/ankane/blazer).

## How It Works

A `Notable::Request` is created for:

- errors
- 404s
- slow requests
- timeouts from [Slowpoke](https://github.com/ankane/slowpoke)
- validation failures
- [CSRF failures](https://guides.rubyonrails.org/security.html#cross-site-request-forgery-csrf)
- unpermitted parameters
- blocked and throttled requests from [Rack Attack](https://github.com/kickstarter/rack-attack)

A `Notable::Job` is created for:

- errors
- slow jobs
- validation failures

Create a custom note inside a request or job with:

```ruby
Notable.track("Note Type", "Optional extra info")
```

## Customization

Disable tracking in certain environments

```ruby
Notable.enabled = Rails.env.production?
```

### Requests

Set slow threshold

```ruby
Notable.slow_request_threshold = 5.seconds
```

Custom user method

```ruby
Notable.user_method = lambda do |env|
  env["warden"].try(:user) || env["action_controller.instance"].try(:current_visit)
end
```

Custom track method

```ruby
Notable.track_request_method = lambda do |data, env|
  Notable::Request.create!(data)
end
```

Skip tracking CSRF failures

```ruby
skip_before_action :track_unverified_request
```

Anonymize IP addresses

```ruby
Notable.mask_ips = true
```

### Jobs

Set slow threshold

```ruby
Notable.slow_job_threshold = 60.seconds
```

To set a threshold for a specific job, use:

```ruby
class CustomJob < ApplicationJob
  def notable_slow_job_threshold
    5.minutes
  end
end
```

Custom track method

```ruby
Notable.track_job_method = lambda do |data|
  Notable::Job.create!(data)
end
```

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/notable/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/notable/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/notable.git
cd notable
bundle install
bundle exec rake test
```
