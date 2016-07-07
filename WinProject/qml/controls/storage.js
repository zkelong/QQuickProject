.pragma library //编译库

.import QtQuick.LocalStorage 2.0 as Sql

//数据库
var _db = null

//转为JSON对象
function toJsObject(obj){
    var tm = {}
    for(var key in obj){ //数组转为数组对象
        var v = obj[key]
        if(typeof v == "object"){
            v = toJsObject(v)
        }
        tm[key] = v;
    }
    return tm
}
//转为JSON字符串
function toJson(obj){
    try{
        return JSON.stringify(obj)
    }catch (e){
       return JSON.stringify( toJsObject(obj))
    }
}

function openDB(){
    if(_db) return _db;
    //打开或创建数据库
    _db = Sql.LocalStorage.openDatabaseSync("dataDB", "1.0", "The data db", 1000000);
    if(_db == null){
        console.log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! open db failed!")
    } else {
        _db.transaction(
                    //创建表
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS data(key TEXT  NOT NULL, value TEXT, type TEXT,PRIMARY KEY ("key"))');
            }
       )
    }
}

//存数据
//key 使用的键，全局唯一
//value 要侟的值，可以是string,object,number
//callback 操作结果回调，可选 function(boo ret)
function setValue(key,value,callback){
    if(_db == null){
        openDB()
    }
    if(!_db) {
        if(callback) callback(false);
        return;
    }
    _db.transaction(
        function(tx) {
            var type = typeof value; //string number object
            var vl = value;
            if(type == 'object'){
                vl = toJson(value)
            }
            tx.executeSql('REPLACE INTO data VALUES(?, ?, ?)', [ key, vl, type ]);
            if(callback) callback(true);
        }
    )
}

//获取存的值
function getValue(key,callback){
    if(_db == null){
        openDB()
    }

    if(!_db) {
        if(callback) callback(null);
        return;
    }

    _db.readTransaction(
        function(tx) {
            var rs = tx.executeSql('SELECT * FROM data WHERE key=?',key);

            if(rs && rs.rows.length){
                var v = rs.rows[0]
                var obj = v.value;
               if(v.type == "object" && v.value){
                   obj = JSON.parse(v.value);
               } else if(v.type == "number" && v.value){
                   obj = parseFloat(v.value);
               }
               if(callback) callback(obj);
            } else{
                if(callback) callback(null);
            }
        }
    )
}


 /*
//////////JSON/////////////
JSON.parse()和JSON.stringify()
parse用于从一个字符串中解析出json对象,如

var str = '{"name":"huangxiaojian","age":"23"}'
结果：
JSON.parse(str)
Object:
    age: "23"
    name: "huangxiaojian"
    __proto__: Object
注意：单引号写在{}外，每个属性名都必须用双引号，否则会抛出异常。

stringify()用于从一个对象解析出字符串，如
var a = {a:1,b:2}
结果：
JSON.stringify(a)
"{"a":1,"b":2}"

///////////DB////////////////
Sql.LocalStorage.openDatabaseSync(identifier, version, description, estimated_size, callback(db))
返回标识符标识的数据库。如果数据库不存在，它的特性描述和estimated_size和函数调用创建调用数据库作为参数。
identifier: 数据库名称
version: 版本
description: 描述
estimated_size: 估计大小
callback(db): 回调函数

1、openDatabase：这个方法使用现有数据库或创建新数据库创建数据库对象。
2、transaction：这个方法允许我们根据情况控制事务提交或回滚。
3、executeSql：这个方法用于执行真实的SQL查询。


Replace类似于insert语句。
如果表中的一个旧记录与一个用于PRIMARY KEY或一个UNIQUE索引的新记录具有相同的值，则在新记录被插入之前，旧记录被删除。
除非表有一个PRIMARY KEY或UNIQUE索引，否则，使用一个REPLACE语句没有意义。
1. replace into tbl_name(col_name, ...) values(...)
2. replace into tbl_name(col_name, ...) select ...
3. replace into tbl_name set col_name=value, ...
4. load data infile replace into tbl_name
*/
