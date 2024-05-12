import 'package:flutter/material.dart';
import 'package:demo_s_application1/core/app_export.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({Key? key}) : super(key: key);

  // Ödeme detayları için bir TextEditingController oluşturulur
  final TextEditingController _paymentDetailController =
      TextEditingController();

  // Örnek kayıtlı kartlar listesi
  final List<Map<String, String>> _registeredCards = [
    {
      'name': 'Kayıtlı Kart 1',
      'number': '1234 5678 9012 3456',
      'expiry': '12/25',
      'cvv': '123'
    },
    {
      'name': 'Kayıtlı Kart 2',
      'number': '9876 5432 1098 7654',
      'expiry': '10/23',
      'cvv': '456'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Methods',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[900],
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showCardMenu(context);
            },
            icon: Icon(Icons.add, color: Colors.white),
          ),
        ],
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
                SizedBox(width: 20),
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
      controller: _paymentDetailController, // TextEditingController atanır
      decoration: InputDecoration(
        labelText: '  Payment Detail',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Text(
        'Payment terms and conditions go here...',
        style: TextStyle(color: Colors.grey[700], fontSize: 15),
      ),
    );
  }

  Widget _buildZipCode() {
    return Expanded(
      child: Container(
        width: double.infinity,
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
        width: double.infinity,
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
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _onTapOK(context);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            'OK',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.green[900],
        ),
      ),
    );
  }

  void _onTapOK(BuildContext context) {
    // Ödeme detayını al
    String paymentDetail = _paymentDetailController.text;

    // Ödeme detayını kullanarak yeni bir kart oluştur
    Map<String, String> newCard = {
      'name': 'Yeni Kart',
      'number':
          '**** **** **** ****', // Gerçek kart numarası buraya eklenebilir
      'expiry': 'MM/YY', // Gerçek son kullanma tarihi buraya eklenebilir
      'cvv': '***', // Gerçek CVV buraya eklenebilir
    };

    // Kayıtlı kartlar listesine yeni kartı ekle
    _registeredCards.add(newCard);

    // Özet ekranına git
    Navigator.pushNamed(context, AppRoutes.overviewScreen);
  }

  void _showCardMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _registeredCards.map((card) {
              return ListTile(
                leading: Icon(Icons.credit_card),
                title: Text(card['name']!),
                onTap: () {
                  // Seçilen kartın detaylarını göstermek için bir fonksiyon çağırın
                  _showCardDetails(context, card);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showCardDetails(BuildContext context, Map<String, String> card) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(card['name']!),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kart Numarası: ${card['number']}'),
              Text('Son Kullanma Tarihi: ${card['expiry']}'),
              Text('CVV: ${card['cvv']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Kapat'),
            ),
            TextButton(
              onPressed: () {
                // Buraya seçilen kartı kullanmak için gereken işlemleri ekleyebilirsiniz
                print('Seçilen kart: ${card['name']}');
                // Örneğin, seçilen kartı kullanmak için bir işlem çağırılabilir
                _useSelectedCard();
              },
              child: Text('Kullan'),
            ),
          ],
        );
      },
    );
  }

  void _useSelectedCard() {
    // Seçilen kartın kullanılması için gereken işlemleri buraya ekleyebilirsiniz
    // Örneğin, seçilen kartın numarasını bir API'ye gönderebilir veya bir ödeme işlemi gerçekleştirebilirsiniz
    // Bu fonksiyon, seçilen kartı kullanmak için gereken tüm işlemleri içerebilir
    print('Seçilen kart kullanıldı');
    // Burada gerekli işlemleri gerçekleştirin
  }
}
