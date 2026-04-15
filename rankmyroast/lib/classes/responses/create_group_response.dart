import 'package:rankmyroast/classes/responses/async_response.dart';
import 'package:rankmyroast/classes/modals/group_member.dart';

class CreateGroupResponse extends AsyncResponse {
  final List<GroupMember>? failedToAddMembers;

  CreateGroupResponse({
    required super.success,
    super.localError,
    super.errorMessage,
    this.failedToAddMembers,
  });
}
