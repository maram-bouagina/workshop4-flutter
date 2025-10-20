class Client {
  final String id;
  final String name;
  final DateTime createdAt;

  Client({required this.id, required this.name, required this.createdAt});

  // Convert from a Map (like Supabase row) to Client object
  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // Convert Client object to Map (for inserting into Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'Client(id: $id, name: $name, createdAt: $createdAt)';
}
