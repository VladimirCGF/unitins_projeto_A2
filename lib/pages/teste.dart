// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:unitins_projeto/models/curso_list.dart';
// import 'package:unitins_projeto/models/disciplina_boletim.dart';
// import 'package:unitins_projeto/models/disciplina_boletim_list.dart';
// import 'package:unitins_projeto/models/user_list.dart';
// import '../models/disciplina_list.dart';
// import '../models/user.dart';
//
// class DisciplinaBoletimFormPage extends StatefulWidget {
//   const DisciplinaBoletimFormPage({Key? key}) : super(key: key);
//
//   @override
//   State<DisciplinaBoletimFormPage> createState() => _DisciplinaBoletimFormPageState();
// }
//
// class _DisciplinaBoletimFormPageState extends State<DisciplinaBoletimFormPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   String? _selectedDisciplinaId;
//   String? _selectedUserId;
//
//   bool _isLoading = false;
//   bool _isEditing = false;
//
//   late final TextEditingController _statusController;
//   late final TextEditingController _a1Controller;
//   late final TextEditingController _a2Controller;
//   late final TextEditingController _exameFinalController;
//   late final TextEditingController _mediaSemestralController;
//   late final TextEditingController _mediaFinalController;
//   late final TextEditingController _faltasNoSemestreController;
//
//   @override
//   void initState() {
//     super.initState();
//     _statusController = TextEditingController();
//     _a1Controller = TextEditingController();
//     _a2Controller = TextEditingController();
//     _exameFinalController = TextEditingController();
//     _mediaSemestralController = TextEditingController();
//     _mediaFinalController = TextEditingController();
//     _faltasNoSemestreController = TextEditingController();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     final cursoList = Provider.of<CursoList>(context, listen: false);
//     final disciplinaBoletim = Provider.of<DisciplinaList>(context, listen: false);
//     final userList = Provider.of<UserList>(context, listen: false);
//
//     cursoList.loadCurso();
//     disciplinaBoletim.loadDisciplinas();
//     userList.loadUser();
//
//     final arg = ModalRoute.of(context)?.settings.arguments;
//     if (arg is DisciplinaBoletim) {
//       _isEditing = true;
//
//       _selectedDisciplinaId = arg.idDisciplina;
//       _selectedUserId = arg.idUser;
//
//       _statusController.text = arg.status;
//       _a1Controller.text = arg.a1.toString();
//       _a2Controller.text = arg.a2.toString();
//       _exameFinalController.text = arg.exameFinal.toString();
//       _mediaSemestralController.text = arg.mediaSemestral.toString();
//       _mediaFinalController.text = arg.mediaFinal.toString();
//       _faltasNoSemestreController.text = arg.faltasNoSemestre.toString();
//     }
//   }
//
//   @override
//   void dispose() {
//     _statusController.dispose();
//     _a1Controller.dispose();
//     _a2Controller.dispose();
//     _exameFinalController.dispose();
//     _mediaSemestralController.dispose();
//     _mediaFinalController.dispose();
//     _faltasNoSemestreController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _submitForm() async {
//     if (!(_formKey.currentState?.validate() ?? false)) return;
//
//     final disciplinaBoletimList = Provider.of<DisciplinaBoletimList>(context, listen: false);
//
//     final data = {
//       'idDisciplina': _selectedDisciplinaId,
//       'idUser': _selectedUserId,
//       'status': _statusController.text,
//       'a1': double.tryParse(_a1Controller.text) ?? 0.0,
//       'a2': double.tryParse(_a2Controller.text) ?? 0.0,
//       'exameFinal': double.tryParse(_exameFinalController.text) ?? 0.0,
//       'mediaSemestral': double.tryParse(_mediaSemestralController.text) ?? 0.0,
//       'mediaFinal': double.tryParse(_mediaFinalController.text) ?? 0.0,
//       'faltasNoSemestre': int.tryParse(_faltasNoSemestreController.text) ?? 0,
//     };
//
//     setState(() => _isLoading = true);
//
//     try {
//       await disciplinaBoletimList.saveDisciplinaBoletim(data);
//       if (context.mounted) {
//         Navigator.of(context).pop();
//       }
//     } catch (error, stackTrace) {
//       debugPrint('❌ ERRO AO SALVAR DISCIPLINA BOLETIM: $error');
//       debugPrint(stackTrace.toString());
//       if (context.mounted) {
//         await showDialog<void>(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: const Text('Erro!'),
//             content: const Text('Ocorreu um erro ao salvar o Disciplina Boletim.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(ctx).pop(),
//                 child: const Text('Ok'),
//               ),
//             ],
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   Widget _buildDropdown<T>({
//     required String? value,
//     required List<T> items,
//     required String label,
//     required String? Function(T) getId,
//     required String Function(T) getName,
//     required void Function(String?) onChanged,
//   }) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//       ),
//       items: items.map((item) {
//         return DropdownMenuItem<String>(
//           value: getId(item),
//           child: Text(getName(item)),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       validator: (val) => val == null ? 'Selecione $label' : null,
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType? keyboardType,
//     bool enabled = true,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//       ),
//       keyboardType: keyboardType,
//       enabled: enabled,
//       validator: (value) => value == null || value.isEmpty ? 'Preencha $label' : null,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final disciplinaBoletim = Provider.of<DisciplinaBoletimList>(context);
//     final userList = Provider.of<UserList>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cadastro de Disciplina Boletim'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _submitForm,
//           )
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(15),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               _isEditing
//                   ? Column(
//                 children: [
//                   _buildTextField(
//                     controller: TextEditingController(
//                       text: disciplinaBoletim.items.firstWhere(
//                             (d) => d.idDisciplina == _selectedDisciplinaId,
//                         orElse: () => disciplinaBoletim.items.first,
//                       ).nomeDisciplina,
//                     ),
//                     label: 'Disciplina',
//                     enabled: false,
//                   ),
//                   const SizedBox(height: 20),
//                   _buildTextField(
//                     controller: TextEditingController(
//                       text: userList.items.firstWhere(
//                             (u) => u.idUser == _selectedUserId,
//                         orElse: () => userList.items.first,
//                       ).nome,
//                     ),
//                     label: 'Usuário',
//                     enabled: false,
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               )
//                   : Column(
//                 children: [
//                   _buildDropdown<DisciplinaBoletim>(
//                     value: _selectedDisciplinaId,
//                     items: disciplinaBoletim.items,
//                     label: 'Disciplina',
//                     getId: (DisciplinaBoletim d) => d.idDisciplina,
//                     getName: (DisciplinaBoletim d) => d.nomeDisciplina,
//                     onChanged: (val) => setState(() => _selectedDisciplinaId = val),
//                   ),
//
//                   const SizedBox(height: 20),
//                   _buildDropdown<User>(
//                     value: _selectedUserId,
//                     items: userList.items,
//                     label: 'Usuário',
//                     getId: (User u) => u.idUser,
//                     getName: (User u) => u.nome,
//                     onChanged: (val) => setState(() => _selectedUserId = val),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//               _buildTextField(controller: _statusController, label: 'Status'),
//               const SizedBox(height: 20),
//               _buildTextField(controller: _a1Controller, label: 'A1', keyboardType: TextInputType.number),
//               const SizedBox(height: 20),
//               _buildTextField(controller: _a2Controller, label: 'A2', keyboardType: TextInputType.number),
//               const SizedBox(height: 20),
//               _buildTextField(controller: _exameFinalController, label: 'Exame Final', keyboardType: TextInputType.number),
//               const SizedBox(height: 20),
//               _buildTextField(controller: _mediaSemestralController, label: 'Média Semestral', keyboardType: TextInputType.number),
//               const SizedBox(height: 20),
//               _buildTextField(controller: _mediaFinalController, label: 'Média Final', keyboardType: TextInputType.number),
//               const SizedBox(height: 20),
//               _buildTextField(controller: _faltasNoSemestreController, label: 'Faltas no Semestre', keyboardType: TextInputType.number),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: const Text('Salvar Disciplina no Boletim'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
