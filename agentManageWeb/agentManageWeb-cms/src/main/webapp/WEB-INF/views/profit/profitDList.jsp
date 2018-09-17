<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    var profitList;
    $(function() {
        profitList = $('#profitList').datagrid({
            url : '${path }/profit/profitDList',
            striped : true,
            rownumbers : true,
            pagination : true,
            singleSelect : true,
            fit : true,
            idField : 'id',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            columns : [ [{
				title : '代理商唯一码',
				field : 'agentPid',
                width:90
			},{
                title : '代理商编号',
                field : 'agentId',
                width:90
            },{
                title : '代理商名称',
                field : 'agentName',
                width:120
            },{
                title : '交易时间',
                field : 'transDate',
                width:100
            },{
                title : '出款时间',
                field : 'remitDate',
                width:100
            },{
                title : '本日应发金额',
                field : 'totalProfit',
                width:90
            },{
                title : '本日冻结金额',
                field : 'frozenMoney',
                width:90
            },{
                title : '打款成功金额',
                field : 'successMoney',
                width:90
            },{
                title : '打款失败金额',
                field : 'failMoney',
                width:90
            },{
				title : '实发金额',
				field : 'realMoney',
                width:90
			},{
                title : '补款金额',
                field : 'redoMoney',
                width:90
            },{
                title : '返现金额',
                field : 'returnMoney',
                width:90
            }
            ]],
            toolbar : '#profitToolbar'
        });

    });

   function searchprofit() {
       profitList.datagrid('load', $.serializeObject($('#searchprofitForm')));
	}
	function cleanprofit() {
		$('#searchprofitForm input').val('');
        profitList.datagrid('load', {});
	}

    function RefreshCloudHomePageTab() {
        profitList.datagrid('reload');
    }
    $("#transDate").datebox({

        required: true,
        formatter: function (date) {
            var y = date.getFullYear();
            var m = date.getMonth()+1;
            var d = date.getDate();
            return y + (m < 10 ? ('0' + m) : m) + (d < 10 ? ('0' + d) : d);
        },
        parser: function (s) {
        }
    })

</script>
<div class="easyui-layout" data-options="fit:true,bprofit:false">
	<div id="" data-options="region:'west',bprofit:true,title:'日分润明细'"  style="width:100%;overflow: hidden; ">
		<table id="profitList" data-options="fit:true,bprofit:false"></table>
	</div>
    <div data-options="region:'north',bprofit:false" style="height: 40px; overflow: hidden;background-color: #fff">
	   <form  method="post" action="${path}/profit/exportProfitD" id ="searchprofitForm" >
			<table>
				<tr>
					<th>代理商编号</th>
					<td><input id="agentId" name="agentId" type="text" class="easyui-textbox" data-options="prompt:'代理商编号'" value="" style="width:180px;"></td>
					<th>代理商名称</th>
					<td><input id="agentName" name="agentName" type="text" class="easyui-textbox" data-options="prompt:'代理商名称'" style="width:180px;"></td><td>
					<th>交易时间:</th>
					<td>
						<input id="transDate" name="transDate">
					</td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchprofit();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanprofit();">清空</a>
                    </td>
					<td>
						<button type="submit" class="easyui-linkbutton"  data-options="iconCls:'icon-print',plain:true," >导出</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>


