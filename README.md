# Soul Garden 🌱

Un jardín emocional para cultivar mindfulness.

## Características

- 🌺 Registra tus emociones diarias y cultiva plantas virtuales
- 🌿 Practica ejercicios de mindfulness y meditación
- 📊 Visualiza estadísticas de tu bienestar emocional
- 🌈 Observa cómo el clima del jardín refleja tu estado emocional
- 🏆 Desbloquea logros y personaliza tu jardín

## Estructura del Proyecto

lib/
├── config/           # Configuración de la app
│   ├── constants.dart
│   ├── routes.dart
│   └── theme.dart
├── models/           # Modelos de datos
│   ├── achievement.dart
│   ├── emotion_check.dart
│   ├── emotion_stats.dart
│   ├── emotion_type.dart
│   ├── exercise.dart
│   ├── plant.dart
│   ├── preferences.dart
│   ├── reward.dart
│   ├── subscription.dart
│   └── weather_state.dart
├── providers/        # Providers de Riverpod
│   ├── achievements_provider.dart
│   ├── check_in_provider.dart
│   ├── environment_provider.dart
│   ├── garden_provider.dart
│   ├── preferences_provider.dart
│   └── rewards_provider.dart
├── screens/          # Pantallas de la app
├── services/         # Servicios
│   └── notifications_service.dart
├── widgets/          # Widgets reutilizables
└── main.dart

## Tecnologías

- Flutter 3.0+
- Riverpod para gestión de estado
- Hive para almacenamiento local
- Material Design 3

## Instalación

1. Clona el repositorio:
git clone https://github.com/yourusername/soul-garden.git

2. Instala las dependencias:
flutter pub get

3. Genera los adaptadores de Hive:
flutter pub run build_runner build --delete-conflicting-outputs

4. Ejecuta la aplicación:
flutter run

## Contribuir

1. Haz fork del proyecto
2. Crea una rama para tu feature: git checkout -b feature/amazing-feature
3. Haz commit de tus cambios: git commit -m 'Add amazing feature'
4. Push a la rama: git push origin feature/amazing-feature
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.
