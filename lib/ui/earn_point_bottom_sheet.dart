import 'package:aim_test/res/colors.dart';
import 'package:aim_test/res/dimens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EarnPointBottomSheet extends StatelessWidget {
  const EarnPointBottomSheet({super.key});

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
                tr("earn_point_title"),
                style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: ColorResources.text),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close),
              ),
            ),
            Text(
              tr("earn_point_message"),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Dimens.paddingSmall),
            Text(
              tr("match_results"),
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: ColorResources.text),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _buildMatch(tr("common_win"), "+100 Pts", Colors.green),
                  const SizedBox(height: Dimens.paddingSmall),
                  _buildMatch(tr("common_draw"), "+50 Pts", Colors.green),
                  const SizedBox(height: Dimens.paddingSmall),
                  _buildMatch(tr("common_lose"), "-50 Pts", Colors.red),
                ],
              ),
            ),
            const SizedBox(height: Dimens.paddingSmall),
            Text(
              tr("bonus_point"),
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: ColorResources.text),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      tr("winning_bonus"),
                      style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: ColorResources.text),
                    ),
                    trailing: Text("n x 5 Pts"),
                  ),
                  Text(tr("winning_bonus_description")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatch(String title, String point, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(
            point,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
