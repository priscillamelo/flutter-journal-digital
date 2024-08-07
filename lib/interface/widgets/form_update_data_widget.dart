import 'package:flutter/material.dart';
import 'package:flutter_journal_moviesandseries/interface/widgets/customs/colors.dart';
import 'package:flutter_journal_moviesandseries/models/abas/assistindo.dart';
import 'package:flutter_journal_moviesandseries/models/serie.dart';
import 'package:flutter_journal_moviesandseries/services/repository/serie_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FormUpdateDataWidget extends StatefulWidget {
  //final String categoriaPertencente;
  final String id;
  const FormUpdateDataWidget({
    super.key,
    //required this.categoriaPertencente,
    required this.id,
  });

  @override
  State<FormUpdateDataWidget> createState() => _FormUpdateDataWidget();
}

class _FormUpdateDataWidget extends State<FormUpdateDataWidget> {
  //late MovieProvider movieProvider;
  //late FilmeRepository filmeRepository;
  //ValuesRegister? _selectedOption;
  // para armazenar o valor do RadioButton selecionado
  String valueOption = "Filme";

  final _formKey = GlobalKey<FormState>();
  TextEditingController tituloController = TextEditingController();
  final generoController = TextEditingController();
  final temporadasController = TextEditingController();
  final temporadaAtualController = TextEditingController();
  final sinopseController = TextEditingController();
  String? posterPath;

  Future<String?> selectedImage(String? path) async {
    final ImagePicker imagePicker = ImagePicker();

    try {
      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          path = file.path;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return path;
  }

  @override
  Widget build(BuildContext context) {
    final serieRepository = Provider.of<SerieRepository>(context);

    return FutureBuilder(
        future: serieRepository.getSerieById(int.parse(widget.id)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Serie serie = snapshot.data;
            if (serie.poster != null) posterPath = serie.poster;
            tituloController.text = serie.titulo;

            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Atualizar Série',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 32),
                      margin: const EdgeInsets.only(top: 56),
                      width: MediaQuery.of(context).size.width,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.7,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                width: 100,
                                height: 200,
                                decoration: const BoxDecoration(
                                  color: ColorsTheme.bgTabSelected,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(
                                        Icons.upload_file_rounded,
                                        size: 96,
                                        color: ColorsTheme.bgInput,
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          String? path =
                                              await selectedImage(posterPath);
                                          if (path != null) {
                                            setState(() {
                                              posterPath = path;
                                            });
                                          }
                                        },
                                        child: const Text(
                                          "Carregar novo poster",
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: ColorsTheme.bgInput),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            TextFormField(
                              initialValue: serie.titulo,
                              onSaved: (newValue) {
                                tituloController.text = newValue!;
                              },
                              decoration: const InputDecoration(
                                label: Text("Título"),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            if (serie.categoriaPertencente == Assistindo.aba)
                              TextFormField(
                                initialValue: serie.temporadaAtual.toString(),
                                keyboardType: TextInputType.number,
                                onSaved: (newValue) {
                                  temporadaAtualController.text = newValue!;
                                },
                                decoration: const InputDecoration(
                                  label: Text("Temporada Atual"),
                                ),
                              ),
                            if (serie.categoriaPertencente == Assistindo.aba)
                              const SizedBox(
                                height: 16,
                              ),
                            TextFormField(
                              initialValue: serie.genero,
                              keyboardType: TextInputType.text,
                              onSaved: (newValue) {
                                generoController.text = newValue!;
                              },
                              decoration: const InputDecoration(
                                label: Text("Gênero"),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              initialValue: serie.temporadas.toString(),
                              keyboardType: TextInputType.number,
                              onSaved: (newValue) {
                                temporadasController.text = newValue!;
                              },
                              decoration: const InputDecoration(
                                label: Text("Temporadas"),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              initialValue: serie.sinopse,
                              keyboardType: TextInputType.multiline,
                              onSaved: (newValue) {
                                sinopseController.text = newValue!;
                              },
                              decoration: const InputDecoration(
                                label: Text("Sinopse"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          serie.titulo = tituloController.text;
                          serie.poster = posterPath;
                          serie.genero = generoController.text;
                          serie.temporadas =
                              int.parse(temporadasController.text);
                          serie.temporadaAtual =
                              int.parse(temporadaAtualController.text);
                          serie.sinopse = sinopseController.text;

                          serieRepository.updateSerie(serie);

                          Navigator.pop(context);
                        }
                      },
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.only(
                            top: 16,
                            right: 52,
                            bottom: 16,
                            left: 52,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Atualizar Série",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Text("Erro ao editar");
          }
        });
  }
}

/* if (tabName.toLowerCase() != TabTypes.assistindo.name)
              OptionsRegister(
                onOptionSelected: (value) {
                  setState(() {
                    _selectedOption = value;
                    _selectedOption.toString().contains("serie")
                        ? valueOption = "Série"
                        : valueOption = 'Filme';
                  });
                },
              ), */
              // Outras widgets que você deseja exibir sempre

              /* tituloController =
                              TextEditingController(text: filme!.titulo);
                          generoController = TextEditingController();
                          diretorController = TextEditingController();
                          anoLancamentoController = TextEditingController();
                          sinopseController = TextEditingController(); */
              //tituloController.text = filme!.titulo;
              /*generoController.text = (filme.genero ?? "");
                          diretorController.text = (filme.diretor ?? "");
                          anoLancamentoController.text =
                              filme.anoLancamento.toString();
                          sinopseController.text = (filme.sinopse ?? ""); */
/* 




if (tabName != TabTypes.assistindo) {
                Text(
                    'Adicionar $valueOption',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            DadosFormFieldWidget(
                              label: 'Título',
                              controller: tituloController,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            DadosFormFieldWidget(
                              label: 'Gênero',
                              controller: generoController,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            DadosFormFieldWidget(
                              label: 'Diretor',
                              controller: diretorController,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            DadosFormFieldWidget(
                              label: 'Ano de Lançamento',
                              controller: anoLancamentoController,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            DadosFormFieldWidget(
                              label: 'Sinopse',
                              controller: sinopseController,
                              keyboardType: TextInputType.multiline,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Filme filme = Filme(
                          tituloController.text,
                          int.parse(anoLancamentoController.text),
                          categoriaPertencente: widget.categoriaPertencente,
                        );
                        movieProvider.saveMovie(filme);
                        //TODO: CRIAR COMPONENTE DE SNACKBAR
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Aba ${widget.categoriaPertencente}"),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.only(
                          top: 16,
                          right: 52,
                          bottom: 16,
                          left: 52,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Adicionar à lista",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                } */