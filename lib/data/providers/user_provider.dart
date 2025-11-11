import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;
  
  final UserRepository _userRepository = UserRepository();
  
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<void> loadUser(String userId) async {
    _setLoading(true);
    
    try {
      _user = await _userRepository.getUserById(userId);
      _clearError();
    } catch (e) {
      _setError('Failed to load user: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> updateUser(UserModel user) async {
    _setLoading(true);
    
    try {
      await _userRepository.updateUser(user);
      _user = user;
      _clearError();
      return true;
    } catch (e) {
      _setError('Failed to update user: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> updateGoals({
    int? waterGoal,
    int? exerciseGoal,
    int? sleepGoal,
    int? calorieGoal,
  }) async {
    if (_user == null) return false;
    
    final updatedUser = _user!.copyWith(
      waterGoal: waterGoal,
      exerciseGoal: exerciseGoal,
      sleepGoal: sleepGoal,
      calorieGoal: calorieGoal,
      updatedAt: DateTime.now(),
    );
    
    return await updateUser(updatedUser);
  }
  
  Future<bool> updatePersonalInfo({
    String? name,
    int? age,
    String? gender,
    double? weight,
    double? height,
  }) async {
    if (_user == null) return false;
    
    final updatedUser = _user!.copyWith(
      name: name,
      age: age,
      gender: gender,
      weight: weight,
      height: height,
      updatedAt: DateTime.now(),
    );
    
    return await updateUser(updatedUser);
  }
  
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
  
  void clearUser() {
    _user = null;
    _clearError();
    notifyListeners();
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  void clearError() {
    _clearError();
  }
}
