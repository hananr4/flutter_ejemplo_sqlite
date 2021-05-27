import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sqlite/bloc/dog-bloc.dart';

import 'package:sqlite/model/dog.dart';

class HomePage extends StatelessWidget {
  final _keyForm = GlobalKey<FormState>();
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dogBloc = Provider.of<DogBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Material App Bar'),
      ),
      body: StreamBuilder(
        stream: dogBloc.dogs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final dogs = snapshot.data as List<Dog>;
            return ListView.separated(
              itemBuilder: (context, index) {
                final dog = dogs[index];
                return _createListTile(context, dog);
              },
              separatorBuilder: (_, i) => Divider(
                height: 1,
                color: Colors.black54,
              ),
              itemCount: dogs.length,
            );
          } else
            return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _insertarDog(context);
        },
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  Widget _createListTile(BuildContext context, Dog dog) {
    var dataManager = Provider.of<DogBloc>(context, listen: false);
    return Dismissible(
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          dataManager.deleteById(dog.id);
          return true;
        }
      },
      crossAxisEndOffset: 10,
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete, color: Colors.white),
              SizedBox(width: 10),
              Text('Borrar',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      key: Key(dog.id.toString()),
      child: ListTile(
        onTap: () => _editarDog(context, dog),
        title: Text(dog.name),
        subtitle: Text('${dog.age}'),
        trailing: Icon(Icons.chevron_right),
        leading: Container(
          child: Text(
            dog.id.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue[400],
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }

  _insertarDog(BuildContext context) async {
    var ctrlNombre = TextEditingController();
    var ctrlEdad = TextEditingController();
    var ctrlId = TextEditingController();
    var dataManager = Provider.of<DogBloc>(context, listen: false);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: _form(ctrlId, ctrlNombre, ctrlEdad),
          actions: [
            TextButton(
              onPressed: () async {
                if (_keyForm.currentState!.validate()) {
                  await dataManager.add(
                    Dog(
                      id: int.parse(ctrlId.text),
                      name: ctrlNombre.text,
                      age: int.parse(ctrlEdad.text),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text('ok'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'),
            )
          ],
        );
      },
    );
  }

  Form _form(TextEditingController ctrlId, TextEditingController ctrlNombre,
      TextEditingController ctrlEdad) {
    return Form(
      key: _keyForm,
      child: Column(
        children: [
          TextFormField(
            controller: ctrlId,
            validator: (value) {
              if (value == null) return 'ingrese la id ';
              int? valor = int.tryParse(value);
              if (valor == null) return 'ingrese la id ';
              return null;
            },
            decoration: InputDecoration(labelText: 'Id'),
          ),
          TextFormField(
            validator: (value) => (value == null || value.isEmpty)
                ? "ingrese se el nombre"
                : null,
            controller: ctrlNombre,
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          TextFormField(
            controller: ctrlEdad,
            validator: (value) {
              if (value == null) return 'ingrese la Edad ';
              int? valor = int.tryParse(value);
              if (valor == null) return 'ingrese la Edad ';
              return null;
            },
            decoration: InputDecoration(labelText: 'Edad'),
          ),
        ],
      ),
    );
  }

  _editarDog(BuildContext context, Dog dog) async {
    var ctrlNombre = TextEditingController()..text = dog.name;
    var ctrlEdad = TextEditingController()..text = dog.age.toString();
    var ctrlId = TextEditingController()..text = dog.id.toString();
    var dataManager = Provider.of<DogBloc>(context, listen: false);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: _form(ctrlId, ctrlNombre, ctrlEdad),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
                onPressed: () async {
                  if (_keyForm.currentState!.validate()) {
                    await dataManager.update(
                      Dog(
                        id: dog.id,
                        name: ctrlNombre.text,
                        age: int.parse(ctrlEdad.text),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: Text('ok'))
          ],
        );
      },
    );
  }
}
