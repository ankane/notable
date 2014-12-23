# Notable

Notable tracks notable requests and backgrounds and stores them in your database.  What makes a request or job notable?  There are a number of default situations, but ultimately you decide what interests you.

By default, Notable tracks:

- errors
- 404s
- slow requests and jobs
- timeouts
- validation failures
- CSRF failures
- unpermitted parameters
- blocked and throttled requests

Notable requests are associated with a user whenever possible, making it great for helping customers.  You can also store custom notes.

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
- 404s
- slow requests
- timeouts
- validation failures
- [CSRF failures](http://guides.rubyonrails.org/security.html#cross-site-request-forgery-csrf)
- unpermitted parameters
- [blocked and throttled requests](https://github.com/kickstarter/rack-attack)

## Jobs

A `Notable::Job` is created for:

- errors
- slow jobs
- validation failures

Currently works with Delayed Job and Sidekiq.

## Manual Tracking

```ruby
Notable.track(note_type, note)
```

Like

```ruby
Notable.track("Signed In", "Platform: iOS")
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
