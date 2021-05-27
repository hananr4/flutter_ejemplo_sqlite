import 'package:sqlite/dao/dog-dao.dart';
import 'package:sqlite/model/dog.dart';

class DogRepository {
  final dogDao = DogDao();

  Future<List<Dog>> getAll({String? query}) => dogDao.getAll(query: query);

  Future insert(Dog dog) => dogDao.create(dog);

  Future update(Dog dog) => dogDao.update(dog);

  Future deleteById(int id) => dogDao.delete(id);

  Future deleteAll() => dogDao.deleteAll();
}
