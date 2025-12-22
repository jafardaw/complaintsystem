class Complaint {
  final int id;
  final String referenceCode;
  final String title;
  final String description;
  final String locationText;
  final String status;
  final String priority;
  final String createdAt;

  final Agency agency;
  final List<Attachment> attachments; // يكون فارغ لأن API لا يحتويه

  Complaint({
    required this.id,
    required this.referenceCode,
    required this.title,
    required this.description,
    required this.locationText,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.agency,
    required this.attachments,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'] ?? 0,
      referenceCode: json['reference_code'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      locationText: json['location_text'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      createdAt: json['created_at'] ?? '',

      // Agency قد تكون null → نعالجها
      agency: Agency.fromJson(json['agency'] ?? {}),

      // attachments غير موجودة في API لكن نخليها موجودة
      attachments: (json['attachments'] as List? ?? [])
          .map((e) => Attachment.fromJson(e))
          .toList(),
    );
  }
}

class Agency {
  final int id;
  final String name;

  Agency({required this.id, required this.name});

  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class Attachment {
  final int id;
  final String filePath;
  final String fileType;

  Attachment({
    required this.id,
    required this.filePath,
    required this.fileType,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] ?? 0,
      filePath: json['file_path'] ?? '',
      fileType: json['file_type'] ?? '',
    );
  }
}

class ComplaintsResponse {
  final int currentPage;
  final List<Complaint> complaints;
  final int lastPage;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final int total;

  ComplaintsResponse({
    required this.currentPage,
    required this.complaints,
    required this.lastPage,
    this.nextPageUrl,
    this.prevPageUrl,
    required this.total,
  });

  factory ComplaintsResponse.fromJson(Map<String, dynamic> json) {
    final complaintsJson = json['complaints'] ?? {};

    return ComplaintsResponse(
      currentPage: complaintsJson['current_page'] ?? 0,
      lastPage: complaintsJson['last_page'] ?? 0,
      total: complaintsJson['total'] ?? 0,
      nextPageUrl: complaintsJson['next_page_url'],
      prevPageUrl: complaintsJson['prev_page_url'],

      complaints: (complaintsJson['data'] as List? ?? [])
          .map((e) => Complaint.fromJson(e))
          .toList(),
    );
  }
}
