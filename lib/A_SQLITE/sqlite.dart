import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_MODEL/cashier.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database? _database;
List wholedatalist = [];
List SYSTEM = [];
List bill = [];
List detail_bill = [];
List customers = [];
List Type_datalist = [];
List Type_datalist2 = [];
List<Map<String, dynamic>> _wholeDataList = [];

class LocalDatabase {
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initializeDB();
    return _database!;
  }

  Future<void> createDatabase() async {
    await _initializeDB();
  }

  Future _initializeDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "Localdata2.db");
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
    );
  }

  static const data_product = '''
  CREATE TABLE IF NOT EXISTS data_product(
  index_tra INTEGER PRIMARY KEY AUTOINCREMENT,
    id TEXT NOT NULL,
    name TEXT NOT NULL,
    price TEXT NOT NULL,
    picture TEXT NOT NULL,
    units TEXT NOT NULL,
    type TEXT NOT NULL,
    other TEXT NOT NULL,
    state TEXT NOT NULL,
        weight TEXT NOT NULL

    
    
  );
  ''';

/*
        form: "0",
        head: true,
        name: true,
        address: true,
        phone: true,
        tax: true,
        sn: true,
        id_bill: true,
        customer: true,
        text1: true,
        text2: true,
        
        HEADS: "HEADS",
        NAMES: "NAMES",
        ADDRESS: "ADDRESS",
        PHONSE: "PHONSE",
        TAXS: "TAXS",
        SNS: "SNS",
        ID_BILLS: "ID_BILLS",
        CUSTOMERS: "CUSTOMERS",
        TEXT1S: "TEXT1S",
        TEXT2S: "TEXT2S"
*/

  static const edit_bill = '''
  CREATE TABLE IF NOT EXISTS edit_bill(
  id_tra INTEGER PRIMARY KEY AUTOINCREMENT,
    form TEXT NOT NULL,
    PICTURE TEXT NOT NULL,
    pic bool NOT NULL,

    head bool NOT NULL,
    name bool NOT NULL,
    address bool NOT NULL,
    phone bool NOT NULL,
    tax bool NOT NULL,
    sn bool NOT NULL,
    id_bill bool NOT NULL,
    customer bool NOT NULL,
    text1 bool NOT NULL,
    text2 bool NOT NULL,
    
    HEADS TEXT NOT NULL,
    NAMES TEXT NOT NULL,
    ADDRESSS TEXT NOT NULL,
    PHONSE TEXT NOT NULL,
    TAXS TEXT NOT NULL,
    SNS TEXT NOT NULL,
    ID_BILLS TEXT NOT NULL,
    CUSTOMERS TEXT NOT NULL,
    TEXT1S TEXT NOT NULL,
    TEXT2S TEXT NOT NULL
    
  );
  ''';

  static const customer = '''
  CREATE TABLE IF NOT EXISTS customer(
  id_tra INTEGER PRIMARY KEY AUTOINCREMENT,
    id TEXT NOT NULL unique,
    name TEXT NOT NULL,
    type TEXT NOT NULL
  );
  ''';

  static const discount_customer = '''
  CREATE TABLE IF NOT EXISTS discount_customer(
  id_tra INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL unique,
    discount REAL NOT NULL
  );
  ''';

  static const index_bill = '''
  CREATE TABLE IF NOT EXISTS index_bill(
  id_tra INTEGER PRIMARY KEY AUTOINCREMENT,
    INDEXS INTEGER NOT NULL
  );
  ''';

  /* his_bill gg = his_bill(
      sn: sn,
      id_bill: id_bill,
      cahier: cahier,
      date_time: date_time,
      tax: tax,
      sum_money: sum_money,
      pay_money: pay_money,
      money_back: money_back,
      method_pay: method_pay,
      sum_list: sum_list,
      sum_detial_list: sum_detial_list,
      state: state,
      detial: detial);*/

  static const his_bill = '''
  CREATE TABLE IF NOT EXISTS his_bill(
  id_tra INTEGER PRIMARY KEY AUTOINCREMENT,
    sn TEXT NOT NULL,
    id_bill TEXT NOT NULL,
   cahier TEXT NOT NULL,
   date_time TEXT NOT NULL,
   tax_id TEXT NOT NULL,
   tax_money TEXT NOT NULL,
  customer TEXT NOT NULL,
  type_customer TEXT NOT NULL,
  discount_customer TEXT NOT NULL,
   sum_money_t TEXT NOT NULL,
   discount TEXT NOT NULL,
   sum_money_before_tax TEXT NOT NULL,
   sum_money TEXT NOT NULL,
   pay_money TEXT NOT NULL,
   money_back TEXT NOT NULL,
   method_pay TEXT NOT NULL,
   sum_list TEXT NOT NULL,
   sum_detial_list TEXT NOT NULL,
   state TEXT NOT NULL,   
   detial TEXT NOT NULL,
   sum_weight TEXT NOT NULL
  );
  ''';

  static const cashier = '''
  CREATE TABLE IF NOT EXISTS cashier(
  id_tra INTEGER PRIMARY KEY AUTOINCREMENT,
  id TEXT TEXT NULL unique,
  name TEXT NOT NULL,
  role TEXT NOT NULL
  );
  ''';

  static const systems = '''
  CREATE TABLE IF NOT EXISTS systems(
  id_tra INTEGER PRIMARY KEY AUTOINCREMENT,
  activate bool NOT NULL,
  discount_mode bool NOT NULL,
 vat_mode bool NOT NULL,
  login_mode bool NOT NULL,
  drawer_manual bool NOT NULL,
   SN TEXT NOT NULL,
    number_prompt_pay TEXT NOT NULL,
     cashier TEXT NOT NULL,
     role TEXT NOT NULL,
      language TEXT NOT NULL,
     vat TEXT NOT NULL,
     vat_num TEXT NOT NULL,
     weight_mode bool NOT NULL,
     format_input TEXT NOT NULL,
     printter TEXT NOT NULL,
     low_cash_allow TEXT NOT NULL
  );
  ''';

  static const lock_page = '''
  CREATE TABLE IF NOT EXISTS lock_page(
  id_tra INTEGER PRIMARY KEY AUTOINCREMENT,
  p1 bool NOT NULL,
   p2 bool NOT NULL,
  p3 bool NOT NULL,
  p4 bool NOT NULL,
  p5 bool NOT NULL,
  p6 bool NOT NULL
  );
  ''';

  static const Stock = '''
  CREATE TABLE IF NOT EXISTS Stock(
  index_tra INTEGER PRIMARY KEY AUTOINCREMENT,
    unix INTEGER NOT NULL,
    date_time TEXT NOT NULL,
    units TEXT NOT NULL,
    type TEXT NOT NULL,
    id TEXT NOT NULL,
    name TEXT NOT NULL,
    state TEXT NOT NULL,
    who TEXT NOT NULL,
    num REAL NOT NULL,
    other TEXT NOT NULL
  );
  ''';
  static const activate = '''
  CREATE TABLE IF NOT EXISTS activate(
  id_tra INTEGER PRIMARY KEY AUTOINCREMENT,
  b1 INTEGER NOT NULL,
  b2 INTEGER NOT NULL,
  b3 INTEGER NOT NULL,
  active bool NOT NULL

  );
  ''';
