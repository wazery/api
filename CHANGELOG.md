v0.2.0 - GitHub basic data - PR#9 (2 Oct 2015)
===
  - Remove unnecessary code - b23e77f
  - Add repo model - 3a2b060
  - Fetch Github hacker's watched repos and followed hackers - 738909f
  - Make tests to pass - 838ce0f

## v0.2.1 - Fix Watched repos and followed users data fetching PR#15 (2 Oct 2015)

  - Fix watched repos and followed users data fetching - 031f8ce

**[Islam Wazery](https://github.com/wazery)**

v0.1.0 - Authentication - PR#8 (25 Sep 2015)
===
  - Refactor the hacker model, with some Yard docs - 76ddbd6
  - Add Sidekiq for background jobs, with Sidekiq RSpec gem - ce472a1
  - Clear out the documentation - 6424446
  - Add Chrome Github authentication endpoints - 74dd0e1
  - Add basic authentication service - 314202b
  - Add Github endpoints dynamic URL methods - 6e9abe0
  - Use Github endpoints dynamic URLs - 5b7fa85
  - Remove Octokit dependancy in favour of our auth service - dee6f6f
  - Add our Github configuration module - ac94f1b
  - Add public and private authentication methods - a078224
  - Add a sessions controller - 1cf23a8
  - Implement session tokens and power them by Redis - 8aa273a
  - Remove the configuration module from services and move it to intializers - 043d334
  - Add JWT token generation service - a61f3db
  - Add more fields to the hacker model and a callback - c32ae3e
  - Implement an application controller - 6cc36ee
  - Change user to hacker in the auth service - 252332a
  - Add a hacker serializer - 3f05d58
  - Remove the endpoints in hacker controller - 7f480aa
  - Add dummy secrets YAML for Drone - 4166130
  - Add some configs for Webmock, Mongo, and Airbrussh - c6e1827
  - Add more validations to the hacker model - ecaa502
  - Test session creation temporarily	- 82eaff7
  - Remove the devise gem entirly	- 9ea3eb3
  
**[Islam Wazery](https://github.com/wazery)**

## v0.1.2 - Handle failure of fetching Github access token - PR#11 (27 Sep 2015)

  - Handle failure of fetching access token - 7a79d74

## v0.1.1 - Fix basic OAuth signup with Github - PR#9 (26 Sep 2015)

  - Fix basic OAuth signup with Github - 210f06e

v0.0.0
===
  - Fix database_cleaner gem version (Mohamed Yossry) - p1
  - Fix Mongoid config for deployment (Islam Wazery) - p2
