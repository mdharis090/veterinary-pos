# veterinary_pos

A new Flutter project.

## UI feature structure

Clinic screens are grouped into separate feature folders under
`lib/src/features/`:

- `auth/presentation/` — sign-in
- `billing/presentation/` — point-of-sale billing
- `consultations/presentation/` — consultations
- `inventory/presentation/` — inventory
- `owners/presentation/` and `patients/presentation/` — owner and animal lists
- `prescriptions/presentation/`, `medicines/presentation/`,
  `batches/presentation/`
- `suppliers/presentation/`, `sales/presentation/`
- `returns/presentation/`, `payments/presentation/`, `reports/presentation/`
- `purchases/presentation/`, `settings/presentation/`
- `shared/presentation/` — reusable page layout, form, table, chart, and
  dashboard widgets

Each feature screen is a standalone Dart library and imports reusable
components from `shared/presentation/clinic_ui.dart`. The dashboard shell owns
the screen navigation and responsive desktop/mobile layouts. Dashboard-only
components live in `dashboard/widgets/`, while the patient list and profile
live in `patients/presentation/`.

The same feature screens adapt to narrow mobile layouts and wide desktop
layouts. Shared components include page frames, panels, forms, buttons, tables,
summary cards, tabs, and charts.

## Node.js API

The Flutter client uses a shared HTTP client under `lib/src/core/network/` and
keeps an API class for each backend route under the matching feature's
`data/` directory. Requests use the Node API's `/api` paths, JSON envelopes,
and bearer-token authentication. The login screen stores JWTs using secure
platform storage; sign-out clears the token. Backend-backed list screens show
loading, server errors, and a retry action instead of silently substituting
sample data.

The supplied Node snippet mounts `/api/purchases` but does not include its
`routes/purchases` implementation. The Flutter purchase screens use
`GET /api/purchases` with a `{ "data": [...] }` response and
`POST /api/purchases` with a `{ "data": {...} }` response. The create request
contains the purchase header columns and an `items` array containing the
`Purchase_Items` columns. The backend must create the purchase, its line items,
associated medicine batches, and stock updates in one database transaction;
the Flutter client does not update stock itself. Implement or verify this
route on the Node.js server before using purchase creation with live data.

The default API address is `http://172.17.2.49:5000/api`, matching the
development machine's LAN address and the Node server's default port. Override
it at build/run time if the machine's address or server port changes:

```powershell
flutter run --dart-define=API_BASE_URL=https://your-api-host/api
```

Ensure the Node server is running and reachable through the machine's firewall.
For production, configure HTTPS. The Android debug manifest permits local HTTP
during development; release builds should use HTTPS.

## Navigation

Named routes are declared under `lib/src/core/routes/`. `app_route_path.dart`
contains the route paths, `app_routes_named.dart` exposes their named-route
constants and dashboard-section mapping, and `app_routes.dart` registers the
screen builders with `MaterialApp`. The dashboard continues to host its
responsive navigation shell while using the shared screen registry for its
feature pages. Feature screens can also be opened directly with
`Navigator.pushNamed`.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
