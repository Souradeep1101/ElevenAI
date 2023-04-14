import 'dart:convert';
import 'dart:io';
import 'package:eleven_ai/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Api {
  Future<Map<String, dynamic>?> generateText({
    required List? messages,
    required BuildContext context,
    required String? apiKey,
  }) async {
    const url = 'https://api.openai.com/v1/chat/completions';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${apiKey!}',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': messages,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        Map<String, dynamic>? generatedText =
            jsonResponse['choices'][0]['message'];
        return generatedText;
      } else if (response.statusCode == 429) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: 'Too many requests. Please wait and try again later.',
            margin: const EdgeInsets.only(bottom: 200),
          ),
        );
        return null;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message:
                'Failed to generate response. Status code: ${response.statusCode}',
            margin: const EdgeInsets.only(bottom: 200),
          ),
        );
        return null;
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message:
              'Failed to connect to server. Please check your internet connection and try again.',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
      return null;
    } on FormatException {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Invalid response format. Please try again later.',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'An error occurred. Please try again later. $e',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
      return null;
    }
  }

  Future<Map<String?, Response?>?> generateImage({
    required String message,
    required BuildContext context,
    required String? apiKey,
  }) async {
    const url = 'https://api.openai.com/v1/images/generations';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'prompt': message,
          'num_images': 1,
          'size': '512x512',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        String? generatedImage = jsonResponse['data'][0]['url'];
        Response? imageResponse = await http.get(Uri.parse(generatedImage!));
        return {generatedImage: imageResponse};
      } else if (response.statusCode == 429) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: 'Too many requests. Please wait and try again later.',
            margin: const EdgeInsets.only(bottom: 200),
          ),
        );
        return null;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message:
                'Failed to generate response. Status code: ${response.statusCode}',
            margin: const EdgeInsets.only(bottom: 200),
          ),
        );
        return null;
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message:
              'Failed to connect to server. Please check your internet connection and try again.',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
      return null;
    } on FormatException {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Invalid response format. Please try again later.',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'An error occurred. Please try again later. $e',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
      return null;
    }
  }
}
