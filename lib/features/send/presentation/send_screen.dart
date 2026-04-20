import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../recipient_lookup_provider.dart';

class SendScreen extends ConsumerStatefulWidget {
  const SendScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends ConsumerState<SendScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lookupState = ref.watch(recipientLookupProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter a recipient code',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Type the 6-character code you want to send files to.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.characters,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                onChanged: ref
                    .read(recipientLookupProvider.notifier)
                    .onInputChanged,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Recipient short code',
                  hintText: 'A4X9K2',
                  errorText: lookupState.errorMessage,
                  suffixIcon: lookupState.isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: lookupState.isLoading ? null : _submit,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final isValid = await ref
        .read(recipientLookupProvider.notifier)
        .validateRecipientCode();
    final resolvedCode = ref
        .read(recipientLookupProvider)
        .resolvedRecipientCode;

    if (!mounted || !isValid || resolvedCode == null) {
      return;
    }

    context.go(AppRoutes.fileSelectorPath(resolvedCode));
  }
}
