import QtQuick 2.0
import "../controls"
import "../toolsbox/tools.js" as Tools

View {
    id: root
    hidenTabbarWhenPush: true

    property string baseStr: "abcdefghijklmnopqrstuvwxyz1234567890~!@#$%^&*():\"<>?;',./_+|-=\\"
    property string baseStr1: "ABCDEFGHIJKLMNOPQRSTUVWXYZx"
    property string baseStr2: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    property string baseStr3: "abc,def,ghi"
    property string tempStr: ""

    Flickable {
        id: flick
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        contentHeight: _col.height + Utl.dp(30)

        Column {
            id: _col
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: Utl.dp(10)
            height: childrenRect.height
            spacing: Utl.dp(10)
            Text {
                id: txt1
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "原始字符串：str:" + baseStr + "\nstr1:" + baseStr1
            }
            Text {
                id: txt2
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "字符串长度(length)：" + baseStr.length
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "返回在指定位置的字符(charAt(0))：" + baseStr.charAt(0)
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "返回在指定的位置的字符的Unicode编码(charCodeAt(0))：" + baseStr.charCodeAt(0)
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "连接字符串(concat(str))：" + baseStr.concat(baseStr1)
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "从字符编码创建一个字符串(String.fromCharCode(numX,numX,...,numX))：" + String.fromCharCode(95,97,98)
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "检索字符串(indexOf(str, index(可选)))：\n" + baseStr.indexOf("abc") + "\n大小写敏感：" + baseStr.indexOf("abc", 5)
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "从后向前搜索字符串(lastIndexOf())：" + baseStr.lastIndexOf("xyz")
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "用本地特定的顺序来比较两个字符串(localeCompare())：" + baseStr1.localeCompare(baseStr2)
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "找到一个或多个正则表达式的匹配(match())：" + baseStr1.match("ABC") + "  " + baseStr1.match(/^[A-Z]+$/)
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "替换与正则表达式匹配的子串(replace())：" + baseStr1.replace("ABCD", "abcd")
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "检索与正则表达式相匹配的值(search())：" + baseStr1.search("abcd") + "\t没有返回：" + baseStr1.search("AGCD")
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "提取字符串的片断，并在新的字符串中返回被提取的部分(slice())：" + baseStr1.slice(10) + "\t起点/终点：" + baseStr1.slice(2, 4) + "\t末尾：" + baseStr1.slice(-5)
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: {
                    var str = "把字符串分割为字符串数组(split())："
                    var ss = baseStr3.split(",")
                    str += ss[0]
                    return str
                }
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "从起始索引号提取字符串中指定数目的字符(substring())：" + baseStr.substring(10) + "\t长度：" + baseStr.substring(10, 3)
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "把字符串转换为小写(toLocaleLowerCase())：" + baseStr.toLocaleLowerCase()
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "把字符串转换为大写(toLocaleUpperCase())：" + baseStr.toLocaleUpperCase()
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "把字符串转换为小写(toLowerCase())：" + baseStr.toLowerCase()
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "把字符串转换为大写(toUpperCase())：" + baseStr.toUpperCase()
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: {
                    var str = "返回字符串(toString())："
                    var aa = 0x9834
                    str += aa.toString()
                }
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.3
                text: "返回某个字符串对象的原始值(valueOf())：" + baseStr.valueOf()
            }
        }

    }

    NavigationBar {
        id: navbar
        title: "String"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }
}
