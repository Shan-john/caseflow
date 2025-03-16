import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PaymentGatewayScreen extends StatefulWidget {
  const PaymentGatewayScreen({super.key});

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  final _formKey = GlobalKey<FormState>();

  String caseNumber = '2023/CR/1256';
  String courtName = 'Delhi High Court';
  String petitionerName = 'Ramesh Kumar vs. State of Delhi';
  String advocateName = 'Adv. Suresh Mehta';
  String caseType = 'Criminal Case';
  String filingYear = '2023';
  String feeType = 'Court fee';
  String amount = '2000';
  String payerName = 'Shan John';
  String mobileNumber = '+91 596254836';
  String email = 'example@gmail.com';
  String address = 'District, State';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC41E3A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset('assets/image/logo.png', height: 130),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PAYMENT GATEWAY',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC41E3A),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Case & Court Details'),
                _buildFormField('CASE NUMBER', caseNumber),
                _buildFormField('COURT NAME', courtName),
                _buildFormField('Petitioner/Defendant Name', petitionerName),
                _buildFormField('Advocate Name', advocateName),
                _buildFormField('Case Type', caseType),
                _buildFormField('Filing Year', filingYear),
                const SizedBox(height: 24),
                _buildSectionTitle('Payment Details'),
                _buildFormField('Fee Type', feeType),
                _buildFormField('Amount', amount),
                const SizedBox(height: 24),
                _buildSectionTitle('Payer Information'),
                _buildFormField('Name', payerName),
                _buildFormField('Mobile Number', mobileNumber),
                _buildFormField('Email ID', email),
                _buildFormField('Address', address),
                const SizedBox(height: 24),
                // Captcha widget would go here

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _printBill();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC41E3A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'PRINT RECEIPT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color(0xFFC41E3A),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: hintText,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFC41E3A)),
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
 
 

void _printBill() async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(16.0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Payment Receipt',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('C41E3A'),
                  ),
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Divider(),
              
              // Case & Court Details Section
              pw.Text(
                'Case & Court Details',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('C41E3A'),
                ),
              ),
              pw.SizedBox(height: 8),
              _buildFormRow('Case Number', caseNumber),
              _buildFormRow('Court Name', courtName),
              _buildFormRow('Petitioner/Defendant', petitionerName),
              _buildFormRow('Advocate Name', advocateName),
              _buildFormRow('Case Type', caseType),
              _buildFormRow('Filing Year', filingYear),
              pw.SizedBox(height: 16),
              pw.Divider(),
              
              // Payment Details Section
              pw.Text(
                'Payment Details',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('C41E3A'),
                ),
              ),
              pw.SizedBox(height: 8),
              _buildFormRow('Fee Type', feeType),
              _buildFormRow('Amount', '$amount'),
              pw.SizedBox(height: 16),
              pw.Divider(),
              
              // Payer Information Section
              pw.Text(
                'Payer Information',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('C41E3A'),
                ),
              ),
              pw.SizedBox(height: 8),
              _buildFormRow('Name', payerName),
              _buildFormRow('Mobile', mobileNumber),
              _buildFormRow('Email', email),
              _buildFormRow('Address', address),
            ],
          ),
        );
      },
    ),
  );

  // Print the document
  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}

// Helper function to create rows for case fields
pw.Widget _buildFormRow(String label, String value) {
  return pw.Row(
    children: [
      pw.Expanded(
        child: pw.Text(
          '$label:',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromHex('333333'),
          ),
        ),
      ),
      pw.Expanded(
        child: pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            color: PdfColor.fromHex('555555'),
          ),
        ),
      ),
    ],
  );
}
}
