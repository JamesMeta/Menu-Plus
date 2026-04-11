import 'package:rankmyroast/models/responses/async_response.dart';
import 'package:rankmyroast/models/group.dart';

class CreateRecipeResponse extends AsyncResponse {
  final List<Group>? failedToAddGroups;
  final bool? failedToUploadImage;

  CreateRecipeResponse({
    required super.success,
    super.localError,
    super.errorMessage,
    this.failedToAddGroups,
    this.failedToUploadImage,
  });
}
