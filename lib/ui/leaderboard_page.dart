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
import "package:aim_test/model/community.dart";
import "package:aim_test/model/period.dart";
import "package:aim_test/model/province.dart";
import "package:aim_test/res/colors.dart";
import "package:aim_test/res/dimens.dart";
import "package:aim_test/ui/period_bottom_sheet.dart";
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
            Container(
              width: 20,
              height: 20,
              padding: EdgeInsets.all(Dimens.paddingSmall),
              decoration: BoxDecoration(
                color: ColorResources.primaryLight,
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: AssetImage("assets/drawable/question_mark.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: Dimens.paddingWidget),
          ],
        ),
        body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) {
            if (state is LeaderboardLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (state is LeaderboardLoaded) {
              return _buildLeaderboard(context: context, communities: state.communities);
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
    var result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<PeriodBloc>(),
        child: const PeriodBottomSheet(),
      ),
    );
    if (context.mounted && result != null && result is Period) {
      context.read<PeriodBloc>().add(SelectPeriod(result));
    }
  }

  Widget _buildLeaderboard({required BuildContext context, required List<Community> communities}) {
    bool smallScreen = ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET);
    List<Community> top3 = communities.take(3).toList();
    List<Community> others = communities.skip(3).toList();

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/drawable/bg.png"),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: Column(
          children: [
            BlocBuilder<PeriodBloc, PeriodState>(
              builder: (context, periodState) {
                if (periodState is PeriodLoaded) {
                  Period period = periodState.selected ?? periodState.periods.first;
                  return InkWell(
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
                    onTap: () => _showPeriod(context),
                  );
                }
                return const CustomShimmer(width: double.infinity, height: Dimens.shimmerHeightSmall);
              },
            ),
            Padding(
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
                            onChanged: (sport) {
                              if (sport != null) {
                                context.read<SportBloc>().add(SelectSport(sport));
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
                            onChanged: (province) {
                              if (province != null) {
                                context.read<ProvinceBloc>().add(SelectProvince(province));
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
            ),
            const SizedBox(height: Dimens.paddingSmall),
            Wrap(
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium, vertical: 0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: Dimens.paddingSmall),
                    leading: const Icon(Icons.groups, color: Colors.orange),
                    title: const Text("Far East United"),
                    subtitle: Text("Surabaya"),
                    trailing: const Text("50 Pts", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium),
                  child: Container(
                    width: double.infinity,
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
              ],
            ),
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
              child: ListView.separated(
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
                            subtitle: Text(community.city),
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
            ),
          ],
        ),
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
