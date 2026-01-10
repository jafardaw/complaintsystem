// lib/models/stats_model.dart
class ComplaintStats {
  final int totalComplaints;
  final StatusDistribution byStatus;
  final PriorityDistribution byPriority;
  final int resolvedCount;
  final double resolutionRate;
  final double avgResolutionHours;

  ComplaintStats({
    required this.totalComplaints,
    required this.byStatus,
    required this.byPriority,
    required this.resolvedCount,
    required this.resolutionRate,
    required this.avgResolutionHours,
  });

  factory ComplaintStats.fromJson(Map<String, dynamic> json) {
    return ComplaintStats(
      totalComplaints: json['total_complaints'] ?? 0,
      byStatus: StatusDistribution.fromJson(json['by_status']),
      byPriority: PriorityDistribution.fromJson(json['by_priority']),
      resolvedCount: json['resolved_count'] ?? 0,
      resolutionRate: (json['resolution_rate'] ?? 0).toDouble(),
      avgResolutionHours: (json['avg_resolution_hours'] ?? 0).toDouble(),
    );
  }
}

class StatusDistribution {
  final int newCount;
  final int inProgress;
  final int rejected;

  StatusDistribution({
    required this.newCount,
    required this.inProgress,
    required this.rejected,
  });

  factory StatusDistribution.fromJson(Map<String, dynamic> json) {
    return StatusDistribution(
      newCount: json['new'] ?? 0,
      inProgress: json['in_progress'] ?? 0,
      rejected: json['rejected'] ?? 0,
    );
  }

  Map<String, int> toChartData() {
    return {'جديد': newCount, 'قيد المعالجة': inProgress, 'مرفوض': rejected};
  }
}

class PriorityDistribution {
  final int medium;
  final int high;
  final int low;

  PriorityDistribution({
    required this.medium,
    required this.high,
    required this.low,
  });

  factory PriorityDistribution.fromJson(Map<String, dynamic> json) {
    return PriorityDistribution(
      medium: json['medium'] ?? 0,
      high: json['high'] ?? 0,
      low: json['low'] ?? 0,
    );
  }

  Map<String, int> toChartData() {
    return {'متوسط': medium, 'عالي': high};
  }
}
