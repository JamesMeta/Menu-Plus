import 'package:rankmyroast/classes/modals/group_order.dart';
import 'package:sqflite/sqflite.dart';

class SqliteHelper {
  // 1. Create a private static instance of the class
  static final SqliteHelper _instance = SqliteHelper._internal();

  // 2. Provide a public constructor to access the instance
  factory SqliteHelper() => _instance;

  // 3. A private named constructor for the internal initialization
  SqliteHelper._internal();

  // 4. Cache the database connection
  static Database? _database;

  // Getter to safely retrieve or initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database file on the device
  Future<Database> _initDatabase() async {
    // Get the default databases path (e.g., /data/data/com.example/databases on Android)
    final dbPath = await getDatabasesPath();

    // Join the path with your database file name
    final path = '$dbPath/rankMyRoast.db';

    // Open the database and apply the schema version and creation callback
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade, // Handle future migrations here
    );
  }

  // This runs the first time the database is created on the device
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE groupOrder (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_id TEXT NOT NULL,
        group_index INTEGER NOT NULL
      )
    ''');
  }

  Future<List<GroupOrder>> getGroupOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('groupOrder');

    // sort by index
    maps.sort((a, b) => a['group_index'].compareTo(b['group_index']));

    return List.generate(maps.length, (i) {
      return GroupOrder.fromMap(maps[i]);
    });
  }

  Future<void> upsertGroupOrder(List<GroupOrder> groupOrders) async {
    final db = await database;

    final batch = db.batch();

    for (final order in groupOrders) {
      batch.insert(
        'groupOrder',
        order.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}
