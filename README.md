# Friendship Collage

Friendship Collage is a Ruby on Rails app where users can sign up, save personality test results, add friends, and view collage-style tables of their own and friends' results.

## Features

- User authentication with Devise
- Save one result per user per test
- View your own collage
- Add friends by username
- View friends' collages
- Styled UI with Tailwind CSS

## Current Supported Tests

- Spotify Wrapped #1
- Animal in You
- Love Language
- Hogwarts house
- Political Compass
- Travel Style

## Tech Stack

- Ruby on Rails 8
- SQLite
- Devise
- Tailwind CSS

## Prerequisites

- Ruby `3.3.6`
- Bundler
- SQLite3

## Local Setup

```bash
git clone https://github.com/davidmakoyo/friendship-collage.git
cd friendship-collage
bundle install
bin/rails db:prepare
bin/dev
```

Then open: `http://localhost:3000`

## Running Tests

```bash
bin/rails test
```

## Seed Data

To reload supported tests:

```bash
bin/rails db:seed
```

## Auth Routes

- Sign up: `/users/sign_up`
- Sign in: `/users/sign_in`

## Notes

- If `bin/dev` fails, try:

```bash
bundle exec foreman start -f Procfile.dev
```

- If Ruby version errors appear, ensure your Ruby version matches `.ruby-version`.
