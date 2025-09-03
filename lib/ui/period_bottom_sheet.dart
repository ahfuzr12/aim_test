import 'package:aim_test/bloc/period/period_bloc.dart';
import 'package:aim_test/bloc/period/period_state.dart';
import 'package:aim_test/model/period.dart';
import 'package:aim_test/res/colors.dart';
import 'package:aim_test/res/dimens.dart';
import 'package:aim_test/widget/custom_button.dart';
import 'package:aim_test/widget/custom_shimmer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectPeriodWidget extends StatefulWidget {
  const SelectPeriodWidget({super.key});

  @override
  State<SelectPeriodWidget> createState() => _SelectPeriodWidgetState();
}

class _SelectPeriodWidgetState extends State<SelectPeriodWidget> {
  Period? _tempSelected; // pilihan sementara (belum commit ke Bloc)

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
                icon: const Icon(Icons.close),
              ),
            ),
            BlocBuilder<PeriodBloc, PeriodState>(
              builder: (context, periodState) {
                if (periodState is PeriodLoaded) {
                  final periods = periodState.periods;
                  final current = _tempSelected ?? periodState.selected;

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: periods.length,
                    itemBuilder: (context, index) {
                      final period = periods[index];
                      final isSelected = current?.id == period.id;

                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.all(Dimens.paddingSmall),
                        title: Text(period.label),
                        subtitle: period.isCurrent ? Text(tr("current_season")) : null,
                        trailing: Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          color: isSelected ? ColorResources.primary : ColorResources.icon,
                        ),
                        onTap: () => setState(() => _tempSelected = period),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                  );
                }

                if (periodState is PeriodLoading) {
                  return const CustomShimmer(width: double.infinity, height: Dimens.shimmerHeightSmall);
                }

                if (periodState is PeriodError) {
                  return Padding(
                    padding: const EdgeInsets.all(Dimens.paddingSmall),
                    child: Text(periodState.message),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: Dimens.paddingMedium),
            BlocBuilder<PeriodBloc, PeriodState>(
              builder: (context, periodState) {
                Period? selected = _tempSelected;
                if (selected == null && periodState is PeriodLoaded) {
                  selected = periodState.selected;
                }

                final bool disabled = selected == null || selected.id == "all";

                return SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: Text(tr("action_apply")),
                    backgroundColor: disabled ? ColorResources.disable : ColorResources.primary,
                    onPressed: disabled ? null : () => Navigator.of(context).pop(selected),
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
