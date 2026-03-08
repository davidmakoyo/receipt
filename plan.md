# Friendship Collage – Project Plan

A Ruby on Rails web app where users sign in with Devise, take (or link to) personality tests, save results to their profile, add friends by username, and view their own and friends’ “collages” (tables of test results).

---

## 1. Tech stack

- **Ruby on Rails** (latest 7.x)
- **Devise** – authentication (login, logout, registration)
- **Database** – SQLite for dev (or PostgreSQL if you prefer)
- **Frontend** – ERB views, minimal JS; **Tailwind CSS** for a modern, consistent UI (recommended: use `tailwindcss-rails` or import Tailwind so the app is beautiful from day one).

---

## 2. UI & design (modern and beautiful)

### 2.1 Design principles

- **Clean and uncluttered** – generous whitespace, clear hierarchy, one primary action per section.
- **Warm and friendly** – soft shadows, rounded corners, a cohesive color palette (not corporate gray).
- **Readable** – strong typography (e.g. a distinctive sans or serif for headings, neutral sans for body).
- **Responsive** – works on mobile and desktop; collages and lists stack or adapt gracefully.
- **Delightful details** – subtle hover states, smooth transitions, clear feedback (success/error toasts or inline messages).

### 2.2 Design system (suggested)

| Element | Suggestion |
|--------|------------|
| **Primary palette** | Warm accent (e.g. soft coral, sage, or muted teal) + neutral grays with a slight warm tint. Avoid pure black; use dark gray. |
| **Typography** | Headings: one font (e.g. **DM Sans**, **Outfit**, or **Fraunces**). Body: readable sans (e.g. **Inter**, **Source Sans 3**). Use font-weight and size for hierarchy. |
| **Surfaces** | Cards with subtle border or soft shadow; optional very light background tint (e.g. off-white or pale warm gray) for the page. |
| **Spacing** | Consistent scale (e.g. 4/8/16/24/32/48px). Comfortable padding in cards and between sections. |
| **Corners** | Rounded (e.g. 8–12px for cards and buttons; 6–8px for inputs). |
| **Links & buttons** | Primary: filled accent; secondary: outline or text. Clear hover state (darker or slight scale/underline). |

### 2.3 Page-by-page UI notes

| Page | UI goals |
|------|----------|
| **Layout / nav** | Sticky or fixed top nav: logo or app name, links (My Collage, Tests, Friends), user name + Log out. Minimal, high contrast. Optional thin bottom border or soft shadow. |
| **My collage** | Hero-style header (“My collage” or “Hello, [username]”). Table in a card: clear header row, alternating or hover row states, “Not taken” in muted text or a small pill/badge. Optional: progress (e.g. “3 of 6 tests completed”). |
| **Tests index** | Grid or list of **cards** (one per test): test name, short description if any, “Take test” + “Save result” or “View / Edit result”. Icons or subtle color per card for visual interest. |
| **Test show** | Single test card: title, description, prominent “Take the test” button (external link), then a clear form to save result (input + “Save my result” button). Success message after save. |
| **Friends index** | Search: prominent input + “Add friend” button. Friends list: avatars (optional placeholder initials), username, “View collage” link/button. Empty state: friendly illustration or message when no friends yet. |
| **Friend’s collage** | Same table as “my collage” but with a header like “[Friend’s] collage” and a back link to Friends or My Collage. |
| **Auth (login/register)** | Centered card on a simple background (gradient or soft color). Clean form fields, one primary button. Link to sign up / sign in. |
| **Flash messages** | Toast-style or banner at top: success (green), error (red), notice (blue). Auto-dismiss or close button. |

### 2.4 Technical approach

- Use **Tailwind CSS** (utility-first) so we can implement the above without writing custom CSS files for every detail. Optionally add **Tailwind UI** or **Flowbite** components for nav, cards, and forms.
- **Custom CSS** only where needed: e.g. one `application.css` for fonts (Google Fonts or local), CSS variables for brand colors if you want to swap themes later.
- **Icons**: use a small set (e.g. **Heroicons** or **Lucide**) for nav, buttons, and empty states so the UI feels polished and consistent.

### 2.5 Implementation order (UI)

- Set up Tailwind + fonts + base layout (nav + flash) **early** (right after Rails + Devise).
- Apply the design system to each new page as you build it (collage table, test cards, friends list).
- Reserve time at the end for **UI polish**: empty states, loading/feedback, and a quick pass on mobile breakpoints.

---

## 3. Core concepts

| Concept | Description |
|--------|-------------|
| **Supported test** | A personality test in the system (e.g. “Animal in You”). Has a name, optional external URL, and is one of a fixed set. |
| **Test result** | A user’s saved result for one test (e.g. “Lion”). One per user per test. |
| **Collage** | A user’s set of test results shown as a table: test name → result (or “Not taken”). |
| **Friends** | Symmetric or one-way “friendship” so users can see each other’s collages. |

---

## 4. Data models

### 4.1 User (Devise + your fields)

- Devise: `email`, `password`, etc.
- Add: `username` (string, unique, required) – used for “add friend by username”.

### 4.2 Supported test (static / seed data)

- **name** (string) – e.g. “Animal in You”
- **slug** (string, unique) – e.g. `animal-in-you` (for routes/keys)
- **external_url** (string, optional) – link to take the test; can be blank for stubs
- **description** (text, optional)

Treat this as a fixed list: seed the DB with real + stub tests; “add test” is not a normal user action.

### 4.3 Test result

- **user_id** (FK → users)
- **supported_test_id** (FK → supported_tests) or **test_slug** (string) if you keep tests in a constant
- **result_value** (string) – e.g. “Lion”, “INTJ”
- **timestamps**

