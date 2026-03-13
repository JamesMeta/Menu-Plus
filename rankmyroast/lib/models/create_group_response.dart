import 'package:rankmyroast/models/group_member.dart';

class CreateGroupResponse {
  final bool success;
  final List<GroupMember>? failedToAddMembers;

  CreateGroupResponse({required this.success, this.failedToAddMembers});
}
