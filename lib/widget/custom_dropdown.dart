import "package:aim_test/res/dimens.dart";
import "package:flutter/material.dart";

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.buttonHeightSmall,
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingSmall),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimens.borderRadius),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: value,
          hint: Text(hint ?? ""),
          icon: const Icon(Icons.arrow_drop_down),
          style: const TextStyle(color: Colors.black, fontSize: Dimens.fontDefault),
          onChanged: onChanged,
          items: items,
        ),
      ),
    );
  }
}
