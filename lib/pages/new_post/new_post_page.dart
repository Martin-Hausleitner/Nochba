import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locoo/models/category.dart';
import 'package:locoo/models/post.dart';
import 'package:locoo/models/tag.dart';
import 'package:locoo/shared/button.dart';
import 'package:locoo/shared/error_text_field.dart';
import 'package:locoo/shared/multi_select.dart';
import 'package:locoo/views/new_post/tag_dialog.dart';

import 'new_post_controller.dart';

/* class NewPostPage extends GetView<NewPostController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "new post",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
} */

class NewPostPage extends GetView<NewPostController> {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: NewPostCategorySelectionView()
      /*GetBuilder<NewPostController>(builder: (c) {
        if(c.category == CategoryOptions.None) return NewPostCategorySelectionView();
      
        /*else if(controller.category == CategoryOptions.Message 
        && controller.subcategory == CategoryOptions.None) return NewPostSubcategorySelectionView(categories: [CategoryOptions.Question, CategoryOptions.Appeal, CategoryOptions.Warning, CategoryOptions.Recommendation, CategoryOptions.Found]);

        else if(controller.category == CategoryOptions.Search
        && controller.subcategory == CategoryOptions.None) return NewPostSubcategorySelectionView(categories: [CategoryOptions.Help, CategoryOptions.Lost]);

        else if(controller.category == CategoryOptions.Lending) return NewPostView();

        else if(controller.category == CategoryOptions.Event) return NewPostView();


        else if(controller.subcategory == CategoryOptions.Question) return NewPostView();
        else if(controller.subcategory == CategoryOptions.Appeal) return NewPostView();
        else if(controller.subcategory == CategoryOptions.Warning) return NewPostView();
        else if(controller.subcategory == CategoryOptions.Recommendation) return NewPostView();
        else if(controller.subcategory == CategoryOptions.Found) return NewPostView();
        else if(controller.subcategory == CategoryOptions.Help) return NewPostView();
        else if(controller.subcategory == CategoryOptions.Lost) return NewPostView();*/

        else return Center(child: Column(children: [
          ElevatedButton(child: Text('Reset'), onPressed: () {c.updateCategory(CategoryOptions.None);}),
          Text('Something went wrong ${c.category.toString()}')
        ],));
      }),*/
    );
  }
}

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




class NewPostCategorySelectionView extends GetView<NewPostController> {
  const NewPostCategorySelectionView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return Column(
      children: [
        Text('Select a category'),
        const SizedBox(height: 10,),
        InkWell(
              onTap: () {
                controller.updateCategory(CategoryOptions.Message);
                Get.to(NewPostSubcategorySelectionView(categories: [CategoryOptions.Question, CategoryOptions.Appeal, CategoryOptions.Warning, CategoryOptions.Recommendation, CategoryOptions.Found]));
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightGreen,
                ),
                child: Text(CategoryOptions.Message.name.toString()),
              ),
            ),
                    const SizedBox(height: 10,),
            InkWell(
              onTap: () {
                controller.updateCategory(CategoryOptions.Lending);
                Get.to(NewPostView(hasSubcategories: false,));
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightGreen,
                ),
                child: Text(CategoryOptions.Lending.name.toString()),
              ),
            ),
                    const SizedBox(height: 10,),
            InkWell(
              onTap: () {
                controller.updateCategory(CategoryOptions.Event);
                Get.to(NewPostView(hasSubcategories: false,));
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightGreen,
                ),
                child: Text(CategoryOptions.Event.name.toString()),
              ),
            ),
                    const SizedBox(height: 10,),
            InkWell(
              onTap: () {
                controller.updateCategory(CategoryOptions.Search);
                Get.to(NewPostSubcategorySelectionView(categories: [CategoryOptions.Help, CategoryOptions.Lost]));
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightGreen,
                ),
                child: Text(CategoryOptions.Search.name.toString()),
              ),
            ),
        /*GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            InkWell(
              //onTap: controller.updateCategory(CategoryOptions.Message),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.lightGreen,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text(CategoryOptions.Message.toString()),
              ),
            ),
            InkWell(
              onTap: controller.updateCategory(CategoryOptions.Lending),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.lightGreen,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text(CategoryOptions.Lending.toString()),
              ),
            ),
            InkWell(
              onTap: controller.updateCategory(CategoryOptions.Event),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.lightGreen,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text(CategoryOptions.Event.toString()),
              ),
            ),
            InkWell(
              onTap: controller.updateCategory(CategoryOptions.Search),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.lightGreen,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text(CategoryOptions.Search.toString()),
              ),
            ),
          ],
        ),*/
      ]
    );
  }
}

class NewPostSubcategorySelectionView extends GetView<NewPostController> {
  final List<CategoryOptions> categories;
  const NewPostSubcategorySelectionView({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a post', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            controller.updateSubcategory(CategoryOptions.None);
            Get.back();
          },
        )
      ), 
      body: Column(
        children: [
          Text('Select a subcategory'),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    controller.updateSubcategory(categories[index]);
                    Get.to(NewPostView());
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
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
          ),
        ]
      ),
    );
  }
}

class NewPostView extends StatelessWidget {
  final bool hasSubcategories;
  const NewPostView({Key? key, this.hasSubcategories = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add a post | ${controller.subcategory != CategoryOptions.None ? controller.subcategory.name.toString() : controller.category.name.toString()}', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            if(hasSubcategories) {
              controller.updateSubcategory(CategoryOptions.None);
            } else {
              controller.updateCategory(CategoryOptions.None);
            }
            Get.back();
          },
        )
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: controller.titleController,
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
                controller: controller.descriptionController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Description'),
                autovalidateMode: AutovalidateMode.disabled,
                validator: (value) => 
                  value != null && value.isEmpty
                  ? 'Enter a description'
                  : null
              ),
              SizedBox(height: 10),
              Center(
                child: InkWell(
                  onTap:() => controller.showTagDialog(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightGreen,
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                )
              ),
              Obx(() => Wrap(
                children: controller.tags
                    .map((e) => Chip(
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            controller.removeTag(e);
                          },
                          label: Text(e),
                        ))
                    .toList(),
              ),),
              const SizedBox(height: 20),
              controller.image != null ? 
                CircleAvatar(
                  backgroundImage: MemoryImage(controller.image!),
                ) :
                Center(
                  child: IconButton(
                    icon: const Icon(Icons.upload), 
                    onPressed: () => controller.selectImage(context),
                  ),
                ),
              const SizedBox(height: 20),
              Button(text: 'Add Post', onPressed:() => controller.addPost()),
            ]
          )
        )
      )
    );
  }
}
