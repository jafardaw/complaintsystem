class UserAdminModel {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String type;
  final bool isActive;
  final String createdAt;

  UserAdminModel({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    required this.type,
    required this.isActive,
    required this.createdAt,
  });

  factory UserAdminModel.fromJson(Map<String, dynamic> json) {
    return UserAdminModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      type: json['type'],
      // التعامل مع القيمة سواء كانت Boolean أو Integer (0/1)
      isActive: json['is_active'] == true || json['is_active'] == 1,
      createdAt: json['created_at'],
    );
  }
}

// الموديل الجديد لإدارة الـ Pagination
class UserPaginationModel {
  final int currentPage;
  final int lastPage;
  final String? nextPageUrl;
  final List<UserAdminModel> users;

  UserPaginationModel({
    required this.currentPage,
    required this.lastPage,
    this.nextPageUrl,
    required this.users,
  });

  factory UserPaginationModel.fromJson(Map<String, dynamic> json) {
    return UserPaginationModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      nextPageUrl: json['next_page_url'],
      users: (json['data'] as List)
          .map((userJson) => UserAdminModel.fromJson(userJson))
          .toList(),
    );
  }
}
