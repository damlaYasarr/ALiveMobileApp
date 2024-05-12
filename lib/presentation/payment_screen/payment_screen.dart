import 'package:flutter/material.dart';
import 'package:demo_s_application1/core/app_export.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Methods',
          style:
              TextStyle(color: Colors.white), // Başlık metninin rengini ayarla
        ),
        backgroundColor: Colors.green[900],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            _buildPaymentDetail(),
            SizedBox(height: 20),
            _buildTermsAndConditions(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildZipCode(),
                SizedBox(width: 20), // Aralara boşluk ekleyelim
                _buildExpirationDateAndCVV(),
              ],
            ),
            SizedBox(height: 50),
            _buildOKButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '  Payment Detail',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center, // Metni ortala
      child: Text(
        'Payment terms and conditions go here...',
        style: TextStyle(color: Colors.grey[700], fontSize: 15),
      ),
    );
  }

  Widget _buildZipCode() {
    return Expanded(
      child: Container(
        width: double.infinity, // Genişliği maksimuma ayarla
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Zip Code',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildExpirationDateAndCVV() {
    return Expanded(
      child: Container(
        width: double.infinity, // Genişliği maksimuma ayarla
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Expiration Date',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'CVV',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOKButton(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Genişliği maksimuma ayarla
      child: ElevatedButton(
        onPressed: () {
          _onTapOK(context);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15), // Yüksekliği ayarla
          child: Text(
            'OK',
            style: TextStyle(
                fontSize: 18, color: Colors.white), // Metin boyutunu ayarla
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Köşeleri yuvarla
          ),
          backgroundColor: Colors.green[900], // Arka plan rengini ayarla
        ),
      ),
    );
  }

  void _onTapOK(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.overviewScreen);
  }
}
