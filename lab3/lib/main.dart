import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int total = 0;
  final List<GlobalKey<_ShoppingItemState>> itemKeys = [
    GlobalKey<_ShoppingItemState>(),
    GlobalKey<_ShoppingItemState>(),
    GlobalKey<_ShoppingItemState>(),
    GlobalKey<_ShoppingItemState>(),
  ];

  void updateTotal(int change, int price) {
    setState(() {
      total += change * price;
    });
  }

  void clearAll() {
    for (var key in itemKeys) {
      key.currentState?.resetCount();
    }
    setState(() {
      total = 0;
    });
  }

  String formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Shopping Cart"),
          backgroundColor: const Color.fromARGB(255, 0, 206, 220),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ShoppingItem("iPad Pro", 39000, updateTotal, key: itemKeys[0]),
                ShoppingItem("iPad Air", 29000, updateTotal, key: itemKeys[1]),
                ShoppingItem("iPad Mini", 23000, updateTotal, key: itemKeys[2]),
                ShoppingItem("iPad", 19000, updateTotal, key: itemKeys[3]),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Total: ${formatPrice(total)} บาท',
                    style: const TextStyle(fontSize: 28),
                  ),
                  ElevatedButton(
                    onPressed: clearAll,
                    child: const Text("Clear"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingItem extends StatefulWidget {
  final String title;
  final int price;
  final Function(int, int) onCountChanged;

  ShoppingItem(this.title, this.price, this.onCountChanged, {Key? key}) : super(key: key);

  @override
  State<ShoppingItem> createState() => _ShoppingItemState();
}

class _ShoppingItemState extends State<ShoppingItem> {
  int count = 0;

  void _incrementCount() {
    setState(() {
      count++;
    });
    widget.onCountChanged(1, widget.price);
  }

  void _decrementCount() {
    if (count > 0) {
      setState(() {
        count--;
      });
      widget.onCountChanged(-1, widget.price);
    }
  }

  void resetCount() {
    if (count > 0) {
      widget.onCountChanged(-count, widget.price);
      setState(() {
        count = 0;
      });
    }
  }

  void _showDetailPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(widget.title, widget.price),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDetailPage,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.title,
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        widget.title,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  Text(
                    '${NumberFormat('#,###').format(widget.price)} บาท',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _decrementCount,
                    icon: const Icon(Icons.remove),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    count.toString(),
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: _incrementCount,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final int price;

  DetailPage(this.title, this.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Detail"),
        backgroundColor: const Color.fromARGB(255, 0, 206, 220),
      ),
      body: Center(
        child: Hero(
          tag: title,
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 48),
                ),
                Text(
                  '${NumberFormat('#,###').format(price)} บาท',
                  style: const TextStyle(fontSize: 24, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
