import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/models/category.dart';
import 'package:locoo/models/post.dart';
import 'package:locoo/models/tag.dart';
import 'package:locoo/shared/button.dart';
import 'package:locoo/shared/error_text_field.dart';
import 'package:locoo/shared/multi_select.dart';
import 'package:locoo/views/new_post/tag_dialog.dart';

import 'new_post_controller.dart';

class NewPostPage extends GetView<NewPostController> {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a post'),
        backgroundColor: Theme.of(context).backgroundColor,
        shadowColor: Colors.transparent,
      ),
      body: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            NewPostCategorySelectionView(),
            NewPostSubcategorySelectionView(),
            NewPostView()
          ]),
    );
  }
}

/*
class NewPostPage1 extends StatefulWidget {
  const NewPostPage1({Key? key}) : super(key: key);

  @override
  State<NewPostPage1> createState() => _NewPostPageState1();
}

class _NewPostPageState1 extends State<NewPostPage1> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Category? category;
  int categoryIndex = 0;
  List<Tag> selectedTags = [];

  List<Tag> tags = <Tag>[];

  @override void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add a post', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: titleController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Title'),
                autovalidateMode: AutovalidateMode.disabled,
                validator: (value) => 
                  value != null && value.isEmpty
                  ? 'Enter a title'
                  : null
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: descriptionController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Description'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => 
                  value != null && value.isEmpty
                  ? 'Enter a description'
                  : null
              ),
              SizedBox(height: 30),
              FutureBuilder<List<Category>>(
                future: getCategories(),
                builder: ((context, snapshot) {
                  if(snapshot.hasError) {
                    return const ErrorTextField(text: 'An Error occured', padding: 16,);
                  } else if(snapshot.hasData) {
                    final List<Category> categories = snapshot.data!;
                    category ??= categories.elementAt(categoryIndex);

                    return Column(
                      children: [
                        DropdownButton<Category>(
                          value: categories.elementAt(categoryIndex),
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(fontSize: 25, color: Colors.black),
                          onChanged: (Category? newValue) {
                            if(newValue != null && category != newValue) {
                              setState(() {
                                categoryIndex = categories.indexOf(newValue);
                                category = newValue;
                                selectedTags.clear();
                              });
                            }
                          },
                          items: categories
                              .map<DropdownMenuItem<Category>>((Category value) {
                            return DropdownMenuItem<Category>(
                              value: value,
                              child: Text(value.category),
                            );
                          }).toList()
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: showMultiSelect,
                          child: const Text('Tags'),
                        ),
                        Wrap(
                          children: selectedTags
                              .map((e) => Chip(
                                    deleteIcon: Icon(Icons.close),
                                    onDeleted: () {
                                      setState(() {
                                        selectedTags.remove(e);
                                      });
                                    },
                                    label: Text(e.tag),
                                  ))
                              .toList(),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })
              ),
              const SizedBox(height: 20),
              Button(text: 'Add Post', onPressed: addPost),
            ]
          )
        )
      ),
    );
  }

  Future<List<Category>> getCategories() async {
    try {
      final snapshots = await FirebaseFirestore.instance.collection('categories').get();
      
      return snapshots.docs.map((e) => Category.fromJson(e.data())).toList();
    } catch(e) {
      print(e);
      return List.empty();
    }
  }

  Future<List<Tag>> getTags(String categoryId) async {
    if(categoryId.isEmpty) {
      return List.empty();
    }
    try {
      final snapshots = await FirebaseFirestore.instance.collection('categories').doc(categoryId).collection('tags').get();

      return snapshots.docs.map((doc) => Tag.fromJson(doc.data())).toList();
    } catch(e) {
      print(e);
      return List.empty();
    }
  }

  Future addPost() async {
    final isValid = formKey.currentState!.validate();
    if(!isValid || category == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator())
    );

    final post = Post(
      user: FirebaseAuth.instance.currentUser!.uid,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      createdAt: Timestamp.now(),
      category: category!.id,
      tags: selectedTags.map((tag) => tag.id).toList(),
      liked: [],
    );

    setState(() {
      titleController.clear();
      descriptionController.clear();
      selectedTags.clear();
    });

    try{
      final doc = FirebaseFirestore.instance.collection('posts').doc();
      post.id = doc.id;
      doc.set(post.toJson());
    
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch(e) {
      print(e);

      Get.snackbar('Error', e.message!);
      Navigator.of(context).pop();
    }
  }

  void showMultiSelect() async {
      final List<Tag> tags = await getTags(category!.id);

      // Utils.showSnackBar(selectedTags.length.toString());
      final List<dynamic> results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(title: 'Select tags', items: tags, alreadySelectedItems: selectedTags, identifyObject: (Tag tag) => tag.tag);
        },
      );

      setState(() {
          selectedTags = List.castFrom<dynamic, Tag>(results);
      });
    }
}
*/

