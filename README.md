# Smart Pharmacy

A Flutter e-commerce app for ordering medicine from a pharmacy — browse and search
the catalog, add to cart, check out with cash or card (Stripe), upload a
prescription when a medicine requires one, track orders and prescription
approval status, and get notified as an order moves through its lifecycle.

The backend is a separate ASP.NET Core (.NET 9) Web API — see
[`smartpharmacy-rand.runasp.net`](https://smartpharmacy-rand.runasp.net).

## Features

- **Auth** — register, log in, forgot/reset password
- **Catalog** — category filters, search, product details with a Hero
  image transition from the list
- **Cart** — add/update/remove items
- **Checkout** — cash on delivery or card (Stripe Checkout via an in-app
  WebView); orders needing a prescription are held until it's uploaded
  and approved
- **Orders** — history, live status timeline, pay/cancel, upload or check
  prescription status
- **Profile** — view/edit info and address, avatar upload
- **Notifications** — order and prescription updates, grouped by date,
  unread badge on Home and Profile
- Custom splash screen, app icon, and a shimmer skeleton loading state on
  every list screen

## Tech stack

- **State management**: `flutter_bloc` (Cubit)
- **DI**: `get_it`
- **Networking**: `dio`
- **Error handling**: `dartz`'s `Either<Failure, T>`
- **Local storage**: `flutter_secure_storage` (tokens), `shared_preferences`
- **UI**: `flutter_svg`, `shimmer`, `flutter_staggered_grid_view`,
  `carousel_slider`, `smooth_page_indicator`
- **Payments**: `webview_flutter` (Stripe Checkout)
- Media: `image_picker` (avatar/prescription uploads)

## Architecture

Feature-first: each feature under `lib/feature/<name>/` is split into

```
data/         # models, repo implementations (talks to ApiService)
domain/       # repo interfaces the presentation layer depends on
presentation/
  manger/     # Cubit + state
  views/      # screens
  widgets/    # screen-specific widgets
```

Cross-feature code (API client, DI setup, routing, theme, shared widgets)
lives under `lib/core/`.

## Getting started

```bash
flutter pub get
flutter run
```

The API base URL is set in `lib/core/service/api_constant.dart`.
