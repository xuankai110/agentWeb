<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<div id="agent_notify_ConditionToolbar" style="display: none;">
    <form method="post" action="" id="agentNotify_list_ConditionToolbar_searchform">
        <table>
            <tr>
                <td>代理商id:</td>
                <td>
                <td><input name="agentId" style="line-height:17px;border:1px solid #ccc" type="text"></td>
                </td>
                <td>
                    <a class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true"
                       onclick="searchagnetNotify_list()">查询</a>
                    <a href="javascript:void(0);" class="easyui-linkbutton"
                    data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanAgentNotifyListSearchForm();">清空</a>
                    <a class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true"
                       onclick="manualNotifyAll()">全部通知</a>
                </td>
            </tr>
        </table>
    </form>
</div>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',fit:true,border:false">
        <table id="agentData_notify_ConditionDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="notifyWin" class="easyui-window" title="通知信息详情" closed="true" style="width:600px;height:200px;" data-options="iconCls:'icon-save',modal:true">

</div>
<script type="text/javascript">
    var agentData_notify_ConditionDataGrid;
    $(function () {
        //代理商表格
        agentData_notify_ConditionDataGrid = $('#agentData_notify_ConditionDataGrid').datagrid({
            url: '${path}/notification/agentNotifyQuery',
            striped: true,
            rownumbers: true,
            pagination: true,
            singleSelect: true,
            idField: 'id',
            pageSize: 20,
            pageList: [10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
            columns: [[{
                title : '代理商id',
                field : 'agentId',
                sortable : true
            },{
                title : '开通业务ID',
                field : 'busId',
                sortable : true
            },{
                title : '业务平台',
                field : 'platformCode',
                sortable : true,
                formatter : function(value, row, index) {
                    if(db_options.ablePlatForm)
                        for(var i=0;i< db_options.ablePlatForm.length;i++){
                            if(db_options.ablePlatForm[i].platformNum==row.platformCode){
                                return db_options.ablePlatForm[i].platformName;
                            }
                        }
                    return "";
                }
            },{
                width : '150',
                title : '通知信息json',
                field : 'sendJson',
                sortable : true
            },{
                width : '150',
                title : '通知返回',
                field : 'notifyJson',
                sortable : true
            },{
                title : '通知次数',
                field : 'notifyCount',
                sortable : true
            },{
                title : '通知状态',
                field : 'notifyStatus',
                sortable : true,
                formatter : function(value, row, index) {
                    switch (value) {
                        case 0:
                            return '失败';
                        case 1:
                            return '成功';
                    }
                }
            },{
                title : '通知时间',
                field : 'notifyTime',
                sortable : true
            },{
                title : '创建用户',
                field : 'cUser',
                sortable : true
            },{
                title : '成功时间',
                field : 'succesTime',
                sortable : true
            },{
                title : '操作',
                field : 'action',
                width:'600px',
                formatter : function(value, row, index) {
                    var str = '';
                    <shiro:hasPermission name="/notification/manualNotify">
                        str += $.formatString('<a href="javascript:void(0)" class="tzsdcl-up-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="manualNotify(\'{0}\');" >开户接口</a>', row.busId);
                        str += $.formatString('<a href="javascript:void(0)" class="sj-up-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="manualEnterInUpdateLevelNotify(\'{0}\');" >升级并执行开户修改接口</a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="up-andlevel-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="manualEnterInUpdateNotify(\'{0}\');" >开户修改接口</a>', row.busId);
                    </shiro:hasPermission>
                    return str;
                }
            }]],
            onLoadSuccess:function(data) {
                $('.tzsdcl-up-easyui-linkbutton-edit').linkbutton({text: '开户接口'});
                $('.sj-up-easyui-linkbutton-edit').linkbutton({text: '升级并执行开户修改接口'});
                $('.up-andlevel-easyui-linkbutton-edit').linkbutton({text: '开户修改接口'});

            },
            onDblClickCell:function(rowIndex, field, value){
                if(field=='sendJson' || field=='notifyJson'){
                    $('#notifyWin').html("");
                    $('#notifyWin').html("详情："+value+"<br>");
                    $('#notifyWin').window('open');
                }

            },
            toolbar: '#agent_notify_ConditionToolbar'
        });
    });

    /**
     * 搜索事件
     */
    function searchagnetNotify_list() {
        agentData_notify_ConditionDataGrid.datagrid('load', $.serializeObject($('#agentNotify_list_ConditionToolbar_searchform')));
    }


    function cleanAgentNotifyListSearchForm() {
        $('#agentNotify_list_ConditionToolbar_searchform input').val('');
        agentData_notify_ConditionDataGrid.datagrid('load', {});
    }

    function manualNotify(busId) {
        parent.$.messager.confirm('询问', '确认要手动通知？', function(b) {
            if (b) {
                $.ajaxL({
                    url: "${path}/notification/manualNotify",
                    type: 'POST',
                    data: {
                        busId: busId
                    },
                    dataType:'json',
                    beforeSend:function(){
                      progressLoad();
                    },
                    success:function(data){
                    },
                    complete:function(){
                        progressClose();
                    }
                });
            }
        });
    }
    function manualEnterInUpdateNotify(busId) {
        parent.$.messager.confirm('询问', '确认要手动通知？', function(b) {
            if (b) {
                $.ajaxL({
                    url: "${path}/notification/manualEnterInUpdateNotify",
                    type: 'POST',
                    data: {
                        busId: busId
                    },
                    dataType:'json',
                    beforeSend:function(){
                        progressLoad();
                    },
                    success:function(data){
                    },
                    complete:function(){
                        progressClose();
                    }
                });
            }
        });
    }
    function manualEnterInUpdateLevelNotify(id) {
        parent.$.messager.confirm('询问', '确认要手动通知？', function(b) {
            if (b) {
                $.ajaxL({
                    url: "${path}/notification/manualEnterInUpdateLevelNotify",
                    type: 'POST',
                    data: {
                        id: id
                    },
                    dataType:'json',
                    beforeSend:function(){
                        progressLoad();
                    },
                    success:function(data){
                    },
                    complete:function(){
                        progressClose();
                    }
                });
            }
        });
    }

    function manualNotifyAll() {
        parent.$.messager.confirm('询问', '确认要手动全部通知？', function(b) {
            if (b) {
                $.ajaxL({
                    url: "${path}/notification/manualNotifyAll",
                    type: 'POST',
                    dataType:'json',
                    beforeSend:function(){
                        progressLoad();
                    },
                    success:function(data){
                    },
                    complete:function(){
                        progressClose();
                    }
                });
            }
        });
    }
</script>
