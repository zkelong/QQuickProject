.pragma library

.import QtQuick.LocalStorage 2.0 as Sql


var _db = null


function toJsObject(obj){
    var tm = {}
    for(var key in obj){
        var v = obj[key]
        if(typeof v == "object"){
            v = toJsObject(v)
        }
        tm[key] = v;
    }
    return tm
}

function toJson(obj){
    try{
        return JSON.stringify(obj)
    }catch (e){
       return JSON.stringify( toJsObject(obj))
    }
}

function openDB(){
    if(_db) return _db;

    _db = Sql.LocalStorage.openDatabaseSync("dataDB", "1.0", "The data db", 1000000);
    if(_db == null){
        console.log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! open db failed!")
    } else {
        _db.transaction(
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
