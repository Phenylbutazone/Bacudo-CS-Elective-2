import 'package:cs_elective_2/pages/cart_page.dart';
import 'package:cs_elective_2/pages/checkout_page.dart';
import 'package:cs_elective_2/pages/home_page.dart';
import 'package:cs_elective_2/pages/keyboard_detail_page.dart';
import 'package:cs_elective_2/pages/keyboard_list_page.dart';
import 'package:cs_elective_2/pages/product_detail_page.dart';
import 'package:cs_elective_2/state/cart_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// Navigation 2.0 routes:
/// `/`                  → Home (product grid)
/// `/product/:id`       → Product detail
/// `/keyboards`         → Keyboard list
/// `/keyboard/:id`      → Keyboard detail
/// `/cart`              → Cart
/// `/checkout`          → Checkout confirmation (guarded)
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    final goingToCheckout = state.matchedLocation == '/checkout';
    if (goingToCheckout && cartNotifier.isEmpty) {
      return '/cart';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailPage(productId: id);
      },
    ),
    GoRoute(
      path: '/keyboards',
      builder: (context, state) => const KeyboardListPage(),
    ),
    GoRoute(
      path: '/keyboard/:id',
      builder: (context, state) {
        final id = Uri.decodeComponent(state.pathParameters['id']!);
        return KeyboardDetailPage(id: id);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutPage(),
    ),
  ],
);
