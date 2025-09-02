import "package:aim_test/bloc/leaderboard/leaderboard_bloc.dart";
import "package:aim_test/bloc/leaderboard/leaderboard_event.dart";
import "package:aim_test/bloc/leaderboard/leaderboard_state.dart";
import "package:aim_test/bloc/province/province_bloc.dart";
import "package:aim_test/bloc/province/province_event.dart";
import "package:aim_test/bloc/province/province_state.dart";
import "package:aim_test/bloc/sport/sport_bloc.dart";
import "package:aim_test/bloc/sport/sport_event.dart";
import "package:aim_test/bloc/sport/sport_state.dart";
import "package:aim_test/model/community.dart";
import "package:aim_test/res/dimens.dart";
import "package:aim_test/widget/custom_dropdown.dart";
import "package:aim_test/widget/custom_shimmer.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:easy_localization/easy_localization.dart";

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LeaderboardBloc()..add(LoadLeaderboard())),
        BlocProvider(create: (_) => SportBloc()..add(LoadSports())),
        BlocProvider(create: (_) => ProvinceBloc()..add(LoadProvinces())),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            tr("leaderboard_title"),
          ),
          actions: [
            Icon(Icons.question_answer_outlined),
            const SizedBox(width: Dimens.paddingWidget),
          ],
        ),
        body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) {
            if (state is LeaderboardLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (state is LeaderboardLoaded) {
              return _buildLeaderboard(context, state.communities);
            } else if (state is LeaderboardError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context, List<Community> communities) {
    final List<Community> top3 = communities.take(3).toList();
    final List<Community> others = communities.skip(3).toList();

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium, vertical: Dimens.paddingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlocBuilder<SportBloc, SportState>(
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
                    return Expanded(
                      child: const CustomShimmer(width: double.infinity, height: Dimens.shimmerHeightSmall),
                    );
                  },
                ),
                const SizedBox(width: Dimens.paddingSmall),
                BlocBuilder<ProvinceBloc, ProvinceState>(
                  builder: (context, provinceState) {
                    if (provinceState is ProvinceLoaded) {
                      return CustomDropdown(
                        value: provinceState.selected?.code,
                        items: provinceState.provinces
                            .map((province) => DropdownMenuItem(
                                  value: province.code,
                                  child: Text(province.name),
                                ))
                            .toList(),
                        onChanged: (province) {
                          if (province != null) {
                            context.read<ProvinceBloc>().add(SelectProvince(province));
                          }
                        },
                      );
                    }
                    return Expanded(
                      child: const CustomShimmer(width: double.infinity, height: Dimens.shimmerHeightSmall),
                    );
                  },
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium, vertical: 0),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: Dimens.paddingSmall),
              leading: const Icon(Icons.groups, color: Colors.orange),
              title: const Text("Far East United"),
              subtitle: Text(tr("surabaya")),
              trailing: const Text("50 Pts", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                tr("your_community_rank", args: ["456"]),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _podiumTile(top3[1], 2, Colors.teal, 120),
                _podiumTile(top3[0], 1, Colors.deepPurple, 150),
                _podiumTile(top3[2], 3, Colors.pink, 100),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView.builder(
                itemCount: others.length,
                itemBuilder: (context, index) {
                  final community = others[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: Dimens.paddingSmall),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Text("${community.rank}"),
                    ),
                    title: Text(community.name),
                    subtitle: Text(community.city),
                    trailing: Text("${community.points} Pts"),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _podiumTile(Community c, int position, Color color, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: height,
          width: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$position",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                c.name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                "${c.points} Pts",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
