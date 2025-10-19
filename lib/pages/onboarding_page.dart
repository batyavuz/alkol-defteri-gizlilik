import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../widgets/glass_container.dart';
import '../widgets/gradient_background.dart';

/// Entry screen introducing the product and handling authentication.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loginWithUsername() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await context.read<AuthService>().loginWithUsername(_controller.text.trim());
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _loading = true);
    await context.read<AuthService>().loginWithGoogle();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: GlassContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'MindMirror',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Duygularınızı zarif bir arayüzle keşfedin. Gündelik ritüelinizi premium bir deneyime dönüştürün.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'Kullanıcı adı',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Lütfen bir kullanıcı adı girin';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _loading ? null : _loginWithUsername,
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('MindMirror\'a Başla'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _loading ? null : _loginWithGoogle,
                          icon: const Icon(Icons.auto_awesome_rounded),
                          label: const Text('Google ile (Mock)'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
