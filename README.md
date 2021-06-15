# Explorer POC (DEPRECATED)

This is a proof of concept for an open-source "Google Street View" for adventurous / outdoor 360 imagery.

It is now deprecated with a completely rewritten version here: https://github.com/trek-view

## Application setup steps

1. Clone the repo: `git clone git@github.com:trekview/explorer.git`
2. Switch to it folder `cd explorer`
3. Run `bundle install`
4. Create DB `rails db:create`
5. Migrate DB `rails db:migrate`
6. Seed DB `rails db:seed`
7. Start your application `rails server`
8. Visit page in your browser `http://localhost:3000`
9. Click 'login' and use `exp-admin@example.com` with password `password` to sign in(or you can register your own user)

## User Documentation

Developer documentation for this project is hosted on the GitHub wiki page for this project at: https://github.com/trek-view/explorer-poc/wiki
