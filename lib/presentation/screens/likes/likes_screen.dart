import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/book.dart';
import '../../../data/repositories/book_repository_impl.dart';
import '../../../data/datasources/local/book_local_datasource.dart';
import '../../../data/datasources/local/interaction_local_datasource.dart';
import '../../../data/datasources/remote/aozora_datasource.dart';
import '../timeline/widgets/book_card.dart';

/// いいね一覧画面
class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  final _repository = BookRepositoryImpl(
    localDataSource: BookLocalDataSource(),
    interactionDataSource: InteractionLocalDataSource(),
    remoteDataSource: AozoraDatasource(),
  );

  List<Book> _likedBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLikedBooks();
  }

  Future<void> _loadLikedBooks() async {
    setState(() => _isLoading = true);
    final books = await _repository.getLikedBooks();
    setState(() {
      _likedBooks = books;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'いいね',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            )
          : _likedBooks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'まだいいねした作品がありません',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _likedBooks.length,
                  itemBuilder: (context, index) {
                    return BookCard(book: _likedBooks[index]);
                  },
                ),
    );
  }
}
