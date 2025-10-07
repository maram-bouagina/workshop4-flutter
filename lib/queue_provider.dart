import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waiting_room_app/model/client.dart';

class QueueProvider extends ChangeNotifier {
  final List<Client> _clients = [];
  List<Client> get clients => _clients;

  final SupabaseClient _supabase;
  late final RealtimeChannel _subscription;

  QueueProvider() : _supabase = Supabase.instance.client {
    _fetchInitialClients();
    _setupRealtimeSubscription();
  }

  // Added for testing: private constructor to inject mock Supabase client
  QueueProvider._forTesting(this._supabase);

  Future<void> _fetchInitialClients() async {
    try {
      final response = await _supabase.from('clients').select().order('created_at');
      _clients.clear();
      _clients.addAll(response.map((e) => Client.fromMap(e)));
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching clients: $e');
    }
  }

  void _setupRealtimeSubscription() {
    _subscription = _supabase
        .channel('public:clients')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'clients',
      callback: (payload) {
        final newClient = Client.fromMap(payload.newRecord);
        _clients.add(newClient);
        _clients.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        notifyListeners();
      },
    )
        .onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: 'clients',
      callback: (payload) {
        final deletedId = payload.oldRecord['id'] as String;
        _clients.removeWhere((client) => client.id == deletedId);
        notifyListeners();
      },
    )
        .subscribe();
  }

  Future<void> addClient(String name) async {
    if (name.trim().isEmpty) return;
    final response = await _supabase.from('clients').insert({'name': name.trim()});
    if (response.error != null) {
      debugPrint('Failed to add client: ${response.error!.message}');
    }
  }

  Future<void> removeClient(String id) async {
    final response = await _supabase.from('clients').delete().match({'id': id});
    if (response.error != null) {
      debugPrint('Failed to remove client: ${response.error!.message}');
    }
  }

  Future<void> nextClient() async {
    if (_clients.isEmpty) return;
    final firstClient = _clients.first;
    await removeClient(firstClient.id);
  }

  @override
  void dispose() {
    _subscription.unsubscribe();
    super.dispose();
  }
}
