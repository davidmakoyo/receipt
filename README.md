# Receipt Rescue

Receipt Rescue is a Ruby on Rails app for tracking personal spending with uploaded receipts. Users can save purchase details, attach receipt images, and view a simple dashboard of monthly totals and category spend.

## MVP Features

- User authentication with Devise
- Create, edit, view, and delete receipts
- Upload a receipt image with each entry
- Track merchant, amount, purchase date, and category
- Dashboard summary for month-to-date totals and category breakdown

## Tech Stack

- Ruby on Rails 8
- SQLite
- Devise
- Tailwind CSS
- Active Storage

## Prerequisites

- Ruby `3.3.6`
- Bundler
- SQLite3

## Local Setup

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server -p 4000
```

Open `http://localhost:4000`.

## Running Tests

```bash
bin/rails test
```

## Auth Routes

- Sign up: `/users/sign_up`
- Sign in: `/users/sign_in`

## Seed Data

`bin/rails db:seed` creates:

- Demo user: `demo@receiptrescue.app`
- Demo password: `password123`
- Sample receipts for dashboard testing

## Current Limitations

- Data entry is manual (no OCR yet)
- No scheduled reminder emails/jobs yet
