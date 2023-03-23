import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nochba/logic/models/ImageFile.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/views/new_post/tag_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class InsetPostController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final eventKey = GlobalKey<FormState>();
  final eventLocationController = TextEditingController();
  final eventTimeController = TextEditingController();
  List<DateTime>? eventTime;
  void setEventTime(List<DateTime>? eventTimeList) {
    if (eventTimeList != null && eventTimeList.length == 2) {
      eventTime = eventTimeList;

      String firstDate =
          '${eventTimeList[0].day.toString().length == 2 ? eventTimeList[0].day : '0${eventTimeList[0].day}'}.${eventTimeList[0].month.toString().length == 2 ? eventTimeList[0].month : '0${eventTimeList[0].month}'}.${eventTimeList[0].year}';

      String firstDateTime =
          '${eventTimeList[0].hour.toString().length == 2 ? eventTimeList[0].hour : '0${eventTimeList[0].hour}'}:${eventTimeList[0].minute.toString().length == 2 ? eventTimeList[0].minute : '0${eventTimeList[0].minute}'}';

      String secondDate =
          '${eventTimeList[1].day.toString().length == 2 ? eventTimeList[1].day : '0${eventTimeList[1].day}'}.${eventTimeList[1].month.toString().length == 2 ? eventTimeList[1].month : '0${eventTimeList[1].month}'}.${eventTimeList[1].year}';

      String secondDateTime =
          '${eventTimeList[1].hour.toString().length == 2 ? eventTimeList[1].hour : '0${eventTimeList[1].hour}'}:${eventTimeList[1].minute.toString().length == 2 ? eventTimeList[1].minute : '0${eventTimeList[1].minute}'}';

      eventTimeController.text =
          '$firstDate $firstDateTime - $secondDate $secondDateTime';
    }
  }

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

  double sliderValue = 500.0;

  void onSliderValueChanged(double newValue) {
    sliderValue = newValue;
    update(['PostRangeSlider']);
  }

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
            title: const Text('Suche ein Photo aus'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Aus deiner Galerie'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await pickImage(ImageSource.gallery);
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Mache ein Photo'),
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
