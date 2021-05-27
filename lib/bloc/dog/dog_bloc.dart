import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:sqlite/model/dog.dart';
import 'package:sqlite/repository/dog-repository.dart';

part 'dog_event.dart';
part 'dog_state.dart';

class DogBloc extends Bloc<DogEvent, DogState> {
  final _dogRepository = DogRepository();

  DogBloc() : super(InicialDogState());

  @override
  Stream<DogState> mapEventToState(DogEvent event) async* {
    if (event is CrearDog) {
      create(event.dog);
      yield InicializadoDogState(await getAll());
    } else if (event is ActualizarDog) {
      update(event.dog);
      yield InicializadoDogState(await getAll());
    } else if (event is BorrarDog) {
      deleteById(event.id);
      yield InicializadoDogState(await getAll());
    } else if (event is ObtenerTodosDogs) {
      yield InicializadoDogState(await getAll());
    }
  }

  void create(Dog dog) async {
    await _dogRepository.insert(dog);
  }

  Future<List<Dog>> getAll({String? query}) async {
    var lista = await _dogRepository.getAll(query: query);
    return lista;
  }

  void update(Dog dog) async {
    await _dogRepository.update(dog);
  }

  void deleteById(int id) async {
    _dogRepository.deleteById(id);
  }
}
