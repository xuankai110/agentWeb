/**
 * Created by RYX on 2018/5/23.
 */
/**
 * isCheckbox 是否多选 true false
 * 回调函数
 */
function showAgentSelectDialog(options) {
    console.log(options)
    parent.$.modalDialog({
        title : '代理商选择',
        width : 800,
        height : 500,
        href : '/abusinfo/agentSelectDialogView'+((options.data.urlpar!=undefined)?options.data.urlpar:"")
    });
    parent.$.modalDialog.handler.par_callBack_options=options;
}
function showAgentInfoSelectDialog(options) {
    parent.$.modalDialog({
        title : '代理商选择',
        width : 800,
        height : 500,
        href : '/abusinfo/agentInfoSelectDialogView'
    });
    parent.$.modalDialog.handler.par_callBack_options=options;
}
/**
 * 地址选择
 * @param options
 */
function showAddressInfoSelectDialog(options) {
    parent.$.modalDialog({
        title : '地址选择',
        width : 800,
        height : 500,
        href : '/address/addressListDialog'
    });
    parent.$.modalDialog.handler.par_callBack_options=options;
}
function  del(t) {
    var inputs  = $(t).parent("td").find("input");
    $(inputs).val("");
    // $("[id='"+id+"']").val('');
    // $("[id='"+ids+"']").val('');
}

/**
 * 商品选择
 * @param options
 */
function showProductSelectDialog(options) {
    var jsonData = "";
    if(options.data!='' && options.data!=undefined){
        jsonData = JSON.stringify(options.data);
    }
    parent.$.modalDialog({
        title : '商品选择',
        width : 800,
        height : 500,
        href : '/product/productListDialog?data='+jsonData
    });
    parent.$.modalDialog.handler.par_callBack_options=options;
}
