class Group {
  final String id;
  final String created_at;
  final String name;
  final bool grade_visible;
  final bool use_rating;
  final bool is_personal_group;
  final String user_id;

  Group({
    required this.id,
    required this.created_at,
    required this.name,
    required this.grade_visible,
    required this.use_rating,
    required this.is_personal_group,
    required this.user_id,
  });
}
