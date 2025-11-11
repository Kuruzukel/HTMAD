import '../models/user_model.dart';
import '../../core/services/database_service.dart';

class UserRepository {
  static const String _tableName = 'users';

  Future<UserModel?> getUserById(String id) async {
    try {
      final results = await DatabaseService.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isNotEmpty) {
        return UserModel.fromMap(results.first);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final results = await DatabaseService.query(
        _tableName,
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (results.isNotEmpty) {
        return UserModel.fromMap(results.first);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get user by email: $e');
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await DatabaseService.insert(_tableName, user.toMap());

      // Add to sync queue for Firebase sync
      await DatabaseService.addToSyncQueue(
        _tableName,
        user.id,
        'CREATE',
        user.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      final updatedUser = user.copyWith(
        updatedAt: DateTime.now(),
        synced: false,
      );

      await DatabaseService.update(
        _tableName,
        updatedUser.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );

      // Add to sync queue for Firebase sync
      await DatabaseService.addToSyncQueue(
        _tableName,
        user.id,
        'UPDATE',
        updatedUser.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await DatabaseService.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      // Add to sync queue for Firebase sync
      await DatabaseService.addToSyncQueue(_tableName, id, 'DELETE', {
        'id': id,
      });
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final results = await DatabaseService.query(_tableName);
      return results.map((map) => UserModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }

  Future<List<UserModel>> getUnsyncedUsers() async {
    try {
      final results = await DatabaseService.query(
        _tableName,
        where: 'synced = ?',
        whereArgs: [0],
      );
      return results.map((map) => UserModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get unsynced users: $e');
    }
  }

  Future<void> markUserAsSynced(String id) async {
    try {
      await DatabaseService.update(
        _tableName,
        {'synced': 1, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to mark user as synced: $e');
    }
  }

  Future<bool> userExists(String id) async {
    try {
      final results = await DatabaseService.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return results.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check if user exists: $e');
    }
  }
}
