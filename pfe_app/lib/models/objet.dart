class Objet {
  final int id;
  final int user;
  final String titre;
  final String description;
  final String lieu;
  final String categorie;
  final String statut;   // 🔥 AJOUT ICI
  final String? imageUrl;
  final String? telephone;

  Objet({
    required this.id,
    required this.user,
    required this.titre,
    required this.description,
    required this.lieu,
    required this.categorie,
    required this.statut,   // 🔥 AJOUT
    this.imageUrl,
    this.telephone, // 🔥 AJOUT
  });

  factory Objet.fromJson(Map<String, dynamic> json) {
    return Objet(
      id: json['id'] ?? 0,
      user: json['user'] ?? 0,
      titre: json['titre'] ?? "",
      description: json['description'] ?? "",
      lieu: json['lieu'] ?? "",
      categorie: json['categorie'] ?? "autre",
      statut: json['statut'] ?? "",   // 🔥 AJOUT
      imageUrl: json['image_url'], // ✔ OK
      telephone: json['telephone'], // 🔥 AJOUT
    );
  }
}