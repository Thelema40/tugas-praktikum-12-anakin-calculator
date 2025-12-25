import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(const CalculatorState());

  void input(String value) {
    if (isOperator(value) && this.state.expression.isNotEmpty) {
      if (isOperator(this.state.expression[this.state.expression.length - 1])) {
        emit(this.state.copyWith(error: "Operator tidak boleh berurutan"));
        return;
      }
    }

    emit(
      this.state.copyWith(
        expression: this.state.expression + value,
        error: null,
      ),
    );
  }

  bool isOperator(String v) {
    return v == "+" || v == "-" || v == "×" || v == "÷";
  }

  void backspace() {
    if (this.state.expression.isNotEmpty) {
      emit(
        this.state.copyWith(
          expression: this.state.expression.substring(
            0,
            this.state.expression.length - 1,
          ),
        ),
      );
    }
  }

  void clear() {
    emit(const CalculatorState());
  }

  void calculate() {
    final exp = this.state.expression;

    if (exp.isEmpty) {
      emit(this.state.copyWith(error: "Ekspresi kosong"));
      return;
    }

    if (isOperator(exp[exp.length - 1])) {
      emit(this.state.copyWith(error: "Ekspresi tidak lengkap"));
      return;
    }

    final converted = exp.replaceAll("×", "*").replaceAll("÷", "/");

    try {
      final result = _evaluate(converted);
      final hasil = _formatResult(result);

      final newHistory = List<String>.from(this.state.history)
        ..add("$exp = $hasil");

      emit(
        this.state.copyWith(
          result: hasil,
          expression: "",
          history: newHistory,
          error: null,
        ),
      );
    } catch (_) {
      emit(this.state.copyWith(error: "Kesalahan perhitungan"));
    }
  }

  double _evaluate(String expression) {
    expression = expression.replaceAll(' ', '');

    if (expression.contains('/0')) {
      throw Exception('Division by zero');
    }

    return _parseExpression(expression);
  }

  double _parseExpression(String expression) {
    for (int i = expression.length - 1; i >= 0; i--) {
      if (expression[i] == '+' && i > 0) {
        return _parseExpression(expression.substring(0, i)) +
            _parseExpression(expression.substring(i + 1));
      }
      if (expression[i] == '-' && i > 0) {
        return _parseExpression(expression.substring(0, i)) -
            _parseExpression(expression.substring(i + 1));
      }
    }

    for (int i = expression.length - 1; i >= 0; i--) {
      if (expression[i] == '*' && i > 0) {
        return _parseExpression(expression.substring(0, i)) *
            _parseExpression(expression.substring(i + 1));
      }
      if (expression[i] == '/' && i > 0) {
        final right = _parseExpression(expression.substring(i + 1));
        if (right == 0) throw Exception('Division by zero');
        return _parseExpression(expression.substring(0, i)) / right;
      }
    }

    if (expression.startsWith('-')) {
      return -_parseExpression(expression.substring(1));
    }

    return double.parse(expression);
  }

  String _formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    }
    return result.toStringAsFixed(6).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  void clearHistory() {
    emit(this.state.copyWith(history: []));
  }
}
