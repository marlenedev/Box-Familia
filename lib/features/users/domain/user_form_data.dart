class UserFormData {
  const UserFormData({
    required this.nom,
    required this.prenom,
    this.email,
    this.telephone,
  });

  final String nom;
  final String prenom;
  final String? email;
  final String? telephone;
}
