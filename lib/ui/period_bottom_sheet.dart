import 'package:aim_test/bloc/period/period_bloc.dart';
import 'package:aim_test/bloc/period/period_event.dart';
import 'package:aim_test/bloc/period/period_state.dart';
import 'package:aim_test/model/period.dart';
import 'package:aim_test/res/colors.dart';
import 'package:aim_test/res/dimens.dart';
import 'package:aim_test/widget/custom_button.dart';
import 'package:aim_test/widget/custom_shimmer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeriodBottomSheet extends StatelessWidget {
  const PeriodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.paddingSmall),
        child: Column(
          children: [
            ListTile(
              title: Text(
                tr("period_title"),
                style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: ColorResources.text),
              ),
              trailing: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close),
              ),
            ),
            BlocBuilder<PeriodBloc, PeriodState>(
              builder: (context, periodState) {
                if (periodState is PeriodLoaded) {
                  List<Period> periods = periodState.periods;
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: periods.length,
                    itemBuilder: (context, index) {
                      Period period = periods.elementAt(index);
                      bool isSelected = periodState.selected?.id == period.id;
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.all(Dimens.paddingSmall),
                        title: Text(period.label),
                        subtitle: period.isCurrent ? Text(tr("current_season")) : null,
                        trailing: Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          color: isSelected ? ColorResources.primary : ColorResources.icon,
                        ),
                        onTap: () => context.read<PeriodBloc>().add(SelectPeriod(period)),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                  );
                }
                return const CustomShimmer(width: double.infinity, height: Dimens.shimmerHeightSmall);
              },
            ),
            BlocBuilder<PeriodBloc, PeriodState>(
              builder: (context, periodState) {
                Period? selected = (periodState is PeriodLoaded) ? periodState.selected : null;

                return SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: Text(tr("action_apply")),
                    backgroundColor: selected?.id == "all" ? ColorResources.disable : ColorResources.primary,
                    onPressed: selected?.id == "all" ? null : () => Navigator.of(context).pop(selected),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
