import 'dart:io';

import 'package:contacts_demo/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../common/text_styles.dart';
import '../common/widgets_common.dart';

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
  final _imagePicker = ImagePicker();
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.editContact?.name ?? '');
    _mobileController = TextEditingController(text: widget.editContact?.mobile ?? '');
    _landlineController = TextEditingController(text: widget.editContact?.landline ?? '');
    _photoPath = widget.editContact?.photoPath;
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

  Widget _buildPhotoPicker() => GestureDetector(
        onTap: () => _showImagePickerDialog(),
        child: _buildImagePreviewOrPicker(),
      );

  Widget _buildImagePreviewOrPicker() {
    double size = 100;
    File imageFile = File(_photoPath ?? '');
    if (_photoPath != null && _photoPath!.isNotEmpty && imageFile.existsSync()) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: FileImage(imageFile),
      );
    } else {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(),
        ),
        child: const Icon(
          Icons.camera_alt,
          size: 30,
        ),
      );
    }
  }

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
              landline: _landlineController.text.trim(),
              photoPath: _photoPath,
            );
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

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Choose image source',
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: _captureImageFromCamera,
                child: Text(
                  'Camera',
                  style: popupDialogButtonTextStyle,
                ),
              ),
              MaterialButton(
                onPressed: _pickImageFromGallery,
                child: Text(
                  'Gallery',
                  style: popupDialogButtonTextStyle,
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updatePhotoPath(null);
                },
                child: Text(
                  'Remove',
                  style: popupDialogButtonTextStyle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImageFromGallery() {
    Navigator.pop(context);
    _fetchImageAndSave(ImageSource.gallery);
  }

  void _captureImageFromCamera() {
    Navigator.pop(context);
    _fetchImageAndSave(ImageSource.camera);
  }

  void _fetchImageAndSave(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        maxHeight: 500,
        maxWidth: 500,
      );

      if (image != null) {
        _copySelectedImageFile(image);
      }
    } on PlatformException {
      _showImagePickerErrorDialog();
    }
  }

  void _copySelectedImageFile(XFile imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    String newPath = path.join(directory.path, imageFile.name);
    await imageFile.saveTo(newPath);
    _updatePhotoPath(newPath);
  }

  void _updatePhotoPath(String? newPath) {
    setState(() => _photoPath = newPath);
  }

  void _showImagePickerErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('There was some error fetching image. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Okay',
                style: popupDialogButtonTextStyle,
              ),
            )
          ],
        );
      },
    );
  }
}
