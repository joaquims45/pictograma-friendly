# Pictogramas

App Android de comunicación aumentativa (pictogramas) para niños con TEA. 100% offline, sin analítica ni cuentas.

## Requisitos (Windows, instalado en D:\dev)
- Flutter estable, JDK 17, Android SDK (plataformas 35/36).
- Variables: `ANDROID_HOME=D:\dev\android-sdk`, `PUB_CACHE=D:\dev\pub-cache`, `GRADLE_USER_HOME=D:\dev\gradle`.
- Verificar con `flutter doctor`.

## Correr
```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Build del APK
```
flutter build apk --release
```
Salida: `build/app/outputs/flutter-apk/app-release.apk`. Instalar por USB: `adb install -r app-release.apk`, o copiar el archivo al celular y abrirlo (permitir "orígenes desconocidos").

## Pictogramas
Fuente: ARASAAC (CC BY-NC-SA). Ver pantalla "Acerca de" para la atribución.

## Fijado de pantalla (para que los chicos no salgan de la app)
1. Ajustes de Android → Seguridad → "Fijar pantalla" (o "Fijación de app") → activar.
2. Al abrir un tablero la app pide fijarse; confirmar.
3. Para salir: mantener presionado 3 segundos el candado gris de la esquina superior derecha.
