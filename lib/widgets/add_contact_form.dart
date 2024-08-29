import 'package:contacts_demo/models/contact.dart';
import 'package:flutter/material.dart';

import '../common/widgets_common.dart';
import '../common/text_styles.dart';

class AddContactForm extends StatefulWidget {
  final Contact? editContact;
  final void Function(Contact contact) onSaved;

  const AddContactForm({super.key, this.editContact, required this.onSaved});

  @override
  State<AddContactForm> createState() => _AddContactFormState();
}

class _AddContactFormState extends State<AddContactForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _landlineController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.editContact?.name ?? '');
    _mobileController = TextEditingController(text: widget.editContact?.mobile ?? '');
    _landlineController = TextEditingController(text: widget.editContact?.landline ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _landlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildContactForm(),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildPhotoPicker() => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(),
            ),
          ),
          const Icon(
            Icons.camera_alt,
            size: 30,
          ),
        ],
      );

  Widget _buildContactForm() => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildPhotoPicker(),
            verticalSpacing(30),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildFormTitleText('Name'),
                      horizontalSpacing(30),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 24,
                          decoration:
                              const InputDecoration(border: OutlineInputBorder(), counterText: ''),
                          controller: _nameController,
                          validator: (text) => _validateName(text),
                        ),
                      ),
                    ],
                  ),
                  verticalSpacing(10),
                  Row(
                    children: [
                      _buildFormTitleText('Mobile'),
                      horizontalSpacing(22),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration:
                              const InputDecoration(border: OutlineInputBorder(), counterText: ''),
                          controller: _mobileController,
                          validator: (text) => _validateMobile(text),
                        ),
                      ),
                    ],
                  ),
                  verticalSpacing(10),
                  Row(
                    children: [
                      _buildFormTitleText('Landline'),
                      horizontalSpacing(10),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          maxLength: 12,
                          decoration:
                              const InputDecoration(border: OutlineInputBorder(), counterText: ''),
                          controller: _landlineController,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildFormTitleText(String title) => Text(
        title,
        style: formFieldTitleStyle,
      );

  Widget _buildSaveButton() => FilledButton(
        style: FilledButton.styleFrom(
          shape: const ContinuousRectangleBorder(),
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          if (_formKey.currentState?.validate() == true) {
            Contact contact = Contact(
                id: widget.editContact?.id ?? -1,
                name: _nameController.text.trim(),
                mobile: _mobileController.text.trim(),
                landline: _landlineController.text.trim());
            widget.onSaved(contact);
          }
        },
        child: const Text(
          'Save',
          style: TextStyle(fontSize: 18),
        ),
      );

  String? _validateName(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Name cannot be blank';
    }

    return null;
  }

  String? _validateMobile(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Mobile cannot be blank';
    } else if (text.trim().length < 10) {
      return 'Mobile length should be 10.';
    }

    return null;
  }
}
