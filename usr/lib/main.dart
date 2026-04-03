import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Details',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TicketScreen(),
      },
    );
  }
}

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  // Constants based on user request
  static const String ticketNumber = "482"; // 3 numerical digits
  static const String pnr = "935"; // 3 numerical digits
  static const double ticketPrice = 987.0;
  static const double cancellationFeePercentage = 0.15; // 15% cancellation fee
  static const double cancellationFee = ticketPrice * cancellationFeePercentage;
  static const double refundAmount = ticketPrice - cancellationFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'BOARDING PASS', 
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold, 
                          letterSpacing: 1.5
                        )
                      ),
                      Icon(Icons.flight_takeoff, color: Colors.blue, size: 32),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailColumn('TICKET NO', ticketNumber),
                      _buildDetailColumn('PNR', pnr),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Divider(thickness: 2),
                  ),
                  const Text(
                    'PAYMENT & CANCELLATION', 
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    )
                  ),
                  const SizedBox(height: 16),
                  _buildPriceRow('Ticket Price', '\$${ticketPrice.toStringAsFixed(2)}', isTotal: true),
                  const SizedBox(height: 12),
                  _buildPriceRow(
                    'Cancellation Fee (15%)', 
                    '-\$${cancellationFee.toStringAsFixed(2)}', 
                    color: Colors.red.shade700
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(),
                  ),
                  _buildPriceRow(
                    'Refund on Cancellation', 
                    '\$${refundAmount.toStringAsFixed(2)}', 
                    isTotal: true, 
                    color: Colors.green.shade700
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PdfPreviewScreen()),
          );
        },
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text('View All Pages (PDF)'),
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: const TextStyle(
            fontSize: 12, 
            color: Colors.grey, 
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          )
        ),
        const SizedBox(height: 4),
        Text(
          value, 
          style: const TextStyle(
            fontSize: 28, 
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          )
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label, 
          style: TextStyle(
            fontSize: isTotal ? 16 : 14, 
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black87 : Colors.grey.shade700,
          )
        ),
        Text(
          amount, 
          style: TextStyle(
            fontSize: isTotal ? 18 : 14, 
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, 
            color: color ?? Colors.black87
          )
        ),
      ],
    );
  }
}

class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({super.key});

  Future<pw.Document> _generatePdf() async {
    final pdf = pw.Document();

    // Page 1: Boarding Pass
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('BOARDING PASS', style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 40),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text('TICKET NO', style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey)),
                        pw.Text(TicketScreen.ticketNumber, style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold)),
                      ]
                    ),
                    pw.Column(
                      children: [
                        pw.Text('PNR', style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey)),
                        pw.Text(TicketScreen.pnr, style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold)),
                      ]
                    ),
                  ]
                ),
                pw.SizedBox(height: 40),
                pw.Text('Page 1 of 3', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey)),
              ],
            ),
          );
        },
      ),
    );

    // Page 2: Payment & Cancellation
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('PAYMENT & CANCELLATION', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 40),
                pw.Container(
                  width: 400,
                  child: pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Ticket Price:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                          pw.Text('\$${TicketScreen.ticketPrice.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        ]
                      ),
                      pw.SizedBox(height: 20),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Cancellation Fee (15%):', style: const pw.TextStyle(fontSize: 16)),
                          pw.Text('-\$${TicketScreen.cancellationFee.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 16, color: PdfColors.red)),
                        ]
                      ),
                      pw.Divider(height: 40, thickness: 2),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Refund on Cancellation:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                          pw.Text('\$${TicketScreen.refundAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
                        ]
                      ),
                    ]
                  )
                ),
                pw.SizedBox(height: 40),
                pw.Text('Page 2 of 3', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey)),
              ],
            ),
          );
        },
      ),
    );

    // Page 3: Terms & Conditions
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('TERMS & CONDITIONS', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 30),
                pw.Text('1. Check-in counters close 45 minutes prior to scheduled departure time.', style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 10),
                pw.Text('2. Passengers must carry a valid photo ID for verification.', style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 10),
                pw.Text('3. Standard baggage allowance is 15kg for check-in and 7kg for cabin.', style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 10),
                pw.Text('4. Cancellation requests must be submitted at least 24 hours before departure to be eligible for the standard refund policy.', style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 10),
                pw.Text('5. The 15% cancellation fee is calculated based on the base ticket price of \$${TicketScreen.ticketPrice.toStringAsFixed(2)}.', style: const pw.TextStyle(fontSize: 14)),
                pw.Spacer(),
                pw.Center(child: pw.Text('Page 3 of 3', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey))),
              ],
            ),
          );
        },
      ),
    );

    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview (All Pages)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: PdfPreview(
        build: (format) async {
          final doc = await _generatePdf();
          return doc.save();
        },
        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation: false,
        canChangePageFormat: false,
      ),
    );
  }
}
