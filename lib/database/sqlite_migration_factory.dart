import 'package:hedeyati/database/migrations/migration.dart';
import 'package:hedeyati/database/migrations/migration_v0.dart';


class SqliteMigrationFactory {

  /// Get all Migrations, both current and past
  List<Migration> getCreateMigration() => [
    MigrationV0(),
  ];

  /// Update for the current Migration
  List<Migration> getUpgradeMigration(int version) {
    final migrations = <Migration>[];

    // if (version == 1) {
    //   migrations.add(MigrationV2());
    //   migrations.add(MigrationV3());
    // }
    //
    // if (version == 2) {
    //   migrations.add(MigrationV3());
    // }

    return migrations;
  }
}