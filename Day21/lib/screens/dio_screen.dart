import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/api_service.dart';

class DioScreen extends StatefulWidget {
  const DioScreen({super.key});

  @override
  State<DioScreen> createState() => _DioScreenState();
}

class _DioScreenState extends State<DioScreen> {
  final ApiService _api = ApiService();
  CancelToken? _cancelToken;

  String _message = 'Press GET products to test Dio.';
  bool _loading = false;

  Future<void> _loadProducts() async {
    _cancelToken = CancelToken();
    setState(() {
      _loading = true;
      _message = 'Requesting products...';
    });

    try {
      final products = await _api.fetchProducts(cancelToken: _cancelToken);
      if (!mounted) return;
      setState(() {
        _message = 'Loaded ${products.length} products successfully.';
      });
    } on DioException catch (error) {
      if (!mounted) return;
      setState(() {
        _message = CancelToken.isCancel(error)
            ? 'Request cancelled by user.'
            : 'Dio error: ${error.message ?? error.type.name}';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _message = 'Unexpected error: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _cancelRequest() => _cancelToken?.cancel('Cancelled by the user');

  Future<void> _downloadFile() async {
    setState(() => _message = 'Downloading demo file...');
    try {
      final path = _api.exampleFilePath();
      await _api.downloadDemoFile(path);
      if (!mounted) return;
      setState(() => _message = 'Downloaded demo file to:\n$path');
    } on DioException catch (error) {
      if (!mounted) return;
      setState(() => _message = 'Download error: ${error.message}');
    } catch (error) {
      if (!mounted) return;
      setState(() => _message = 'Download error: $error');
    }
  }

  @override
  void dispose() {
    _cancelToken?.cancel('Screen disposed');
    _api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio Example'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Advanced HTTP Client', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(_message))),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loading ? null : _loadProducts,
            icon: const Icon(Icons.cloud_download),
            label: Text(_loading ? 'Loading...' : 'GET products'),
          ),
          OutlinedButton.icon(
            onPressed: _loading ? _cancelRequest : null,
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancel request'),
          ),
          OutlinedButton.icon(
            onPressed: _downloadFile,
            icon: const Icon(Icons.file_download_outlined),
            label: const Text('Download file'),
          ),
          const SizedBox(height: 20),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Dio features demonstrated: BaseOptions, timeouts, '
                'interceptors, GET requests, CancelToken and download().',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
