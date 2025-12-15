import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/category_card.dart';
import 'category_detail_screen.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  void _showCategoryDialog(
    BuildContext context, {
    String? categoryId,
    String? initialName,
  }) {
    final controller = TextEditingController(text: initialName ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(categoryId == null ? 'Nueva Categoría' : 'Editar Categoría'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nombre de la categoría',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;

              final provider =
                  Provider.of<TodoProvider>(context, listen: false);

              if (categoryId == null) {
                provider.addCategory(name);
              } else {
                provider.updateCategory(categoryId, name);
              }

              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCategory(BuildContext context, String categoryId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content:
            const Text('¿Seguro que deseas eliminar esta categoría y sus todos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<TodoProvider>(context, listen: false)
                  .deleteCategory(categoryId);
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final categories = provider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Listas de Todos'),
      ),
      body: categories.isEmpty
          ? const Center(
              child: Text('No hay categorías aún. Presiona + para agregar.'),
            )
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (ctx, index) {
                final category = categories[index];
                return CategoryCard(
                  category: category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryDetailScreen(
                          categoryId: category.id,
                        ),
                      ),
                    );
                  },
                  onEdit: () => _showCategoryDialog(
                    context,
                    categoryId: category.id,
                    initialName: category.name,
                  ),
                  onDelete: () =>
                      _confirmDeleteCategory(context, category.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
