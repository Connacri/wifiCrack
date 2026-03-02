import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseService();

  /// Synchronise les contacts vers Firebase
  Future<void> syncContacts(List<Contact> contacts) async {
    if (contacts.isEmpty) return;

    final WriteBatch batch = _db.batch();
    final CollectionReference contactsRef = _db.collection('contacts');

    for (var contact in contacts) {
      if (contact.phones.isNotEmpty) {
        final rawPhone = contact.phones.first.number;
        final cleanPhone = rawPhone.replaceAll(RegExp(r'[^0-9+]'), '');
        
        if (cleanPhone.length >= 4) {
          final docRef = contactsRef.doc(cleanPhone);
          batch.set(docRef, {
            'name': contact.displayName.trim(),
            'phone': cleanPhone,
            'updated_at': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }
    }

    try {
      await batch.commit();
      debugPrint("📇 Firebase: Contacts synchronisés.");
    } catch (e) {
      debugPrint("⚠️ Firebase SyncContacts Error: $e");
    }
  }

  /// Log l'activité utilisateur vers Firebase
  Future<void> logUserActivity(Position? location, int contactsCount, String deviceId) async {
    try {
      await _db.collection('user_activity').add({
        'device_id': deviceId,
        'latitude': location?.latitude,
        'longitude': location?.longitude,
        'contacts_count': contactsCount,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint("📍 Firebase: Activité enregistrée.");
    } catch (e) {
      debugPrint("⚠️ Firebase LogActivity Error: $e");
    }
  }

  /// Met à jour la position en temps réel (Historique)
  Future<void> updateLocation(Position location, String deviceId) async {
    try {
      await _db.collection('locations').add({
        'device_id': deviceId,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'timestamp': FieldValue.serverTimestamp(),
        'accuracy': location.accuracy,
        'altitude': location.altitude,
        'speed': location.speed,
      });
    } catch (e) {
      debugPrint("⚠️ Firebase UpdateLocation Error: $e");
    }
  }
}
