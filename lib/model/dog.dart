class Dog {
  final int id;
  final String name;
  final int age;
  final bool adopt;

  Dog({
    required this.id,
    required this.name,
    required this.age,
    this.adopt = false,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'adopt': this.adopt == false ? 0 : 1,
    };
  }

  factory Dog.fromDatabaseJson(Map<String, dynamic> data) => Dog(
        id: data['id'],
        name: data['name'],
        adopt: data['adopt'] == 0 ? false : true,
        age: data['age'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        'id': this.id,
        'name': this.name,
        'adopt': this.adopt == false ? 0 : 1,
        'age': this.age,
      };

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age, adopt: $adopt}';
  }
}
