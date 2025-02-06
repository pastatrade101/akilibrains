class BoughtBook {
  final String id;

  // Add more fields as needed

  BoughtBook({
    required this.id,

    // Add more required fields here
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      // Add more fields as needed
    };
  }

  factory BoughtBook.fromJson(Map<String, dynamic> json) {
    return BoughtBook(
      id: json['id'] ?? '',

      // Add more fields as needed
    );
  }
}
