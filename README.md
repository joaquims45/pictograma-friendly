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

## Firmar el APK (release)
1. Crear la clave (una sola vez, guardarla y respaldarla; sin ella no se puede actualizar la app):
   ```
   keytool -genkey -v -keystore D:\dev\pictogramas-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pictogramas
   ```
2. Crear `android/key.properties` (no se versiona):
   ```
   storePassword=TU_CLAVE
   keyPassword=TU_CLAVE
   keyAlias=pictogramas
   storeFile=D:/dev/pictogramas-release.jks
   ```
3. `flutter build apk --release`. Sin `key.properties` firma con la clave de debug (sirve para instalar en tu celular).

## Emulador (sin celular)
Todo vive en D:. Crear/usar el AVD:
```
set ANDROID_AVD_HOME=D:\devvd
D:\devndroid-sdkmulatormulator.exe -avd medium_phone
flutter run -d emulator-5554
```

## Modo adulto (etapa 2)
Desde la pantalla "¿Quién usa la app?" tocar el candado → crear un PIN de 4 dígitos (la primera vez) o ingresarlo.
Por perfil se puede: cambiar el tamaño de grilla (1x1 a 4x4; con 1x1 se ve de a uno y se pasa deslizando hacia arriba), activar la barra de frases, ordenar (arrastrando), ocultar o quitar pictogramas, agregar existentes, crear pictogramas propios con foto y voz grabada, y crear/ordenar/ocultar categorías.
Si se olvida el PIN: borrar los datos de la app (Ajustes → Apps → Pictogramas → Almacenamiento) reinicia todo, incluidas las fotos y audios propios.

## Rutinas / agenda visual (etapa 3)
Modo adulto → perfil → Rutinas → Nueva. Se agregan pasos (cualquier pictograma, también los propios) y se ordenan arrastrando.
En el tablero del chico aparece el botón "Rutinas": muestra "Primero", "Después" y el botón "Listo". El progreso queda guardado; el adulto puede reiniciarlo con "Empezar de nuevo" (o "Reiniciar progreso" en el editor).

## Copia de seguridad y registro de uso (etapa 4)
Modo adulto → "Copia de seguridad": **Crear copia** guarda un `.zip` con todo (perfiles, tableros, pictogramas propios con fotos y voces, rutinas y registro de uso) donde elijas, por ejemplo en Descargas. **Restaurar copia** reemplaza todos los datos del teléfono por los de la copia (pide confirmación). Para pasar la app a otro teléfono: instalar el APK, crear la copia en el viejo, copiar el `.zip` al nuevo y restaurarlo. El PIN no se copia: se crea uno nuevo.

Modo adulto → "Registro de uso": opcional y apagado por defecto. Anota qué pictograma se toca y cuándo, solo en el teléfono. Muestra un resumen de los últimos 7 días, se exporta a CSV (para planilla) y se puede borrar.

## Detalles de uso para los chicos
- El botón "Atrás" de Android no sale del tablero: se sale manteniendo 3 segundos el candado de la esquina.
- En la barra de frases, "Borrar" quita el último pictograma; mantenido presionado, vacía toda la frase.
- En celulares la pantalla queda siempre vertical.
