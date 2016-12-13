import QtQuick 2.0
import QtQml.Models 2.2
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    DelegateModel {
              id: visualModel
              model: ListModel {
                  ListElement { name: "Apple" }
                  ListElement { name: "Orange" }
              }
              delegate: Rectangle {
                  height: 25
                  width: 100
                  Text { text: "Name: " + name}
              }
          }

          ListView {
              anchors.fill: parent
              model: visualModel
          }
}
