import 'package:flutter/material.dart';
import 'package:image_fetcher/core/styles/text_style/app_text_style.dart';
import 'package:image_fetcher/core/widgets/common_button.dart';

import '../../../core/styles/colors.dart';

class AllPhotos extends StatelessWidget {
  const AllPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      floatingActionButton: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          child: CommonButton(
            width: size.width,
            height: 42,
            borderColor: AppColors.buttonColor,
            buttonColor: AppColors.buttonColor,
            buttonContent: Text(
              "DOWNLOAD",
              style: AppTextStyle.getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {},
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Navigates back to the previous screen
              },
            ),
            title: Text(
              'Photos',
              style: AppTextStyle.getTextStyle(fontSize: 20),
            ),
            pinned: true,
            floating: true,
            snap: true,
            backgroundColor: Colors.white, // Customize as needed
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: size.height,
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: 100,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(2),
                    height: 84,
                    width: 84,
                    decoration: BoxDecoration(
                      color: Colors.primaries[index % Colors.primaries.length],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
