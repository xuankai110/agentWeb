<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<div id="plannerListToolbar" style="display: none;">
	<form  method="post" action="" id ="plannerList_searchform" >
		<table>
			<tr>
				<td>订单编号:</td>
				<td><input name="orderId" style="line-height:17px;border:1px solid #ccc" type="text"></td>
				<td>订单子编号:</td>
				<td><input  style="border:1px solid #ccc" name="receiptNum" type="text"></td>
				<td>收货人姓名:</td>
				<td><input  style="border:1px solid #ccc" name="addrRealname" type="text"></td>
				<td>
					<a  class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchPlannerList()">查询</a>
					<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanPlannerList();">清空</a>
				</td>
			</tr>
			<tr>
				<td>
					<a  class="easyui-linkbutton" data-options="iconCls:'fi-save',region:'center'" onclick="batchPlanner()">批量排单</a>
				</td>
			</tr>
		</table>
	</form>
</div>
<div  class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',fit:true,border:false">
		<table id="plannerList" data-options="fit:true,border:false"></table>
	</div>
</div>
<script type="text/javascript">
    var plannerList;
    var Address = ${manufacturer};
    $(function() {
        //代理商表格
        plannerList = $('#plannerList').datagrid({
            url : '${path}/planner/plannerList',
            rownumbers : true,
            striped : true,
            pagination : true,
            iconCls:'icon-save',
            editors:$.fn.datagrid.defaults.editors,
            idField : 'ID',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            columns : [ [
			{
				field : 'ck',
                checkbox:true
			},{
                title : '订单编号',
                field : 'ORDER_ID',
                sortable : true
            } , {
                title : '子订单编号',
                field : 'RECEIPT_NUM',
                sortable : true
            },{
                title : '代理商ID',
                field : 'AGENT_ID',
                sortable : true
            } ,{
                title : '收货姓名',
                field : 'ADDR_REALNAME',
                sortable : true
            } ,{
                title : '商品名称',
                field : 'PRO_NAME',
                sortable : true
            }  ,{
                title : '订单名称',
                field : 'ORDER_ID',
                sortable : true
            }  ,{
                title : '订货量',
                field : 'PRO_NUM',
                sortable : true
            }  ,{
                title : '已排量',
                field : 'SEND_NUM',
                sortable : true
            }  ,{
                title : '厂家',
                field : 'proCom',
                sortable : true,
                width:120,
                editor:
				{
					type: 'combobox',
					options: {data: Address, valueField: "dItemvalue", textField: "dItemname"}
				}
            } ,{
                title : '机型',
                field : 'model',
                sortable : true,
                editor:"text",
                width:80
            } ,{
                title : '数量',
                field : 'planProNum',
                sortable : true,
                editor:"numberbox",
                width:80
            } ,{
                field : 'action',
                title : '操作',
                width : 100,
                formatter : function(value, row, index) {
                    var str = '';
                    str += $.formatString('<a href="javascript:void(0)" class="plannerList-look-easyui-linkbutton-add" data-options="plain:true,iconCls:\'fi-magnifying-glass\'" onclick="savePlanner(\'{0}\',\'{1}\',\'{2}\',\'{3}\',\'{4}\',\'{5}\');" >保存</a>', row.ID,index,row.RECEIPT_PRO_ID,row.PRO_NUM,row.ORDER_ID,row.SEND_NUM);
                    return str;
                }
            }  ] ],
            onLoadSuccess:function(data){
                $('.plannerList-look-easyui-linkbutton-add').linkbutton({text:'保存'});
                for (var i in data.rows){
                    plannerList.datagrid("beginEdit",i);
                }
            },
            onDblClickRow: function (rowIndex, rowData) {
            },
            onBeforeEdit:function(index,row){
                row.editing = true;
            },
            onAfterEdit:function(index,row){
                row.editing = false;
//                saveRowAction(row);
            },
            onCancelEdit:function(index,row){
                row.editing = false;
            },
            toolbar : '#plannerListToolbar'
        });
    });

    /**
     * 搜索事件
     */
    function searchPlannerList() {
        plannerList.datagrid('load', $.serializeObject($('#plannerList_searchform')));
    }

    function cleanPlannerList() {
        $('#plannerList_searchform input').val('');
        plannerList.datagrid('load', {});
    }

    function savePlanner(id,index,receiptProId,proNum,orderId,sendNum) {
		var proCom = plannerList.datagrid("getEditor",{index:index,field:'proCom'});
        var model = plannerList.datagrid("getEditor",{index:index,field:'model'});
		var planProNum = plannerList.datagrid("getEditor",{index:index,field:'planProNum'});
		var proComVal = $(proCom.target).combobox('getValue');
		var modelVal = $(model.target).val();
		var planProNumVal = $(planProNum.target).val();
		if(proComVal=='' || proComVal==undefined){
			info("请填写厂家");
			return false;
		}
		if(modelVal=='' || modelVal==undefined){
			info("请填写型号");
			return false;
		}
		if(planProNumVal=='' || planProNumVal==undefined){
			info("请填写数量");
			return false;
		}
		if(parseInt(planProNumVal)>parseInt(proNum)-parseInt(sendNum)){
			info("排单数量不能大于订货量");
			return false;
		}
        parent.$.messager.confirm('询问', '确认要保存？', function(b) {
            if (b) {
				$.ajaxL({
					type: "POST",
					url: "${path}/planner/savePlanner",
					dataType:'json',
					data: {
						receiptId:id,
						proCom:proComVal,
						model:modelVal,
						planProNum:planProNumVal,
						orderId:orderId,
						receiptProId:receiptProId
					},
					success: function(result){
						if (result.success) {
							plannerList.datagrid('load', {});
							info(result.msg);
						}else{
							info(result.msg);
						}
					}
				});
            }
        });
    }

    function batchPlanner() {
        var selRows = $('#plannerList').datagrid('getChecked');
        var selected = $("#plannerList").datagrid('getSelected');
        var index = $("#plannerList").datagrid('getRowIndex',selected);

        var proCom = plannerList.datagrid("getEditor",{index:index,field:'proCom'});
        var model = plannerList.datagrid("getEditor",{index:index,field:'model'});
        var planProNum = plannerList.datagrid("getEditor",{index:index,field:'planProNum'});
        var proComVal = $(proCom.target).combobox('getValue');
        var modelVal = $(model.target).val();
        var planProNumVal = $(planProNum.target).val();
        if(proComVal=='' || proComVal==undefined){
            info("请填写厂家");
            return false;
        }
        if(modelVal=='' || modelVal==undefined){
            info("请填写型号");
            return false;
        }
        if(planProNumVal=='' || planProNumVal==undefined){
            info("请填写数量");
            return false;
        }
        if(selRows.length==0){
            info("最少选中一条记录");
            return false;
		}
        parent.$.messager.confirm('询问', '批量保存以第一次选中为基准，确认要保存？', function(b) {
            if (b) {
                var receiptPlanJson = {proCom:proComVal,model:modelVal,planProNum:planProNumVal};
                $.ajaxL({
                    type: "POST",
                    url: "/planner/batchPlanner",
                    dataType: 'json',
                    traditional: true,//这使json格式的字符不会被转码
                    contentType: 'application/json;charset=UTF-8',
                    data: JSON.stringify({
                        reqListMap:selRows,
                        receiptPlan:receiptPlanJson
                    }),
                    beforeSend: function () {
                        progressLoad();
                    },
                    success: function (data) {
                        info(data.msg);
                        if(data.success){
                            plannerList.datagrid('load', {});
                            $('#plannerList').datagrid('clearSelections');
                        }
                    },
                    complete: function (XMLHttpRequest, textStatus) {
                        progressClose();
                    }
                });
            }
        });
    }

</script>
