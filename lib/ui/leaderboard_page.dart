import "package:aim_test/bloc/leaderboard/leaderboard_bloc.dart";
import "package:aim_test/bloc/leaderboard/leaderboard_event.dart";
import "package:aim_test/bloc/leaderboard/leaderboard_state.dart";
import "package:aim_test/bloc/period/period_bloc.dart";
import "package:aim_test/bloc/period/period_event.dart";
import "package:aim_test/bloc/period/period_state.dart";
import "package:aim_test/bloc/province/province_bloc.dart";
import "package:aim_test/bloc/province/province_event.dart";
import "package:aim_test/bloc/province/province_state.dart";
import "package:aim_test/bloc/sport/sport_bloc.dart";
import "package:aim_test/bloc/sport/sport_event.dart";
import "package:aim_test/bloc/sport/sport_state.dart";
import "package:aim_test/main.dart";
import "package:aim_test/model/community.dart";
import "package:aim_test/model/period.dart";
import "package:aim_test/model/province.dart";
import "package:aim_test/res/colors.dart";
import "package:aim_test/res/dimens.dart";
import "package:aim_test/ui/earn_point_bottom_sheet.dart";
import "package:aim_test/ui/period_bottom_sheet.dart";
import "package:aim_test/widget/custom_button.dart";
import "package:aim_test/widget/custom_dropdown.dart";
import "package:aim_test/widget/custom_shimmer.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:easy_localization/easy_localization.dart";
import "package:responsive_framework/responsive_framework.dart";

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LeaderboardBloc()..add(LoadLeaderboard())),
        BlocProvider(create: (_) => SportBloc()..add(LoadSports())),
        BlocProvider(create: (_) => ProvinceBloc()..add(LoadProvinces())),
        BlocProvider(create: (_) => PeriodBloc()..add(LoadPeriods())),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            tr("leaderboard_title"),
          ),
          actions: [
            InkWell(
              onTap: () => _showInfo(context),
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: ColorResources.primaryDark.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/drawable/question_mark.png",
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Dimens.paddingWidget),
            _buildPopUpLanguageButton(context: context),
          ],
        ),
        body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) {
            if (state is LeaderboardLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (state is LeaderboardLoaded) {
              List<Community> communities = state.communities;
              return communities.isEmpty
                  ? _buildEmptyLeaderBoard(context: context)
                  : _buildLeaderboard(context: context, communities: communities);
            } else if (state is LeaderboardError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Future<void> _showPeriod(BuildContext context) async {
    bool smallScreen = ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET);
    var result = !smallScreen && context.mounted
        ? await showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<PeriodBloc>(),
              child: Dialog(
                child: Container(
                  padding: EdgeInsets.all(Dimens.paddingSmall),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(Dimens.borderRadiusCircular)),
                    color: ColorResources.background,
                  ),
                  width: 0.6 * (MediaQuery.of(context).size.width * 0.8),
                  child: const SelectPeriodWidget(),
                ),
              ),
            ),
          )
        : context.mounted
            ? await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => BlocProvider.value(
                  value: context.read<PeriodBloc>(),
                  child: const SelectPeriodWidget(),
                ),
              )
            : null;
    if (context.mounted && result != null && result is Period) {
      context.read<PeriodBloc>().add(SelectPeriod(result.id));

      SportState sportState = context.read<SportBloc>().state;
      String? sportId = sportState is SportLoaded ? sportState.selected?.id : null;
      ProvinceState provinceState = context.read<ProvinceBloc>().state;
      String? provinceCode = provinceState is ProvinceLoaded ? provinceState.selected?.code : null;

      context.read<LeaderboardBloc>().add(FilterLeaderboard(
            sportId: sportId,
            provinceCode: provinceCode,
            periodId: result.id,
          ));
    }
  }

  Future<void> _showInfo(BuildContext context) async {
    bool smallScreen = ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET);
    !smallScreen && context.mounted
        ? showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Container(
                padding: EdgeInsets.all(Dimens.paddingSmall),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(Dimens.borderRadiusCircular)),
                  color: ColorResources.background,
                ),
                width: 0.6 * (MediaQuery.of(context).size.width * 0.8),
                child: const EarnPointWidget(),
              ),
            ),
          )
        : context.mounted
            ? showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const EarnPointWidget(),
              )
            : null;
  }

  Widget _buildPeriod({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.paddingMedium),
      child: BlocBuilder<PeriodBloc, PeriodState>(
        builder: (context, periodState) {
          if (periodState is PeriodLoaded) {
            Period period = periodState.selected ?? periodState.periods.first;
            return InkWell(
              onTap: () => _showPeriod(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    period.label,
                    style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(fontSize: Dimens.fontLarge),
                  ),
                  const SizedBox(width: Dimens.paddingSmall),
                  Icon(
                    Icons.expand_circle_down,
                    color: ColorResources.textInverse,
                    size: Dimens.fontLarge,
                  ),
                ],
              ),
            );
          }
          return const CustomShimmer(width: double.infinity, height: Dimens.shimmerHeightSmall);
        },
      ),
    );
  }

  Widget _buildFilter({required BuildContext context}) {
    bool smallScreen = ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium, vertical: Dimens.paddingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: BlocBuilder<SportBloc, SportState>(
              builder: (context, sportState) {
                if (sportState is SportLoaded) {
                  return CustomDropdown(
                    value: sportState.selected?.id,
                    items: sportState.sports
                        .map((sport) => DropdownMenuItem(
                              value: sport.id,
                              child: Text(sport.name),
                            ))
                        .toList(),
                    onChanged: (sportId) {
                      if (sportId != null) {
                        context.read<SportBloc>().add(SelectSport(sportId));
                        PeriodState periodState = context.read<PeriodBloc>().state;
                        String? periodId = periodState is PeriodLoaded ? periodState.selected?.id : null;
                        ProvinceState provinceState = context.read<ProvinceBloc>().state;
                        String? provinceCode = provinceState is ProvinceLoaded ? provinceState.selected?.code : null;

                        context.read<LeaderboardBloc>().add(FilterLeaderboard(
                              sportId: sportId,
                              provinceCode: provinceCode,
                              periodId: periodId,
                            ));
                      }
                    },
                  );
                }
                return const CustomShimmer(width: double.infinity, height: Dimens.shimmerHeightSmall);
              },
            ),
          ),
          const SizedBox(width: Dimens.paddingSmall),
          Expanded(
            child: BlocBuilder<ProvinceBloc, ProvinceState>(
              builder: (context, provinceState) {
                if (provinceState is ProvinceLoaded) {
                  List<Province> provinces = provinceState.provinces;
                  provinces.sort(Province.nameComparator);

                  return CustomDropdown(
                    value: provinceState.selected?.code,
                    items: provinceState.provinces
                        .map((province) => DropdownMenuItem(
                              value: province.code,
                              child: Text(
                                smallScreen ? province.acronym : province.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    onChanged: (provinceCode) {
                      if (provinceCode != null) {
                        context.read<ProvinceBloc>().add(SelectProvince(provinceCode));
                        PeriodState periodState = context.read<PeriodBloc>().state;
                        String? periodId = periodState is PeriodLoaded ? periodState.selected?.id : null;
                        SportState sportState = context.read<SportBloc>().state;
                        String? sportId = sportState is SportLoaded ? sportState.selected?.id : null;

                        context.read<LeaderboardBloc>().add(FilterLeaderboard(
                              sportId: sportId,
                              provinceCode: provinceCode,
                              periodId: periodId,
                            ));
                      }
                    },
                  );
                }
                return const CustomShimmer(width: double.infinity, height: Dimens.shimmerHeightSmall);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopUpLanguageButton({required BuildContext context}) {
    String languageCode = context.locale.languageCode;

    Widget idWidget = Tooltip(
      message: "Bahasa Indonesia",
      child: Image.asset(
        "assets/drawable/indonesia.png",
        width: Dimens.iconSize,
        height: Dimens.iconSize,
      ),
    );

    Widget enWidget = Tooltip(
      message: "English",
      child: Image.asset(
        "assets/drawable/united-states.png",
        width: Dimens.iconSize,
        height: Dimens.iconSize,
      ),
    );

    List<PopupMenuItem> popUpButtons = [
      PopupMenuItem(
        value: "en",
        child: enWidget,
        onTap: () {
          context.setLocale(Locale("en", "US"));
          EasyLocalization.of(context)?.setLocale(Locale("en", "US"));
        },
      ),
      PopupMenuItem(
        value: "id",
        child: idWidget,
        onTap: () {
          context.setLocale(Locale("id", ""));
          EasyLocalization.of(context)?.setLocale(Locale("id", ""));
        },
      ),
    ];

    return PopupMenuButton(
      itemBuilder: (context) => popUpButtons,
      tooltip: "",
      child: Padding(
        padding: EdgeInsets.all(Dimens.paddingSmall),
        child: languageCode == "id" ? idWidget : enWidget,
      ),
    );
  }

  Widget _buildEmptyLeaderBoard({required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/drawable/bg.png"),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Column(
        children: [
          _buildPeriod(context: context),
          _buildFilter(context: context),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/drawable/empty.png",
                  width: Dimens.imageSizeMedium,
                ),
                const SizedBox(height: Dimens.paddingSmall),
                Text(
                  tr("common_empty_leaderboard_title"),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorResources.textInverse),
                ),
                Text(
                  tr("common_empty_leaderboard_message"),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: ColorResources.textInverse),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimens.paddingSmall),
                CustomButton(
                  label: Text(
                    tr("start_competition"),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorResources.primary),
                  ),
                  backgroundColor: ColorResources.background,
                  onPressed: () => messengerKey.currentState?.showSnackBar(SnackBar(content: Text(tr("comming_soon")))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLeaderboard({required BuildContext context, required List<Community> communities}) {
    List<Community> top3 = [];
    if (communities.length >= 3) {
      top3 = communities.take(3).toList();
    } else {
      top3 = List.from(communities);
    }
    List<Community> others = communities.length > 3 ? communities.skip(3).toList() : [];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/drawable/bg.png"),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Column(
        children: [
          _buildPeriod(context: context),
          _buildFilter(context: context),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: Dimens.paddingMedium,
                right: Dimens.paddingMedium,
                bottom: -37,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorResources.primaryDark.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(Dimens.borderRadius)),
                  ),
                  padding: const EdgeInsets.all(Dimens.paddingSmall),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr("your_community_rank", args: ["456"]),
                        style: TextStyle(color: ColorResources.textInverse),
                        textAlign: TextAlign.left,
                      ),
                      Icon(Icons.share_outlined, size: Dimens.fontLarge, color: ColorResources.textInverse),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium, vertical: 0),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: Dimens.paddingSmall),
                  leading: const Icon(Icons.language_outlined, color: Colors.orange),
                  title: const Text("Far East United"),
                  subtitle: Text("Surabaya"),
                  trailing: Container(
                    width: Dimens.buttonHeight / 1.2,
                    height: 17,
                    decoration: BoxDecoration(
                      color: ColorResources.primary,
                      borderRadius: BorderRadius.circular(Dimens.borderRadiusCircular),
                    ),
                    child: Text(
                      "50 Pts",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Dimens.fontSmall,
                        color: ColorResources.textInverse,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.paddingLarge),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: Dimens.paddingLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _podiumTile(top3[1], 2, Colors.teal, 100),
                      _podiumTile(top3[0], 1, Colors.deepPurple, 125),
                      _podiumTile(top3[2], 3, Colors.pink, 75),
                    ],
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.linear_scale_sharp),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: others.length,
                          itemBuilder: (context, index) {
                            Community community = others[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingSmall),
                              child: Row(
                                children: [
                                  Text(
                                    "${community.rank}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: Dimens.paddingSmall),
                                  Expanded(
                                    child: ListTile(
                                      leading: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(Dimens.borderRadiusCircular),
                                        ),
                                        padding: EdgeInsets.all(Dimens.paddingGap),
                                        child: ClipOval(
                                          child: Image.network(
                                            community.logoUrl,
                                            height: 28,
                                            width: 28,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      title: Text(community.name),
                                      subtitle: Text(community.province),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            index == 2 ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                                            size: Dimens.headlineLarge,
                                            color: index == 2 ? Colors.red : Colors.green,
                                          ),
                                          Text("${community.points} Pts"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingSmall),
                            child: Divider(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _podiumTile(Community community, int position, Color color, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(Dimens.borderRadiusCircular),
          ),
          padding: EdgeInsets.all(Dimens.paddingGap),
          child: ClipOval(
            child: Image.network(
              community.logoUrl,
              height: 48,
              width: 48,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          community.name,
          style: TextStyle(
            color: ColorResources.textInverse,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorResources.background,
            borderRadius: BorderRadius.circular(Dimens.borderRadiusCircular),
          ),
          padding: EdgeInsets.all(Dimens.paddingGap),
          child: Text(
            "${community.points} pts",
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: Dimens.paddingSmall),
        Container(
          height: height,
          width: 80,
          decoration: BoxDecoration(
            color: ColorResources.primaryDark.withValues(alpha: 0.7),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimens.borderRadius)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "$position",
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
