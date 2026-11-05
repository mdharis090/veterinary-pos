import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../shared/presentation/clinic_ui.dart';

abstract interface class SettingsStore {
  Future<Map<String, dynamic>?> read();
  Future<void> write(Map<String, dynamic> settings);
}

class EncryptedSettingsStore implements SettingsStore {
  EncryptedSettingsStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static final instance = EncryptedSettingsStore();
  static const _key = 'app_settings_v1';
  final FlutterSecureStorage _storage;

  @override
  Future<Map<String, dynamic>?> read() async {
    try {
      final value = await _storage.read(key: _key);
      if (value == null) return null;
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) return decoded;
      throw const SettingsStoreException('Saved settings are invalid.');
    } on PlatformException catch (error) {
      throw SettingsStoreException(
        'Could not load settings: ${error.message ?? error.code}',
      );
    } on FormatException {
      throw const SettingsStoreException('Saved settings are invalid.');
    }
  }

  @override
  Future<void> write(Map<String, dynamic> settings) async {
    try {
      await _storage.write(key: _key, value: jsonEncode(settings));
    } on PlatformException catch (error) {
      throw SettingsStoreException(
        'Could not save settings: ${error.message ?? error.code}',
      );
    }
  }
}

class SettingsStoreException implements Exception {
  const SettingsStoreException(this.message);

  final String message;

  @override
  String toString() => message;
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({this.store, super.key});

  final SettingsStore? store;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _sections = [
    'Profile',
    'Users',
    'Roles',
    'Clinic info',
    'Notifications',
    'Backup',
  ];
  static const _profileDefaults = <String, String>{
    'name': '',
    'username': '',
    'email': '',
    'phone': '',
  };
  static const _clinicDefaults = <String, String>{
    'name': '',
    'address': '',
    'phone': '',
    'email': '',
  };
  static const _notificationDefaults = <String, bool>{
    'appointment_reminders': true,
    'low_stock_alerts': true,
    'daily_reports': false,
  };
  static const _defaultRoles = [
    'Administrator',
    'Veterinarian',
    'Receptionist',
  ];

  final _profileFormKey = GlobalKey<FormState>();
  final _clinicFormKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _profileControllers;
  late final Map<String, TextEditingController> _clinicControllers;
  String _selected = 'Profile';
  Map<String, String> _profile = Map.of(_profileDefaults);
  Map<String, String> _clinic = Map.of(_clinicDefaults);
  Map<String, bool> _notifications = Map.of(_notificationDefaults);
  List<String> _roles = List.of(_defaultRoles);
  List<_LocalUser> _users = [];
  bool _loading = true;
  String? _loadError;

  SettingsStore get _store => widget.store ?? EncryptedSettingsStore.instance;

  @override
  void initState() {
    super.initState();
    _profileControllers = _makeControllers(_profileDefaults);
    _clinicControllers = _makeControllers(_clinicDefaults);
    _loadSettings();
  }

