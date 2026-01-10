class ComplaintRevisionsResponse {
  final int complaintId;
  final List<RevisionModel> revisions;

  ComplaintRevisionsResponse({
    required this.complaintId,
    required this.revisions,
  });

  factory ComplaintRevisionsResponse.fromJson(Map<String, dynamic> json) {
    return ComplaintRevisionsResponse(
      complaintId: json['complaint_id'],
      revisions: (json['revisions'] as List)
          .map((i) => RevisionModel.fromJson(i))
          .toList(),
    );
  }
}

class RevisionModel {
  final int id;
  final int versionNumber;
  final RevisionData data;
  final ChangedBy changedBy;
  final String changedAt;

  RevisionModel({
    required this.id,
    required this.versionNumber,
    required this.data,
    required this.changedBy,
    required this.changedAt,
  });

  factory RevisionModel.fromJson(Map<String, dynamic> json) {
    return RevisionModel(
      id: json['id'],
      versionNumber: json['version_number'],
      data: RevisionData.fromJson(json['data']),
      changedBy: ChangedBy.fromJson(json['changed_by']),
      changedAt: json['changed_at'],
    );
  }
}

class RevisionData {
  final String title;
  final String description;
  final String status;
  final String priority;

  RevisionData({
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
  });

  factory RevisionData.fromJson(Map<String, dynamic> json) {
    return RevisionData(
      title: json['title'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
    );
  }
}

class ChangedBy {
  final int id;
  final String name;

  ChangedBy({required this.id, required this.name});

  factory ChangedBy.fromJson(Map<String, dynamic> json) {
    return ChangedBy(id: json['id'], name: json['name']);
  }
}
