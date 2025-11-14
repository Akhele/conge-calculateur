import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';

class AppAboutDialog extends StatelessWidget {
  const AppAboutDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const AppAboutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        l10n.aboutAppTitle,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // App Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/app_icon.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to a default icon if asset not found
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      size: 40,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Message
          Text(
            l10n.aboutAppMessage,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Contact Information
          _buildClickableEmail(context, l10n),
        ],
      ),
      actions: [
        Center(
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.understood),
          ),
        ),
      ],
    );
  }

  Widget _buildClickableEmail(BuildContext context, AppLocalizations l10n) {
    final email = 'contact@akhele.com';
    final contactText = l10n.aboutAppContact;
    final emailIndex = contactText.indexOf(email);
    
    if (emailIndex == -1) {
      // Fallback if email not found in text
      return Text(
        contactText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
        textAlign: TextAlign.center,
      );
    }

    final beforeEmail = contactText.substring(0, emailIndex);
    final afterEmail = contactText.substring(emailIndex + email.length);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
        children: [
          TextSpan(text: beforeEmail),
          TextSpan(
            text: email,
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Theme.of(context).colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final uri = Uri.parse('mailto:$email');
                try {
                  // Try to launch directly - Android will show app chooser if multiple apps available
                  final launched = await launchUrl(
                    uri,
                    mode: LaunchMode.platformDefault,
                  );
                  if (!launched && context.mounted) {
                    throw 'Could not launch $uri';
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not open email client. Please make sure you have an email app installed.'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
          ),
          TextSpan(text: afterEmail),
        ],
      ),
    );
  }
}