  @override
  void dispose() {
    for (final controller in [
      ..._profileControllers.values,
      ..._clinicControllers.values,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Map<String, TextEditingController> _makeControllers(
    Map<String, String> values,
  ) => values.map(
    (key, value) => MapEntry(key, TextEditingController(text: value)),
  );

  Future<void> _loadSettings() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final stored = await _store.read();
      if (stored != null) _applySnapshot(stored);
      if (!mounted) return;
      setState(() => _loading = false);
    } on SettingsStoreException catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error.message;
        _loading = false;
      });
    }
  }

  void _applySnapshot(Map<String, dynamic> snapshot) {
    final profile = _readStringMap(snapshot['profile'], _profileDefaults);
    final clinic = _readStringMap(snapshot['clinic'], _clinicDefaults);
    final notifications = _readBoolMap(
      snapshot['notifications'],
      _notificationDefaults,
    );
    final rolesValue = snapshot['roles'];
    final usersValue = snapshot['users'];
    if (rolesValue != null &&
        (rolesValue is! List || rolesValue.any((role) => role is! String))) {
      throw const SettingsStoreException('Saved roles are invalid.');
    }
    if (usersValue != null &&
        (usersValue is! List ||
            usersValue.any((user) => user is! Map<String, dynamic>))) {
      throw const SettingsStoreException('Saved users are invalid.');
    }
    final roles = rolesValue == null
        ? List<String>.of(_defaultRoles)
        : List<String>.from(rolesValue as List);
    final users = usersValue == null
        ? <_LocalUser>[]
        : (usersValue as List)
              .map((user) => _LocalUser.fromJson(user as Map<String, dynamic>))
              .toList();
    _profile = profile;
    _clinic = clinic;
    _notifications = notifications;
    _roles = roles;
    _users = users;
    _setControllerValues(_profileControllers, profile);
    _setControllerValues(_clinicControllers, clinic);
  }

  Map<String, String> _readStringMap(
    Object? value,
    Map<String, String> defaults,
  ) {
    if (value == null) return Map.of(defaults);
    if (value is! Map<String, dynamic>) {
      throw const SettingsStoreException('Saved text settings are invalid.');
    }
    return {
      for (final key in defaults.keys)
        key: value[key] is String ? value[key] as String : defaults[key]!,
    };
  }

  Map<String, bool> _readBoolMap(Object? value, Map<String, bool> defaults) {
    if (value == null) return Map.of(defaults);
    if (value is! Map<String, dynamic>) {
      throw const SettingsStoreException(
        'Saved notification settings are invalid.',
      );
    }
    return {
      for (final key in defaults.keys)
        key: value[key] is bool ? value[key] as bool : defaults[key]!,
    };
  }

  void _setControllerValues(
    Map<String, TextEditingController> controllers,
    Map<String, String> values,
  ) {
    for (final entry in controllers.entries) {
      entry.value.text = values[entry.key] ?? '';
    }
  }

  Map<String, dynamic> _snapshot() => {
    'profile': _profile,
    'clinic': _clinic,
    'notifications': _notifications,
    'roles': _roles,
    'users': _users.map((user) => user.toJson()).toList(),
  };

  Future<bool> _persist() async {
    try {
      await _store.write(_snapshot());
      return true;
    } on SettingsStoreException catch (error) {
      if (mounted) showClinicNotice(context, error.message);
      return false;
    }
  }

  String? _required(String? value, String field) =>
      value == null || value.trim().isEmpty ? '$field is required.' : null;

  Future<void> _saveProfile() async {
    if (!_profileFormKey.currentState!.validate()) return;
    _profile = {
      for (final entry in _profileControllers.entries)
        entry.key: entry.value.text.trim(),
    };
    if (await _persist() && mounted) {
      showClinicNotice(context, 'Profile saved on this device.');
    }
  }

  Future<void> _saveClinic() async {
    if (!_clinicFormKey.currentState!.validate()) return;
    _clinic = {
      for (final entry in _clinicControllers.entries)
        entry.key: entry.value.text.trim(),
    };
    if (await _persist() && mounted) {
      showClinicNotice(context, 'Clinic information saved on this device.');
    }
  }

  Future<void> _setNotification(String key, bool value) async {
    setState(() => _notifications[key] = value);
    if (await _persist() && mounted) {
      showClinicNotice(context, 'Notification preferences saved.');
    }
  }

  Future<void> _addUser() async {
    final user = await showDialog<_LocalUser>(
      context: context,
      builder: (context) => _UserDialog(roles: _roles),
    );
    if (user == null || !mounted) return;
    setState(() => _users = [..._users, user]);
    if (await _persist() && mounted) {
      showClinicNotice(context, 'Local user added.');
    }
  }

  Future<void> _removeUser(_LocalUser user) async {
    setState(() => _users = _users.where((item) => item != user).toList());
    await _persist();
  }

  Future<void> _editRole({String? role}) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _RoleDialog(initialValue: role),
    );
    if (result == null || !mounted) return;
    if (_roles.any(
      (existing) =>
          existing.toLowerCase() == result.toLowerCase() && existing != role,
    )) {
      showClinicNotice(context, 'That role already exists.');
      return;
    }
    setState(() {
      if (role == null) {
        _roles = [..._roles, result];
      } else {
        _roles = _roles.map((item) => item == role ? result : item).toList();
        _users = _users
            .map(
              (user) => user.role == role
                  ? _LocalUser(name: user.name, role: result)
                  : user,
            )
            .toList();
      }
    });
    if (await _persist() && mounted) {
      showClinicNotice(context, 'Roles saved on this device.');
    }
  }

  Future<void> _removeRole(String role) async {
    if (_roles.length == 1) {
      showClinicNotice(context, 'At least one role must remain.');
      return;
    }
    if (_users.any((user) => user.role == role)) {
      showClinicNotice(
        context,
        'Remove or reassign users with this role first.',
      );
      return;
    }
    setState(() => _roles = _roles.where((item) => item != role).toList());
    await _persist();
  }

  Future<void> _copyBackup() async {
    await Clipboard.setData(ClipboardData(text: jsonEncode(_snapshot())));
    if (mounted)
      showClinicNotice(context, 'Settings backup copied to clipboard.');
  }

  Future<void> _restoreBackup() async {
    final json = await showDialog<String>(
      context: context,
      builder: (context) => const _RestoreDialog(),
    );
    if (json == null || !mounted) return;
    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected a settings object.');
      }
      _applySnapshot(decoded);
      setState(() {});
      if (await _persist() && mounted) {
        showClinicNotice(context, 'Settings backup restored.');
      }
    } on FormatException {
      showClinicNotice(context, 'Backup is not valid JSON settings data.');
    } on SettingsStoreException catch (error) {
      showClinicNotice(context, error.message);
    }
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_loadError != null) {
      return ClinicPanel(
        title: 'Settings could not be loaded',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_loadError!),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _loadSettings,
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final menu = ClinicPanel(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              for (final section in _sections)
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  child: ListTile(
                    selected: section == _selected,
                    selectedTileColor: const Color(0xFFCCFBF1),
                    selectedColor: clinicTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text(section),
                    onTap: () => setState(() => _selected = section),
                  ),
                ),
            ],
          ),
        );
        final content = _buildSection();
        if (constraints.maxWidth < 780) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [menu, const SizedBox(height: 16), content],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 220, child: menu),
            const SizedBox(width: 16),
            Expanded(child: content),
          ],
        );
      },
    );
  }

  Widget _buildSection() => switch (_selected) {
    'Profile' => _profileSection(),
    'Users' => _usersSection(),
    'Roles' => _rolesSection(),
    'Clinic info' => _clinicSection(),
    'Notifications' => _notificationsSection(),
    'Backup' => _backupSection(),
    _ => const SizedBox.shrink(),
  };

  Widget _profileSection() => ClinicPanel(
    title: 'Profile',
    child: Form(
      key: _profileFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _textField(
            'Full name',
            'Your name',
            _profileControllers['name']!,
            validator: (value) => _required(value, 'Full name'),
          ),
          const SizedBox(height: 14),
          _textField(
            'Username',
            'Username',
            _profileControllers['username']!,
            validator: (value) => _required(value, 'Username'),
          ),
          const SizedBox(height: 14),
          _textField(
            'Email',
            'name@example.com',
            _profileControllers['email']!,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          _textField(
            'Phone',
            '+92 300 1234567',
            _profileControllers['phone']!,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: ClinicPrimaryButton(
              label: 'Save changes',
              onPressed: _saveProfile,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _clinicSection() => ClinicPanel(
    title: 'Clinic info',
    child: Form(
      key: _clinicFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _textField(
            'Clinic name',
            'Clinic name',
            _clinicControllers['name']!,
            validator: (value) => _required(value, 'Clinic name'),
          ),
          const SizedBox(height: 14),
          _textField(
            'Address',
            'Clinic address',
            _clinicControllers['address']!,
            validator: (value) => _required(value, 'Address'),
            maxLines: 2,
          ),
          const SizedBox(height: 14),
          _textField(
            'Phone',
            '+92 300 1234567',
            _clinicControllers['phone']!,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          _textField(
            'Email',
            'clinic@example.com',
            _clinicControllers['email']!,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: ClinicPrimaryButton(
              label: 'Save clinic info',
              onPressed: _saveClinic,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _textField(
    String label,
    String hint,
    TextEditingController controller, {
    FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(hintText: hint),
      ),
    ],
  );

  Widget _usersSection() => ClinicPanel(
    title: 'Users',
    trailing: IconButton(
      tooltip: 'Add user',
      onPressed: _addUser,
      icon: const Icon(Icons.person_add_alt_1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'These user entries are stored on this device only. They do not create server accounts.',
          style: TextStyle(color: clinicMuted),
        ),
        const SizedBox(height: 12),
        if (_users.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('No local users added yet.'),
          )
        else
          for (final user in _users)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.person_outline)),
              title: Text(user.name),
              subtitle: Text(user.role),
              trailing: IconButton(
                tooltip: 'Remove ${user.name}',
                onPressed: () => _removeUser(user),
                icon: const Icon(Icons.delete_outline),
              ),
            ),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: _addUser,
            icon: const Icon(Icons.add),
            label: const Text('Add user'),
          ),
        ),
      ],
    ),
  );

  Widget _rolesSection() => ClinicPanel(
    title: 'Roles',
    trailing: IconButton(
      tooltip: 'Add role',
      onPressed: () => _editRole(),
      icon: const Icon(Icons.add),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Manage role labels for local user entries. These roles do not change server permissions.',
          style: TextStyle(color: clinicMuted),
        ),
        const SizedBox(height: 12),
        for (final role in _roles)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.admin_panel_settings_outlined),
            title: Text(role),
            trailing: Wrap(
              children: [
                IconButton(
                  tooltip: 'Edit $role',
                  onPressed: () => _editRole(role: role),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Remove $role',
                  onPressed: () => _removeRole(role),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () => _editRole(),
            icon: const Icon(Icons.add),
            label: const Text('Add role'),
          ),
        ),
      ],
    ),
  );

  Widget _notificationsSection() => ClinicPanel(
    title: 'Notifications',
    child: Column(
      children: [
        _notificationTile(
          'Appointment reminders',
          'Remind staff about upcoming appointments.',
          'appointment_reminders',
        ),
        const Divider(height: 1),
        _notificationTile(
          'Low stock alerts',
          'Alert when medicine stock is running low.',
          'low_stock_alerts',
        ),
        const Divider(height: 1),
        _notificationTile(
          'Daily reports',
          'Receive a daily clinic activity summary.',
          'daily_reports',
        ),
      ],
    ),
  );

  Widget _notificationTile(String title, String subtitle, String key) =>
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title),
        subtitle: Text(subtitle),
        value: _notifications[key]!,
        onChanged: (value) => _setNotification(key, value),
      );

  Widget _backupSection() => ClinicPanel(
    title: 'Backup and restore',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Create a JSON backup of your profile, clinic information, notification preferences, and local users and roles. This does not include clinic records stored on the server.',
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: ClinicPrimaryButton(
            label: 'Copy settings backup',
            icon: Icons.copy_outlined,
            onPressed: _copyBackup,
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: _restoreBackup,
            icon: const Icon(Icons.restore),
            label: const Text('Restore from JSON'),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Settings',
    subtitle: 'Manage preferences saved on this device.',
    child: _buildBody(),
  );
}

