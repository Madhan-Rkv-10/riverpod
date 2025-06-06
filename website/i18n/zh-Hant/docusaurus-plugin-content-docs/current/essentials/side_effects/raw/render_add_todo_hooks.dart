import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'rest_add_todo.dart';
import 'todo_list_notifier.dart' show Todo;

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Example());
  }
}

/* SNIPPET START */
class Example extends HookConsumerWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 待處理的 addTodo 操作。如果沒有待處理的，則為 null。
    final pendingAddTodo = useState<Future<void>?>(null);
    // 我們監聽待處理的操作，以相應地更新 UI。
    final snapshot = useFuture(pendingAddTodo.value);

    // 計算是否存在錯誤狀態。
    // 檢查 connectionState 用於在重試操作時進行處理。
    final isErrored = snapshot.hasError &&
        snapshot.connectionState != ConnectionState.waiting;

    return Row(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            // 如果出現錯誤，我們會將該按鈕顯示為紅色
            backgroundColor: WidgetStatePropertyAll(
              isErrored ? Colors.red : null,
            ),
          ),
          onPressed: () async {
            // 我們將 addTodo 返回的 future 儲存在變數中
            final future = ref
                .read(todoListProvider.notifier)
                .addTodo(Todo(description: 'This is a new todo'));

            // 我們將這個 future 儲存在本地的狀態中
            pendingAddTodo.value = future;
          },
          child: const Text('Add todo'),
        ),
        // 操作正在等待，讓我們顯示一個進度指示器
        if (snapshot.connectionState == ConnectionState.waiting) ...[
          const SizedBox(width: 8),
          const CircularProgressIndicator(),
        ]
      ],
    );
  }
}
/* SNIPPET END */