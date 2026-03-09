// ignore_for_file: non_constant_identifier_names

class Group {
  final String id;
  final String created_at;
  final String name;
  final String user_id;
  final bool grade_visible;
  final bool use_rating;
  final bool is_personal_group;
  final int number_of_members;
  final int number_of_recipes;

  Group({
    required this.id,
    required this.created_at,
    required this.name,
    required this.grade_visible,
    required this.use_rating,
    required this.is_personal_group,
    required this.user_id,
    required this.number_of_members,
    required this.number_of_recipes,
  });
}
