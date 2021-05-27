part of 'dog_bloc.dart';

@immutable
abstract class DogState {
  final List<Dog> dogs;
  DogState({this.dogs = const <Dog>[]});
}

class InicialDogState extends DogState {
  InicialDogState() : super();
}

class InicializadoDogState extends DogState {
  InicializadoDogState(List<Dog> dogs) : super(dogs: dogs);
}
