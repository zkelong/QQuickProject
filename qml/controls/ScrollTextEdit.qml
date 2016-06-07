import QtQuick 2.0

Flickable {
     id: flick
     property alias textEdit: edit
     property alias inputFocus: edit.focus

     property string hintText: "请输入"
     property string inputText: ""

     contentWidth: edit.paintedWidth
     contentHeight: edit.paintedHeight
     clip: true
     interactive: false

     function ensureVisible(r) {
         if (contentX >= r.x)
             contentX = r.x;
         else if (contentX+width <= r.x+r.width)
             contentX = r.x+r.width-width;
         if (contentY >= r.y)
             contentY = r.y;
         else if (contentY+height <= r.y+r.height)
             contentY = r.y+r.height-height;
     }

     TextEdit {
         id: edit
         width: flick.width
         height: flick.height
         focus: false
         wrapMode: TextEdit.Wrap
         onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
         text: inputText == "" && !focus ? hintText : inputText
         onFocusChanged: {
             if(!focus)
                inputText = text
         }
     }
 }

