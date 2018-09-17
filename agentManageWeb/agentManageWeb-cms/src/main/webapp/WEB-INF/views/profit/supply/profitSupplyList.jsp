<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>

<script type="text/javascript">
    var logisticsA;
    $(function() {
        logisticsA = $('#SupplyList').datagrid({
            url : '${path }/profitSupply/getList',
            striped : true,
            rownumbers : true,
            pagination : true,
            singleSelect : true,
            fit : true,
            idField : 'ID',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            columns : [ [ {
                title : '代理商唯一码',
                field : 'AGENT_PID',
                align : 'center',
                width : 180
            } , {
                title : '代理商名称',
                field : 'AGENT_NAME',
                align : 'center',
                width : 200
            }
            , {
                title : '代理商编号',
                field : 'AGENT_ID',
                align : 'center',
                width : 120
            } , {
                title : '月份',
                field : 'SUPPLY_DATE',
                align : 'center',
                width : 120
            } , {
                title : '补款类型',
                field : 'SUPPLY_TYPE',
                align : 'center',
                width : 120
            } , {
                title : '补款金额',
                field : 'SUPPLY_AMT',
                align : 'center',
                width : 120
            } , {
                title : '录入日期',
                field : 'SOURCE_ID',
                align : 'center',
                width : 120
            }, {
                title : '补款码',
                field : 'SUPPLY_CODE',
                align : 'center',
                width : 120
            }
            ] ],
            toolbar : '#ProfitSupplyToolbar'
        });
    });

    /**
     * 搜索事件
     */
    function searchProfitSupply() {
        logisticsA.datagrid('load', $.serializeObject($('#ProfitSupplyForm')));
    }

    function cleanProfitSupply() {
        $('#ProfitSupplyForm input').val('');
        logisticsA.datagrid('load', {});
    }

    // 导入数据
    $("#importProfitSupply").click(function(){
        parent.$.modalDialog({
            title : '导入补款数据',
            width : 300,
            height : 110,
            href : "/profitSupply/importPage",
            buttons : [ {
                text : '确定',
                handler : function() {
                    var fun = parent.$.modalDialog.handler.find('#importSupplyForm');
                    fun.submit();
                }
            } ]
        });
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div id="" data-options="region:'west',border:true,title:'业务平台列表'" style="width:100%;overflow: hidden; ">
        <table id="SupplyList" data-options="fit:true,border:false"></table>
    </div>
    <div data-options="region:'north',border:false" style="height: 56px; overflow: hidden;background-color: #fff">
        <form id ="ProfitSupplyForm" method="post">
            <table>
                <tr>
                    <th>代理商名称：</th>
                    <td><input name="AGENT_NAME" id="AGENT_NAME" style="line-height:17px;border:1px solid #ccc;width:160px;">&nbsp;&nbsp;&nbsp;</td>
                    <th>代理商唯一码：</th>
                    <td><input name="AGENT_PID" id="AGENT_PID" style="line-height:17px;border:1px solid #ccc;width:160px;">&nbsp;&nbsp;&nbsp;</td>
                    <th>补款类型：</th>
                    <td><input name="SUPPLY_TYPE" style="line-height:17px;border:1px solid #ccc;width:160px;">&nbsp;&nbsp;&nbsp;</td>
                    <th></th><td></td>
                </tr>
                <tr>
                    <th>录入日期：</th>
                    <td><input name="SUPPLY_DATE_START" class="easyui-datebox" style="line-height:17px;border:1px solid #ccc;width:160px;" value=""></td>
                    <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;至</th>
                    <td><input name="SUPPLY_DATE_END" class="easyui-datebox" style="line-height:17px;border:1px solid #ccc;width:160px;" value=""></td>
                    <th>&nbsp;&nbsp;&nbsp;</th>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchProfitSupply();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanProfitSupply();">清空</a>
                    </td><th></th>
                    <td>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-archive icon-green'" id="importProfitSupply">导入补款数据</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
