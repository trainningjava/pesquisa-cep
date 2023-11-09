import 'package:flutter/material.dart';
import 'package:pesquisa_cep/models/result_cep.dart';
import 'package:pesquisa_cep/services/via_cep_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCepController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  bool _visivel = false;
  String? _resultCep;

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar CEP'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchCepTextField(),
            _buildSearchCepButton(),
            Visibility(visible: _visivel, child: _buildResultForm()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCepTextField() {
    return TextField(
      autofocus: true,
      onTap: () {_textvisible();},
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          hintText: 'Preencher o campo cep somente com número.  ',
          labelText: 'Cep',
          labelStyle: TextStyle(
            color: Colors.black,
          )),
      controller: _searchCepController,
      style: const TextStyle(color: Colors.black),
      enabled: _enableField,
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: FloatingActionButton(
        onPressed: _searchCep,
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: _loading ? _circularLoading() : const Text('Consultar'),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _loading = enable;
      _enableField = !enable;
      _visivel = !enable;
    });
  }

  void _textvisible() {
    setState(() {
      _visivel = false;
    });
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: const CircularProgressIndicator(),
    );
  }

  Future _searchCep() async {
    _searching(true);

    final cep = _searchCepController.text;

    final resultCep = await ViaCepService.fetchCep(cep: cep);
    //print(resultCep.localidade); // Exibindo somente a localidade no terminal

    setState(() {
      _resultCep = resultCep.toJson();
    });

    _searching(false);
  }

  Widget _buildResultForm() {
    ResultCep resultCep = _resultCep!= null  ? ResultCep.fromJson(_resultCep.toString()) : ResultCep();
    return Container(
      padding: const EdgeInsets.only(top: 25.0),
      child: Column(children: [
        CepRow('Cep: ', resultCep.cep),
        CepRow('Logradouro: ', resultCep.logradouro),
        CepRow('Complemento: ', resultCep.complemento),
        CepRow('Bairro: ', resultCep.bairro),
        CepRow('Localidade: ', resultCep.localidade),
        CepRow('Uf: ', resultCep.uf),
        CepRow('IBGE: ', resultCep.ibge),
        CepRow('Unidade: ', resultCep.unidade),
        CepRow('Guia: ', resultCep.gia),
      ]),
    );
  }
}

class CepRow extends StatelessWidget {
  final String? message;
  final String? result;

  const CepRow(this.message, this.result, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          message.toString(),
          style:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
        ),
        Text(
          validResult(result),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 20),
      ],
    ); 
    
  }
  
  String validResult(String? result) {
    if(result?.isEmpty ?? true) {
      return 'Não foi preenchido';
    } else {
      return result.toString();
    }
  }
}

