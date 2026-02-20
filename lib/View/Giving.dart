// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
//
// import 'Sidebar.dart';
//
//
// class Giving extends StatefulWidget {
//   const Giving({super.key});
//
//   @override
//   State<Giving> createState() => _GivingState();
// }
//
// class _GivingState extends State<Giving> {
//   @override
//   Widget build(BuildContext context) {
//     final isLargeScreen = MediaQuery.of(context).size.width >= 800;
//
//     return Scaffold(
//       drawer: isLargeScreen ? null : Container( ),
//       body: Center(
//         child: Expanded(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Center(child: Lottie.network('https://res.cloudinary.com/dggylwwqk/raw/upload/v1756722681/loading_circle_v2ikmh.json',height: 200,width: 200,options: LottieOptions(enableMergePaths: false),)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class Giving extends StatelessWidget {
  const Giving({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Section
            const HeaderSection(),

            // 2. Pricing Card
            const PricingCard(),

            const SizedBox(height: 40),

            // 3. Activation Section
            const ActivationSection(),

            const SizedBox(height: 40),

            // 4. Features Grid
            const FeaturesGrid(),

            const SizedBox(height: 20),

            // 5. Fine Print
            const FinePrint(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'GIVING',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              letterSpacing: 4,
              fontWeight: FontWeight.w300,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'FUEL YOUR MISSION',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 30),
          // Placeholder for the Hand/Phone image
          Image.network(
            'https://wallet.subsplash.com/img/dashboard/giving_signup_header.jpg', // Replace with your asset
            height: 300,
          ),
        ],
      ),
    );
  }
}

class PricingCard extends StatelessWidget {
  const PricingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '\$',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
              Text(
                '0',
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.w300),
              ),
              Padding(
                padding: EdgeInsets.only(top: 35, left: 8),
                child: Text('per month', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPricingDetail(
                'CARDS:',
                '1.9% - 2.3% + 0.30 per transaction*',
              ),
              const SizedBox(height: 8),
              _buildPricingDetail('ACH:', '0.5% - 1%*'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingDetail(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, fontSize: 12),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

class ActivationSection extends StatelessWidget {
  const ActivationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'First Assembly of God - Hawaii (P7B6XM)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black54, fontSize: 14),
            children: [
              TextSpan(text: 'An activation email will be sent to: '),
              TextSpan(
                text: 'ancil@ancilwebmedia.com',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5865F2),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Activate Giving',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class FeaturesGrid extends StatelessWidget {
  const FeaturesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "No hidden fees. We mean it.",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _featureItem('No setup fee'),
                _featureItem('No monthly minimum fee'),
                _featureItem('No annual fee'),
              ],
            ),
            const SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _featureItem('No cancellation fee'),
                _featureItem('No statement fee'),
                _featureItem('No transfer fee'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle_outlined, size: 8, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class FinePrint extends StatelessWidget {
  const FinePrint({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        '*Processing rates will drop as donation volume increases... (Long legal text here)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
      ),
    );
  }
}
