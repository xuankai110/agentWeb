<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    var logisticsA;
    $(function() {
        logisticsA = $('#logisticsId').datagrid({
            url : '${path }/logistics/oLogisticsList',
            striped : true,
            rownumbers : true,
            pagination : true,
            singleSelect : true,
            fit : true,
            idField : 'id',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            columns : [ [ {
                title : '排单编号',
                field : 'PLAN_NUM'
            }, {
                title : '代理商名称',
                field : 'AG_NAME'
            }, {
                title : '商品编号',
                field : 'PRO_CODE'
            } , {
                title : '商品名称',
                field : 'PRO_NAME'
            } , {
                title : '商品数量',
                field : 'PRO_NUM'
            } , {
                title : '已排单数量',
                field : 'SEND_NUM'
            } , {
                title : '订货厂家',
                field : 'PRO_COM'
            } , {
                title : '订货数量',
                field : 'PLAN_PRO_NUM'
            } , {
                title : '发货数量',
                field : 'SEND_PRO_NUM'
            } , {
                title : '机型',
                field : 'MODEL'
            }, {
                title : '发货时间',
                field : 'REAL_SEND_DATE'
            } , {
                title : '收货人姓名',
                field : 'ADDR_REALNAME'
            }, {
                title : '退货子订单编号',
                field : 'RETURN_ORDER_DETAIL_ID'
            } , {
                title : '物流公司',
                field : 'LOG_COM'
            } , {
                title : '物流类型',
                field : 'LOG_TYPE',
                formatter : function(value, row, index) {
                    switch (value) {
                        case "2":
                            return '退货物流';
                        case "1":
                            return '发货物流';
                    }
                }
            } , {
                title : '物流单号',
                field : 'W_NUMBER'
            } , {
                title : '起始SN序列号',
                field : 'SN_BEGIN_NUM'
            } , {
                title : '结束SN序列号',
                field : 'SN_END_NUM'
            }, {
                title : '代理商ID',
                field : 'ID'
            } ,{
                title : '订单编号',
                field : 'ORDER_ID'
            }] ],
            toolbar : '#logisticsToolbar'
        });
    });

    /**
     * 搜索事件
     */
    function searchOLogistics() {
        logisticsA.datagrid('load', $.serializeObject($('#logisticsForm')));
    }

    function cleanOLogistics() {
        $('#logisticsForm input').val('');
        logisticsA.datagrid('load', {});
    }

    // 导出数据
    function exportOLogisticsFun(){
        $('#logisticsForm').form({
            url : '${path }/logistics/exportOLogistics',
            onSubmit : function() {
                return $(this).form('validate');
            }
        });
        $('#logisticsForm').submit();
    }

    // 导入数据
    $("#importOLogisticsFun").click(function(){
        parent.$.modalDialog({
            title : '导入物流信息',
            width : 300,
            height : 110,
            href : "/logistics/importPage",
            buttons : [ {
                text : '确定',
                handler : function() {
                    var fun = parent.$.modalDialog.handler.find('#logisticsImportFileForm');
                    fun.submit();
                }
            } ]
        });
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div id="" data-options="region:'west',border:true,title:'业务平台列表'" style="width:100%;overflow: hidden; ">
        <table id="logisticsId" data-options="fit:true,border:false"></table>
    </div>
    <div data-options="region:'north',border:false" style="height: 32px; overflow: hidden;background-color: #fff">
        <form id ="logisticsForm" method="post">
            <table>
                <tr>
                    <th>排单编号：</th>
                    <td><input name="PLAN_NUM" id="PLAN_NUM" style="line-height:17px;border:1px solid #ccc;width:160px;"></td>
                    <td>&nbsp;&nbsp;&nbsp;</td>
                    <th>订单编号：</th>
                    <td><input name="ORDER_ID" id="ORDER_ID" style="line-height:17px;border:1px solid #ccc;width:160px;"></td>
                    <td>&nbsp;&nbsp;&nbsp;</td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchOLogistics();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanOLogistics();">清空</a>
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>
                        <shiro:hasPermission name="/oLogistics/toLeadLog">
                            <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-print',plain:true" onclick="exportOLogisticsFun();">导出物流信息</a>
                        </shiro:hasPermission>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <shiro:hasPermission name="/oLogistics/importLog">
                            <a href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-archive icon-green'" id="importOLogisticsFun">导入物流信息</a>
                        </shiro:hasPermission>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
