import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notifications_service.dart';
import '../providers/subscription_provider.dart';
import '../providers/preferences_provider.dart';
import '../screens/achievements_screen.dart';
import '../models/preferences.dart';
import 'subscription_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider);
    final preferences = ref.watch(preferencesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            title: 'Apariencia',
            children: [
              ListTile(
                title: const Text('Tema'),
                trailing: DropdownButton<ThemeMode>(
                  value: preferences.theme,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('Sistema'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Claro'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Oscuro'),
                    ),
                  ],
                  onChanged: (mode) {
                    if (mode != null) {
                      ref.read(preferencesProvider.notifier).setThemeMode(mode);
                    }
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Notificaciones',
            children: [
              SwitchListTile(
                title: const Text('Recordatorios diarios'),
                subtitle: const Text('Recibe notificaciones para hacer check-in'),
                value: preferences.dailyReminders,
                onChanged: (value) {
                  ref.read(preferencesProvider.notifier).updatePreferences(
                    preferences.copyWith(dailyReminders: value),
                  );
                },
              ),
              ListTile(
                title: const Text('Hora del recordatorio'),
                trailing: TextButton(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: preferences.reminderTime,
                    );
                    if (time != null) {
                      ref.read(preferencesProvider.notifier).updatePreferences(
                        preferences.copyWith(reminderTime: time),
                      );
                    }
                  },
                  child: Text(
                    '${preferences.reminderTime.hour}:${preferences.reminderTime.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Cuenta',
            children: [
              ListTile(
                title: const Text('Suscripción'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                  );
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Logros'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AchievementsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Acerca de'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Bloom Mind',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2024 Bloom Mind',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ...children,
      ],
    );
  }
} 