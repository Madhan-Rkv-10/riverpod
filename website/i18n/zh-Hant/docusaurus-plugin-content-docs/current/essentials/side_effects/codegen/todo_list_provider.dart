import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_list_provider.freezed.dart';
part 'todo_list_provider.g.dart';

/* SNIPPET START */
@freezed
class Todo with _$Todo {
  factory Todo({
    required String description,
    @Default(false) bool completed,
  }) = _Todo;
}

@riverpod
Future<List<Todo>> todoList(Ref ref) async {
  // 模擬一個網路請求。這通常來自真實的 API
  return [
    Todo(description: 'Learn Flutter', completed: true),
    Todo(description: 'Learn Riverpod'),
  ];
}
