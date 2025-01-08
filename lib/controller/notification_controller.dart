// import 'dart:convert';
// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:googleapis_auth/auth_io.dart';

// class NotificationController extends GetxController {
//   final supabase = Supabase.instance.client;

//   final String _projectId = "swim-strive";
//   final String _fcmEndpoint =
//       "https://fcm.googleapis.com/v1/projects/swim-strive/messages:send";

//   final Map<String, dynamic> _serviceAccountJson = {
//   "type": "service_account",
//   "project_id": "swim-strive",
//   "private_key_id": "e66a8a48322e41860abb7d8a3888d0f4979ceb3d",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDEjDJ2pNeazIoB\nMNnRWgVkXWrgAdkn9P5Txuvy+nhFnDLz1g1SzKUNzqpPT1gUTBJXy8+hXTmSypcm\ncejS38h2k6jzolHehgPO74592EvpvjjIqnQ0ykqdCwKHfmvFmk6jBNK0oXurlHZK\nZG179a461+Z3AvWmUg9vjoWNtigUb2wgucMUKUPa5I/qhgrGK5y4QD7Misx/GsSC\npAAJ+WRkRpUyxhfnh4flx4SHFJh2rpH9SMVEqhQgPSKgHgYIRYPnMgLQcBZQXpEZ\nrzL68901j0T5uSsGVFHBE9cvjpgNBgNd+fqjsCEqmVJPnbd3kcENPCeiKOp8bKEq\ncCIEAkrvAgMBAAECggEAAOlwfdSI9KdKZGXMyj0/2NJNdyJ7D36sxA+D7J1GwwRc\nHUS3Wo19EBq5ohw7Lv5BzYd5X745tDYIE2GHzNThg9LgVRF6/949aiwWr8MdaijR\nKLy7DBE1TxP91PT8QD1HT8lO/2T8LfSqGPFCcsbWE+7Pt7++0lmqHTlwcKEKOKy1\nWD6MXQCHAu8XjWL1OznrYJDp7d5OexdHm2+detNK7b7wjkCPVoglJdr25gnE99MF\nfghbgSShm7IQw/U1wmqzmKKU5osQllWu3OwtrAfiezsMgOo7mNYKwWZs5XINUwMu\nKDWOhJac/bHNqCJyekuQY3jdr6Vp7vcx+J8bRx5I7QKBgQD9LxVYyPFZH/cI8DKG\n+WdijmE5LySL6hGIm+jY4exNZNYmgpf+AMQa3mJ0212/0m9KHvItYncYyR5oYa72\ntdYxG4eHgzEg7oBxnYDRL1dIAz4CxM/ZINgfx8WF8zGsmC7Gfj7pK84xcKTPDNEI\nmywsqp+HPFYJkJt/bqTtKMNx2wKBgQDGu9jyUfPZCPSCIZvSyclJDNwIRv6V2IwJ\nk6iPg9QLUX/9DOJvy/m4hgOOJfuxpVTzoLi+MSJ+FQVciKPHjksD1iJWDqStktjz\nnVtMzecV0w7T8Qdi3VKg7SHpgPqO+X21Ocelh5UEqAa9aGmow2I+hcJtiwT0Vz6X\nhvdOfKkJfQKBgQD77qcCMumdsuYBWeodTv1mH6F04okuRFrwIZwAfEbD+Gvz5A1U\nLfT1e4ZjG4nc/4vIKKT5LjquSipc2Z7dVbFuKiOhX5U6XLko1P5CqSXjvX4uCSN9\nvmXwsbvF/2nVgZVB5Iu7P+CsZ5dHhExYkPfS9nFJg2tllyR0GGg6qU5Z8wKBgAHg\nhlULlx0Gq6CLBri/9Sm+eFmPqhnqOLBid6YbXaZZt7bBJ2Zc69flVCVEkJMF975x\nVy1cs3GzayCLndhlrKm1nQ9pBf8psujiJJmeHD+lha9UyHgTlRM2Cir1b+hnzNso\nV41lsW+g0qd5U/4nEkd65fI47OwN4uZ1fOJ95O7VAoGAatyGCPwlOnIpBrtyQqM2\nu0o79cLCX72SmEsuuaV0Ifhcq+5B4UlYzpr3BtfmfciMAhTQqLzQIoFlv9/oURLm\ntmSX+LBeS9oFVHei811ggCAQEc6J/FaC2RJsAVtSVxZzdRoHVHeGQ+zaXj12Wmw7\n7fipM/+xmW/6xGcOTImRfd4=\n-----END PRIVATE KEY-----\n",
//   "client_email": "firebase-adminsdk-ut5z3@swim-strive.iam.gserviceaccount.com",
//   "client_id": "114551309527571034588",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ut5z3%40grato-7a89a.iam.gserviceaccount.com",
//   "universe_domain": "googleapis.com"
// };

//   Future<String> getAccessToken() async {
//     try {
//       final credentials =
//           ServiceAccountCredentials.fromJson(_serviceAccountJson);
//       final client = await clientViaServiceAccount(credentials, [
//         'https://www.googleapis.com/auth/firebase.messaging',
//       ]);
//       return client.credentials.accessToken.data;
//     } catch (e) {
//       log("Error generating access token: $e");
//       rethrow;
//     }
//   }

// Future<String?> getUserFcmToken(String recipientId) async {
//     final supabase = Supabase.instance.client;
//     final response = await supabase
//         .from('fcm_tokens')
//         .select('fcm_token')
//         .eq('user_id', recipientId)
//         .maybeSingle();

//     if (response != null && response['fcm_token'] != null) {
//       return response['fcm_token'];
//     }

//     return null;
//   }
//   Future<void> sendNotification({
//     required String fcmToken,
//     required String title,
//     required String body,
//     Map<String, dynamic>? data,
//   }) async {
//     try {
//       final accessToken = await getAccessToken();

//       final message = {
//         "message": {
//           "token": fcmToken,
//           "notification": {"title": title, "body": body},
//           "data": data ?? {}
//         }
//       };

//       final response = await http.post(
//         Uri.parse(_fcmEndpoint),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//         },
//         body: jsonEncode(message),
//       );

//       if (response.statusCode == 200) {
//         log('Notification sent successfully');
//       } else {
//         log('Failed to send notification: ${response.body}');
//       }
//     } catch (e) {
//       log('Error sending notification: $e');
//     }
//   }

//   Future<void> saveNotificationToDB({
//     required String recipientUserId,
//     required String senderUserId,
//     required String message,
//   }) async {
//     try {
//       await supabase.from('notifications').insert({
//         'recipient_user_id': recipientUserId,
//         'sender_user_id': senderUserId,
//         'message': message,
//         'created_at': DateTime.now().toIso8601String(),
//       });
//       log('Notification saved to database');
//     } catch (e) {
//       log('Error saving notification to database: $e');
//     }
//   }
// }
