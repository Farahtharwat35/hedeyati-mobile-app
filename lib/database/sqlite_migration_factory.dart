import 'migrations/migration.dart';
import 'migrations/migration_v0.dart';
import 'migrations/migration_v1.dart';
import 'migrations/migration_v2.dart';

class SqliteMigrationFactory {
  /// Get all Migrations, both current and past
  List<Migration> getCreateMigration() => [
    MigrationV0(),
    MigrationV1(),
    MigrationV2(),
  ];

  /// Update for the current Migration
  List<Migration> getUpgradeMigration(int oldVersion) {
    final migrations = <Migration>[];

    // Add the relevant migrations based on the old version
    if (oldVersion < 1) {
      migrations.add(MigrationV0()); // Apply v0 if version < 1
    }
    if (oldVersion < 2) {
      migrations.add(MigrationV0());
      migrations.add(MigrationV1()); // Apply v1 if version < 2
    }
    if (oldVersion < 3) {
      migrations.add(MigrationV0());
      migrations.add(MigrationV1());
      migrations.add(MigrationV2()); // Apply v2 if version < 3
    }

    return migrations;
  }
}
