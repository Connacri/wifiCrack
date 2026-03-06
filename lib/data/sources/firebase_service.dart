import 'package:cloud_firestore/cloud_firestore.dart';

/// Service Firebase OBSOLÈTE pour les contacts et la localisation.
/// TOUTES les données de contacts et de tracking sont désormais sur SUPABASE.
/// Firebase ne sert plus QUE pour le Messaging (voir FirebaseMessengerService).
class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseService();

  // Les méthodes syncContacts, logUserActivity et updateLocation ont été supprimées
  // pour centraliser la sécurité et la RGPD sur Supabase uniquement.
}
