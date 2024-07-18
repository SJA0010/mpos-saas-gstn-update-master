import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import 'Constant Data/constant.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.09,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.09,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.09,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.09,
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

class TabletTableWidget extends StatelessWidget {
  const TabletTableWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: context.width(),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: context.width() / 10,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: context.width() / 10,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: context.width() / 10,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: context.width() / 10,
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        'Delete',
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

class SmallTableWidget extends StatelessWidget {
  const SmallTableWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .057,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .057,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .057,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .057,
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

class TabletSmallTableWidget extends StatelessWidget {
  const TabletSmallTableWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .075,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .075,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .075,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .075,
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

class DayBookWidget extends StatelessWidget {
  const DayBookWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .070,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .070,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .070,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .070,
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

class TabletDayBookWidget extends StatelessWidget {
  const TabletDayBookWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .098,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .098,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .098,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .098,
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

class AllTransactionWidget extends StatelessWidget {
  const AllTransactionWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .050,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .050,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .050,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .050,
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

class TabletAllTransactionWidget extends StatelessWidget {
  const TabletAllTransactionWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .070,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .070,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .070,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .070,
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

//Supplier Customer Table List
class CustomerListTableWidget extends StatelessWidget {
  const CustomerListTableWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.13,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.10,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.13,
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.10,
                            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.list, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).dueCollection,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

class TabletCustomerListTableWidget extends StatelessWidget {
  const TabletCustomerListTableWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.10,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.10,
                            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.list, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).dueCollection,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

// class ExpensesTableWidget extends StatefulWidget {
//   const ExpensesTableWidget({
//     Key? key,
//   }) : super(key: key);
//
//   final List<ExpenseModel>
//
//   @override
//   State<ExpensesTableWidget> createState() => _ExpensesTableWidgetState();
// }
//
// class _ExpensesTableWidgetState extends State<ExpensesTableWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10.0),
//           decoration: BoxDecoration(
//             color: kGreyTextColor.withOpacity(0.2),
//           ),
//           child: HorizontalList(
//               padding: EdgeInsets.zero,
//               itemCount: catrgoryList.length,
//               itemBuilder: (_, i) {
//                 return Row(
//                   children: [
//                     Container(
//                       width: MediaQuery.of(context).size.width * .08,
//                       padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
//                       child: Center(
//                         child: Text(
//                           catrgoryList[i],
//                           maxLines: 2,
//                           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width * .08,
//                       padding: const EdgeInsets.all(10.0),
//                       child: const Center(
//                         child: Icon(FeatherIcons.settings, color: kGreyTextColor),
//                       ),
//                     ).visible(i == catrgoryList.length - 1),
//                   ],
//                 );
//               }),
//         ),
//         ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: itemCount,
//             itemBuilder: (_, ind) {
//               return Container(
//                 padding: const EdgeInsets.all(10.0),
//                 decoration: const BoxDecoration(
//                   color: kWhiteTextColor,
//                 ),
//                 child: HorizontalList(
//                     physics: const NeverScrollableScrollPhysics(),
//                     padding: EdgeInsets.zero,
//                     itemCount: catrgoryData.length,
//                     itemBuilder: (_, i) {
//                       return Row(
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width * .08,
//                             padding: const EdgeInsets.all(10.0),
//                             child: Center(
//                               child: Text(
//                                 i == 0 ? (ind + 1).toString() : catrgoryData[i],
//                                 maxLines: 2,
//                                 style: kTextStyle.copyWith(color: kGreyTextColor),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             width: MediaQuery.of(context).size.width * .08,
//                             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                             child: PopupMenuButton(
//                               icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
//                               padding: EdgeInsets.zero,
//                               itemBuilder: (BuildContext bc) => [
//                                 PopupMenuItem(
//                                   child: Row(
//                                     children: [
//                                       const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
//                                       const SizedBox(width: 4.0),
//                                       Text(
//                                         'Edit',
//                                         style: kTextStyle.copyWith(color: kTitleColor),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 PopupMenuItem(
//                                   child: Row(
//                                     children: [
//                                       const Icon(MdiIcons.delete, size: 18.0, color: kTitleColor),
//                                       const SizedBox(width: 4.0),
//                                       Text(
//                                         'Delete',
//                                         style: kTextStyle.copyWith(color: kTitleColor),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 PopupMenuItem(
//                                   child: Row(
//                                     children: [
//                                       const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
//                                       const SizedBox(width: 4.0),
//                                       Text(
//                                         'Share',
//                                         style: kTextStyle.copyWith(color: kTitleColor),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 PopupMenuItem(
//                                   child: Row(
//                                     children: [
//                                       const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
//                                       const SizedBox(width: 4.0),
//                                       Text(
//                                         'Preview',
//                                         style: kTextStyle.copyWith(color: kTitleColor),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                               onSelected: (value) {
//                                 Navigator.pushNamed(context, '$value');
//                               },
//                             ),
//                           ).visible(i == catrgoryData.length - 1),
//                         ],
//                       );
//                     }),
//               );
//             }),
//       ],
//     );
//   }
// }

class TabletExpensesTableWidget extends StatelessWidget {
  const TabletExpensesTableWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .092,
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .093,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .093,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .093,
                            padding: const EdgeInsets.only(right: 10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

class ExpensesCategoryListWidget extends StatelessWidget {
  const ExpensesCategoryListWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .15,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .15,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .15,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .15,
                            padding: const EdgeInsets.all(10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

class TabletExpensesCategoryListWidget extends StatelessWidget {
  const TabletExpensesCategoryListWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .18,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .18,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .18,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .18,
                            padding: const EdgeInsets.all(10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

//Stock
class StockReportWidget extends StatelessWidget {
  const StockReportWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .062,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .062,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .062,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .062,
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}

class TableStockReportWidget extends StatelessWidget {
  const TableStockReportWidget({
    Key? key,
    required this.catrgoryList,
    required this.itemCount,
    required this.catrgoryData,
  }) : super(key: key);

  final List<String> catrgoryList;
  final int itemCount;
  final List<String> catrgoryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kGreyTextColor.withOpacity(0.2),
          ),
          child: HorizontalList(
              padding: EdgeInsets.zero,
              itemCount: catrgoryList.length,
              itemBuilder: (_, i) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .095,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          catrgoryList[i],
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .095,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Icon(FeatherIcons.settings, color: kGreyTextColor),
                      ),
                    ).visible(i == catrgoryList.length - 1),
                  ],
                );
              }),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, ind) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: kWhiteTextColor,
                ),
                child: HorizontalList(
                    padding: EdgeInsets.zero,
                    itemCount: catrgoryData.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .095,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                i == 0 ? (ind + 1).toString() : catrgoryData[i],
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .095,
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: PopupMenuButton(
                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).edit,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).delete,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).share,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        lang.S.of(context).preview,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                            ),
                          ).visible(i == catrgoryData.length - 1),
                        ],
                      );
                    }),
              );
            }),
      ],
    );
  }
}
