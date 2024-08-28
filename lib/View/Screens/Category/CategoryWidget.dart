import 'package:aichat/model/CategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/Utils.dart';
import '../Chat/ChatPage.dart';

class CategoryWidget extends StatefulWidget {
  CategoryModel categoryModel;

  CategoryWidget({super.key, required this.categoryModel});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.jumpPage(
          context,
          ChatPage(
            tips: widget.categoryModel.tips ?? [],
            chatType: widget.categoryModel.type ?? '',
            autofocus: true,
            chatId: const Uuid().v4(),
          ),
        );
      },
      child: Card(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 7.0,
            right: 7,
            top: 10,
            bottom: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                radius: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.categoryModel.image,
                    width: 33,
                    height: 33,
                  ),
                ),
              ),
              Text(
                widget.categoryModel.title,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
              // SizedBox(he)
            ],
          ),
        ),
      ),
    );
  }
}
