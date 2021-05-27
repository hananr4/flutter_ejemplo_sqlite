import 'dart:async';

import 'package:sqlite/model/dog.dart';
import 'package:sqlite/repository/dog-repository.dart';

class DogBloc {
  //Get instance of the Repository
  final _dogRepository = DogRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _dogController = StreamController<List<Dog>>.broadcast();

  get dogs => _dogController.stream;

  DogBloc() {
    getAll();
  }

  getAll({String? query}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    var l = await _dogRepository.getAll(query: query);
    _dogController.sink.add(l);
  }

  add(Dog dog) async {
    await _dogRepository.insert(dog);
    getAll();
  }

  update(Dog dog) async {
    await _dogRepository.update(dog);
    getAll();
  }

  deleteById(int id) async {
    _dogRepository.deleteById(id);
    getAll();
  }

  dispose() {
    _dogController.close();
  }
}
