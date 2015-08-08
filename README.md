Airbrake Crystal
----------------
[![Build Status](https://travis-ci.org/kyrylo/airbrake-crystal.svg)](https://travis-ci.org/kyrylo/airbrake-crystal)

Introduction
------------

Airbrake Crystal is a Crystal notifier for [Airbrake][airbrake.io]. Airbrake
Crystal is currently in early development. Please, use and report bugs or share
your ideas. The library provides minimalist API that enables the ability to send
any Crystal exception to the Airbrake dashboard.

Installation
------------

Add the library to `Projectfile`.

```crystal
deps do
  github "kyrylo/airbrake"
end
```

Examples
--------

```crystal
require "airbrake"

Airbrake.configure do |config|
  config.project_id = 105138
  config.project_key = "fd04e13d806a90f96614ad8e529b2822"
end

begin
  1/0
rescue ex : DivisionByZero
  Airbrake.notify(ex)
end

puts 'Check your dashboard on https://airbrake.io'
```

Configuration
-------------

The main interface is `Airbrake.configure`.

```crystal
Airbrake.configure do |config|
  # ...
end
```

To tweak values inline use the following API:

```crystal
Airbrake.config.project_id = 105138
```

### Config options

#### project_id & project_key

You **must** set both `project_id` & `project_key`.

To find your `project_id` and `project_key` navigate to your project's _General
Settings_ and copy the values from the right sidebar.

![][project-idkey]

```ruby
airbrake.configure do |config|
  config.project_id = 105138
  config.project_key = 'fd04e13d806a90f96614ad8e529b2822'
end
```

API
---

#### Airbrake#notify

Sends an exception to Airbrake.

```crystal
Airbrake.notify(Exception.new("App crashed!"))
```

[airbrake.io]: http://airbrake.io
[project-idkey]: https://img-fotki.yandex.ru/get/3907/98991937.1f/0_b558a_c9274e4d_orig
