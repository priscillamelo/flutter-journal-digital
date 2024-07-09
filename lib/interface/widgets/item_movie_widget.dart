import 'package:flutter/material.dart';
// PROVIDER
import 'package:provider/provider.dart';
// SERVICE
import '../../services/repository/filme_repository.dart';
// ROUTE
import '../../routes/pages_routes.dart';
// MODEL
import '../../models/filme.dart';
// WIDGET
import 'customs/colors.dart';
import 'rating_bar_widget.dart';

class ItemMovieWidget extends StatefulWidget {
  final Filme filme;
  final String nameTab;

  const ItemMovieWidget(
      {super.key, required this.filme, required this.nameTab});

  @override
  State<ItemMovieWidget> createState() => _ItemMovieWidgetState();
}

class _ItemMovieWidgetState extends State<ItemMovieWidget> {
  @override
  Widget build(BuildContext context) {
    final Filme filme = widget.filme;
    final filmeRepository = Provider.of<FilmeRepository>(context);
    return GestureDetector(
      child: Card(
        color: ColorsTheme.bgCardDetails,
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Container(
          color: Colors.amber,
          height: MediaQuery.of(context).size.height / 6,
          child: LayoutBuilder(builder: (context, constraints) {
            final double availableHeight = constraints.maxHeight;
            final double desiredHeight = availableHeight / 1.5;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Row(
                children: [
                  Column(
                    children: [
                      Center(
                        child: SizedBox(
                          width: constraints.maxWidth / 4,
                          height: desiredHeight,
                          child: filme.poster == null
                              ? Image.asset(
                                  'assets/no_image.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.asset("${filme.poster}"),
                        ),
                      ),
                      RatingBarWidget(ratingMovie: filme.avaliacao),
                    ],
                  ),
                ],
                Column(
                  
                  children[

                  ]
                )
              ),
            );
          }),
        ),
        /* ListTile(
          minLeadingWidth: 100,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 200,
                color: Colors.amber,
                child: filme.poster == null
                    ? Image.asset(
                        'assets/no_image.png',
                      )
                    : Image.asset("${filme.poster}"),
              ),

              /* SizedBox(
                  width: 80,
                  height: 54,
                  child: filme.poster == null
                      ? Image.asset(
                          'assets/no_image.png',
                          fit: BoxFit.fitHeight,
                        )
                      : Image.asset("${filme.poster}"),
                ), */
              /* Row(
          
                  children: [
                    Icon(Icons.star_rate_outlined),
                    Icon(Icons.star_rate_outlined),
                    Icon(Icons.star_rate_outlined),
                    Icon(Icons.star_rate_outlined),
                    Icon(Icons.star_rate_outlined),
                  ],
                ), */
            ],
          ),
          title: Text(
            widget.filme.titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(widget.filme.anoLancamento.toString()),
            ],
          ),
          trailing: Text(widget.filme.categoriaPertencente.toString()),
          /* leading: Image.network(
              pokemon.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ), */
        ),*/
      ),
      onTap: () {
        Navigator.pushNamed(context, PagesRoutes.kUPDATE_MOVIE_SERIE,
            arguments: widget.filme.id.toString());
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Deseja Excluir ${widget.filme.titulo}?"),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Não"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final int numberRowsAffected;
                          numberRowsAffected = await filmeRepository
                              .deleteMovie(widget.filme.id);
                          if (!context.mounted) return;
                          if (numberRowsAffected != 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Deletado com sucesso"),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Erro no processo de exclusão!"),
                              ),
                            );
                          }

                          Navigator.pop(context);
                        },
                        child: const Text("Sim"),
                      ),
                    ],
                  ),
                ],
              );
            });
      },
    );
  }
}
