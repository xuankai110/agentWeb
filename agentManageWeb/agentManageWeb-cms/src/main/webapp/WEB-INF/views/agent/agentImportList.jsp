<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<div id="agnet_import_list_ConditionToolbar" style="display: none;">
    <form  method="post" action="" id ="agnet_import_list__ConditionToolbar_searchform" >
        <table>
            <tr>
                <td>处理状态:</td>
                <td>
                    <select name="dealstatus" style="width:140px;height:21px" >
                        <option value="">--请选择--</option>
                        <option value="0">未处理</option>
                        <option value="1">处理中</option>
                        <option value="2">成功</option>
                        <option value="3">失败</option>
                    </select>
                </td>
                <td>
                    <select name="datatype" style="width:140px;height:21px" >
                        <option value="">--请选择--</option>
                        <option value="BASICS">基础信息</option>
                        <option value="BUSINESS">业务信息</option>
                        <option value="CONTRACT">合同信息</option>
                        <option value="PAYMENT">缴款信息</option>
                        <option value="BASBUSR">业务关系</option>
                        <option value="GATHER">收款账户</option>
                        <option value="NETINAPP">代理商入网开通任务</option>
                        <option value="BUSAPP">业务入网开通任务</option>
                    </select>
                </td>
                <td>
                    <a  class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchagnet_import_list_()">查询</a>
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanagnet_import_listSearchForm();">清空</a>
                </td>
            </tr>
        </table>
    </form>
    <a id="angetImportFormDialog" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-archive icon-green'">导入</a>
    <a id="analysisRecode" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-graph-horizontal icon-green'">分析处理</a>
</div>
<div  class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',fit:true,border:false">
        <table id="agnet_import_list__ConditionDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<script type="text/javascript">

    var agnet_import_list__ConditionDataGrid;
    $(function() {
        //代理商表格
        agnet_import_list__ConditionDataGrid = $('#agnet_import_list__ConditionDataGrid').datagrid({
            url : '${path}/agImport/list',
            striped : true,
            rownumbers : true,
            pagination : true,
            singleSelect : true,
            idField : 'id',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            columns : [ [{
                title : 'ID',
                field : 'id',
                sortable : true
            },{
                title : '代理商唯一编号',
                field : 'dataid',
                sortable : true
            },{
                title : '类型',
                field : 'datatype',
                sortable : true
            } , {
                title : '批次码',
                field : 'batchcode',
                sortable : true
            } ,{
                title : '创建时间',
                field : 'cTime',
                sortable : true
            }, {
                title : '处理时间',
                field : 'dealTime',
                sortable : true
            } , {
                title : '处理状态',
                field : 'dealstatus',
                sortable : true,
                formatter : function(value, row, index) {
                    switch(row.dealstatus){
                        case 0:
                            return "待处理";
                        case 1:
                            return "处理中";
                        case 2:
                            return "成功";
                        case 3:
                            return "失败";
                    }
                    return "";
                }
            } , {
                title : '处理结果',
                field : 'dealmsg',
                sortable : true
            } ,{
                field : 'action',
                title : '操作',
                width : 350,
                formatter : function(value, row, index) {

                    var str = '';

                    return str;
                }
            } ] ],
            onLoadSuccess:function(data){
            },
            onDblClickRow:function(dataIndex,rowData){
            },
            toolbar : '#agnet_import_list_ConditionToolbar'
        });

        //代理商入网form
        $("#angetImportFormDialog").click(function(){
            parent.$.modalDialog({
                title : '代理商导入',
                width : 300,
                height : 110,
                href : "/agImport/importView",
                buttons : [ {
                    text : '确定',
                    handler : function() {
                        var f = parent.$.modalDialog.handler.find('#agentImportFileForm');
                        f.submit();
                    }
                } ]
            });
        });

        $("#analysisRecode").click(function(){
            $.ajaxL({
                type: "POST",
                url: "/agImport/analysisRecode",
                dataType:'json',
                beforeSend:function(){
                  progressLoad();
                },
                success: function(msg){
                    info(msg.resInfo);
                },
                complete:function (XMLHttpRequest, textStatus) {
                    progressClose();
                    agnet_import_list__ConditionDataGrid.datagrid('reload');
                }
            });
        });


    });

    /**
     * 搜索事件
     */
    function searchagnet_import_list_() {
        agnet_import_list__ConditionDataGrid.datagrid('load', $.serializeObject($('#agnet_import_list__ConditionToolbar_searchform')));
    }

    function cleanagnet_import_listSearchForm() {
        $("[name='datatype']").val('');
        $("[name='dealstatus']").val('');
        agnet_import_list__ConditionDataGrid.datagrid('load', {});
    }

</script>
