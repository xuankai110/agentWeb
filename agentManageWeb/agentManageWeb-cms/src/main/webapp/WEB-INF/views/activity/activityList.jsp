<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var activityDataGrid;
    $(function() {
        activityDataGrid = $('#activityDataGrid').datagrid({
            url : '${path }/activity/activityList.htmls',
            striped : true,
            rownumbers : true,
//            pagination : true,
            singleSelect : true,
            idField : 'id',
           // sortName : 'jobTime',
           // sortOrder : 'asc',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            columns : [ [ {
                title : '编号',
                field : 'id',
                sortable : true
            }, {
                title : '任务名称',
                field : 'name',
                sortable : true
            } , {
                title : '业务类型',
                field : 'busType',
                sortable : true,
                formatter : function(value, row, index) {
                    if(db_options.busActRelBustype)
                        for(var i=0;i< db_options.busActRelBustype.length;i++){
                            if(db_options.busActRelBustype[i].dItemvalue==row.busType){
                                return db_options.busActRelBustype[i].dItemname;
                            }
                        }
                    return "";
                }
            }  , {
                title : '业务数据',
                field : 'busData',
                sortable : true
            }, {
                title : '处理时间',
                field : 'createTime',
                sortable : true
            }, {
                field : 'action',
                title : '操作',
                width : 120,
                formatter : function(value, row, index) {
                    var str = '';
                    <shiro:hasPermission name="/agActivity/taskApproval">
                    str += $.formatString('<a href="javascript:void(0)" class="batch-easyui-linkbutton-ok"  data-options="plain:true,iconCls:\'fi-check icon-green\'" onclick="updateconditionValue(\'{0}\',\'{1}\',\'{2}\',\'{3}\',\'{4}\',\'{5}\');" >任务处理</a>', row.id,row.procInstId,row.busType,row.busId,row.busData,row.sid);
                    </shiro:hasPermission>
                    return str;
                }
            } ] ],
            onLoadSuccess:function(data){
                $('.batch-easyui-linkbutton-ok').linkbutton({text:'任务处理'});
            }
        });
    });


    function updateconditionValue(taskid,proIns,busType,busId,busData,sid) {
        var url  ;
        if(busType=='Agent')
           url  = $.formatString('/agActivity/toTaskApproval?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);
        else if(busType=='Business')
            url  = $.formatString('/agActivity/agentBusTaskApproval?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);
        else if(busType=='DC_Agent')
            url  = $.formatString('/agActivity/dataChangerUpdateAprroval?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);
        else if(busType=='DC_Colinfo')
            url  = $.formatString('/agActivity/dataChangerUpdateAprroval?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);
        else if(busType=='STAGING')
            url  = $.formatString('/stagActivity/toTaskApproval?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);
        else if(busType=='OTHER_DEDUCTION')
            url  = $.formatString('/otherDeductionActivity/toTaskApproval?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);
        else if(busType=='THAW')
            url  = $.formatString('/thawActivity/toTaskApproval?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);
        else if(busType=='TOOLS')
            url  = $.formatString('/toolsActivity/toTaskApproval?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);
        else if(busType=='PkType')
            url  = $.formatString('/supplement/queryById?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);
        else if(busType=='ORDER')
            url  = $.formatString('/orderbuild/approvalOrderView?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);
        else if(busType=='COMPENSATE')
            url  = $.formatString('/compensate/approvalCompensateView?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);
        else if(busType=='refund')
            url  = $.formatString('/order/return/approvalView?taskId={0}&proIns={1}&busType={2}&busId={3}&sid={4}',taskid,proIns,busType,busId,sid);
        else if(busType=='POSREWARD')
            url  = $.formatString('/rewardActivity/toTaskApproval?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);
        else if(busType=='POSCHECK')
            url  = $.formatString('/checkActivity/toTaskApproval?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);
        else if(busType=='POSTAX')
            url  = $.formatString('/posTaxActivity/toTaskApproval?taskId={0}&proIns={1}&busType={2}&busId={3}',taskid,proIns,busType,busId);

        addTab({
            title : taskid,
            border : false,
            closable : true,
            fit : true,
            iconCls : 'fi-database',
            href:url
        });

    }


</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <a onclick="updateconditionValue()" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-plus icon-green'">添加业务</a>
    <div data-options="region:'center',fit:true,border:false">
        <table id="activityDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
