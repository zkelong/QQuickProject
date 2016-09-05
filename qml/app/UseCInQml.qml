import QtQuick 2.0
import QtQuick.Controls 1.1
import ColorMaker 1.0
import "../controls"
import "./androidSys"
import "../toolsbox/config.js" as Config
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    Component.onCompleted: {
        colorMaker.color = Qt.rgba(0,180,120, 255);
        colorMaker.setAlgorithm(ColorMaker.LinearIncrease);
        changeAlgorithm(colorAlgorithm, colorMaker.algorithm());
    }

    NavigationBar {
        id: navbar
        title: "USE_C_IN_QML"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Item {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100

        Text {
            id: timeLabel;
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: colorRect.top
            anchors.bottomMargin: Utl.dp(20);
            font.pixelSize: 26;
            text: "yoho...."
        }
        ColorMaker {
            id: colorMaker;
            color: "green"//Qt.green
            onColorChanged:{
                colorRect.color = color;
            }
        }

        Rectangle {
            id: colorRect;
            anchors.centerIn: parent;
            width: 200;
            height: 200;
            color: "blue";
        }

        Button {
            id: start;
            width: Utl.dp(45)
            height: Utl.dp(30)
            color: Color.GreenTheme
            label.text: "start";
            anchors.left: parent.left;
            anchors.leftMargin: Utl.dp(10);
            anchors.top: colorRect.bottom
            anchors.topMargin: Utl.dp(20)
            onClicked: {
                colorMaker.start();
            }
        }
        Button {
            id: stop;
            width: Utl.dp(45)
            height: Utl.dp(30)
            color: Color.GreenTheme
            label.text: "stop";
            anchors.left: start.right;
            anchors.leftMargin: 4;
            anchors.bottom: start.bottom;
            onClicked: {
                colorMaker.stop();
            }
        }



        Button {
            id: colorAlgorithm;
            width: Utl.dp(120)
            height: Utl.dp(30)
            color: Color.GreenTheme
            label.text: "RandomRGB";
            anchors.left: stop.right;
            anchors.leftMargin: 4;
            anchors.bottom: start.bottom;
            onClicked: {
                var algorithm = (colorMaker.algorithm() + 1) % 5;
                changeAlgorithm(colorAlgorithm, algorithm);
                colorMaker.setAlgorithm(algorithm);
            }
        }

        Connections {
            target: colorMaker;
            onCurrentTime:{
                timeLabel.text = strTime;
                timeLabel.color = colorMaker.timeColor;
            }
        }

//        Connections {
//            target: colorMaker;
//            onColorChanged:{
//                colorRect.color = color;
//            }
//        }
    }

    function changeAlgorithm(button, algorithm){
        switch(algorithm)
        {
        case 0:
            button.label.text = "RandomRGB";
            break;
        case 1:
            button.label.text = "RandomRed";
            break;
        case 2:
            button.label.text = "RandomGreen";
            break;
        case 3:
            button.label.text = "RandomBlue";
            break;
        case 4:
            button.label.text = "LinearIncrease";
            break;
        }
    }
}
