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

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
