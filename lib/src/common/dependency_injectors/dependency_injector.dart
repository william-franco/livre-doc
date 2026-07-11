import 'package:get_it/get_it.dart';
import 'package:livre_doc/src/common/services/file_service.dart';
import 'package:livre_doc/src/common/services/share_service.dart';
import 'package:livre_doc/src/common/services/storage_service.dart';
import 'package:livre_doc/src/features/editor/repositories/document_repository.dart';
import 'package:livre_doc/src/features/editor/repositories/editor_repository.dart';
import 'package:livre_doc/src/features/editor/services/document_export_service.dart';
import 'package:livre_doc/src/features/editor/view_models/editor_view_model.dart';
import 'package:livre_doc/src/features/settings/repositories/setting_repository.dart';
import 'package:livre_doc/src/features/settings/view_models/setting_view_model.dart';
import 'package:livre_doc/src/features/welcome/repositories/welcome_repository.dart';
import 'package:livre_doc/src/features/welcome/view_models/welcome_view_model.dart';

final locator = GetIt.instance;

void dependencyInjector() {
  _registerServices();
  _registerSettings();
  _registerWelcome();
  _registerEditor();
}

void _registerServices() {
  locator.registerLazySingleton<StorageService>(() => StorageServiceImpl());
  locator.registerLazySingleton<FileService>(() => FileServiceImpl());
  locator.registerLazySingleton<ShareService>(() => ShareServiceImpl());
  locator.registerLazySingleton<DocumentExportService>(
    () => DocumentExportService(),
  );
}

void _registerSettings() {
  locator.registerCachedFactory<SettingRepository>(
    () => SettingRepositoryImpl(storageService: locator<StorageService>()),
  );
  locator.registerLazySingleton<SettingViewModel>(
    () => SettingViewModelImpl(settingRepository: locator<SettingRepository>()),
  );
}

void _registerWelcome() {
  locator.registerCachedFactory<WelcomeRepository>(
    () => WelcomeRepositoryImpl(storageService: locator<StorageService>()),
  );
  locator.registerLazySingleton<WelcomeViewModel>(
    () => WelcomeViewModelImpl(welcomeRepository: locator<WelcomeRepository>()),
  );
}

void _registerEditor() {
  locator.registerCachedFactory<DocumentRepository>(
    () => DocumentRepositoryImpl(
      fileService: locator<FileService>(),
      shareService: locator<ShareService>(),
      exportService: locator<DocumentExportService>(),
    ),
  );
  locator.registerCachedFactory<EditorRepository>(
    () => EditorRepositoryImpl(
      documentRepository: locator<DocumentRepository>(),
      storageService: locator<StorageService>(),
    ),
  );
  locator.registerFactoryParam<EditorViewModel, String?, void>(
    (filePath, _) => EditorViewModelImpl(
      editorRepository: locator<EditorRepository>(),
      initialFilePath: filePath,
    ),
  );
}

Future<void> initDependencies() async {
  await locator<StorageService>().initStorage();
  await Future.wait([
    locator<SettingViewModel>().loadSettings(),
    locator<WelcomeViewModel>().loadRecent(),
  ]);
}

void resetDependencies() => locator.reset();
