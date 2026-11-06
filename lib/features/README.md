# Features

One folder per feature, feature-first:

```
features/<feature>/
  data/          repositories, DTOs, mappers
  domain/        entities, use cases
  presentation/  screens, controllers (Riverpod), widgets
```

Rules:

- A feature may import `core/`, `config/` and `packages/`, never another
  feature's `data/` or `presentation/`. Cross-feature needs go through a
  domain interface in `core/` or a Riverpod provider.
- Every file ends in its role: `attack_repository.dart`, `attack_screen.dart`,
  `attack_controller.dart`, `attack_entity.dart`.
- Tests mirror the path under `test/`.
- Configurable values (names, colours, thresholds, endpoints, flags) come from
  `lib/config/app_config.dart`, never from literals in a feature.
