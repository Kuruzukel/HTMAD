import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_overlay.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _waterGoalController = TextEditingController();
  final _exerciseGoalController = TextEditingController();
  final _sleepGoalController = TextEditingController();
  final _calorieGoalController = TextEditingController();
  
  String? _selectedGender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _waterGoalController.dispose();
    _exerciseGoalController.dispose();
    _sleepGoalController.dispose();
    _calorieGoalController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    if (user != null) {
      _nameController.text = user.name;
      _ageController.text = user.age?.toString() ?? '';
      _weightController.text = user.weight?.toString() ?? '';
      _heightController.text = user.height?.toString() ?? '';
      _waterGoalController.text = user.waterGoal.toString();
      _exerciseGoalController.text = user.exerciseGoal.toString();
      _sleepGoalController.text = user.sleepGoal.toString();
      _calorieGoalController.text = user.calorieGoal.toString();
      _selectedGender = user.gender;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.updateUserProfile(
        name: _nameController.text.trim(),
        age: _ageController.text.isNotEmpty ? int.parse(_ageController.text) : null,
        gender: _selectedGender,
        weight: _weightController.text.isNotEmpty ? double.parse(_weightController.text) : null,
        height: _heightController.text.isNotEmpty ? double.parse(_heightController.text) : null,
        waterGoal: int.parse(_waterGoalController.text),
        exerciseGoal: int.parse(_exerciseGoalController.text),
        sleepGoal: int.parse(_sleepGoalController.text),
        calorieGoal: int.parse(_calorieGoalController.text),
      );

      if (success && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
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
        title: const Text('Edit Profile'),
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
                _buildPersonalInfoSection(),
                SizedBox(height: 24.h),
                _buildPhysicalInfoSection(),
                SizedBox(height: 24.h),
                _buildGoalsSection(),
                SizedBox(height: 32.h),
                CustomButton(
                  text: 'Save Changes',
                  onPressed: _saveProfile,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
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
              'Personal Information',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: _ageController,
              label: 'Age (Optional)',
              hint: 'Enter your age',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final age = int.tryParse(value);
                  if (age == null || age < 1 || age > 150) {
                    return 'Please enter a valid age';
                  }
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            _buildGenderSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender (Optional)',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Male'),
                value: 'Male',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.primaryColor,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Female'),
                value: 'Female',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhysicalInfoSection() {
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
              'Physical Information',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _weightController,
                    label: 'Weight (kg)',
                    hint: 'Enter weight',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final weight = double.tryParse(value);
                        if (weight == null || weight <= 0 || weight > 500) {
                          return 'Invalid weight';
                        }
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomTextField(
                    controller: _heightController,
                    label: 'Height (cm)',
                    hint: 'Enter height',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final height = double.tryParse(value);
                        if (height == null || height <= 0 || height > 300) {
                          return 'Invalid height';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsSection() {
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
              'Daily Goals',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _waterGoalController,
                    label: 'Water (glasses)',
                    hint: 'Daily goal',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final goal = int.tryParse(value);
                      if (goal == null || goal <= 0) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomTextField(
                    controller: _exerciseGoalController,
                    label: 'Exercise (min)',
                    hint: 'Daily goal',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final goal = int.tryParse(value);
                      if (goal == null || goal <= 0) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _sleepGoalController,
                    label: 'Sleep (hours)',
                    hint: 'Daily goal',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final goal = int.tryParse(value);
                      if (goal == null || goal <= 0 || goal > 24) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomTextField(
                    controller: _calorieGoalController,
                    label: 'Calories',
                    hint: 'Daily goal',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final goal = int.tryParse(value);
                      if (goal == null || goal <= 0) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
