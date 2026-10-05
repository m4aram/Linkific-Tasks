import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UtilitiesScreen extends StatefulWidget {
  const UtilitiesScreen({super.key});

  @override
  State<UtilitiesScreen> createState() => _UtilitiesScreenState();
}

class _UtilitiesScreenState extends State<UtilitiesScreen> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  String _connection = 'Checking...';

  @override
  void initState() {
    super.initState();

    _checkConnectivity();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) {
          if (!mounted) return;

          setState(() {
            _connection = _formatConnectivity(results);
          });
        });
  }

  Future<void> _checkConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();

      if (!mounted) return;

      setState(() {
        _connection = _formatConnectivity(results);
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _connection = 'Unknown';
      });
    }
  }

  String _formatConnectivity(List<ConnectivityResult> results) {
    if (results.isEmpty ||
        results.contains(ConnectivityResult.none)) {
      return 'No Internet Connection';
    }

    final names = <String>[];

    if (results.contains(ConnectivityResult.wifi)) {
      names.add('Wi-Fi');
    }

    if (results.contains(ConnectivityResult.mobile)) {
      names.add('Mobile');
    }

    if (results.contains(ConnectivityResult.ethernet)) {
      names.add('Ethernet');
    }

    if (results.contains(ConnectivityResult.bluetooth)) {
      names.add('Bluetooth');
    }

    if (results.contains(ConnectivityResult.vpn)) {
      names.add('VPN');
    }

    if (results.contains(ConnectivityResult.other)) {
      names.add('Other');
    }

    return names.isEmpty ? 'Connected' : names.join(', ');
  }

  Future<void> _openFlutterWebsite() async {
    final uri = Uri.parse('https://flutter.dev');

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open Flutter website'),
        ),
      );
    }
  }

  Future<void> _shareContent() async {
    await SharePlus.instance.share(
      ShareParams(
        text: 'Flutter Package Explorer - Utility Packages Demo',
        subject: 'Flutter Utility Packages',
      ),
    );
  }

  String get _formattedDate {
    return DateFormat.yMMMMd().add_jm().format(DateTime.now());
  }

  String get _formattedCurrency {
    return NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    ).format(1234.56);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utility Packages'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Home',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Common Utility Packages',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Examples of useful Flutter utility packages.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'intl',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.calendar_month),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text('Formatted Date:'),
                            const SizedBox(height: 4),
                            Text(_formattedDate),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Formatted Currency:',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formattedCurrency,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.wifi),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'connectivity_plus',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Current connection: $_connection',
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _checkConnectivity,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh connection',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _openFlutterWebsite,
              icon: const Icon(Icons.open_in_new),
              label: const Text(
                'url_launcher - Open Flutter.dev',
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _shareContent,
              icon: const Icon(Icons.share),
              label: const Text(
                'share_plus - Share Content',
              ),
            ),
          ),

          const SizedBox(height: 28),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Packages Demonstrated',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text('✓ intl'),
                  Text('✓ url_launcher'),
                  Text('✓ share_plus'),
                  Text('✓ connectivity_plus'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
