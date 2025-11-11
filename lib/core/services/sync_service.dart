import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'database_service.dart';
import 'firebase_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  /// Initialize sync service and set up connectivity listener
  static Future<void> initialize() async {
    final connectivity = Connectivity();

    // Listen for connectivity changes
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        // Connection restored, attempt sync
        SyncService().syncPendingChanges();
      }
    });
  }

  /// Check if device is connected to internet
  Future<bool> isConnected() async {
    try {
      final connectivity = Connectivity();
      final result = await connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking connectivity: $e');
      }
      return false;
    }
  }

  /// Sync all pending changes to Firebase
  Future<bool> syncPendingChanges() async {
    if (_isSyncing || !FirebaseService.isInitialized) return false;

    final connected = await isConnected();
    if (!connected) return false;

    _isSyncing = true;

    try {
      final pendingItems = await DatabaseService.getPendingSyncItems();

      for (final item in pendingItems) {
        await _processSyncItem(item);
      }

      if (kDebugMode) {
        print(
            'Sync completed successfully. Processed ${pendingItems.length} items.');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Sync failed: $e');
      }
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  /// Process individual sync item
  Future<void> _processSyncItem(Map<String, dynamic> item) async {
    try {
      final tableName = item['table_name'] as String;
      final recordId = item['record_id'] as String;
      final operation = item['operation'] as String;
      final data = json.decode(item['data'] as String) as Map<String, dynamic>;

      final collection = FirebaseService.firestore.collection(tableName);

      switch (operation) {
        case 'CREATE':
        case 'UPDATE':
          await collection.doc(recordId).set(data);
          break;
        case 'DELETE':
          await collection.doc(recordId).delete();
          break;
      }

      // Mark as synced in local database
      await _markRecordAsSynced(tableName, recordId);

      // Remove from sync queue
      await DatabaseService.removeSyncItem(item['id'] as int);
    } catch (e) {
      if (kDebugMode) {
        print('Error processing sync item: $e');
      }
      // Don't remove from queue if sync failed
      rethrow;
    }
  }

  /// Mark a record as synced in local database
  Future<void> _markRecordAsSynced(String tableName, String recordId) async {
    try {
      await DatabaseService.update(
        tableName,
        {
          'synced': 1,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [recordId],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error marking record as synced: $e');
      }
    }
  }

  /// Sync data from Firebase to local database
  Future<bool> syncFromFirebase(String userId) async {
    if (!FirebaseService.isInitialized) return false;

    final connected = await isConnected();
    if (!connected) return false;

    try {
      // Sync users
      await _syncCollection('users', userId);

      // Sync activities
      await _syncCollection('activities', userId, userIdField: 'user_id');

      // Sync reminders
      await _syncCollection('reminders', userId, userIdField: 'user_id');

      // Sync achievements
      await _syncCollection('achievements', userId, userIdField: 'user_id');

      if (kDebugMode) {
        print('Firebase sync completed successfully');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Firebase sync failed: $e');
      }
      return false;
    }
  }

  /// Sync a specific collection from Firebase
  Future<void> _syncCollection(
    String collectionName,
    String userId, {
    String? userIdField,
  }) async {
    try {
      final collection = FirebaseService.firestore.collection(collectionName);

      QuerySnapshot snapshot;
      if (userIdField != null) {
        snapshot = await collection.where(userIdField, isEqualTo: userId).get();
      } else {
        snapshot =
            await collection.doc(userId).get().then((doc) => [doc] as dynamic);
      }

      for (final doc in snapshot.docs) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          data['synced'] = 1; // Mark as synced

          // Check if record exists locally
          final existingRecords = await DatabaseService.query(
            collectionName,
            where: 'id = ?',
            whereArgs: [doc.id],
            limit: 1,
          );

          if (existingRecords.isNotEmpty) {
            // Update existing record
            await DatabaseService.update(
              collectionName,
              data,
              where: 'id = ?',
              whereArgs: [doc.id],
            );
          } else {
            // Insert new record
            await DatabaseService.insert(collectionName, data);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing collection $collectionName: $e');
      }
      rethrow;
    }
  }

  /// Force sync all data (upload and download)
  Future<bool> forceSyncAll(String userId) async {
    if (_isSyncing) return false;

    _isSyncing = true;

    try {
      // First, sync pending changes to Firebase
      await syncPendingChanges();

      // Then, sync data from Firebase to local
      await syncFromFirebase(userId);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Force sync failed: $e');
      }
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  /// Get sync status information
  Future<Map<String, dynamic>> getSyncStatus() async {
    final pendingItems = await DatabaseService.getPendingSyncItems();
    final connected = await isConnected();

    return {
      'isConnected': connected,
      'isSyncing': _isSyncing,
      'pendingItems': pendingItems.length,
      'lastSyncAttempt': DateTime.now().toIso8601String(),
    };
  }

  /// Clear all sync queue items (use with caution)
  Future<void> clearSyncQueue() async {
    await DatabaseService.clearSyncQueue();
  }
}
