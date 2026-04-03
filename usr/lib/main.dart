import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    // Constants based on user request
    const String ticketNumber = "482"; // 3 numerical digits
    const String pnr = "935"; // 3 numerical digits
    const double ticketPrice = 987.0;
    
    // Calculating cancellation amounts based on the 987 ticket price
    const double cancellationFeePercentage = 0.15; // 15% cancellation fee
    const double cancellationFee = ticketPrice * cancellationFeePercentage;
    const double refundAmount = ticketPrice - cancellationFee;

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
