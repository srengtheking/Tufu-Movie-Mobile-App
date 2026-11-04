import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/pill_chip.dart';
import '../../widgets/section_title.dart';
import '../movies/data/sample_movies.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  static final _genres = ['All', ...SampleMovies.genres];
  int _genre = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final query = controller.text.trim().toLowerCase();

    final results = SampleMovies.all.where((m) {
      final matchesGenre = _genre == 0 || m.genre == _genres[_genre];
      final matchesQuery =
          query.isEmpty || m.title.toLowerCase().contains(query);
      return matchesGenre && matchesQuery;
    }).toList();

    final pillBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: p.border),
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(color: p.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search movies and series',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 6),
                      child: Icon(Icons.search_rounded, color: p.textSecondary),
                    ),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear',
                            icon: Icon(Icons.close, color: p.textMuted),
                            onPressed: controller.clear,
                          ),
                    border: pillBorder,
                    enabledBorder: pillBorder,
                    focusedBorder: pillBorder.copyWith(
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: PillChipRow(
                labels: _genres,
                selected: _genre,
                onSelected: (i) => setState(() => _genre = i),
              ),
            ),
            SliverToBoxAdapter(
              child: SectionTitle(
                title: query.isEmpty && _genre == 0
                    ? 'Top searches'
                    : '${results.length} result${results.length == 1 ? '' : 's'}',
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
              ),
            ),
            if (results.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: p.textMuted,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No titles match "${controller.text}"',
                        style: TextStyle(color: p.textSecondary),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: results.length,
                  itemBuilder: (_, i) => MovieCard(movie: results[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
