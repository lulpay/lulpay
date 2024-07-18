// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:showcaseview/showcaseview.dart';

// import '../../../../constants/padding.dart';
// import '../../../../theme/colors.dart';
// import '../../../common/controllers/global_controller.dart';
// import '../../../common/utility/kabbee_icons.dart';
// import '../../../common/widgets/kabbee_text.dart';

// class RegistrationToolTip extends StatefulWidget {
//   const RegistrationToolTip({Key? key, this.email}) : super(key: key);

//   final String? email;

//   @override
//   State<RegistrationToolTip> createState() => _RegistrationToolTipState();
// }

// class _RegistrationToolTipState extends State<RegistrationToolTip> {
//   GlobalKey? tipKey;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.email != null) {
//       tipKey = GlobalKey();
//       WidgetsBinding.instance.addPostFrameCallback(
//         (_) {
//           ShowCaseWidget.of(context).startShowCase(
//             [
//               tipKey!,
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ShowCaseWrapper(
//       globalKey: tipKey,
//       message:
//           'Dear user, \n\n Since you are not registered as ${widget.email} , in order to use kabbee+ click ‘Next’ button to register. In case if you entered incorrect email address, please return to the previous page and correct your email address.'
//               .tr,
//       child: const SizedBox.shrink(),
//     );
//   }
// }

// class ShowCaseWrapper extends StatelessWidget {
//   const ShowCaseWrapper({
//     Key? key,
//     required this.child,
//     required this.message,
//     this.globalKey,
//   }) : super(key: key);

//   final Widget child;
//   final String message;

//   final GlobalKey? globalKey;
//   @override
//   Widget build(BuildContext context) {
//     if (globalKey == null) return child;
//     return Showcase.withWidget(
//       key: globalKey!,
//       height: null,
//       width: Get.width,
//       container: ShowcaseCard(
//         onSkip: () => ShowCaseWidget.of(context).dismiss(),
//         message: message,
//       ),
//       child: child,
//     );
//   }
// }

// class ShowcaseCard extends StatelessWidget {
//   const ShowcaseCard({
//     Key? key,
//     this.message,
//     this.onSkip,
//   }) : super(key: key);

//   final String? message;
//   final Function()? onSkip;

//   @override
//   Widget build(BuildContext context) {
//     var isAppInDarkMode = Get.find<GlobalController>().isDarkMode.isTrue;

//     return Card(
//       color: Get.find<GlobalController>().isDarkMode.isTrue
//           ? LightModeColors.backgroundVariant
//           : DarkModeColors.backgroundVariant,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       borderOnForeground: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(borderRadius),
//         ),
//       ),
//       child: Container(
//         constraints: BoxConstraints(
//           maxWidth: Get.width,
//         ),
//         padding: const EdgeInsets.fromLTRB(sPadding, xsPadding, 24, 0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             KabbeeIcons.toolTip(
//               color: PrimaryColorTones.mainColor,
//               size: 32,
//             ),
//             const SizedBox(width: sPadding),
//             Expanded(
//               child: LimitedBox(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     KabbeeText.bodyText2(
//                       '$message'.tr,
//                       isSelectable: true,
//                       overflow: TextOverflow.ellipsis,
//                       customStyle: TextStyle(
//                         color: isAppInDarkMode
//                             ? DarkModeColors.surfaceColor
//                             : LightModeColors.surfaceColor,
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: onSkip,
//                       child: Text(
//                         'dismiss'.tr,
//                         style: TextStyle(
//                             color: isAppInDarkMode
//                                 ? DarkModeColors.surfaceColor
//                                 : PrimaryColorTones.mainColor),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
