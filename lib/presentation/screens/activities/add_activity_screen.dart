import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/activity_provider.dart';
import '../../../data/models/activity_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_overlay.dart';

class AddActivityScreen extends StatefulWidget {
  final ActivityType? activityType;
  final ActivityModel? activity;

  const AddActivityScreen({
    super.key,
    this.activityType,
    this.activity,
  });

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _notesController = TextEditingController();
  
  late ActivityType _selectedType;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.activityType ?? ActivityType.water;
    
    if (widget.activity != null) {
      _valueController.text = widget.activity!.value.toString();
      _notesController.text = widget.activity!.notes ?? '';
      _selectedDate = widget.activity!.date;
      _selectedTime = TimeOfDay.fromDateTime(widget.activity!.time);
      _selectedType = widget.activity!.type;
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String get _title => widget.activity != null 
      ? 'Edit ${_selectedType.displayName}'
      : 'Add ${_selectedType.displayName}';

  String get _valueLabel {
    switch (_selectedType) {
      case ActivityType.water:
        return 'Glasses of Water';
      case ActivityType.exercise:
        return 'Minutes';
      case ActivityType.sleep:
        return 'Hours';
      case ActivityType.meal:
        return 'Calories';
    }
  }

  String get _valueHint {
    switch (_selectedType) {
      case ActivityType.water:
        return 'Enter number of glasses';
      case ActivityType.exercise:
        return 'Enter minutes exercised';
      case ActivityType.sleep:
        return 'Enter hours slept';
      case ActivityType.meal:
        return 'Enter calories consumed';
    }
  }

  String get _unit {
    switch (_selectedType) {
      case ActivityType.water:
        return 'glasses';
      case ActivityType.exercise:
        return 'minutes';
      case ActivityType.sleep:
        return 'hours';
      case ActivityType.meal:
        return 'calories';
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveActivity() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
      
      if (authProvider.user == null) return;

      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final activity = ActivityModel(
        id: widget.activity?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        userId: authProvider.user!.id,
        type: _selectedType,
        value: double.parse(_valueController.text),
        unit: _unit,
        date: _selectedDate,
        time: dateTime,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        createdAt: widget.activity?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success;
      if (widget.activity != null) {
        success = await activityProvider.updateActivity(activity);
      } else {
        success = await activityProvider.addActivity(activity);
      }

      if (success && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.activity != null 
                  ? 'Activity updated successfully'
                  : 'Activity added successfully',
            ),
            backgroundColor: AppTheme.secondaryColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.accentColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        elevation: 0,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Show type selector only when adding new activity from "All" tab
                if (widget.activityType == null && widget.activity == null)
                  _buildTypeSelector(),
                if (widget.activityType == null && widget.activity == null)
                  SizedBox(height: 24.h),
                _buildActivityTypeCard(),
                SizedBox(height: 24.h),
                _buildValueInput(),
                SizedBox(height: 24.h),
                _buildDateTimeSection(),
                SizedBox(height: 24.h),
                _buildNotesInput(),
                SizedBox(height: 32.h),
                CustomButton(
                  text: widget.activity != null ? 'Update Activity' : 'Save Activity',
                  onPressed: _saveActivity,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Activity Type',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ActivityType.values.map((type) {
                final isSelected = _selectedType == type;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _getColorForType(type).withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color: isSelected
                                ? _getColorForType(type)
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            type.icon,
                            style: TextStyle(fontSize: 28.sp),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        type.displayName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? _getColorForType(type) : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTypeCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: _getActivityColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Center(
                child: Text(
                  _selectedType.icon,
                  style: TextStyle(fontSize: 40.sp),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              _selectedType.displayName,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: _getActivityColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueInput() {
    return CustomTextField(
      controller: _valueController,
      label: _valueLabel,
      hint: _valueHint,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        final numValue = double.tryParse(value);
        if (numValue == null || numValue <= 0) {
          return 'Please enter a valid positive number';
        }
        return null;
      },
    );
  }

  Widget _buildDateTimeSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date & Time',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildDateSelector(),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildTimeSelector(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16.sp,
                  color: AppTheme.primaryColor,
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return InkWell(
      onTap: _selectTime,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16.sp,
                  color: AppTheme.primaryColor,
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    _selectedTime.format(context),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesInput() {
    return CustomTextField(
      controller: _notesController,
      label: 'Notes (Optional)',
      hint: 'Add any additional notes...',
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Color _getActivityColor() {
    return _getColorForType(_selectedType);
  }

  Color _getColorForType(ActivityType type) {
    switch (type) {
      case ActivityType.water:
        return Colors.blue;
      case ActivityType.exercise:
        return Colors.orange;
      case ActivityType.sleep:
        return Colors.purple;
      case ActivityType.meal:
        return Colors.green;
    }
  }
}
