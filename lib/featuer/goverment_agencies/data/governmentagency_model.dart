class GovernmentAgency {
  final int id;
  final String name;
  final String category;
  final String city;
  final String address;
  final String phone;

  GovernmentAgency({
    required this.id,
    required this.name,
    required this.category,
    required this.city,
    required this.address,
    required this.phone,
  });

  factory GovernmentAgency.fromJson(Map<String, dynamic> json) {
    return GovernmentAgency(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
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
    // معالجة قائمة البيانات (data list)
    final List<dynamic> dataList = json['data'] ?? [];
    final List<GovernmentAgency> agenciesList = dataList
        .map((agencyJson) => GovernmentAgency.fromJson(agencyJson))
        .toList();

    return AgenciesPaginationModel(
      agencies: agenciesList,
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
    );
  }
}
