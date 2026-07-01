class Schedule {
  int? id;
  String createdAt;
  String servedAt;
  String recipeId;
  String groupId;
  String userId;

  Schedule({
    this.id,
    required this.createdAt,
    required this.servedAt,
    required this.recipeId,
    required this.groupId,
    required this.userId,
  });

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      createdAt: map['created_at'] ?? '',
      servedAt: map['served_at'] ?? '',
      recipeId: map['recipe_id'] ?? '',
      groupId: map['group_id'] ?? '',
      userId: map['user_id'] ?? '',
    );
  }
}
