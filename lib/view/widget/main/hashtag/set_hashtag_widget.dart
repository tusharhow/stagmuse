import 'package:flutter/material.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class SetHashtagWidget extends StatelessWidget {
  const SetHashtagWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top
          Container(
            padding: const EdgeInsets.all(margin),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Title
                Center(
                  child: Text(
                    "Add Hashtag",
                    style: bold18(colorThird),
                  ),
                ),
                const SizedBox(height: 14),
                // Search Bar
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.clear, color: colorThird),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(child: SearchSearchBarWidget()),
                  ],
                ),
              ],
            ),
          ),
          Container(height: 0.5, color: colorPrimary),
          // Content
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CardHashtagWidget(),
                  CardHashtagWidget(),
                  CardHashtagWidget(),
                  CardHashtagWidget(),
                  CardHashtagWidget(),
                  CardHashtagWidget(),
                  CardHashtagWidget(),
                  CardHashtagWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
