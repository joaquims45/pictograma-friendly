# Decisiones por defecto

- Navegación con `Navigator` simple (sin go_router).
- PIN de 4 dígitos (etapa 2), guardado como hash+salt en flutter_secure_storage.
- Perfiles iniciales creados al primer arranque: "Mellizas" y "Sobrino".
- Voz: es-AR; si no está, es-US, luego es-ES.
- `minSdk 26`. Solo plataforma Android.
- Sin permiso INTERNET en release (el manifest principal no lo declara).
- Posición de pictogramas explícita en `board_items.position`; nunca se reordena sola.
- Riverpod 3.x, drift 2.x (versiones exactas en `pubspec.lock`).
- Archivos generados de drift (`*.g.dart`) se versionan para poder compilar sin build_runner.
- Toolchain instalado en `D:\dev` (flutter, android-sdk, pub-cache, gradle) por falta de espacio en C:.
