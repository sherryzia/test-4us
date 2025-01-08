import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:swim_strive/constants/app_urls.dart';
import 'package:swim_strive/view/widgets/DialogBoxes.dart';

class EmailSenderController extends GetxController {


Future<void> sendEmail(String otp, String email) async {
    final smtpServer = gmail('shaheerzia00@gmail.com', 'rovs lzxt iykx kvue'); // Replace with your credentials

    final mailMessage = Message()
      ..from = Address('your_email@gmail.com', 'Swim Strive Admin')
      ..recipients.add('$email') // Replace with the recipient email
      ..subject = 'OTP Verification Email '
      ..text = 'Your 6 Digit OTP is:  $otp';

    try {
      final sendReport = await send(mailMessage, smtpServer);
      print('Message sent: ${sendReport.toString()}');

      // Show success dialog
   SuccessDialog.showSuccessDialog('Success!', 'OTP has been sent to your email successfully', false, ontap: () {
    // get to back
          print(" Message sent successfully");  // Debug log

          Get.back();
    

    });
    } catch (e) {
      print('Message not sent: $e');

      // Show error dialog
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to send your message. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }


}
