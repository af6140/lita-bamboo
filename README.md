# lita-bamboo

Lita bamboo build server handler.

## Installation

Add lita-bamboo to your Lita instance's Gemfile:

``` ruby
gem "lita-bamboo"
```

## Configuration

```ruby
Lita.configure do |config|
  config.handlers.bamboo.url = "https://bamboo.example.com/rest/api/latest"  
  config.handlers.bamboo.verify_ssl = false # default
end
```
## Usage

* bamboo list projects
* bamboo list project PROJECT_KEY plans
* bamboo list plan PLAN_KEY results limit 2
* bamboo list queue
* bamboo queue PLAN_KEY
* bamboo dequeue BUILD_KEY
