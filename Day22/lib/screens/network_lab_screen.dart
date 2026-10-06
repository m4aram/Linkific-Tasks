import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../debug/app_log.dart';
import '../widgets/lab_card.dart';

/// Each button makes a request that behaves differently. Open DevTools > Network and press them:
/// you see the method, the status code, the time, the size and the headers of every request.
class NetworkLabScreen extends StatefulWidget {
  const NetworkLabScreen({super.key});

  @override
  State<NetworkLabScreen> createState() => _NetworkLabScreenState();
}

class _NetworkLabScreenState extends State<NetworkLabScreen> {
  static const String _base = 'https://jsonplaceholder.typicode.com';

  final List<String> _results = [];
  bool _busy = false;

  Future<void> _run(String label, Future<String> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    final watch = Stopwatch()..start();
    AppLog.info('$label: started');

    String result;
    try {
      result = await action();
    } on TimeoutException {
      result = 'TimeoutException (the server was too slow)';
    } on SocketException catch (e) {
      result = 'SocketException: ${e.message}';
    } on http.ClientException catch (e) {
      result = 'ClientException: ${e.message}';
    } on FormatException catch (e) {
      result = 'FormatException: ${e.message}';
    } catch (e) {
      result = 'Error: $e';
    }

    watch.stop();
    AppLog.info('$label -> $result');
    if (!mounted) return;
    setState(() {
      _busy = false;
      _results.insert(0, '$label\n   $result  (${watch.elapsedMilliseconds} ms)');
    });
  }

  Future<String> _status(Uri uri, {Duration timeout = const Duration(seconds: 10)}) async {
    final response = await http.get(uri).timeout(timeout);
    final code = response.statusCode;
    // The http package does NOT throw on 404 or 500. You must check the status code yourself.
    final note = code >= 400 ? '  <- not an exception: check statusCode!' : '';
    return 'HTTP $code, ${response.bodyBytes.length} bytes$note';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network errors')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LabCard(
            title: 'Requests',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: _busy ? null : () => _run('GET /posts/1 (200)', () => _status(Uri.parse('$_base/posts/1'))),
                  child: const Text('200 OK'),
                ),
                FilledButton.tonal(
                  onPressed: _busy ? null : () => _run('GET /posts/9999 (404)', () => _status(Uri.parse('$_base/posts/9999'))),
                  child: const Text('404'),
                ),
                FilledButton.tonal(
                  onPressed: _busy
                      ? null
                      : () => _run('GET unknown host', () => _status(Uri.parse('https://this-host-does-not-exist.invalid/'))),
                  child: const Text('No host'),
                ),
                FilledButton.tonal(
                  onPressed: _busy
                      ? null
                      : () => _run('GET with 1 ms timeout', () => _status(Uri.parse('$_base/posts'), timeout: const Duration(milliseconds: 1))),
                  child: const Text('Timeout'),
                ),
                FilledButton.tonal(
                  onPressed: _busy ? null : () => _run('GET /photos (about 1 MB)', () => _status(Uri.parse('$_base/photos'))),
                  child: const Text('Big payload'),
                ),
                FilledButton.tonal(
                  onPressed: _busy
                      ? null
                      : () => _run('GET / then jsonDecode', () async {
                            final response = await http.get(Uri.parse('$_base/')).timeout(const Duration(seconds: 10));
                            jsonDecode(response.body); // the page is HTML, not JSON
                            return 'decoded';
                          }),
                  child: const Text('Invalid JSON'),
                ),
              ],
            ),
          ),
          LabCard(
            title: 'Results',
            child: _results.isEmpty
                ? const Text('Press a button.')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final r in _results.take(10))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(r, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                        ),
                    ],
                  ),
          ),
          const LabCard(
            title: 'What to look for in DevTools > Network',
            child: Text(
              'Status 200 / 404 (404 is a normal response, not an exception). The unknown host and the timeout never '
              'get a status: the request fails before a response exists. Compare the size and the duration of /photos '
              'with /posts/1. Click a row to see the request and response headers.',
            ),
          ),
        ],
      ),
    );
  }
}
