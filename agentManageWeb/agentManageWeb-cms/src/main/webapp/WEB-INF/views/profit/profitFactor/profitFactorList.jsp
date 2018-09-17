<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>

<script type="text/javascript">
    var logisticsA;
    $(function() {
        logisticsA = $('#ID').datagrid({
            url : '${path }/profitFactor/getList',
            striped : true,
            rownumbers : true,
            pagination : true,
            singleSelect : true,
            fit : true,
            idField : 'ID',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            columns : [ [ {
                title : '编号',
                field : 'ID'
            } , {
                title : '代理商编号',
                field : 'AGENT_ID'
            } , {
                title : '代理商唯一码',
                field : 'AGENT_PID',
            } , {
                title : '代理商名称',
                field : 'AGENT_NAME'
            } , {
                title : '月份',
                field : 'FACTOR_MONTH'
            } , {
                title : '应还款',
                field : 'TATOL_AMT'
            } , {
                title : '已扣款',
                field : 'BUCKLE_AMT'
            } , {
                title : '未扣足',
                field : 'SURPLUS_AMT'
            } , {
                title : '备注',
                field : 'REMARK'
            } , {
                title : '导入时间',
                field : 'FACTOR_DATE'
            } ] ],
            toolbar : '#profitFactorToolbar'
        });
    });

    /**
     * 搜索事件
     */
    function searchProfitFactor() {
        logisticsA.datagrid('load', $.serializeObject($('#ProfitFactorForm')));
    }

    function cleanProfitFactor() {
        $('#ProfitFactorForm input').val('');
        logisticsA.datagrid('load', {});
    }

    // 导入数据
    $("#importProfitFactor").click(function(){
        parent.$.modalDialog({
            title : '导入保理数据',
            width : 300,
            height : 110,
            href : "/profitFactor/importPage",
            buttons : [ {
                text : '确定',
                handler : function() {
                    var fun = parent.$.modalDialog.handler.find('#importFileForm');
                    fun.submit();
                }
            } ]
        });
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div id="" data-options="region:'west',border:true,title:'业务平台列表'" style="width:100%;overflow: hidden; ">
        <table id="ID" data-options="fit:true,border:false"></table>
    </div>
    <div data-options="region:'north',border:false" style="height: 32px; overflow: hidden;background-color: #fff">
        <form id ="ProfitFactorForm" method="post">
            <table>
                <tr>
                    <th>代理商名称：</th>
                    <td><input name="AGENT_NAME" id="AGENT_NAME" style="line-height:17px;border:1px solid #ccc;width:160px;"></td>
                    <td>&nbsp;&nbsp;&nbsp;</td>
                    <th>代理商唯一码：</th>
                    <td><input name="AGENT_PID" id="AGENT_PID" style="line-height:17px;border:1px solid #ccc;width:160px;"></td>
                    <td>&nbsp;&nbsp;&nbsp;</td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchProfitFactor();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanProfitFactor();">清空</a>
                    </td>
                    <td>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-archive icon-green'" id="importProfitFactor">导入保理数据</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
