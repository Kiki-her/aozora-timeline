import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/book.dart';
import '../../../data/repositories/book_repository_impl.dart';
import '../../../data/datasources/local/book_local_datasource.dart';
import '../../../data/datasources/local/interaction_local_datasource.dart';
import '../../../data/datasources/remote/aozora_datasource.dart';
import '../timeline/widgets/book_card.dart';

/// 読了一覧画面
class ReadsScreen extends StatefulWidget {
  const ReadsScreen({super.key});

  @override
  State<ReadsScreen> createState() => _ReadsScreenState();
}

class _ReadsScreenState extends State<ReadsScreen> {
  final _repository = BookRepositoryImpl(
    localDataSource: BookLocalDataSource(),
    interactionDataSource: InteractionLocalDataSource(),
    remoteDataSource: AozoraDatasource(),
  );

  List<Book> _readBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReadBooks();
  }

  Future<void> _loadReadBooks() async {
    setState(() => _isLoading = true);
    final books = await _repository.getReadBooks();
    setState(() {
      _readBooks = books;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '読了',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            )
          : _readBooks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 64,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'まだ読了した作品がありません',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _readBooks.length,
                  itemBuilder: (context, index) {
                    return BookCard(book: _readBooks[index]);
                  },
                ),
    );
  }
}
