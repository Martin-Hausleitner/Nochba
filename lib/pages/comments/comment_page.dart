import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/Comment.dart';
import 'package:nochba/logic/models/CommentFilter.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/pages/comments/comment_controller.dart';
import 'package:nochba/pages/comments/widgets/comment_cart.dart';
import 'package:nochba/pages/feed/widgets/filter/filter_chip.dart';

class CommentPage extends GetView<CommentController> {
  const CommentPage({Key? key, required this.postId}) : super(key: key);

  final String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Kommentare'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: // top 8 left 8 bottom 12 right 8
                const EdgeInsets.only(top: 8, left: 8, bottom: 12, right: 8),
            child: GetBuilder<CommentController>(
              builder: (c) => Row(
                children: [
                  FilterLabelChip(
                    label: 'Datum',
                    isSelected: () => controller.isCommentFilterSortBySelected(
                        CommentFilterSortBy.date),
                    onTap: () => controller
                        .selectCommentFilterSortBy(CommentFilterSortBy.date),
                  ),
                  const SizedBox(width: 8),
                  FilterLabelChip(
                    label: 'Likes',
                    isSelected: () => controller.isCommentFilterSortBySelected(
                        CommentFilterSortBy.likes),
                    onTap: () => controller
                        .selectCommentFilterSortBy(CommentFilterSortBy.likes),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<CommentController>(
              builder: (c) => StreamBuilder<List<Comment>>(
                  stream: controller.getComments(postId),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      //return Text(snapshot.error.toString());
                      return const Center(
                          child: Text(
                              'Die Kommentarsektion kann momentan nicht geladen werden'));
                    } else if (snapshot.hasData) {
                      final comments = snapshot.data!;

                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (BuildContext context, int index) {
                            final comment = comments.elementAt(index);

                            return Padding(
                                padding: // top 3
                                    // top left right 5
                                    const EdgeInsets.only(
                                        top: 3, left: 8, right: 8),
                                child: CommentCard(comment: comment));
                          });
                    } else {
                      return Container();
                    }
                  })),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Form(
                key: controller.formKey,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: controller.textController,
                          cursorColor: Colors.white,
                          textInputAction: TextInputAction.done,
                          decoration:
                              InputDecoration(labelText: 'Enter your comment'),
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) => value != null && value.isEmpty
                              ? 'Enter your comment'
                              : null),
                    ),
                    IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async =>
                            await controller.addComment(postId))
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
