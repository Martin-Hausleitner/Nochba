import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nochba/logic/models/ImageFile.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/views/new_post/tag_dialog.dart';

class InsetPostController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final Rx<CategoryOptions> _category = CategoryOptions.None.obs;
  final Rx<CategoryOptions> _subCategory = CategoryOptions.None.obs;

  CategoryOptions get category => _category.value;
  CategoryOptions get subCategory => _subCategory.value;

  void setCategory(CategoryOptions categoryOption) {
    _category.value = categoryOption;
  }

  void setSubCategory(CategoryOptions categoryOption) {
    _subCategory.value = categoryOption;
  }

  final Rx<String> _categoryName = ''.obs;
  String get categoryName => _categoryName.value;

  void refreshCategoryName() =>
      _categoryName.value = category == CategoryOptions.None
          ? ''
          : subCategory == CategoryOptions.None
              ? category.name.toString()
              : "${category.name.toString()} - ${subCategory.name.toString()}";

  final RxList<String> _tags = <String>[].obs;

  List<String> get tags => _tags;

  //String imageName = '';
  //Uint8List? image;

  final Rx<ImageFile> _imageFile = ImageFile().obs;
  ImageFile get imageFile => _imageFile.value;

  void setImageFile(ImageFile imageFile) {
    _imageFile.value.name = imageFile.name;
    _imageFile.value.file = imageFile.file;
  }

  String get imageName => imageFile.name;
  Uint8List? get image => imageFile.file;

  addTag(String tag) {
    _tags.add(tag);
  }

  addTags(List<String> tags) {
    _tags.addAll(tags);
  }

  removeTag(String tag) {
    _tags.remove(tag);
  }

  void showTagDialog(BuildContext context) async {
    final String result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TagDialog();
      },
    );

    addTag(result);
  }

  selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Pick an image'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await pickImage(ImageSource.gallery);
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await pickImage(ImageSource.camera);
                },
              )
            ],
          );
        });
  }

  editImage(BuildContext context) async {
    Uint8List? editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditor(
          image: _imageFile.value.file,
        ),
      ),
    );

    if (editedImage != null) {
      _imageFile.value.file = editedImage;
      update();
    }
  }

  pickImage(ImageSource imageSource) async {
    final imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: imageSource);

    if (file != null) {
      //imageName = file.path.split('/').last;
      //image = await file.readAsBytes();

      _imageFile.value.name = file.name;
      _imageFile.value.file = await file.readAsBytes();

      update();
    }
  }

  deleteImage() {
    //image = null;
    //imageName = '';

    _imageFile.value.name = '';
    _imageFile.value.file = null;

    update();
  }

  bool isLoading = false;

  clear({bool alsoCategory = true}) {
    titleController.clear();
    descriptionController.clear();
    if (alsoCategory) {
      _category.value = CategoryOptions.None;
    }
    _subCategory.value = CategoryOptions.None;
    refreshCategoryName();
    _tags.clear();
    //image = null;
    //imageName = '';

    _imageFile.value.name = '';
    _imageFile.value.file = null;

    isLoading = false;

    update();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }
}