class NewPostCategorySelectionView extends GetView<NewPostController> {
  const NewPostCategorySelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return Column(children: [
      Text('Select a category'),
      const SizedBox(
        height: 10,
      ),
      Expanded(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            InkWell(
              onTap: () {
                controller.updateCategory(CategoryOptions.Message);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightGreen,
                ),
                child: Center(
                    child: Text(CategoryOptions.Message.name.toString())),
              ),
            ),
            InkWell(
              onTap: () {
                controller.updateCategory(CategoryOptions.Lending);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightGreen,
                ),
                child: Center(
                    child: Text(CategoryOptions.Lending.name.toString())),
              ),
            ),
            InkWell(
              onTap: () {
                controller.updateCategory(CategoryOptions.Event);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightGreen,
                ),
                child:
                    Center(child: Text(CategoryOptions.Event.name.toString())),
              ),
            ),
            InkWell(
              onTap: () {
                controller.updateCategory(CategoryOptions.Search);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightGreen,
                ),
                child:
                    Center(child: Text(CategoryOptions.Search.name.toString())),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

class NewPostSubcategorySelectionView extends GetView<NewPostController> {
  const NewPostSubcategorySelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return Column(children: [
      Text('Select a subcategory'),
      const SizedBox(
        height: 10,
      ),
      Obx(
        () => Expanded(
          child: ListView.separated(
            itemCount: controller.subcategoriesForDisplay.length,
            itemBuilder: (BuildContext context, int index) {
              final categories = controller.subcategoriesForDisplay;
              return InkWell(
                onTap: () {
                  controller.updateSubcategory(categories[index]);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lightGreen,
                  ),
                  child: Text(categories[index].name.toString()),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      ),
      IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            controller.jumpBack();
          })
    ]);
  }
}

class NewPostView extends StatelessWidget {
  final bool hasSubcategories;
  const NewPostView({Key? key, this.hasSubcategories = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
                controller.subcategory != CategoryOptions.None
                    ? controller.subcategory.name.toString()
                    : controller.category.name.toString(),
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            TextFormField(
                controller: controller.titleController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Title'),
                autovalidateMode: AutovalidateMode.disabled,
                validator: (value) =>
                    value != null && value.isEmpty ? 'Enter a title' : null),
            SizedBox(height: 40),
            TextFormField(
                controller: controller.descriptionController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Description'),
                autovalidateMode: AutovalidateMode.disabled,
                validator: (value) => value != null && value.isEmpty
                    ? 'Enter a description'
                    : null),
            SizedBox(height: 10),
            Center(
                child: InkWell(
              onTap: () => controller.showTagDialog(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightGreen,
                ),
                child: Icon(Icons.add, color: Colors.white),
              ),
            )),
            Obx(
              () => Wrap(
                children: controller.tags
                    .map((e) => Chip(
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            controller.removeTag(e);
                          },
                          label: Text('#$e'),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            GetBuilder<NewPostController>(
              builder: (c) => controller.image != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: MemoryImage(controller.image!),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => controller.deleteImage(),
                        )
                      ],
                    )
                  : Center(
                      child: IconButton(
                        icon: const Icon(Icons.upload),
                        onPressed: () => controller.selectImage(context),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Button(
              text: 'Add Post',
              onPressed: () => controller.addPost(),
              icon: FlutterRemix.account_box_fill,
            ),
            IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  controller.jumpBack();
                })
          ]),
        ));
  }
}
