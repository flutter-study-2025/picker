import 'package:flutter/material.dart';
import 'picker_theme.dart';

class PickerWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final PickerTheme theme;
  final bool showConfirmButton;
  final bool showCancelButton;
  final String confirmText;
  final String cancelText;

  const PickerWrapper({
    Key? key,
    required this.title,
    required this.child,
    this.onConfirm,
    this.onCancel,
    this.theme = const PickerTheme(),
    this.showConfirmButton = true,
    this.showCancelButton = true,
    this.confirmText = '확인',
    this.cancelText = '취소',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(theme.borderRadius),
          topRight: Radius.circular(theme.borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Flexible(child: child),
          if (showConfirmButton || showCancelButton) _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.primaryColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showCancelButton)
            TextButton(
              onPressed: () {
                if (onCancel != null) {
                  onCancel!();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                cancelText,
                style: theme.itemStyle.copyWith(color: theme.primaryColor.withOpacity(0.8)),
              ),
            )
          else
            const SizedBox(width: 48),
          Text(
            title,
            style: theme.titleStyle,
          ),
          if (showConfirmButton)
            TextButton(
              onPressed: onConfirm ?? () => Navigator.of(context).pop(),
              child: Text(
                confirmText,
                style: theme.itemStyle.copyWith(color: theme.primaryColor),
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (showCancelButton)
            Expanded(
              child: TextButton(
                onPressed: () {
                  if (onCancel != null) {
                    onCancel!();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: theme.textColor,
                ),
                child: Text(cancelText),
              ),
            ),
          if (showConfirmButton)
            Expanded(
              child: ElevatedButton(
                onPressed: onConfirm ?? () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.selectedTextColor,
                ),
                child: Text(confirmText),
              ),
            ),
        ],
      ),
    );
  }
}

// Picker 위젯을 표시하는 함수
Future<T?> showPickerModal<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  PickerTheme? theme,
  bool isDismissible = true,
  bool useRootNavigator = true,
  bool showConfirmButton = true,
  bool showCancelButton = true,
  String confirmText = '확인',
  String cancelText = '취소',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  final pickerTheme = theme ?? const PickerTheme();
  
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    useRootNavigator: useRootNavigator,
    backgroundColor: Colors.transparent,
    builder: (context) => PickerWrapper(
      title: title,
      theme: pickerTheme,
      showConfirmButton: showConfirmButton,
      showCancelButton: showCancelButton,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      child: child,
    ),
  );
}
