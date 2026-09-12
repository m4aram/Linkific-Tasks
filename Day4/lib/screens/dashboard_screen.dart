import 'package:flutter/material.dart';



class DashboardScreen extends StatelessWidget
{ const DashboardScreen({super.key});
@override Widget build(BuildContext context)
{ return Scaffold( appBar: AppBar( title: const Text('Responsive Dashboard'), centerTitle: true, ),
  body: LayoutBuilder( builder: (context, constraints)
  { final isWide = constraints.maxWidth > 700;
final cards = [
  const _StatCard(
    title: 'Users',
    value: '1,250',
    icon: Icons.people,
  ),
  const _StatCard(
    title: 'Orders',
    value: '350',
    icon: Icons.shopping_cart,
  ),
  const _StatCard(
    title: 'Revenue',
    value: '\$8,450',
    icon: Icons.attach_money,
  ),
];

return SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Dashboard',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 20),
      isWide
          ? Row(
        children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 16),
          Expanded(child: cards[1]),
          const SizedBox(width: 16),
          Expanded(child: cards[2]),
        ],
      )
          : Column(
        children: [
          cards[0],
          const SizedBox(height: 16),
          cards[1],
          const SizedBox(height: 16),
          cards[2],
        ],
      ),
      const SizedBox(height: 24),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: LinearProgressIndicator(value: 0.75),
                ),
                SizedBox(width: 12),
                Text('75%'),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
);
},
),
);
} }
class _StatCard extends StatelessWidget
{ final String title; final String value; final IconData icon;
const _StatCard({ required this.title, required this.value, required this.icon, });
@override Widget build(BuildContext context) { return Container
  ( width: double.infinity, padding: const EdgeInsets.all(20),
  decoration: BoxDecoration( borderRadius: BorderRadius.circular(20), color: Theme.of(context).colorScheme.primaryContainer, ),
  child: Column( children: [ Icon(icon, size: 40), const SizedBox(height: 12),
    Text( value, style: const TextStyle( fontSize: 24, fontWeight: FontWeight.bold, ), ),
    Text(title),
  ], ), ); } }