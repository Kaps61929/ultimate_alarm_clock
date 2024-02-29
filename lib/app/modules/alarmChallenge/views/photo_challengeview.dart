// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../controllers/alarm_challenge_controller.dart';

class PhotoChallengeView extends GetView<AlarmChallengeController> {
  PhotoChallengeView({Key? key}) : super(key: key);

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var width = Get.width;
    var height = Get.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: GestureDetector(
        onTap: () {
          Utils.hapticFeedback();
          controller.restartTimer();
        },
        child: Column(
          children: [
            Obx(
              () => LinearProgressIndicator(
                minHeight: 2,
                value: controller.progress.value,
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation<Color>(kprimaryColor),
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Match the Photo'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: themeController.isLightMode.value
                                      ? kLightPrimaryTextColor.withOpacity(0.7)
                                      : kprimaryTextColor.withOpacity(0.7),
                                ),
                          ),
                          SizedBox(
                            height: height * 0.08,
                          ),
                          Obx(
                            () => Column(
                              children: [
                                (controller.isPhotoChallengeOngoing.value ==
                                        Status.initialized)
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 15.0,
                                            ),
                                            child: File(
                                              controller.alarmRecord.imageurl,
                                            ).existsSync()
                                                // Check if file exists before trying to display
                                                ? Image.file(
                                                    File(
                                                      controller
                                                          .alarmRecord.imageurl,
                                                    ),
                                                    fit: BoxFit.cover,
                                                    height: MediaQuery.of(
                                                          Get.context!,
                                                        ).size.height *
                                                        0.3,
                                                    width: MediaQuery.of(
                                                      Get.context!,
                                                    ).size.width,
                                                  )
                                                : const CircularProgressIndicator(),
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                kprimaryColor,
                                              ),
                                            ),
                                            child: Text(
                                              'Take Photo',
                                              style: Theme.of(Get.context!)
                                                  .textTheme
                                                  .displaySmall!
                                                  .copyWith(
                                                    color: themeController
                                                            .isLightMode.value
                                                        ? kLightPrimaryTextColor
                                                        : ksecondaryTextColor,
                                                  ),
                                            ),
                                            onPressed: () async {
                                              PermissionStatus cameraStatus =
                                                  await Permission
                                                      .camera.status;
                                              if (cameraStatus.isGranted) {
                                                final pickedFile =
                                                    await ImagePicker()
                                                        .pickImage(
                                                  source: ImageSource.camera,
                                                );
                                                if (pickedFile != null) {
                                                  final imageFile =
                                                      File(pickedFile.path);
                                                  controller.imageurl.value =
                                                      imageFile.path;

                                                  await controller.compareImage(
                                                    controller.imageurl.value,
                                                    controller
                                                        .alarmRecord.imageurl,
                                                  );

                                                  if (controller.imagesimilarity
                                                          .value >
                                                      0.7) {
                                                    controller
                                                        .isPhotoChallengeOngoing
                                                        .value = Status.completed;
                                                  } else {
                                                    controller
                                                        .isPhotoChallengeOngoing
                                                        .value = Status.ongoing;
                                                  }

                                                  await imageFile.delete();
                                                } else {}
                                                // Process the image as needed
                                              } else {}
                                            },
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        height: 300,
                                        width: 300,
                                        child: Center(
                                          child: (controller
                                                      .imagesimilarity.value >
                                                  0.7)
                                              ? Icon(
                                                  Icons.done,
                                                  size: height * 0.2,
                                                  color: themeController
                                                          .isLightMode.value
                                                      ? kLightPrimaryTextColor
                                                          .withOpacity(0.7)
                                                      : kprimaryTextColor
                                                          .withOpacity(0.7),
                                                )
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      Icons.close,
                                                      size: height * 0.2,
                                                      color: themeController
                                                              .isLightMode.value
                                                          ? kLightPrimaryTextColor
                                                              .withOpacity(0.7)
                                                          : kprimaryTextColor
                                                              .withOpacity(
                                                              0.7,
                                                            ),
                                                    ),
                                                    Text(
                                                      'Wrong Photo Captured'.tr,
                                                      style: Theme.of(
                                                        context,
                                                      )
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: themeController
                                                                    .isLightMode
                                                                    .value
                                                                ? kLightPrimaryTextColor
                                                                    .withOpacity(
                                                                    0.7,
                                                                  )
                                                                : kprimaryTextColor
                                                                    .withOpacity(
                                                                    0.7,
                                                                  ),
                                                          ),
                                                    ),
                                                    TextButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                          kprimaryColor,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Retake'.tr,
                                                        style: Theme.of(
                                                          context,
                                                        )
                                                            .textTheme
                                                            .displaySmall!
                                                            .copyWith(
                                                              color: themeController
                                                                      .isLightMode
                                                                      .value
                                                                  ? kLightSecondaryTextColor
                                                                  : ksecondaryTextColor,
                                                            ),
                                                      ),
                                                      onPressed: () async {
                                                        Utils.hapticFeedback();

                                                        controller
                                                                .isPhotoChallengeOngoing
                                                                .value =
                                                            Status.initialized;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}