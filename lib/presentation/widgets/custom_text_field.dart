import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? initialValue;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.initialValue,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            onFieldSubmitted: widget.onSubmitted,
            inputFormatters: widget.inputFormatters,
            autofocus: widget.autofocus,
            textCapitalization: widget.textCapitalization,
            style: TextStyle(
              fontSize: 16.sp,
              color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: isDark 
                    ? AppTheme.darkTextSecondaryColor 
                    : AppTheme.lightTextSecondaryColor,
                fontFamily: 'Poppins',
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused
                          ? AppTheme.primaryColor
                          : (isDark 
                              ? AppTheme.darkTextSecondaryColor 
                              : AppTheme.lightTextSecondaryColor),
                      size: 20.sp,
                    )
                  : null,
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: isDark 
                  ? AppTheme.darkSurfaceColor 
                  : AppTheme.lightSurfaceColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark 
                      ? Colors.grey.shade600 
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark 
                      ? Colors.grey.shade600 
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppTheme.accentColor,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppTheme.accentColor,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              counterStyle: TextStyle(
                fontSize: 12.sp,
                color: isDark 
                    ? AppTheme.darkTextSecondaryColor 
                    : AppTheme.lightTextSecondaryColor,
              ),
              errorStyle: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.accentColor,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final void Function(String)? onChanged;
  final void Function()? onClear;
  final bool showClearButton;

  const CustomSearchField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onClear,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 16.sp,
          color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
          fontFamily: 'Poppins',
        ),
        decoration: InputDecoration(
          hintText: hint ?? 'Search...',
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: isDark 
                ? AppTheme.darkTextSecondaryColor 
                : AppTheme.lightTextSecondaryColor,
            fontFamily: 'Poppins',
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark 
                ? AppTheme.darkTextSecondaryColor 
                : AppTheme.lightTextSecondaryColor,
            size: 20.sp,
          ),
          suffixIcon: showClearButton && 
                      controller != null && 
                      controller!.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: isDark 
                        ? AppTheme.darkTextSecondaryColor 
                        : AppTheme.lightTextSecondaryColor,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    controller!.clear();
                    if (onClear != null) onClear!();
                    if (onChanged != null) onChanged!('');
                  },
                )
              : null,
          filled: true,
          fillColor: isDark 
              ? AppTheme.darkSurfaceColor 
              : AppTheme.lightSurfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }
}
