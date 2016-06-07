import QtQuick 2.4

QtObject{
    signal captureCanceled  //用户取消拍摄
    signal captureFailed(var requestId, var message) //拍摄失败
    signal imageCaptured(var requestId, var preview) //拍摄完成
    signal imageSaved(var requestId,var path) //图片保存成功
}
