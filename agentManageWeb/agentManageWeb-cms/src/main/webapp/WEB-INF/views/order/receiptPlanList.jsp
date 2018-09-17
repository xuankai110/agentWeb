<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    var receipPlanDataGrid;
    $(function () {
        receipPlanDataGrid = $('#receipPlanListId').datagrid({
            url : '${path }/receiptPlan/list',
            striped : true,
            rownumbers : true,
            pagination : true,
            singleSelect : true,
            fit : true,
            idField : 'id',
            pageSize: 15,
            pageList: [15, 20, 30, 40, 50, 100, 200, 300, 400, 500],
            columns : [ [{
                title : '排单编号',
                field : 'PLAN_NUM'
            },{
                title : '订单编号',
                field : 'ORDER_ID'
            },{
                title : '商品名称',
                field : 'PRO_NAME'
            },{
                title : '订货厂家',
                field : 'PRO_COM'
            },{
                title : '商品数量',
                field : 'PRO_NUM'
            },{
                title : '机型',
                field : 'MODEL'
            },{
                title : '已排单数量',
                field : 'SEND_NUM'
            },{
                title : '订货数量',
                field : 'PLAN_PRO_NUM'
            },{
                title : '收货人姓名',
                field : 'ADDR_REALNAME'
            },{
                title : '收货人联系电话',
                field : 'ADDR_MOBILE'
            },{
                title : '省',
                field : 'NAME'
            },{
                title : '市',
                field : 'CITY'
            },{
                title : '区',
                field : 'DISTRICT'
            },{
                title : '详细地址',
                field : 'ADDR_DETAIL'
            },{
                title : '邮编',
                field : 'ZIP_CODE'
            },{
                title : '地址备注',
                field : 'REMARK'
            },{
                title : '创建时间',
                field : 'C_DATE'
            },{
                title : '退货子订单编号',
                field : 'RETURN_ORDER_DETAIL_ID'
            },{
                title : '排单状态',
                field : 'PLAN_ORDER_STATUS',
                formatter : function(value, row, index) {
                    switch (value) {
                        case 1:
                            return '已排单';
                        case 2:
                            return '已发货';
                        case 3:
                            return '未发货';
                    }
                }
            }]],
            toolbar : '#receiptPlanToolbar'
        });
    });

    function searchPlan() {
        receipPlanDataGrid.datagrid('load', $.serializeObject($('#receipPlanQueryForm')));
    }

    function cleanPlan() {
        $('#receipPlanQueryForm input').val('');
        receipPlanDataGrid.datagrid('load', {});
    }

    function exportData() {
        $('#receipPlanQueryForm').form({
            url : '${path }/receiptPlan/export',
            onSubmit : function() {
                return $(this).form('validate');
            }
        });
        $('#receipPlanQueryForm').submit();
    }

    function toPlannerList() {
        addTab({
            title : '排单',
            border : false,
            closable : true,
            fit : true,
            href:'${path}/planner/toPlannerList'
        });
    }
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div id="" data-options="region:'west',border:true,title:'排单列表'"  style="width:100%;overflow: hidden; ">
        <table id="receipPlanListId" data-options="fit:true,border:false"></table>
    </div>
    <div data-options="region:'north',border:false" style="height: 57px; overflow: hidden;background-color: #fff">
        <form id ="receipPlanQueryForm" method="post">
            <table>
                <tr>
                    <th>排单编号：</th>
                    <td><input name="PLAN_NUM" style="line-height:17px;border:1px solid #ccc;width:160px;">&nbsp;&nbsp;</td>
                    <th>排单状态：</th>
                    <td>
                        <select name="PLAN_ORDER_STATUS" style="width:160px;height:21px">
                            <option value="">--请选择--</option>
                            <option value="1">已排单</option>
                            <option value="2">已发货</option>
                            <option value="3">未发货</option>
                        </select>
                        &nbsp;&nbsp;
                    </td>
                    <th>订单编号：</th>
                    <td><input name="ORDER_ID" style="line-height:17px;border:1px solid #ccc;width:160px;">&nbsp;&nbsp;&nbsp;</td>
                    <th>订货厂家：</th>
                    <td><input name="PRO_COM" style="line-height:17px;border:1px solid #ccc;width:160px;">&nbsp;&nbsp;&nbsp;</td>
                    <th></th>
                    <td></td>
                </tr>
                <tr>
                    <th>开始时间：</th>
                    <td><input name="C_DATE_START" class="easyui-datebox" style="line-height:17px;border:1px solid #ccc;width:160px;" value=""></td>
                    <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;至</th>
                    <td><input name="C_DATE_END" class="easyui-datebox" style="line-height:17px;border:1px solid #ccc;width:160px;" value=""></td>
                    <th></th>
                    <td>
                        &nbsp;&nbsp;
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchPlan();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanPlan();">清空</a>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <shiro:hasPermission name="/planner/toLeadPlanner">
                            <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-print',plain:true" onclick="exportData();">导出排单信息</a>
                        </shiro:hasPermission>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
<div id="receiptPlanToolbar">
    <shiro:hasPermission name="/planner/plannerAdd">
        <a onclick="toPlannerList()" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-plus icon-green'">排单</a>
    </shiro:hasPermission>
</div>
