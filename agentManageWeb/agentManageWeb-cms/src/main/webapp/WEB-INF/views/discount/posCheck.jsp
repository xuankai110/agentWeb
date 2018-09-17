<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    var posCheckList;
    $(function() {
        posCheckList = $('#posCheckList').datagrid({
            url : '${path }/discount/posCheckList',
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
                title : '考核起始日期',
                field : 'checkDateS',
                align : 'center',
                width : 130
            },{
                title : '考核截止日期',
                field : 'checkDateE',
                align : 'center',
                width : 130
            },{
                title : '交易总额（万）',
                field : 'totalAmt',
                align : 'center',
                width : 130
            },{
                title : '机具订货量',
                field : 'posOrders',
                align : 'center',
                width : 130
            },{
                title : '分润比例',
                field : 'profitScale',
                align : 'center',
                width : 130
            },{
                title : '申请日期',
                field : 'appDate',
                align : 'center',
                width : 130
            },{
                title : '考核状态',
                field : 'checkStatus',
                align : 'center',
            	width : 130,
                formatter : function(value, row, index) {
                    switch (value) {
                        case "0":
                            return '申请中';
                        case "1":
                            return '生效';
                        case "2":
                            return '无效';
                        case "9":
                            return '新建';
                    }
                }
            },{
                field : 'action',
                title : '操作',
                width : 130,
                formatter : function(value, row, index) {
                    var str = '';
                    if(row.checkStatus == '0'|| row.checkStatus == '1'){
                        str += $.formatString('<a href="javascript:void(0)" class="check-easyui-linkbutton-query" data-options="plain:true,iconCls:\'fi-magnifying-glass\'" onclick="showActivity(\'{0}\');">查看审批进度</a>', row.id);
                    }
                    return str;
                }
            }]],
            onLoadSuccess:function(data){
                $('.check-easyui-linkbutton-query').linkbutton({text:'查看审批进度'});
            },
            toolbar : '#checkToolbar'
        });
    });

    function posCheckDialog(id) {
        parent.$.modalDialog({
            title : '申请分润考核',
            width : 540,
            height : 360,
            href : '${path }/discount/addCheckPage',
            buttons : [ {
                text : '申请',
                handler : function() {
                    parent.$.modalDialog.openner_dataGrid = posCheckList;	//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                    var f = parent.$.modalDialog.handler.find('#posCheckAddForm');
                    f.submit();
                }
            } ]
        });
    }

    function showActivity(id) {
        addTab({
            title : '分润比例申请审批进度',
            border : false,
            closable : true,
            fit : true,
            href : '/checkActivity/gotoTaskApproval?id='+id
        });
    }

   function searchcheck() {
       posCheckList.datagrid('load', $.serializeObject($('#searchcheckForm')));
	}
	function cleancheck() {
		$('#searchcheckForm input').val('');
        posCheckList.datagrid('load', {});
	}

    function RefreshCloudHomePageTab() {
        posCheckList.datagrid('reload');
    }

    //    //申请考核form
    //    $("#posCheckDialog").click(function(){
    //        addTab({
    //            title : '优惠政策-申请考核奖励',
    //            border : false,
    //            closable : true,
    //            fit : true,
    //            href:'/discount/posCheckForm'
    //        });
    //    });

    <%--function addPosCheck() {--%>
        <%--parent.$.modalDialog({--%>
            <%--title : '新增考核奖励',--%>
            <%--width : 800,--%>
            <%--height : 300,--%>
            <%--maximizable:true,--%>
            <%--href : '${path}/discount/posCheckAddView',--%>
            <%--buttons : [ {--%>
                <%--text : '确定',--%>
                <%--handler : function() {--%>
                    <%--parent.$.modalDialog.openner_dataGrid = posCheckList;--%>
                    <%--var gr = parent.$.modalDialog.handler.find('#posCheckAddForm');--%>
                    <%--gr.submit();--%>
                <%--}--%>
            <%--} ]--%>
        <%--});--%>
    <%--}--%>
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div id="" data-options="region:'west',border:true,title:''"  style="width:100%;overflow: hidden; ">
		<table id="posCheckList" data-options="fit:true,border:false"></table>
	</div>
    <div data-options="region:'north',border:false" style="height: 60px; overflow: hidden;background-color: #fff">
	   <form  method="post" action="${path}/check/exportcheckD" id ="searchcheckForm" >
		   <table>
			   <tr>
				   <td width="480px">
					   <input id="agPid" name="agentPid" type="text" class="easyui-textbox" data-options="prompt:'代理商唯一码'" value="" style="width:180px;">
					   <input id="agName" name="agentName" type="text" class="easyui-textbox" data-options="prompt:'代理商名称'" style="width:180px;">

					   <a  class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchcheck()">查询</a>
					   <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleancheck();">清空</a>
				   </td>
			   </tr>
		   </table>
		</form>
        <shiro:hasPermission name="/discount/addCheck" >
            <a onclick="posCheckDialog();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-plus icon-green'">申请分润比例</a>
        </shiro:hasPermission>
	</div>
	<%--<div id="checkToolbar">--%>
		<%--<a onclick="addPosCheck()" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-plus icon-green'">新增考核</a>--%>
	<%--</div>--%>
</div>

