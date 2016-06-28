import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    Component.onCompleted: {
        ad_one.listModel = null
        var picNum = Math.min(10, Config.testPicUrl.length)
        for(var i = 0; i < picNum; i++) {
            var item = {picUrl: Config.testPicUrl[i]}
            _listModel.append(item)
        }
        ad_one.listModel = _listModel
    }

    Adcolumn {
        id: ad_one
        anchors.top: navbar.bottom
        width: parent.width
        height: Utl.dp(280)
        delegate: _delegate
    }

    ListModel {
        id: _listModel
    }

    Component {
        id: _delegate
        ImageLoader {
            width: ad_one.width
            height: ad_one.height
            defaultSource: Config.DefaultImage
            source: picUrl
            fillModel: Image.PreserveAspectCrop
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("show.....", ad_one.pathView.model.count, ad_one.pathView.currentIndex);
                }
                onPressed: ad_one.userPress = true
                onReleased: ad_one.userPress = false
                onCanceled: ad_one.userPress = false
            }
        }
    }

    NavigationBar {
        id: navbar
        title: ""
        onButtonClicked: {
            root.navigationView.pop()
        }
    }
}

