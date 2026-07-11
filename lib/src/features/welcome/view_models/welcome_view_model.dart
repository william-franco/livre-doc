import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:livre_doc/src/common/patterns/app_state_pattern.dart';
import 'package:livre_doc/src/common/state_management/state_management.dart';
import 'package:livre_doc/src/features/welcome/models/recent_document.dart';
import 'package:livre_doc/src/features/welcome/repositories/welcome_repository.dart';

typedef WelcomeState = AppState<List<RecentDocument>>;

typedef _WelcomeViewModel = StateManagement<WelcomeState>;

abstract interface class WelcomeViewModel extends _WelcomeViewModel {
  Future<void> loadRecent();
  Future<void> removeRecent(String filePath);
  Future<void> clearRecent();
  Future<String?> pickDocumentFile();
}

class WelcomeViewModelImpl extends _WelcomeViewModel implements WelcomeViewModel {
  final WelcomeRepository welcomeRepository;

  WelcomeViewModelImpl({required this.welcomeRepository});

  @override
  WelcomeState build() => const InitialState();

  @override
  Future<void> loadRecent() async {
    _emit(const LoadingState());

    final result = await welcomeRepository.readRecentDocuments();

    final nextState = result.fold<WelcomeState>(
      onSuccess: (docs) => SuccessState(data: docs),
      onError: (error) => ErrorState(message: '$error'),
    );

    _emit(nextState);
  }

  @override
  Future<void> removeRecent(String filePath) async {
    await welcomeRepository.removeRecentDocument(filePath);
    await loadRecent();
  }

  @override
  Future<void> clearRecent() async {
    await welcomeRepository.clearRecentDocuments();
    await loadRecent();
  }

  @override
  Future<String?> pickDocumentFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['livre', 'txt', 'json'],
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return null;
    return result.files.single.path;
  }

  void _emit(WelcomeState newState) {
    emitState(newState);
    debugPrint('WelcomeViewModel: $state');
  }
}
