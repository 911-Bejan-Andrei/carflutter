import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart' as sql;

class SQLHelper {
    static Future<void> createTables(sql.Database database) async {
        await database.execute("""CREATE TABLE data(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            brand TEXT,
            model TEXT,
            color TEXT,
            price TEXT,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            
        )""");
    }
    static Future<Database> db() async {
        return openDatabase(
            'database_name.db',
            version: 1,
            onCreate: (Database database, int version) async {
                await createTables(database);
            },
        );
    }
    static Future<int> createData(String brand, String? model, String color, String price) async {
        final db = await SQLHelper.db();
        final data = {
            'brand' : brand,
            'model': model,
            'color': color,
            'price': price
        };
        final id = await db.insert(
            'data',
            data,
            conflictAlgorithm: ConflictAlgorithm.replace, // Use ConflictAlgorithm.replace for the same behavior as sql.ConflictAlgorithm
        );
        return id;
    }

    static Future<List<Map<String, dynamic>>> getAllData() async {
        final db = await SQLHelper.db();
        return db.query('data', orderBy: 'id');
    }

    static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
        final db = await SQLHelper.db();
        return db.query('data', where: "id = ?", whereArgs: [id], limit: 1);
    }

    static Future<int> updateData(int id, String brand, String? model, String color, String price) async {
        final db = await SQLHelper.db();
        final data = {
            'brand' : brand,
            'model': model,
            'color': color,
            'price': price,
            'createdAt': DateTime.now().toString()
        };
        final result = await db.update('data', data, where: "id = ?", whereArgs: [id]);
        await db.update('data', data, where: "id = ?", whereArgs: [id]);
        return result;
    }

    static Future<void> deleteData(int id) async {
        final db = await SQLHelper.db();
        try {
            await db.delete('data', where: "id = ?", whereArgs: [id]);
        } catch (e) {}
    }
}
