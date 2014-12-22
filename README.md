# Notable

Track notable requests and background jobs

See users affected by:

- errors
- slow requests, jobs, and timeouts
- 404s
- validation failures
- CSRF failures
- unpermitted parameters
- blocked and throttled requests

:tangerine: Battle-tested at [Instacart](https://www.instacart.com)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'notable'
```

And run:

```sh
rails generate notable:requests
rails generate notable:jobs # optional
rake db:migrate
```

For a web interface, check out [Notable Web](https://github.com/ankane/notable_web).

## Requests

A `Notable::Request` is created for:

- errors
- slow requests and timeouts
- 404s
- validation failures
- [CSRF failures](http://guides.rubyonrails.org/security.html#cross-site-request-forgery-csrf)
- unpermitted parameters
- [blocked and throttled requests](https://github.com/kickstarter/rack-attack)

## Jobs

A `Notable::Job` is created for:

- errors
- slow jobs

Currently works with Delayed Job and Sidekiq.

## Manual Tracking

```ruby
Notable.track(note_type, note)
```

## Customize

Disable tracking in certain environments

```ruby
Notable.enabled = Rails.env.production?
```

### Requests

Set slow threshold

```ruby
Notable.slow_request_threshold = 5 # seconds (default)
```

Custom user method

```ruby
Notable.user_method = proc do |env|
  env["warden"].try(:user) || env["action_controller.instance"].try(:current_visit)
end
```

Custom track method

```ruby
Notable.track_request_method = proc do |data, env|
  Notable::Request.create!(data)
end
```

### Jobs

Set slow threshold

```ruby
Notable.slow_job_threshold = 60 # seconds (default)
```

Custom track method

```ruby
Notable.track_job_method = proc do |data|
  Notable::Job.create!(data)
end
```

## TODO

- ability to disable features
- add indexes

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/notable/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/notable/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
