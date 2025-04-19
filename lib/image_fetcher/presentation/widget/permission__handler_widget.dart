import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_fetcher/core/widgets/common_button.dart';
import 'package:image_fetcher/gen/assets.gen.dart';
import 'package:image_fetcher/image_fetcher/presentation/bloc/image_fetcher_cubit.dart';
import 'package:image_fetcher/core/styles/colors.dart';
import 'package:image_fetcher/core/styles/fonts/font.dart';
import 'package:image_fetcher/core/styles/text_style/app_text_style.dart';

class PermissionHandlerWidget extends StatelessWidget {
  const PermissionHandlerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.fileStorage),
            const SizedBox(height: 42),
            Text(
              "Require Permission",
              style: AppTextStyle.getTextStyle(
                  fontSize: 20,
                  fontFamily: Fonts.roboto,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Text(
                "To show your black and white photos we just need your folder permission. We promise, we don’t take your photos.",
                textAlign: TextAlign.center,
                style: AppTextStyle.getTextStyle(
                    fontSize: 14, color: AppColors.titleColor),
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 42),
            CommonButton(
                width: 296,
                height: 42,
                borderColor: AppColors.buttonColor,
                buttonColor: AppColors.buttonColor,
                buttonContent: Text(
                  "Grant Access",
                  style: AppTextStyle.getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () =>
                    context.read<ImageFetcherCubit>().checkForPermission()),
          ],
        ),
      ),
    );
  }
}