/*
  bool activate = false;
  bool discount_mode = true;
  bool vat_mode = true;
  bool login_mode = true;
  String SN = "";
  String number_prompt_pay = "";
  String cashier = "";
  String language = "thai";
  String vat = "0.00";
*/

  Future<void> _createDB(Database db, int version) async {
    await db.execute(data_product);
    await db.execute(edit_bill);
    await db.execute(customer);
    await db.execute(discount_customer);
    await db.execute(his_bill);
    await db.execute(index_bill);
    await db.execute(cashier); //
    await db.execute(systems);
    await db.execute(lock_page);
    await db.execute(Stock);
    await db.execute(activate);
  }

  ///   Stock      ///   Stock      ///   Stock      ///   Stock      ///   Stock      ///   Stock
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   Stock      ///   Stock      ///   Stock      ///   Stock      ///   Stock      ///   Stock

  Future<List<Map<String, dynamic>>> readall_Stock() async {
    final db = await database;
    final alldata = await db.query("Stock");
    wholedatalist = alldata;
    // print(wholedatalist);
    return alldata;
  }

  Future<List<Map<String, dynamic>>> getSum_Stock_ByIdAndName() async {
    final db = await database;

    // ใช้คำสั่ง SQL เพื่อรวมค่า num ตาม id และ name
    final result = await db.rawQuery(
      'SELECT id, name, units, type, SUM(num) as sum FROM Stock GROUP BY id, name, units, type',
    );

    // แปลงผลลัพธ์เป็น List<Map<String, dynamic>>
    List<Map<String, dynamic>> summaryList = result.map((row) {
      return {
        'id': row['id'],
        'name': row['name'],
        'units': row['units'],
        'type': row['type'],
        'sum': row['sum'],
      };
    }).toList();

    return summaryList;
  }

  Future<int> update_stock_NumById(String id, double newNum) async {
    final db = await database;

    // ใช้คำสั่ง SQL เพื่ออัปเดตค่า num ตาม id ที่กำหนด
    int count = await db.update(
      'Stock',
      {'num': newNum}, // ค่าที่ต้องการอัปเดต
      where: 'id = ?', // เงื่อนไขการค้นหา
      whereArgs: [id], // ค่าที่จะถูกแทนในเงื่อนไข
    );

    return count; // ส่งกลับจำนวนแถวที่ถูกอัปเดต
  }

  Future<void> add_Stock({
    required int unix,
    required String date_time,
    required String units,
    required String id,
    required String type,
    required String name,
    required String state,
    required String who,
    required double num,
    required String other,
  }) async {
    final db = await database;

    // ข้อมูลที่ต้องการเพิ่ม
    final stockData = {
      'unix': unix,
      'date_time': date_time,
      'units': units,
      'type': type,
      'id': id,
      'name': name,
      'state': state,
      'who': who,
      'num': num,
      'other': other,
    };

    // ใช้คำสั่ง SQL เพื่อเพิ่มข้อมูล
    await db.insert(
      'Stock', // ชื่อตาราง
      stockData, // ข้อมูลที่ต้องการเพิ่ม
      ///conflictAlgorithm: ConflictAlgorithm.replace, // กรณีที่ข้อมูลมีอยู่แล้วจะทำการแทนที่
    );
  }

  Future<List<Map<String, dynamic>>> readStockByTimeRange(int startTime, int endTime) async {
    final db = await database;

    // ใช้คำสั่ง SQL เพื่อเลือกข้อมูลที่ unix อยู่ในช่วงระหว่าง startTime และ endTime
    final result = await db.rawQuery(
      'SELECT * FROM Stock WHERE unix BETWEEN ? AND ?',
      [startTime, endTime],
    );

    return result;
  }

  Future<List<Map<String, dynamic>>> read_stock_data_by_input(int startTime, int endTime, String id, String type, String units) async {
    final db = await database;

    // Base query
    String query = 'SELECT * FROM Stock WHERE unix BETWEEN ? AND ?';
    List<dynamic> args = [startTime, endTime];

    // Dynamically add conditions based on non-empty parameters
    if (id.isNotEmpty) {
      query += ' AND id = ?';
      args.add(id);
    }
    if (type.isNotEmpty) {
      query += ' AND type = ?';
      args.add(type);
    }
    if (units.isNotEmpty) {
      query += ' AND units = ?';
      args.add(units);
    }

    // Execute the query with the dynamic arguments
    final result = await db.rawQuery(query, args);

    return result;
  }

  Future<void> delete_all_stock() async {
    final db = await database;
    await db.delete("Stock");
    // print('All data deleted successfully');
  }
  /*
    static const Stock = '''
  CREATE TABLE IF NOT EXISTS Stock(
  index_tra INTEGER PRIMARY KEY AUTOINCREMENT,
    unix INTEGER NOT NULL,
        date_time TEXT NOT NULL,
    units TEXT NOT NULL,
    id TEXT NOT NULL,
    name TEXT NOT NULL,
    state TEXT NOT NULL,
    who TEXT NOT NULL,
    num REAL NOT NULL,
    other TEXT NOT NULL
  );
  ''';*/

  ///   PRODUCT      ///   PRODUCT      ///   PRODUCT      ///   PRODUCT      ///   PRODUCT      ///   PRODUCT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   PRODUCT      ///   PRODUCT      ///   PRODUCT      ///   PRODUCT      ///   PRODUCT      ///   PRODUCT

  Future<List<Map<String, dynamic>>> readall_data_product() async {
    final db = await database;
    final alldata = await db.query("data_product");
    wholedatalist = alldata;
    // print(wholedatalist);
    return alldata;
  }

  Future<void> adddata_all_product(
      {required String id,
      required String name,
      required String price,
      required String picture,
      required String units,
      required String type,
      required String other,
      required String state,
      required String weight,
      required context}) async {
    final db = await database;

    // Check if the ID is "999"
    if (id == "99999") {
      // Directly insert the data for ID "999"
      await db.insert(
        "data_product",
        {"id": id, "name": name, "price": price, "picture": picture, "units": units, "type": type, "other": other, "state": state, "weight": weight},
      );
    } else {
      // Check if the ID already exists in the database
      final existingProducts = await db.query(
        "data_product",
        where: "id = ?",
        whereArgs: [id],
      );

      if (existingProducts.isEmpty) {
        // ID does not exist, proceed with insertion
        await db.insert(
          "data_product",
          {
            "id": id,
            "name": name,
            "price": price,
            "picture": picture,
            "units": units,
            "type": type,
            "other": other,
            "state": state,
            "weight": weight
          },
        );
      } else {
        // Handle the case where the ID already exists, if needed
        // For example, you might throw an exception or log a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
                height: 100,
                child: Center(
                  child: Text(
                    'รหัสสินค้าซ้ำ',
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                )),
          ),
        );
      }
    }
  }

  Future<void> updatedata_price_product({
    required String id,
    required String price,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.update(
      "data_product",
      {
        "price": price,
      },
      where: "id = ?", // SQLite uses "rowid" to refer to the index  sdf
      whereArgs: [id],
    );
    // print('Data updatedata_all_product successfully');
  }

  Future<void> updatedata_all_product({
    required String id,
    required String name,
    required String price,
    required String picture,
    required String units,
    required String type,
    required String other,
    required String state,
    required String weight,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.update(
      "data_product",
      {
        "id": id,
        "name": name,
        "price": price,
        "picture": picture,
        "units": units,
        "type": type,
        "other": other,
        "state": state,
        "weight": weight,
      },
      where: "rowid = ?", // SQLite uses "rowid" to refer to the index
      whereArgs: [id],
    );
    // print('Data updatedata_all_product successfully');
  }

  Future<void> deleteDataByIndex(String id) async {
    final db = await database;
    await db.delete(
      "data_product",
      where: "id = ?",
      whereArgs: [id],
    );
    // print('Data deleted successfully');
  }

  Future<void> deleteDataByTYPE(String data) async {
    final db = await database;
    await db.delete(
      "data_product",
      where: "type = ?",
      whereArgs: [data],
    );
    //  print('Data deleted successfully');
  }

  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete("data_product");
    // print('All data deleted successfully');
  }

  ///   PRODUCT      ///   PRODUCT      ///   PRODUCT      ///   PRODUCT      ///   PRODUCT      ///   PRODUCT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   PRODUCT      ///   PRODUCT      ///   PRODUCT      ///   PRODUCT      ///   PRODUCT      ///   PRODUCT

  ///   edit_bill      ///   edit_bill      ///   edit_bill      ///   edit_bill      ///   edit_bill      ///   edit_bill
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   edit_bill      ///   edit_bill      ///   edit_bill      ///   edit_bill      ///   edit_bill      ///   edit_bill

  Future<List<Map<String, dynamic>>> readall_edit_bill() async {
    final db = await database;
    final alldata = await db.query("edit_bill");
    wholedatalist = alldata;
    // print(wholedatalist);
    return alldata;
  }

  Future<void> adddata_edit_bill({
    /*
      id_tra INTEGER PRIMARY KEY AUTOINCREMENT,
    form TEXT NOT NULL,
    
    head bool NOT NULL,
    name bool NOT NULL,
    address bool NOT NULL,
    phone bool NOT NULL,
    tax bool NOT NULL,
    sn bool NOT NULL,
    id_bill bool NOT NULL,
    customer bool NOT NULL,
    text1 bool NOT NULL,
    text2 bool NOT NULL,
    
    HEADS TEXT NOT NULL,
    NAMES TEXT NOT NULL,
    ADDRESS TEXT NOT NULL,
    PHONSE TEXT NOT NULL,
    TAXS TEXT NOT NULL,
    SNS TEXT NOT NULL,
    ID_BILLS TEXT NOT NULL,
    CUSTOMERS TEXT NOT NULL,
    TEXT1S TEXT NOT NULL,
    TEXT2S TEXT NOT NULL
    */
    required String form,
    required String PICTURE,
    required bool pic,

    /////////////////////////////

    required bool head,
    required bool name,
    required bool address,
    required bool phone,
    required bool tax,
    required bool sn,
    required bool id_bill,
    required bool customer,
    required bool text1,
    required bool text2,
    /////////////////////////////
    required String HEADS,
    required String NAMES,
    required String ADDRESSS,
    required String PHONSE,
    required String TAXS,
    required String SNS,
    required String ID_BILLS,
    required String CUSTOMERS,
    required String TEXT1S,
    required String TEXT2S,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.insert(
      "edit_bill",
      {
        "form": form,
        "PICTURE": PICTURE,
        "pic": pic,

        /////////////////////////////////////
        "head": head,
        "name": name,
        "address": address,
        "phone": phone,
        "tax": tax,
        "sn": sn,
        "id_bill": id_bill,
        "customer": customer,
        "text1": text1,
        "text2": text2,
        /////////////////////////////////////
        "HEADS": HEADS,
        "NAMES": NAMES,
        "ADDRESSS": ADDRESSS,
        "PHONSE": PHONSE,
        "TAXS": TAXS,
        "SNS": SNS,
        "ID_BILLS": ID_BILLS,
        "CUSTOMERS": CUSTOMERS,
        "TEXT1S": TEXT1S,
        "TEXT2S": TEXT2S,
      },
    );
    // print('Data product successfully');
  }

  Future<void> updatedata_edit_bill({
    required String form,
    required String PICTURE,
    required bool pic,

    /////////////////////////////

    required bool head,
    required bool name,
    required bool address,
    required bool phone,
    required bool tax,
    required bool sn,
    required bool id_bill,
    required bool customer,
    required bool text1,
    required bool text2,
    /////////////////////////////
    required String HEADS,
    required String NAMES,
    required String ADDRESSS,
    required String PHONSE,
    required String TAXS,
    required String SNS,
    required String ID_BILLS,
    required String CUSTOMERS,
    required String TEXT1S,
    required String TEXT2S,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.update(
      "edit_bill",
      {
        "form": form,
        "PICTURE": PICTURE,
        "pic": pic,

        /////////////////////////////////////
        "head": head,
        "name": name,
        "address": address,
        "phone": phone,
        "tax": tax,
        "sn": sn,
        "id_bill": id_bill,
        "customer": customer,
        "text1": text1,
        "text2": text2,
        /////////////////////////////////////
        "HEADS": HEADS,
        "NAMES": NAMES,
        "ADDRESSS": ADDRESSS,
        "PHONSE": PHONSE,
        "TAXS": TAXS,
        "SNS": SNS,
        "ID_BILLS": ID_BILLS,
        "CUSTOMERS": CUSTOMERS,
        "TEXT1S": TEXT1S,
        "TEXT2S": TEXT2S,
      },
      where: "rowid = ?", // SQLite uses "rowid" to refer to the index
      whereArgs: [1],
    );
    //  print('Data updatedata_all_product successfully');
  }

  ///   customer      ///   customer      ///   customer      ///   customer      ///   customer      ///   customer
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   customer      ///   customer      ///   customer      ///   customer      ///   customer      ///   customer

/*
  static const customer = '''
  CREATE TABLE IF NOT EXISTS customer(
  id_tra INTEGER PRIMARY KEY AUTOINCREMENT,
    id TEXT NOT NULL unique,
    name TEXT NOT NULL,
    type TEXT NOT NULL
  );
  ''';
*/
  Future<List<Map<String, dynamic>>> readall_customer() async {
    final db = await database;
    final alldata = await db.query("customer");
    wholedatalist = alldata;
    // print(wholedatalist);
    return alldata;
  }

  Future<void> adddata_customer({required String id, required String name, required String type, context
      // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
      }) async {
    final db = await database;
    try {
      await db.insert(
        "customer",
        {
          "id": id,
          "name": name,
          "type": type,
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("รหัสลูกค้าซ้ำ"),
      ));
    }

    // print('Data product successfully');
  }

  Future<void> updatedata_customer({
    required String id,
    required String name,
    required String type,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.update(
      "customer",
      {
        "name": name,
        "type": type,
      },
      where: "id = ?", // SQLite uses "rowid" to refer to the index
      whereArgs: [id],
    );
    // print('Data updatedata_all_product successfully');
  }

  Future<void> delete_all_customer() async {
    final db = await database;
    await db.delete("customer");
    // print('All customer deleted successfully');
  }

  Future<void> delete_customer(String id) async {
    final db = await database;
    await db.delete(
      "customer",
      where: "id = ?",
      whereArgs: [id],
    );
    // print('Data deleted successfully');
  }

  ///   customer      ///   customer      ///   customer      ///   customer      ///   customer      ///   customer
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   customer      ///   customer      ///   customer      ///   customer      ///   customer      ///   customer

  ///   discount_customer      ///   discount_customer      ///   discount_customer      ///   discount_customer      ///   discount_customer      ///   customer
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   discount_customer      ///   discount_customer      ///   discount_customer      ///   discount_customer      ///   discount_customer      ///   discount_customer
  Future<List<Map<String, dynamic>>> readall_discount_customer() async {
    final db = await database;
    final alldata = await db.query("discount_customer");
    wholedatalist = alldata;
    // print(wholedatalist);
    return alldata;
  }

  Future<void> adddata_discount_customer({
    required String type,
    required double discount,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.insert(
      "discount_customer",
      {
        "type": type,
        "discount": discount,
      },
    );
    //  print('Data product successfully');
  }

  Future<void> updatedata_discount_customer({
    required String type,
    required double discount,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.update(
      "discount_customer",
      {
        "type": type,
        "discount": discount,
      },
      where: "type = ?", // SQLite uses "rowid" to refer to the index
      whereArgs: [type],
    );
    //  print('Data updatedata_all_product successfully');
  }

  Future<void> delete_all_discount_customer() async {
    final db = await database;
    await db.delete("discount_customer");
    //  print('All discount_customer deleted successfully');
  }

  Future<void> delete_discount_customer(String type) async {
    final db = await database;
    await db.delete(
      "discount_customer",
      where: "type = ?",
      whereArgs: [type],
    );
    // print('Data deleted successfully');
  }

  Future<void> update_discount_customer_ByType({
    required String type,
    required double discount,
  }) async {
    final db = await database;
    await db.update(
      "discount_customer",
      {
        "discount": discount,
      },
      where: "type = ?",
      whereArgs: [type],
    );
    // print('Discount updated successfully');
  }

  ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL

  Future<List<Map<String, dynamic>>> readall_bill_time(DateTime timeA, DateTime timeB) async {
    final db = await database;

    // Format the DateTime objects to the required string format 'yyyy-MM-dd HH:mm:ss'
    String formattedTimeA =
        "${timeA.year}-${timeA.month.toString().padLeft(2, '0')}-${timeA.day.toString().padLeft(2, '0')} ${timeA.hour.toString().padLeft(2, '0')}:${timeA.minute.toString().padLeft(2, '0')}:${timeA.second.toString().padLeft(2, '0')}";

    String formattedTimeB =
        "${timeB.year}-${timeB.month.toString().padLeft(2, '0')}-${timeB.day.toString().padLeft(2, '0')} ${timeB.hour.toString().padLeft(2, '0')}:${timeB.minute.toString().padLeft(2, '0')}:${timeB.second.toString().padLeft(2, '0')}";

    final alldata = await db.rawQuery(
      "SELECT * FROM his_bill WHERE date_time BETWEEN ? AND ?",
      [formattedTimeA, formattedTimeB],
    );

    wholedatalist = alldata;
    // print(wholedatalist);
    return alldata;
  }

  Future<int> deleteBillByTimeRange(DateTime timeA, DateTime timeB) async {
    final db = await database;

    // Format the DateTime objects to the required string format 'yyyy-MM-dd HH:mm:ss'
    String formattedTimeA =
        "${timeA.year}-${timeA.month.toString().padLeft(2, '0')}-${timeA.day.toString().padLeft(2, '0')} ${timeA.hour.toString().padLeft(2, '0')}:${timeA.minute.toString().padLeft(2, '0')}:${timeA.second.toString().padLeft(2, '0')}";

    String formattedTimeB =
        "${timeB.year}-${timeB.month.toString().padLeft(2, '0')}-${timeB.day.toString().padLeft(2, '0')} ${timeB.hour.toString().padLeft(2, '0')}:${timeB.minute.toString().padLeft(2, '0')}:${timeB.second.toString().padLeft(2, '0')}";

    // Execute the delete query
    int count = await db.rawDelete(
      "DELETE FROM his_bill WHERE date_time BETWEEN ? AND ?",
      [formattedTimeA, formattedTimeB],
    );

    return count; // Return the number of rows affected
  }

  Future<List<Map<String, dynamic>>> readall_his_bill() async {
    final db = await database;
    final alldata = await db.query("his_bill");
    wholedatalist = alldata;
    // print(wholedatalist);
    return alldata;
  }

  Future<int> getColumnCount() async {
    final db = await database;
    final List<Map<String, dynamic>> allRows = await db.query("his_bill");
    return allRows.length;
  }

/*
  his_bill GG = his_bill(
      sn: sn,
      id_bill: id_bill,
      cahier: cahier,
      date_time: date_time,
      tax: tax,
      sum_money: sum_money,
      pay_money: pay_money,
      money_back: money_back,
      method_pay: method_pay,
      sum_list: sum_list,
      sum_detial_list: sum_detial_list,
      state: state,
      detial: detial);*/
  Future<void> adddata_his_bill(
      {required String sn,
      required String id_bill,
      required String cahier,
      required String date_time,
      required String tax_id,
      required String tax_money,
      required String customer,
      required String type_customer,
      required String discount_customer,
      required String sum_money_t,
      required String discount,
      required String sum_money_before_tax,
      required String sum_money,
      required String pay_money,
      required String money_back,
      required String method_pay,
      required String sum_list,
      required String sum_detial_list,
      required String state,
      required String detial,
      required String sum_weight

      // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
      }) async {
    final db = await database;
    await db.insert(
      "his_bill",
      {
        "sn": sn,
        "id_bill": id_bill,
        "cahier": cahier,
        "date_time": date_time,
        "tax_id": tax_id,
        "tax_money": tax_money,
        "customer": customer,
        "type_customer": type_customer,
        "discount_customer": discount_customer,
        "sum_money_t": sum_money_t,
        "discount": discount,
        "sum_money_before_tax": sum_money_before_tax,
        "sum_money": sum_money,
        "pay_money": pay_money,
        "money_back": money_back,
        "method_pay": method_pay,
        "sum_list": sum_list,
        "sum_detial_list": sum_detial_list,
        "state": state,
        "detial": detial,
        "sum_weight": sum_weight
      },
    );
    // print('Data his_bill successfully');
  }

  Future<void> updatedata_state_his_bill({
    required int index,
    required String state,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.update(
      "his_bill",
      {
        "state": state,
      },
      where: "id_tra = ?", // SQLite uses "rowid" to refer to the index
      whereArgs: [index],
    );
    // print('Data updatedata_his_bill successfully');
  }

  Future<void> delete_all_his_bill() async {
    final db = await database;
    await db.delete("his_bill");
    // print('All his_bill deleted successfully');
  }

///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
  Future<int> readall_index_bill() async {
    final db = await database;
    final alldata = await db.query("index_bill");
    if (alldata.isNotEmpty) {
      wholedatalist = alldata; // เปลี่ยนเป็น List<dynamic> โดยใส่ข้อมูลในลิสต์ด้วยวงเล็บเหลี่ยม []
      return wholedatalist[0]['INDEXS'];
    } else {
      await db.insert(
        "index_bill",
        {"INDEXS": 0},
      );
    }
    // print(wholedatalist);
    return alldata.length;
  }

  Future<void> updatedata_index_bill({
    required int INDEXS,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.update(
      "index_bill",
      {
        "INDEXS": INDEXS,
      },
      where: "rowid = ?", // SQLite uses "rowid" to refer to the index
      whereArgs: [1],
    );

    /// print('Data updatedata_his_bill successfully');
  }

  ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL      ///   HIS_BILL
  ///   cashier      ///   cashier      ///   cashier      ///   cashier      ///   cashier      ///   cashier
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   cashier      ///   cashier      ///   cashier      ///   cashier      ///   cashier      ///   cashier

  Future<List<Map<String, dynamic>>> readall_cashier() async {
    final db = await database;
    final alldata = await db.query("cashier");
    wholedatalist = alldata;
    // print(wholedatalist);
    return alldata;
  }

  Future<void> adddata_cashier({
    required String id,
    required String name,
    required String role,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.insert(
      "cashier",
      {"id": id, "name": name, "role": role},
    );
    //  print('Data cashier successfully');
  }

  Future<void> delete_cashier() async {
    final db = await database;
    await db.delete("cashier");
    // print('All cashier deleted successfully');
  }

  Future<void> delete_cashier_id(String id) async {
    final db = await database;
    await db.delete(
      "cashier",
      where: "id = ?",
      whereArgs: [id],
    );
    // print('Cashier with id $id deleted successfully');
  }

  ///   cashier      ///   cashier      ///   cashier      ///   cashier      ///   cashier      ///   cashier
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   cashier      ///   cashier      ///   cashier      ///   cashier      ///   cashier      ///   cashier

  ///   system      ///   system      ///   system      ///   system      ///   system      ///   system
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   system      ///   system      ///   system      ///   system      ///   system      ///   system

  Future<List<Map<String, dynamic>>> readall_systems() async {
    final db = await database;
    final alldata = await db.query("systems");
    wholedatalist = alldata;
    // print(wholedatalist);
    return alldata;
  }
/*

 CREATE TABLE IF NOT EXISTS systems(
  id_tra INTEGER PRIMARY KEY AUTOINCREMENT,
  activate bool NOT NULL,
  discount_mode bool NOT NULL,
 vat_mode bool NOT NULL,
  login_mode bool NOT NULL,
   SN TEXT NOT NULL,
    number_prompt_pay TEXT NOT NULL,
     cashier TEXT NOT NULL,
      language TEXT NOT NULL,
     vat TEXT NOT NULL

*/

  Future<void> adddata_systems({
    required bool activate,
    required bool discount_mode,
    required bool vat_mode,
    required bool login_mode,
    required bool weight_mode,
    required bool drawer_manual,
    required String SN,
    required String number_prompt_pay,
    required String cashier,
    required String role,
    required String language,
    required String vat,
    required String vat_num,
    required String format_input,
    required String printter,
    required String low_cash_allow,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.insert(
      "systems",
      {
        "activate": activate,
        "discount_mode": discount_mode,
        "vat_mode": vat_mode,
        "weight_mode": weight_mode,
        "drawer_manual": drawer_manual,
        "SN": SN,
        "number_prompt_pay": "0123456789",
        "cashier": cashier,
        "role": role,
        "login_mode": login_mode,
        "language": language,
        "vat": vat,
        "vat_num": vat_num,
        "low_cash_allow": low_cash_allow,
        "format_input": format_input,
        "printter": printter
      },
    );
    // print('Data systems successfully');
  }

  Future<void> updatedata_state_systems({
    required bool activate,
    required bool discount_mode,
    required bool vat_mode,
    required bool login_mode,
    required bool weight_mode,
    required bool drawer_manual,
    required String SN,
    required String number_prompt_pay,
    required String cashier,
    required String role,
    required String language,
    required String vat,
    required String vat_num,
    required String format_input,
    required String printter,
    required String low_cash_allow,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.update(
      "systems",
      {
        "activate": activate,
        "discount_mode": discount_mode,
        "vat_mode": vat_mode,
        "weight_mode": weight_mode,
        "drawer_manual": drawer_manual,
        "SN": SN,
        "number_prompt_pay": number_prompt_pay,
        "cashier": cashier,
        "role": role,
        "login_mode": login_mode,
        "language": language,
        "vat": vat,
        "vat_num": vat_num,
        "low_cash_allow": low_cash_allow,
        "format_input": format_input,
        "printter": printter
      },
      where: "rowid = ?", // SQLite uses "rowid" to refer to the index
      whereArgs: [1],
    );
    // print('Data systems successfully');
  }

  ///   system      ///   system      ///   system      ///   system      ///   system      ///   system
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   system      ///   system      ///   system      ///   system      ///   system      ///   system

  ///   lock_page      ///   lock_page      ///   lock_page      ///   lock_page      ///   lock_page      ///   lock_page
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   lock_page      ///   lock_page      ///   lock_page      ///   lock_page      ///   lock_page      ///   lock_page

  Future<List<Map<String, dynamic>>> readall_lock_page() async {
    final db = await database;
    final alldata = await db.query("lock_page");
    wholedatalist = alldata;
    // print(wholedatalist);
    return alldata;
  }

  Future<void> adddata_lock_page({
    required bool p1,
    required bool p2,
    required bool p3,
    required bool p4,
    required bool p5,
    required bool p6,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.insert(
      "lock_page",
      {"p1": p1, "p2": p2, "p3": p3, "p4": p4, "p5": p5, "p6": p6},
    );
    // print('Data systems successfully');
  }

  Future<void> updatedata_lock_page({
    required bool p1,
    required bool p2,
    required bool p3,
    required bool p4,
    required bool p5,
    required bool p6,

    // เพิ่มข้อมูลที่ต้องการอัปเดตต่อไปได้ตามต้องการ
  }) async {
    final db = await database;
    await db.update(
      "lock_page",
      {"p1": p1, "p2": p2, "p3": p3, "p4": p4, "p5": p5, "p6": p6},
      where: "rowid = ?", // SQLite uses "rowid" to refer to the index
      whereArgs: [1],
    );
    // print('Data systems successfully');
  }

  ///   activate      ///   activate      ///   activate      ///   activate      ///   activate      ///   activate
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///   activate      ///   activate      ///   activate      ///   activate      ///   activate      ///   activate

  Future<List<Map<String, dynamic>>> getAll_active() async {
    final db = await database;
    return await db.query('activate');
  }

  Future<void> add_activate({required int b1, required int b2, required int b3, required bool active, context}) async {
    final db = await database;
    await db.insert(
      'activate',
      {
        'b1': b1,
        'b2': b2,
        'b3': b3,
        'active': active,
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('activate add'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> update_activate({required int b1, required int b2, required int b3, required bool active, context}) async {
    final db = await database;
    await db.update(
      'activate',
      {
        'b1': b1,
        'b2': b2,
        'b3': b3,
        'active': active,
      },
      where: 'id_tra = ?',
      whereArgs: [1],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('activate update'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
