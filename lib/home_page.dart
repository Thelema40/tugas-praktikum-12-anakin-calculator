import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/calculator_cubit.dart';
import '../bloc/calculator_state.dart';
import 'history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalculatorCubit, CalculatorState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Terjadi kesalahan: ${state.error}")),
          );
        }
      },
      child: Theme(
        data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
        child: Scaffold(
          backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.grey[100],
          appBar: AppBar(
            title: const Text(
              "Kalkulator Flutter",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            backgroundColor: _isDarkMode ? Colors.blue[800] : Colors.blue[600],
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: _toggleTheme,
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => _buildSettings(context),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.history_outlined),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryPage()),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              _buildDisplay(),
              Expanded(flex: 1, child: _buildButtons(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    return Expanded(
      child: BlocBuilder<CalculatorCubit, CalculatorState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isDarkMode
                    ? [Colors.blue[900]!, Colors.blue[700]!]
                    : [Colors.blue[50]!, Colors.blue[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (_isDarkMode ? Colors.blue[800] : Colors.blue)!
                      .withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  state.expression.isEmpty ? "0" : state.expression,
                  style: TextStyle(
                    fontSize: 24,
                    color: _isDarkMode ? Colors.white70 : Colors.blue[800],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  state.result.isEmpty ? "0" : state.result,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.blue[900],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final cubit = context.read<CalculatorCubit>();
    final List<String> buttons = [
      "C",
      "⌫",
      "",
      "÷",
      "7",
      "8",
      "9",
      "×",
      "4",
      "5",
      "6",
      "-",
      "1",
      "2",
      "3",
      "+",
      "",
      "0",
      "",
      "=",
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          final button = buttons[index];
          if (button.isEmpty) {
            return const SizedBox();
          }
          return _buildButton(
            button,
            onTap: () => _handleButtonPress(button, cubit, context),
          );
        },
      ),
    );
  }

  Widget _buildButton(String text, {required VoidCallback onTap}) {
    Color getButtonColor() {
      if (text == "=")
        return _isDarkMode ? Colors.blue[600]! : Colors.blue[700]!;
      if (["÷", "×", "-", "+"].contains(text))
        return _isDarkMode ? Colors.orange[600]! : Colors.orange[500]!;
      if (["C", "⌫"].contains(text))
        return _isDarkMode ? Colors.red[600]! : Colors.red[500]!;
      return _isDarkMode ? Colors.grey[700]! : Colors.grey[200]!;
    }

    Color getTextColor() {
      if (text == "=" || ["÷", "×", "-", "+"].contains(text)) {
        return Colors.white;
      }
      if (["C", "⌫"].contains(text)) return Colors.white;
      return _isDarkMode ? Colors.white : Colors.black87;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: getButtonColor(),
        foregroundColor: getTextColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        shadowColor: getButtonColor().withOpacity(0.4),
        padding: const EdgeInsets.all(16),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: text == "⌫" ? 20 : 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _handleButtonPress(
    String button,
    CalculatorCubit cubit,
    BuildContext context,
  ) {
    HapticFeedback.lightImpact(); // Add haptic feedback
    switch (button) {
      case "=":
        cubit.calculate();
        break;
      case "C":
        _confirmClear(context);
        break;
      case "⌫":
        cubit.backspace();
        break;
      default:
        cubit.input(button);
        break;
    }
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Konfirmasi Reset",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Apakah Anda yakin ingin menghapus semuainput?"),
        actions: [
          TextButton(
            child: Text("BATAL", style: TextStyle(color: Colors.grey[600])),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("YA"),
            onPressed: () {
              context.read<CalculatorCubit>().clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Pengaturan",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: "Tentang Aplikasi",
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text("Tentang Aplikasi"),
                  content: const Text(
                    "Kalkulator Flutter dengan BLoC\nVersi 1.0\nDibuat untuk pembelajaran Flutter",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.delete_outline,
            title: "Hapus Riwayat",
            onTap: () {
              context.read<CalculatorCubit>().clearHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Riwayat berhasil dihapus"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[600]),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
