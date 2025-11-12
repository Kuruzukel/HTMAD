import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

import '../../../../core/theme/app_theme.dart';

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

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.secondaryColor.withValues(alpha: 0.1),
              AppTheme.primaryColor.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      color: AppTheme.secondaryColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Daily Motivation',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppTheme.secondaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.format_quote,
                      color: AppTheme.secondaryColor.withValues(alpha: 0.6),
                      size: 24.sp,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      quote['quote']!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontStyle: FontStyle.italic,
                        color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '— ${quote['author']}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Remember: Small consistent actions lead to big results!',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark 
                            ? AppTheme.darkTextSecondaryColor 
                            : AppTheme.lightTextSecondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
