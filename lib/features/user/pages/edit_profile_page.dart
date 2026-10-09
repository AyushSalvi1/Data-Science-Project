import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/core/services/offline_cache_service.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/user/blocs/user_bloc/user_bloc.dart';
import 'package:flutter_ecommerce/features/user/model/user.dart';
import 'package:gap/gap.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _cacheService = sl<OfflineCacheService>();
  final _client = sl<SupabaseClient>();
  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _budgetController;

  bool _isSaving = false;
  bool _priceDropAlerts = true;
  final Set<String> _selectedRetailers = {'Amazon India', 'Flipkart', 'Croma', 'ShopWave'};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _usernameController = TextEditingController(text: widget.user.username);
    final prefs = _cacheService.getUserPreferences();
    final budgetNum = (prefs['budget'] as num?)?.toDouble() ?? 50000.0;
    _budgetController = TextEditingController(
      text: budgetNum.toStringAsFixed(0),
    );
    _priceDropAlerts = prefs['priceDropAlerts'] ?? true;
    if (prefs['preferredRetailers'] != null) {
      _selectedRetailers.clear();
      _selectedRetailers.addAll(List<String>.from(prefs['preferredRetailers']));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    final updatedName = _nameController.text.trim();
    final updatedUsername = _usernameController.text.trim();
    final budget = double.tryParse(_budgetController.text) ?? 50000.0;

    // 1. Save preferences locally
    await _cacheService.saveUserPreferences({
      'budget': budget,
      'preferredRetailers': _selectedRetailers.toList(),
      'priceDropAlerts': _priceDropAlerts,
    });

    // 2. Save profile in Supabase
    try {
      await _client.from('users').update({
        'name': updatedName,
        'username': updatedUsername,
      }).eq('id', widget.user.id);

      await _client.from('user_preferences').upsert({
        'user_id': widget.user.id,
        'budget_preference': budget,
        'preferred_retailers': _selectedRetailers.toList(),
        'price_drop_alerts_enabled': _priceDropAlerts,
      });

      // Refresh UserBloc
      sl<UserBloc>().add(const UserEvent.getCurrentUserData());
    } catch (_) {}

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile and preferences saved successfully!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile & Preferences", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("User Information", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const Gap(12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const Gap(12),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            const Gap(24),
            Text("AI Shopping Preferences", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const Gap(12),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Default Shopping Budget (₹)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
                helperText: "Used by the AI Assistant to personalize recommendations",
              ),
            ),
            const Gap(16),
            const Text("Preferred Retailers for Search & Comparison:", style: TextStyle(fontWeight: FontWeight.w500)),
            const Gap(8),
            Wrap(
              spacing: 8,
              children: ['Amazon India', 'Flipkart', 'Croma', 'ShopWave'].map((r) {
                final isSelected = _selectedRetailers.contains(r);
                return FilterChip(
                  label: Text(r),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedRetailers.add(r);
                      } else if (_selectedRetailers.length > 1) {
                        _selectedRetailers.remove(r);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const Gap(16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Price Drop Alerts"),
              subtitle: const Text("Receive notifications when saved products drop in price"),
              value: _priceDropAlerts,
              onChanged: (val) => setState(() => _priceDropAlerts = val),
            ),
            const Gap(28),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
