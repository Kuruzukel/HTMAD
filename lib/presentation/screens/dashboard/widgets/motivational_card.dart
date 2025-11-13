import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

import '../../../../core/theme/app_theme.dart';
import '../../../widgets/glassmorphism_container.dart';

class MotivationalCard extends StatelessWidget {
  const MotivationalCard({super.key});

  static final List<Map<String, String>> _motivationalQuotes = [
    {
      'quote': 'Your body can do it. It\'s your mind you need to convince.',
      'author': 'Unknown'
    },
    {
      'quote': 'Health is not about the weight you lose, but about the life you gain.',
      'author': 'Unknown'
    },
    {
      'quote': 'Take care of your body. It\'s the only place you have to live.',
      'author': 'Jim Rohn'
    },
    {
      'quote': 'A healthy outside starts from the inside.',
      'author': 'Robert Urich'
    },
    {
      'quote': 'The groundwork for all happiness is good health.',
      'author': 'Leigh Hunt'
    },
    {
      'quote': 'To keep the body in good health is a duty... otherwise we shall not be able to keep our mind strong and clear.',
      'author': 'Buddha'
    },
    {
      'quote': 'Health is a state of complete harmony of the body, mind and spirit.',
      'author': 'B.K.S. Iyengar'
    },
    {
      'quote': 'The first wealth is health.',
      'author': 'Ralph Waldo Emerson'
    },
    {
      'quote': 'Your health is an investment, not an expense.',
      'author': 'Unknown'
    },
    {
      'quote': 'Every step you take is a step towards a healthier you.',
      'author': 'Unknown'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final quote = _getRandomQuote();

    return GlassmorphismContainer(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                AppTheme.secondaryColor.withValues(alpha: 0.15),
                AppTheme.primaryColor.withValues(alpha: 0.15),
              ]
            : [
                AppTheme.secondaryColor.withValues(alpha: 0.2),
                AppTheme.primaryColor.withValues(alpha: 0.2),
              ],
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.secondaryColor.withValues(alpha: 0.3),
                      AppTheme.primaryColor.withValues(alpha: 0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.lightbulb,
                  color: AppTheme.secondaryColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                'Daily Motivation',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.white.withValues(alpha: 0.04),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.9),
                        Colors.white.withValues(alpha: 0.7),
                      ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppTheme.secondaryColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.format_quote,
                  color: AppTheme.secondaryColor.withValues(alpha: 0.7),
                  size: 32.sp,
                ),
                SizedBox(height: 12.h),
                Text(
                  quote['quote']!,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontStyle: FontStyle.italic,
                    color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '— ${quote['author']}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.withValues(alpha: 0.2),
                  Colors.orange.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.amber.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Colors.amber[700],
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Small consistent actions lead to big results!',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _getRandomQuote() {
    final today = DateTime.now();
    final seed = today.year * 1000 + today.month * 100 + today.day;
    final randomWithSeed = Random(seed);
    final index = randomWithSeed.nextInt(_motivationalQuotes.length);
    return _motivationalQuotes[index];
  }
}
