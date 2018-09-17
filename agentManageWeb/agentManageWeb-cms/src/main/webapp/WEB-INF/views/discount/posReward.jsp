<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    var posRewardList;
    $(function() {
        posRewardList = $('#posRewardList').datagrid({
            url : '${path }/discount/posRewardList',
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
                align : 'center',
                width : 200
			},{
                title : '代理商名称',
                field : 'agentName',
                align : 'center',
                width : 200
            },{
                title : '交易总额对比月',
                field : 'totalConsMonth',
                align : 'center',
                width : 200
            },{
                title : '对比交易金额（万）',
                field : 'growAmt',
                align : 'center',
                width : 150
            },{
                title : '贷记交易金额对比月',
                field : 'creditConsMonth',
                align : 'center',
                width : 150
            },{
                title : '奖励比例',
                field : 'rewardScale',
                align : 'center',
                width : 150
            },{
                title : '奖励考核日期',
                field : 'totalEndMonth',
                align : 'center',
                width : 150
            },{
                title : '申请状态',
                field : 'applyStatus',
                align : 'center',
            	width : 150,
                formatter : function(value, row, index) {
                    switch (value) {
                        case "9":
                            return '新建';
                        case "0":
                            return '申请中';
                        case "1":
                            return '生效';
                        case "2":
                            return '无效';
                    }
                }
            },{
                field : 'action',
                title : '操作',
                width : 150,
                formatter : function(value, row, index) {
                    var str = '';
                    if(row.applyStatus == '0'|| row.applyStatus == '1'){
                        str += $.formatString('<a href="javascript:void(0)" class="reward-easyui-linkbutton-query" data-options="plain:true,iconCls:\'fi-magnifying-glass\'" onclick="showActivity(\'{0}\');">查看审批进度</a>', row.id);
                    }
                    return str;
                }
            }]],
            onLoadSuccess:function(data){
                $('.reward-easyui-linkbutton-query').linkbutton({text:'查看审批进度'});
            },
            toolbar : '#rewardToolbar'
        });
    });

    function posRewardDialog(id) {
        parent.$.modalDialog({
            title : '申请奖励',
            width : 520,
            height : 360,
            href : '${path }/discount/addPage',
            buttons : [ {
                text : '申请',
                handler : function() {
                    parent.$.modalDialog.openner_dataGrid = posRewardList;	//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                    var f = parent.$.modalDialog.handler.find('#posRewardAddForm');
                    f.submit();
                }
            } ]
        });
    }

    function showActivity(id) {
        addTab({
            title : '奖励考核申请审批进度',
            border : false,
            closable : true,
            fit : true,
            href : '/rewardActivity/gotoTaskApproval?id='+id
        });
    }

   function searchreward() {
       posRewardList.datagrid('load', $.serializeObject($('#searchrewardForm')));
	}
	function cleanreward() {
		$('#searchrewardForm input').val('');
        posRewardList.datagrid('load', {});
	}

    function RefreshCloudHomePageTab() {
        posRewardList.datagrid('reload');
    }

//    //申请奖励form
//    $("#posRewardDialog").click(function(){
//        addTab({
//            title : '优惠政策-申请奖励',
//            border : false,
//            closable : true,
//            fit : true,
//            href:'/discount/posRewardForm'
//        });
//    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div id="" data-options="region:'west',border:true,title:''"  style="width:100%;overflow: hidden; ">
		<table id="posRewardList" data-options="fit:true,border:false"></table>
	</div>
    <div data-options="region:'north',border:false" style="height: 60px; overflow: hidden;background-color: #fff">
	   <form  method="post" action="${path}/reward/exportrewardD" id ="searchrewardForm" >
		   <table>
			   <tr>
				   <td width="480px">
					   <input id="agPid" name="agentPid" type="text" class="easyui-textbox" data-options="prompt:'代理商唯一码'" value="" style="width:180px;">
					   <input id="agName" name="agentName" type="text" class="easyui-textbox" data-options="prompt:'代理商名称'" style="width:180px;">

					   <a class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchreward()">查询</a>
					   <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanreward();">清空</a>
				   </td>
			   </tr>
		   </table>
		</form>
        <shiro:hasPermission name="/discount/addReward">
            <a onclick="posRewardDialog();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-plus icon-green'">申请奖励</a>
        </shiro:hasPermission>
	</div>
</div>