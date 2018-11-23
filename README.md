# DNS Records Challenge

Rails API project with the following tech stack:
  - Rails 5.2.0
  - Ruby 2.4.1
  - SQLite3 (built-in)
  - RSpec, FactoryBot and Database Cleaner for the test suite.

### Installation

This project requires Ruby 2.4.1 and bundler gem installed locally. Multiple Ruby versions can be managed by RVM or rbenv.

```sh
$ git clone git@github.com:mauroponce/dns_records_challenge.git
$ cd dns_records_challenge
$ bundle
$ bundle exec rake db:create:all
$ bundle exec rake db:migrate
```

Seed data can be inserted using
```sh
$ bundle exec rake db:seed
```

Run development server using
```sh
$ bundle exec rails s
```

Tests can be run like this
```sh
$ bundle exec rspec spec
```

### API Endpoints
There are currently 2 endpoints
#### DNS records creation
##### POST /dns_records
Example JSON request
 ```json
{
  "dns_record" : {
    "ipv4_address" : "127.0.0.1",
    "hostnames" : [
      "lorem.com", "ipsum.com", "dolor.com", "amet.com"
    ]
  }
}
```
Example Response with created DNS ID
 ```json
{
    "ID": 124
}
```
#### DNS records and hostname search
##### GET /dns_records/search
Example JSON request
 ```json
{
  "search" : {
    "page_number" : 10,
    "included_hostnames" : ["ipsum.com", "dolor.com"],
    "excluded_hostnames" : ["sit.com"]
  }
}
```
Example Response with DNS records matching included and excluded hostnames, and additional hostnames for those DNS records, not sent by the query in either included_hostnames or excluded_hostnames params
 ```json
{
    "dns_records_number": 4,
    "dns_records": [
        {
            "ID": 117,
            "IP": "1.1.1.1"
        },
        {
            "ID": 119,
            "IP": "3.3.3.3"
        },
        {
            "ID": 123,
            "IP": "1.1.1.126"
        },
        {
            "ID": 124,
            "IP": "1.1.1.123"
        }
    ],
    "hostnames": [
        "Hostname: lorem.com, Number of matching DNS records: 3",
        "Hostname: amet.com, Number of matching DNS records: 4"
    ]
}
```

### Features
* Current applitacion uses Ruby built-in IPAddr class, which is used to validate IP address in DNS creation endpoint and display the error in the response as follows:
 ```json
{
    "errors": [
        "Ipv4 address is not a valid IPv4 address"
    ]
}
 ```
* When an IP address is already taken, appropriate message is displayed too.
 ```json
{
    "errors": [
        "Ipv4 address is already taken."
    ]
}
 ```


License
----

MIT
**Free Software**

