class GroupMember {
  final String? id;
  final String? userId;
  final String username;
  int permissionLevel;

  GroupMember({
    this.id,
    this.userId,
    required this.username,
    required this.permissionLevel,
  });

  factory GroupMember.fromMap(Map<String, dynamic> map) {
    return GroupMember(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      username: map['username'] ?? 'Unknown User',
      permissionLevel: map['permission_level'] ?? 0,
    );
  }
}
