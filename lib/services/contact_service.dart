import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_portfolio/core/constants/app_links.dart';

class ContactSubmissionResult {
  final bool isSuccess;
  final String message;

  const ContactSubmissionResult({
    required this.isSuccess,
    required this.message,
  });
}

class ContactService {
  Future<ContactSubmissionResult> submitContactForm({
    required String name,
    required String email,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse(AppLinks.web3FormsEndpoint),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'access_key': AppLinks.web3FormsAccessKey,
        'subject': '[Portfolio Contact] Message from $name',
        'from_name': 'Purnendu Portfolio',
        'to': AppLinks.email.replaceFirst('mailto:', ''),
        'replyto': email,
        'source': 'Purnendu Samanta Portfolio',
        'name': name,
        'email': email,
        'message': message,
      }),
    );

    if (response.body.isEmpty) {
      return const ContactSubmissionResult(
        isSuccess: false,
        message: 'Submission failed. Please try again.',
      );
    }

    final data = jsonDecode(response.body);
    final success = data['success'] == true;
    final serverMessage = data['message']?.toString();

    if (success) {
      return ContactSubmissionResult(
        isSuccess: true,
        message: serverMessage ?? 'Message sent successfully.',
      );
    }

    return ContactSubmissionResult(
      isSuccess: false,
      message: serverMessage ?? 'Submission failed. Please try again.',
    );
  }
}
