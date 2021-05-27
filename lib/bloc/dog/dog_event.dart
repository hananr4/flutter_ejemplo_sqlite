part of 'dog_bloc.dart';

@immutable
abstract class DogEvent {}

class CrearDog extends DogEvent {
  final Dog dog;
  CrearDog(this.dog);
}

class ActualizarDog extends DogEvent {
  final Dog dog;
  ActualizarDog(this.dog);
}

class BorrarDog extends DogEvent {
  final int id;
  BorrarDog(this.id);
}

class ObtenerTodosDogs extends DogEvent {}
