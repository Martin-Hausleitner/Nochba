import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/commonbase/util.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/views/public_profile/public_profile_controller.dart';

class UserInfo extends GetView<PublicProfileController> {
  final String userId;
  const UserInfo({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String font = "SanFrancisco";
    const double size = 20.0;
    const double height = 45.0;

    // return a contianer with a title, a sizedbox, a widped Clip
    return Container(
      child: ListView(
        //align left
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 18,
                ),
                FutureBuilder<UserPublicInfo?>(
                  future: controller.getPublicInfoOfUser(userId),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            'Die Profilinfos sind derzeit nicht verfügbar'),
                      );
                    } else if (snapshot.hasData) {
                      final userPublicInfo = snapshot.data!;
                      bool areInterestsValid =
                          userPublicInfo.interests != null &&
                              userPublicInfo.interests!.isNotEmpty;
                      bool areOffersValid = userPublicInfo.offers != null &&
                          userPublicInfo.offers!.isNotEmpty;
                      bool isBirthdayValid = userPublicInfo.birthday != null;
                      bool isNeighbourhoodMemberSinceValid =
                          userPublicInfo.neighbourhoodMemberSince != null;
                      bool isProfessionValid =
                          userPublicInfo.profession != null &&
                              userPublicInfo.profession!.isNotEmpty;
                      bool isFamilyStatusValid =
                          userPublicInfo.familyStatus != null &&
                              userPublicInfo.familyStatus!.isNotEmpty;
                      bool isHasPetsValid = userPublicInfo.hasPets != null &&
                          userPublicInfo.hasPets!;
                      bool isBioValid = userPublicInfo.bio != null &&
                          userPublicInfo.bio!.isNotEmpty;

                      bool isSomethingValid = areInterestsValid ||
                          areOffersValid ||
                          isBirthdayValid ||
                          isNeighbourhoodMemberSinceValid ||
                          isProfessionValid ||
                          isFamilyStatusValid ||
                          isHasPetsValid ||
                          isBioValid;

                      return isSomethingValid
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                areInterestsValid
                                    ? Column(
                                        children: [
                                          Text(
                                            'Interessen',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  //use the font of the theme
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          // create a text with weigh t900
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          Wrap(
                                            // space between chips
                                            spacing: 6,
                                            runSpacing: 7,
                                            // list of chips
                                            children: userPublicInfo.interests!
                                                .map((e) => UserInfoClip(
                                                      text: e,
                                                    ))
                                                .toList(),
                                          ),
                                          const SizedBox(
                                            height: 18,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                areOffersValid
                                    ? Column(
                                        children: [
                                          Text(
                                            'Bietet',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          Wrap(
                                            // space between chips
                                            spacing: 6,
                                            runSpacing: 7,
                                            // list of chips
                                            children: userPublicInfo.offers!
                                                .map((e) => UserInfoClip(
                                                      text: e,
                                                    ))
                                                .toList(),
                                          ),
                                          const SizedBox(
                                            height: 18,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                isBirthdayValid ||
                                        isNeighbourhoodMemberSinceValid ||
                                        isProfessionValid ||
                                        isFamilyStatusValid ||
                                        isHasPetsValid
                                    ? Column(
                                        //set left align
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Basis Info',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          isBirthdayValid
                                              ? BaseInfoRow(
                                                  data: getCalenderDate(
                                                      userPublicInfo.birthday!
                                                          .toDate()),
                                                  icon:
                                                      FlutterRemix.cake_2_line,
                                                  title: 'Geburtstag: ')
                                              : Container(),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          isNeighbourhoodMemberSinceValid
                                              ? BaseInfoRow(
                                                  data: getCalenderDate(
                                                      userPublicInfo
                                                          .neighbourhoodMemberSince!
                                                          .toDate()),
                                                  icon:
                                                      FlutterRemix.history_line,
                                                  title:
                                                      'In der Nachbarschaft seit: ')
                                              : Container(),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          isProfessionValid
                                              ? BaseInfoRow(
                                                  data: userPublicInfo
                                                      .profession!,
                                                  icon: FlutterRemix
                                                      .briefcase_4_line,
                                                  title: 'Beruf: ')
                                              : Container(),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          isFamilyStatusValid
                                              ? BaseInfoRow(
                                                  data: userPublicInfo
                                                      .familyStatus!,
                                                  icon: FlutterRemix.group_line,
                                                  title: 'Familienstand: ')
                                              : Container(),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          isHasPetsValid
                                              ? BaseInfoRow(
                                                  data: userPublicInfo.hasPets!
                                                      ? 'Ja'
                                                      : 'Nein',
                                                  icon: Icons.pets_outlined,
                                                  title: 'Haustiere: ')
                                              : Container(),
                                          const SizedBox(
                                            height: 18,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                isBioValid
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Mehr über mich',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          Text(
                                            userPublicInfo.bio!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.color
                                                        ?.withOpacity(0.6)),
                                          )
                                        ],
                                      )
                                    : Container(),
                              ],
                            )
                          : Center(
                              child: Column(
                                //center
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  // add a forum icon
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                  ),

                                  Icon(
                                    FlutterRemix.information_line,
                                    size: 100,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.1),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Es sind keine Informationen vorhanden',
                                    //align center
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.15),
                                        ),
                                  ),
                                ],
                              ),
                            );
                    } else {
                      return Container();
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BaseInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String data;

  const BaseInfoRow(
      {super.key, required this.icon, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 17,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          data,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.6)),
        ),
      ],
    );
  }
}

class UserInfoClip extends StatelessWidget {
  final String text;

  const UserInfoClip({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),

      // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      // add a border 1
      shape: StadiumBorder(
          side: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
              // color: Colors.transparent,
              width: 1)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
