$.extend({
    ajaxL:function(opt){
        $.ajax({
            type: opt.type?opt.type:"POST",
            url: opt.url?opt.url:"/agentEnter/agentEnterIn",
            dataType:opt.dataType?opt.dataType:'json',
            async:(typeof opt.async == 'boolean'?opt.async:true),
            contentType:opt.contentType?opt.contentType:'application/x-www-form-urlencoded',
            data: opt.data?opt.data:{},
            beforeSend : opt.beforeSend ?opt.beforeSend :function(){},
            success: opt.success?opt.success:function(){},
            complete:opt.complete?opt.complete:function (XMLHttpRequest, textStatus) {

            }
        });
    }
});

function info(msg){
    parent.$.messager.alert('提示',msg, 'info');
}

function err(msg){
    parent.$.messager.alert('错误', msg, 'error');
}
