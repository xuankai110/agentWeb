var callBackCp = "";
function multFileUpload(callBack) {
    callBackCp = callBack;
    parent.$.modalDialog({
        title : '多文件上传',
        width : 300,
        height : 110,
        href : "/multiFile/toUploadPage",
        buttons : [ {
            text : '确定',
            handler : function() {
                var f = parent.$.modalDialog.handler.find('#multiFileForm');
                f.submit();
            }
        } ]
    });
}
function stepping(data) {
    callBackCp(data);
}