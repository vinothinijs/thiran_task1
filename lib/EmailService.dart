import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_email/transactions_model.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static Future<void> SendEmail(
      List<Transactions> errorRecords, BuildContext context) async {
    final smtpServer =
        gmail('vinothiniprogrammer@gmail.com', 'noqo hsgx seku rznf');

    //const String sender_email = 'vinothiniprogrammer@gmail.com';
    const String sender_email = 'Shaalin@thirantech.com';

    String records =
        "<p>Hi Administrator,<br/>We are found ${errorRecords.length} error records in Transactions DB.<br/><p><table>"
        "<thead><tr><th colspan='4'>Error Records</th></tr></thead>"
        "<thead><tr><th style="
        ">TransID</th><th>TransDesc</th><th>TransStatus</th><th>TransDateTime</th></tr></thead>"
        "<tbody>";
    for (var record in errorRecords) {
      records += "<tr>"
          "<td>${record.TransID}</td>"
          "<td>${record.TransDesc}</td>"
          "<td>${record.TransStatus}</td>"
          "<td>${record.TransDateTime}</td></tr>";
    }
    records += "</tbody></table>";

    final message = Message()
      ..from =
          const Address('vinothiniprogrammer@gmail.com', 'Vinothini Programmer')
      ..recipients.add(sender_email)
      ..subject = 'Daily Error Records Report Task'
      ..html = '''
      <!DOCTYPE html>
      <html>
        <head>
        <style type="text/css">
          th, td {
             padding: 15px;
             border:2px solid black
          } 
          table {
            border:2px solid black
          }
        </style>
        </head>
        <body>${records}</body>
      </html>
    ''';

    try {
      final sendReport = await send(message, smtpServer);
      if (context != null) {
        const snackBar = SnackBar(
            content: Text("Mail send successfully to ${sender_email}"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on MailerException catch (e) {
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  static Future<void> SendEmailTask(List<Transactions> errorRecords) async {
    final smtpServer =
        gmail('vinothiniprogrammer@gmail.com', 'noqo hsgx seku rznf');

    String records =
        "<p>Hi Administrator,<br/>We are found ${errorRecords.length} error records in Transactions DB.<br/><p><table>"
        "<thead><tr><th colspan='4'>Error Records</th></tr></thead>"
        "<thead><tr><th style="
        ">TransID</th><th>TransDesc</th><th>TransStatus</th><th>TransDateTime</th></tr></thead>"
        "<tbody>";
    for (var record in errorRecords) {
      records += "<tr>"
          "<td>${record.TransID}</td>"
          "<td>${record.TransDesc}</td>"
          "<td>${record.TransStatus}</td>"
          "<td>${record.TransDateTime}</td></tr>";
    }
    records += "</tbody></table>";

    final message = Message()
      ..from =
          const Address('vinothiniprogrammer@gmail.com', 'Vinothini Programmer')
      ..recipients.add('Shaalin@thirantech.com')
      ..subject = 'Daily Error Records Report Task'
      ..html = '''
      <!DOCTYPE html>
      <html>
        <head>
        <style type="text/css">
          th, td {
             padding: 15px;
             border:2px solid black
          } 
          table {
            border:2px solid black
          }
        </style>
        </head>
        <body>${records}</body>
      </html>
    ''';

    try {
      final sendReport = await send(message, smtpServer);
      const snackBar = SnackBar(content: Text("Mail send successfully."));
      print('Mail send successfully');
    } on MailerException catch (e) {
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
