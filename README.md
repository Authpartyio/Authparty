# Authparty
Utilize your Bitcoin or Counterparty-enabled wallet to enable seameless, secure, and cross-service authentication.

# Configuration
The current version requres ruby-2.2.2. Clone the repo and `bundle install`.

## Database
A seed has been included for testing purposes. Update the values of the seed as needed, then initialize the database.

`rake db:create db:migrate db:seed`

## Environment Variables

* **Set the base url for the API:** Leave as-is to enable single sign-on mode utilizing authparty servers. Change to your host to enable single-site usage.
  * `BASE_API_URL=http://dev.authparty.io`
* **Set the Admin Address:** This address is used to allow access to restricted functions such as viewing, creating, and editing providers. This is set to change in a future release.
  * `PUBLIC_KEY=aWalletAddress`

## API
API-related functions are located in `app/api` and are mounted at `host/api/v1/`. This feature is for single sign-on functions and is interfaces with using your own HTTP client or [Connect](https://github.com/Authpartyio/Connect), our package for easy Authparty login integrations.

# Contributing
It is encouraged for the community to contribute with the following process.

1. Fork master/create branch named with your update
2. Commit your changes and create a Pull Request detailing the changes made and for what purposes.
3. Your PR will be reviewed ASAP after submittal.
