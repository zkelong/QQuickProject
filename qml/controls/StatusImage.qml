import QtQuick 2.0
import QtGraphicalEffects 1.0

/**
* 状态图片，根据不同的状态显示不同的图片
* 状态1： selected
* 状态2： enabled
* 图片： normalSource，selectedSource，disableSource
*/

Rectangle {
    id:root
    color: "transparent"

    property bool selected: false  //是否处于选中状态,会根据此状态来切换normalSource, selectedSource的显示
    property alias normalSource: normalImage.source //正常情况下的图片地址
    property alias selectedSource: selectedImage.source //选中状态下的图片地址
    property alias disableSource: disableImage.source  //禁用情况下的图片地址
    property bool cache: false  //是否启用缓存--默认为true
    property bool smooth: false  //缩放转换时，平滑过滤图像--默认为true
    property var sueSaturation: null;
    property bool useSUE: true

    onSelectedChanged: {
        update()
    }

    onEnabledChanged: {
        update()
    }

    Image { //正常显示的图片
        id: normalImage
        z:0
        anchors.fill: parent
        cache: root.cache
        smooth: smooth
        visible: {
            if(selected === false && enabled)   //未选择并可用
                return true;

            if(selected && (selectedImage.source == null || selectedImage.source == ""))    //选择，但没有选择时的图片
                return true;

            if(enabled === false && (disableImage.source == null || disableImage.source == "")) //不可用，但无不可用时的图片
                return true;

            return false;
        }
        onStatusChanged: {
            if (normalImage.status === Image.Ready){
                if (root.width == 0 && root.height == 0){   //未设置root的width, height
                    root.width = normalImage.implicitWidth;
                    root.height = normalImage.implicitHeight;
                } else if (root.width == 0){   //未设置root的width
                    root.width = Math.floor(normalImage.implicitWidth * root.height / normalImage.implicitHeight);
                } else if (root.height == 0){   //未设置root的height
                    root.height = Math.floor(normalImage.implicitHeight * root.width / normalImage.implicitWidth);
                }
                //只有normalsource
                if (useSUE && sueSaturation === null && selectedSource == "" && disableSource == "" && normalImage.status === Image.Ready){
                    sueSaturation = hslComponent.createObject(root);
                }
            }

        }
    }

    Image { //选中时的图片
        id: selectedImage
        z: 2
        anchors.fill: parent
        visible: selected && enabled
        smooth: root.smooth
        cache: root.cache
    }

    Image { //不可用时的图片
        id: disableImage
        z: 3
        anchors.fill: parent
        visible: enabled === false
        smooth: root.smooth  //缩放转换时，平滑过滤图像
        cache: root.cache
    }

    Component{
        id:hslComponent
        HueSaturation { //图片处理
            z:1
            smooth: root.smooth
            anchors.fill: normalImage
            source: normalImage //处理对象（Image）
            hue: 0.0    //色调：-1.0~1.0 default(0.0)
            saturation: 0.0 //饱和度：-1.0~1.0 default(0.0)
            lightness: 0.0  //亮度：-1.0~1.0 default(0.0)
        }
    }

    function update(){
        if (sueSaturation == null || sueSaturation.visible === false)
            return

        if (enabled){   //能用
            if (selected){   //选中
                if (selectedSource == ""){
                    sueSaturation.hue = 0.0;
                    sueSaturation.saturation = 0.0;
                    sueSaturation.lightness = -0.4;
                }
            } else {     //选中
                sueSaturation.hue = 0.0;
                sueSaturation.saturation = 0.0;
                sueSaturation.lightness = 0.0;
            }

        } else {    //不能用
            if (disableSource == ""){
                sueSaturation.hue = 0.0;
                sueSaturation.saturation = -0.6;
                sueSaturation.lightness = 0.6;
            }
        }
    }


}

