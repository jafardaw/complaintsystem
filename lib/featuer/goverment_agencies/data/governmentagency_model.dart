class GovernmentAgency {
  final int id;
  final String name;
  final String category;
  final String city;
  final String address;
  final String phone;
  final int complaintscount;

  GovernmentAgency({
    required this.id,
    required this.name,
    required this.category,
    required this.city,
    required this.address,
    required this.phone,
    required this.complaintscount,
  });

  factory GovernmentAgency.fromJson(Map<String, dynamic> json) {
    return GovernmentAgency(
      // استخدام ?? يمنع خطأ الـ Null تماماً
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'غير معروف',
      category: json['category'] as String? ?? 'عام',
      city: json['city'] as String? ?? 'غير محدد',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      complaintscount: json['complaints_count'] as int? ?? 0,
    );
  }
}

class AgenciesPaginationModel {
  final List<GovernmentAgency> agencies;
  final int currentPage;
  final int lastPage;

  AgenciesPaginationModel({
    required this.agencies,
    required this.currentPage,
    required this.lastPage,
  });

  factory AgenciesPaginationModel.fromJson(Map<String, dynamic> json) {
    // معالجة القائمة بشكل آمن
    var dataList = json['data'] as List? ?? [];

    return AgenciesPaginationModel(
      agencies: dataList
          .map((agencyJson) => GovernmentAgency.fromJson(agencyJson))
          .toList(),
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
    );
  }
}
