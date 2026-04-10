import 'package:rankmyroast/models/async_response.dart';
import 'package:rankmyroast/models/group.dart';

class CreateRecipeResponse extends AsyncResponse {
  final List<Group>? failedToAddGroups;

  CreateRecipeResponse({
    required super.success,
    super.error,
    super.errorMessage,
    this.failedToAddGroups,
  });
}