Unique on `[user_id, supported_test_id]` (or user + slug) so one result per user per test.

### 4.4 Friendship

- **user_id** (FK → users) – the user who “owns” this row
- **friend_id** (FK → users) – the friend
- **timestamps**

- Unique on `[user_id, friend_id]`.
- Either:
  - **Symmetric**: when A adds B, create both (A→B and B→A), or
  - **One-way**: only A→B; “friends” = “people I follow”; viewing rules stay the same (A can see B’s collage if A has B as friend).

Recommendation: **symmetric** so “add friend” is mutual (or you can do request/accept later).

---

## 5. Supported tests (seed + stubs)

Seed a table (or constant) of tests. Include one real one and several stubs:

| Name | Slug | External URL | Notes |
|------|------|--------------|--------|
| Animal in You | `animal-in-you` | (your link later) | Real test |
| Stub Test Alpha | `stub-test-alpha` | (blank) | Stub |
| Stub Test Beta | `stub-test-beta` | (blank) | Stub |
| Stub Test Gamma | `stub-test-gamma` | (blank) | Stub |
| Stub Test Delta | `stub-test-delta` | (blank) | Stub |
| Stub Test Epsilon | `stub-test-epsilon` | (blank) | Stub |

You can add more stubs; links can be filled in later in seeds or admin.

---

## 6. Routes and pages

### 6.1 Routes (summary)

```text
# Auth (Devise)
devise_for :users

# Logged-in scope
  root                          → home#index (or collages#show for “my collage”)
  get  '/my_collage'            → collages#show (current user)
  get  '/collages/:username'    → collages#show (friend’s collage by username)

  get  '/tests'                 → tests#index (list of supported tests)
  get  '/tests/:slug'           → tests#show (one test: take link + form to save result)
  post '/tests/:slug/results'   → test_results#create (save/update result)

  get  '/friends'               → friends#index (list + search)
  post '/friends'               → friends#create (add by username)
  delete '/friends/:id'         → friends#destroy (remove friend)
```

(Exact naming can be `friendships` if you prefer.)

### 6.2 Page behavior

| Page | Who | What they see |
|------|-----|----------------|
| **Home / My collage** | Logged-in user | Table: supported test name → my result (or “Not taken”). |
| **Tests index** | Logged-in | List of supported tests; each links to test page (take link + save result). |
| **Test show** | Logged-in | One test: button “Take the test” (external link if present), form to “Save my result”. |
| **Friends index** | Logged-in | Search by username, “Add friend”, list of my friends with links to their collage. |
| **Friend’s collage** | Logged-in | Same table as “my collage” but for that friend (test name → their result). |

Guests: redirect to login or show a landing page; Devise handles login/register.

---

## 7. Implementation order

1. **Rails app + UI foundation**
   - New app, DB, add Devise, add `username` to User (migration + validations).
   - Add Tailwind CSS, pick fonts (e.g. Google Fonts), create application layout with nav and flash area so every new page is already modern and on-brand.

2. **Supported tests**
   - Model (or table) `SupportedTest` with name, slug, external_url; seed real + stub tests.

3. **Test results**
   - Model `TestResult` (user, test, result_value), validations, uniqueness.

4. **My collage**
   - Route + controller that loads current user + all supported tests + user’s results; view = table.

5. **Tests index + test page**
   - List tests; test show page: external link (if any) + form to create/update result for that test.

6. **Friendships**
   - Model `Friendship` (user_id, friend_id), add/remove actions, “add by username” (search user by username).

7. **Friends index**
   - List friends, search box, link “Add friend”, links to `/collages/:username`.

8. **Friend’s collage**
   - Same table as my collage but for `User.find_by(username: params[:username])`; only allow if current user is friend with that user (or allow public collages; your choice).

9. **Nav / menu**
   - Logged-in: Home (my collage), Tests, Friends, Log out. Optional: “My profile” or username in header. Style per **§2 UI & design**.

10. **UI polish**
    - Apply design system everywhere: cards, tables, buttons, forms. Empty states, flash styling, hover/transition details. Quick responsive pass (collage table, friends list, nav on small screens).

---

## 8. Decisions to make

- **Collage visibility**: Only friends can see each other’s collages, or public (any logged-in user)?
- **Friends**: Symmetric (both see each other) vs follow (one-way)?
- **Stub tests**: Keep as DB seeds so you can add links later without code change, or constant in code (simpler, less flexible).

---

## 9. File sketch (high level)

```text
app/
  models/
    user.rb              # Devise + has_many :test_results, :friendships
    supported_test.rb    # seed data
    test_result.rb       # user + supported_test + result_value
    friendship.rb        # user_id, friend_id
  controllers/
    application_controller.rb
    collages_controller.rb   # show (my or friend’s)
    tests_controller.rb     # index, show
    test_results_controller.rb  # create (save result)
    friends_controller.rb    # index, create, destroy
  views/
    layouts/
      application.html.erb   # nav, flash, Tailwind, fonts
    collages/show.html.erb   # table of test → result (card, modern table)
    tests/index.html.erb     # grid of test cards
    tests/show.html.erb      # take test link + save result form
    friends/index.html.erb   # search + friends list (cards or list)
  assets/ or app/assets/
    stylesheets/             # Tailwind + optional custom variables
config/
  routes.rb
db/
  migrate/
  seeds.rb   # create SupportedTest records (real + stubs)
```

---

## 10. Next step

Once you’re happy with this plan, next step is: **scaffold the Rails app, install Devise, and add the User + SupportedTest models and seeds.** If you want, we can go through that step-by-step in the repo (e.g. run `rails new`, add Devise, then migrations and seeds).
