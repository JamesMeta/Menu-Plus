import 'package:rankmyroast/models/group_member.dart';

class CreateGroupResponse {
  final bool success;
  final bool? error;
  final String? errorMessage;
  final List<GroupMember>? failedToAddMembers;

  CreateGroupResponse({
    required this.success,
    this.failedToAddMembers,
    this.error,
    this.errorMessage,
  });
}
