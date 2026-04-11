import 'package:rankmyroast/models/responses/async_response.dart';
import 'package:rankmyroast/models/group_member.dart';

class CreateGroupResponse extends AsyncResponse {
  final List<GroupMember>? failedToAddMembers;

  CreateGroupResponse({
    required super.success,
    super.localError,
    super.errorMessage,
    this.failedToAddMembers,
  });
}
