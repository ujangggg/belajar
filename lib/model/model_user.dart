class UserModel {
  final String userId;
  final String nama;
  final String email;
  final String peran; // Admin / Petani

  UserModel({
    required this.userId,
    required this.nama,
    required this.email,
    required this.peran,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      userId: id,
      nama: data['nama'],
      email: data['email'],
      peran: data['peran'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'email': email,
      'peran': peran,
    };
  }
}
