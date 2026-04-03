class InventoryItem {
  final String id;
  final String name;
  final int quantity;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
  });

  InventoryItem copyWith({
    String? id,
    String? name,
    int? quantity,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'quantity': quantity,
      };

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
    );
  }
}

