import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/calculator_cubit.dart';
import '../bloc/calculator_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator BLoC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              _showHistory(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              context.read<CalculatorCubit>().clearHistory();
            },
          ),
        ],
      ),
      body: BlocBuilder<CalculatorCubit, CalculatorState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        state.expression,
                        style: const TextStyle(fontSize: 24),
                      ),
                      if (state.result.isNotEmpty)
                        Text(
                          state.result,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (state.error != null)
                        Text(
                          state.error!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              _buildButtons(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final cubit = context.read<CalculatorCubit>();
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      children: [
        _buildButton('7', () => cubit.input('7')),
        _buildButton('8', () => cubit.input('8')),
        _buildButton('9', () => cubit.input('9')),
        _buildButton('÷', () => cubit.input('÷')),
        _buildButton('4', () => cubit.input('4')),
        _buildButton('5', () => cubit.input('5')),
        _buildButton('6', () => cubit.input('6')),
        _buildButton('×', () => cubit.input('×')),
        _buildButton('1', () => cubit.input('1')),
        _buildButton('2', () => cubit.input('2')),
        _buildButton('3', () => cubit.input('3')),
        _buildButton('-', () => cubit.input('-')),
        _buildButton('0', () => cubit.input('0')),
        _buildButton('.', () => cubit.input('.')),
        _buildButton('⌫', () => cubit.backspace()),
        _buildButton('+', () => cubit.input('+')),
        _buildButton('C', () => cubit.clear()),
        _buildButton('=', () => cubit.calculate()),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 20)),
    );
  }

  void _showHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Riwayat'),
          content: BlocBuilder<CalculatorCubit, CalculatorState>(
            builder: (context, state) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: state.history
                      .map((item) => ListTile(title: Text(item)))
                      .toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
