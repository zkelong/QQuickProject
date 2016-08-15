import QtQuick 2.0
import "../controls"
import "../toolsbox/tools.js" as Tools
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    property string showT: ""

    Component.onCompleted: {
        showT += " JavaScript 中，万物皆对象！但对象也是有区别的。分为普通对象和函数对象。"
        showT += "\n凡是通过 new Function() 创建的对象都是函数对象，其他的都是普通对象。Function Object 也都是通过 New Function()创建的(f1 = funciton(){}也是函数对象)。"
        showT += "\n在JavaScript 中，每当定义一个对象（函数）时候，对象中都会包含一些预定义的属性。其中函数对象的一个属性就是原型对象 prototype(普通对象没有prototype,但有__proto__属性)。"
        showT += "\n原型对象其实属于普通对象（Function.prototype除外,它是函数对象，但它很特殊，他没有prototype属性（前面说道函数对象都有prototype属性））"
        showT += "\n原型对象的主要作用是用于继承。"
        showT += "\nJS在创建对象（不论是普通对象还是函数对象）的时候，都有一个叫做__proto__的内置属性，用于指向创建它的函数对象的原型对象prototype。"
        showT += "\nhttp://www.php100.com/html/webkaifa/javascript/2012/1015/11260.html"
        showT += "\nhttp://www.108js.com/article/article1/10201.html?id=1092"
    }

    NavigationBar {
        id: navbar
        title: "Object"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Flickable {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        clip: true
        contentHeight: childrenRect.height

        Text {
            anchors.top: parent.top
            anchors.topMargin: Utl.dp(10)
            width: parent.width - Utl.dp(10)
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: FontUtl.FontSizeSmallE
            color: "#383838"
            text: showT
        }
    }
}