class _LocalUser {
  const _LocalUser({required this.name, required this.role});

  final String name;
  final String role;

  Map<String, dynamic> toJson() => {'name': name, 'role': role};

  factory _LocalUser.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final role = json['role'];
    if (name is! String || role is! String) {
      throw const SettingsStoreException('A saved user entry is invalid.');
    }
    return _LocalUser(name: name, role: role);
  }

  @override
  bool operator ==(Object other) =>
      other is _LocalUser && other.name == name && other.role == role;

  @override
  int get hashCode => Object.hash(name, role);
}

class _UserDialog extends StatefulWidget {
  const _UserDialog({required this.roles});

  final List<String> roles;

  @override
  State<_UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<_UserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late String _role = widget.roles.first;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Add local user'),
    content: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Name is required.'
                : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _role,
            decoration: const InputDecoration(labelText: 'Role'),
            items: [
              for (final role in widget.roles)
                DropdownMenuItem(value: role, child: Text(role)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _role = value);
            },
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
          Navigator.pop(
            context,
            _LocalUser(name: _nameController.text.trim(), role: _role),
          );
        },
        child: const Text('Add'),
      ),
    ],
  );
}

class _RoleDialog extends StatefulWidget {
  const _RoleDialog({this.initialValue});

  final String? initialValue;

  @override
  State<_RoleDialog> createState() => _RoleDialogState();
}

class _RoleDialogState extends State<_RoleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.initialValue == null ? 'Add role' : 'Edit role'),
    content: Form(
      key: _formKey,
      child: TextFormField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Role name'),
        validator: (value) => value == null || value.trim().isEmpty
            ? 'Role name is required.'
            : null,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
          Navigator.pop(context, _controller.text.trim());
        },
        child: const Text('Save'),
      ),
    ],
  );
}

class _RestoreDialog extends StatefulWidget {
  const _RestoreDialog();

  @override
  State<_RestoreDialog> createState() => _RestoreDialogState();
}

class _RestoreDialogState extends State<_RestoreDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Restore settings backup'),
    content: SizedBox(
      width: 480,
      child: TextField(
        controller: _controller,
        minLines: 4,
        maxLines: 8,
        decoration: const InputDecoration(
          hintText: 'Paste the settings JSON backup here',
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, _controller.text),
        child: const Text('Restore'),
      ),
    ],
  );
}
