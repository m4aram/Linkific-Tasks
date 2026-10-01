import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/product.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/posts_provider.dart';
import 'providers/todo_provider.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider: all app-wide providers in one flat list instead of nested widgets.
    // Anything registered here is available to every screen (global scope).
    return MultiProvider(
      providers: [
        // ---- 1) Plain Provider: a value that never changes (dependency injection) ----
        Provider<ApiService>(
          create: (_) => ApiService(),
          dispose: (_, api) => api.dispose(),
        ),
        Provider<ProductCatalog>(create: (_) => const ProductCatalog()),

        // ---- 2) ChangeNotifierProvider: state that changes and notifies the UI ----
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<TodoProvider>(create: (_) => TodoProvider()),
        ChangeNotifierProvider<PostsProvider>(
          // context.read inside create: take another provider's value once.
          create: (ctx) => PostsProvider(ctx.read<ApiService>())..load(),
        ),

        // ---- 3) ChangeNotifierProxyProvider: a notifier that depends on another provider ----
        // CartProvider receives AuthProvider updates (members get a discount).
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, auth, cart) => cart!..updateMembership(auth.isLoggedIn),
        ),

        // ---- 4) ProxyProvider: a read-only value derived from another provider ----
        ProxyProvider<CartProvider, CartSummary>(
          update: (_, cart, __) => CartSummary.fromCart(cart),
        ),
      ],
      child: MaterialApp(
        title: 'Provider Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const HomeScreen(),
      ),
    );
  }
}
