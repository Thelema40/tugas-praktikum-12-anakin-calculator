import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<Product> get products => const [
        Product(name: "Kaos", price: 75000),
        Product(name: "Celana", price: 150000),
        Product(name: "Topi", price: 50000),
        Product(name: "Sepatu", price: 100000),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toko Online"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () =>
                Navigator.pushNamed(context, '/about'),
          ),
          _buildCartIcon(context),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(p.name),
              subtitle: Text("Rp ${p.price}"),
              trailing: ElevatedButton(
                onPressed: () {
                  context.read<CartCubit>().addToCart(p);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Produk ditambahkan"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text("Tambah"),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartIcon(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/cart'),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.shopping_cart),
                if (state.totalItems > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        state.totalItems.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
