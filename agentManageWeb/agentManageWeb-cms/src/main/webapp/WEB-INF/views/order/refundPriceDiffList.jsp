<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    var refundPriceDiffList;
    $(function() {
        refundPriceDiffList = $('#refundPriceDiffList').datagrid({
            url : '${path }/compensate/refundPriceDiffList',
            striped : true,
            rownumbers : true,
            pagination : true,
            singleSelect : true,
            fit : true,
            idField : 'id',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            columns : [ [{
                title : '申请补差价类型',
                field : 'applyCompName'
            },{
                title : '申请补差价金额',
                field : 'applyCompAmt'
            },{
                title : '实际补差价类型',
                field : 'relCompName'
            },{
                title : '实际补差价金额',
                field : 'relCompAmt'
            },{
                title : '机具扣除金额',
                field : 'machOweAmt'
            },{
                title : '扣除总金额',
                field : 'deductAmt'
            },{
                title : '收款时间',
                field : 'gatherTime'
            },{
                title : '收款金额',
                field : 'gatherAmt'
            },{
                title : '申请备注',
                field : 'applyRemark'
            },{
                title : '审批状态',
                field : 'reviewStatus',
                formatter : function(value, row, index) {
                    if(db_options.agStatusi)
                        for(var i=0;i< db_options.agStatusi.length;i++){
                            if(db_options.agStatusi[i].dItemvalue==row.reviewStatus){
                                return db_options.agStatusi[i].dItemname;
                            }
                        }
                    return "";
                }
            },{
                title : '申请时间',
                field : 'sTime'
            },{
                title : '更新时间',
                field : 'uTime'
            }, {
                field : 'action',
                title : '操作',
                width : 220,
                formatter : function(value, row, index) {
                    var str = '';
                    str += $.formatString('<a href="javascript:void(0)" class="priceDiff-easyui-linkbutton-see" data-options="plain:true,iconCls:\'fi-magnifying-glass\'" onclick="seeCompensate(\'{0}\',\'{1}\');" >查看</a>', row.id,row.reviewStatus);
					<shiro:hasPermission name="/compensate/refundPriceDiffEdit">
						if(row.reviewStatus==1)
						str += $.formatString('<a href="javascript:void(0)" class="priceDiff-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="editCompensate(\'{0}\');" >编辑</a>', row.id);
                    </shiro:hasPermission>
					<shiro:hasPermission name="/compensate/refundPriceDiffApp">
						if(row.reviewStatus==1)
						str += $.formatString('<a href="javascript:void(0)" class="priceDiff-easyui-linkbutton-sub" data-options="plain:true,iconCls:\'fi-magnifying-glass\'" onclick="subCompensate(\'{0}\');" >提交审批</a>', row.id);
					</shiro:hasPermission>
                    return str;
                }
            }
            ]],
            onLoadSuccess:function(data){
                $('.priceDiff-easyui-linkbutton-see').linkbutton({text:'查看'});
                $('.priceDiff-easyui-linkbutton-edit').linkbutton({text:'编辑'});
                $('.priceDiff-easyui-linkbutton-sub').linkbutton({text:'提交审批'});
            },
            toolbar : '#compensateToolbar'
        });

    });

   function searchCompensate() {
       refundPriceDiffList.datagrid('load', $.serializeObject($('#searchCompensateForm')));
	}
	function cleanCompensate() {
        $("#applyBeginTime").datebox("setValue","");
        $("#applyEndTime").datebox("setValue","");
        $('#reviewStatus').combobox('clear');
        refundPriceDiffList.datagrid('load', {});
	}

    function RefreshCloudHomePageTab() {
        refundPriceDiffList.datagrid('reload');
    }

    function seeCompensate(id,reviewStatus) {
		addTab({
			title : '补差价-查看',
			border : false,
			closable : true,
			fit : true,
			href:'/compensate/refundPriceDiffQuery?id='+id+"&reviewStatus="+reviewStatus
		});
    }

    //订单构建
    function compensateAmt(){
        addTab({
            title : '退补差价',
            border : false,
            closable : true,
            fit : true,
            href:'${path}/compensate/toCompensateAmtAddPage'
        });
    }

    function editCompensate(id) {
        addTab({
            title : '补差价-修改',
            border : false,
            closable : true,
            fit : true,
            href:'/compensate/toCompensateAmtEditPage?id='+id
        });
    }


    function subCompensate(compId) {
        if(compId=='' || compId==undefined){
			info("提交审批参数错误");
            return false;
		}
        parent.$.messager.confirm('询问', '确认要提交审批？', function(b) {
            if (b) {
                $.ajaxL({
                    type: "POST",
                    url: basePath+"/compensate/startCompensate",
                    data:{
                        compId:compId
                    },
                    beforeSend : function() {
                        progressLoad();
                    },
                    success: function(data){
						info(data.msg);
                        refreshRefundPriceDiffList();
                    },
                    complete:function (XMLHttpRequest, textStatus) {
                        progressClose();
                    }
                });
            }
        });
    }

    function refreshRefundPriceDiffList() {
        refundPriceDiffList.datagrid('load', {});
    }
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div id="" data-options="region:'west',border:true,title:'补差价列表'"  style="width:100%;overflow: hidden; ">
		<table id="refundPriceDiffList" data-options="fit:true,border:false"></table>
	</div>
    <div data-options="region:'north',border:false" style="height: 40px; overflow: hidden;background-color: #fff">
	   <form id ="searchCompensateForm">
			<table>
				<tr>
					<th>申请开始时间:</th>
					<td>
						<input class="easyui-datetimebox" name="applyBeginTime" id="applyBeginTime" style="width:150px">
					</td>
					<th>申请结束时间:</th>
					<td>
						<input class="easyui-datetimebox" name="applyEndTime" id="applyEndTime" style="width:150px">
					</td>
					<th>审核状态:</th>
					<td>
						<select  class="easyui-combobox" name="reviewStatus" id="reviewStatus" style="width:150px;">
							<option value="" >--全部--</option>
							<c:forEach var="status" items="${agStatusi}" >
								<option value="${status.dItemvalue}" >${status.dItemname}</option>
							</c:forEach>
						</select>
					</td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchCompensate();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanCompensate();">清空</a>
                    </td>
				</tr>
			</table>
		</form>
	</div>
</div>
<div id="compensateToolbar">
	<shiro:hasPermission name="/compensate/refundPriceDiffAdd">
		<a onclick="compensateAmt()" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-plus icon-green'">补差价</a>
	</shiro:hasPermission>
</div>

