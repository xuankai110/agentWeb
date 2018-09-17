<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    var orderReturnList;
    $(function() {
        orderReturnList = $('#orderReturnList').datagrid({
            url : '${path }/order/return/list',
            striped : true,
            rownumbers : true,
            pagination : true,
            singleSelect : true,
            fit : true,
            idField : 'id',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            columns : [ [{
                title : '退货单号',
                field : 'id',
                width : 200
            },/*{
                title : '代理商编号',
                field : 'agentId'
            },*/{
                title : '退货进度',
                field : 'retSchedule',
                formatter : function(value, row, index) {
                    switch (value) {
                        case 3:
                            return '发货中';
                        case 2:
                            return '待发货';
                        case 1:
                            return '审批中';
                        case 4:
                            return '退款中';
                        case 5:
                            return '完成';
                        case 6:
                            return '审批拒绝';
                        case 7:
                            return '驳回修改';
                        case 8:
                            return '已发货';
                    }
                },
                width : 200
            },/*{
                title : '创建人',
                field : 'cUser'
            },{
                title : '更新人',
                field : 'uUser'
            },*/{
                title : '创建时间',
                field : 'cTime',
                width : 200
            },{
                title : '更新时间',
                field : 'uTime',
                width : 200
            }, {
                field : 'action',
                title : '操作',
                width : 200,
                formatter : function(value, row, index) {
                    var str = '';
                    str += $.formatString('<a href="javascript:void(0)" class="activity-easyui-linkbutton-look" data-options="plain:true,iconCls:\'fi-magnifying-glass\'"  onclick="viewAgent(\'{0}\');" >查看</a>&nbsp;&nbsp;&nbsp;&nbsp;', row.id);
                    return str;
                }
            }
            ]],
            onLoadSuccess: function (data) {
                $('.activity-easyui-linkbutton-look').linkbutton({text: '查看'});
            },
            toolbar : '#returnorderToolbar'
        });

    });


    function applyReturn() {
        parent.$.modalDialog.openner_dataGrid = orderReturnList;
        parent.$.modalDialog({
            title : '申请退货',
            width : '60%',
            height : '60%',
            maximizable:true,
            href : '${path }/order/return/page/create',
            buttons : [ {
                text : '关闭',
                handler : function() {
                    parent.$.modalDialog.handler.dialog('close');
                }
            } ]
        });
    }


    function viewAgent(id) {
        addTab({
            title : '退货详情',
            border : false,
            closable : true,
            fit : true,
            href:'${path}/order/return/page/viewAgentIndex?returnId='+id
        });
    }

   function searchRefund() {
       orderReturnList.datagrid('load', $.serializeObject($('#searchOrderForm_return')));
	}

	function cleanOrder_return() {
		$('#searchOrderForm_return input').val('');
        orderReturnList.datagrid('load', {});
	}




</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div id="" data-options="region:'west',border:true,title:'我的退货列表'"  style="width:100%;overflow: hidden; ">
		<table id="orderReturnList" data-options="fit:true,border:false"></table>
	</div>
    <div data-options="region:'north',border:false" style="height: 40px; overflow: hidden;background-color: #fff">
	   <form id ="searchOrderForm_return">
			<table>
				<tr>
					<td>退货单号:</td>
					<td><input name="id" style="line-height:17px;border:1px solid #ccc"></td>
					<%--<td>代理商ID:</td>
					<td><input name="agentId" style="line-height:17px;border:1px solid #ccc"></td>--%>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchRefund();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanOrder_return();">清空</a>
                    </td>
				</tr>
			</table>
		</form>
	</div>
</div>
<div id="returnorderToolbar">
	<a onclick="applyReturn()" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-plus icon-green'">申请退货</a>
</div>

