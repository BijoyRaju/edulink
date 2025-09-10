import 'package:edu_link/controller/fee_controller.dart';
import 'package:edu_link/model/fee_model.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final FeeModel fee;

  const PaymentScreen({super.key, required this.fee});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  late Razorpay _razorpay;
  
   @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    // Event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

   void openCheckout() {
    var options = {
      'key': 'rzp_test_RFOnd4V3QeEso4', 
      'amount': widget.fee.amount * 100,
      'name': 'EduLink Fees',
      'description': 'Fee for ${DateFormat('MMM yyyy').format(widget.fee.month!)}',
      'prefill': {
        'contact': '', 
        'email': 'student@email.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  String feeId = widget.fee.feeId;  

  await Provider.of<FeeController>(context, listen: false).markFeeAsPaid(
    feeId: feeId,
    transactionId: response.paymentId ?? "",
  );

    if(mounted) showSnackBarMessage(context, "Payment Successful! ID: ${response.paymentId}");

}


  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed! ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet Selected: ${response.walletName}")),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Details"),
        backgroundColor: const Color(0xFF254F43),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(text: "Transaction Details", fontSize: 18.sp),
            SizedBox(height: 16.h),
            ListTile(
              leading: const Icon(Icons.currency_rupee),
              title: Text("Amount: ₹${widget.fee.amount}"),
              subtitle: Text("Status: ${widget.fee.status}"),
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: Text("Due Date"),
              subtitle: Text(
                widget.fee.paidOn != null
                    ? DateFormat('dd MMM yyyy').format(widget.fee.paidOn!)
                    : "Not Paid",
              ),
            ),
            ListTile(
              leading: const Icon(Icons.confirmation_number),
              title: Text("Transaction ID"),
              subtitle: Text(widget.fee.transactionId.isNotEmpty ? widget.fee.transactionId : "N/A"),
            ),
            const Spacer(),
           (widget.fee.status == "Pending")
        ? customButton(
            text: "Pay",
            onPressed: openCheckout,
          )
        : Center(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text("Paid", style: TextStyle(color: Colors.green, fontSize: 16)),
                ],
              ),
            ),
        ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
