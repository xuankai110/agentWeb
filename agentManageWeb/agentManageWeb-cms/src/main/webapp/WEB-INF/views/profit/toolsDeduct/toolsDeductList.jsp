<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    var toolsDeductListGrid;
    $(function() {
        toolsDeductListGrid = $('#toolsDeductList').datagrid({
            url : '${path }/toolsDeduct/list',
            striped : true,
            rownumbers : true,
            pagination : true,
            singleSelect : true,
            fit : true,
            idField : 'id',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100],
            columns : [ [{
                title : '分期日期',
                field : 'deductionDate',
                align:'center',
                width:150
            },{
                title : '代理商名称',
                field : 'agentName',
                align:'center',
                width:250
            },{
                title : '代理商编号',
                field : 'agentPid',
                align:'center',
                width:250
            },{
                title : '担保代理商编号',
                field : 'parentAgentPid',
                align:'center',
                width:250
            },{
                title : '订单机具类型',
                field : 'deductionDesc',
                align:'center',
                width:150,
                formatter : function(value, row, index) {
                    switch (value) {
                        case "100002":
                            return '智能POS';
                        case "100003":
                            return 'POS';
                        case "5000":
                            return 'MPOS-瑞和宝';
                        case "6000":
                            return 'MPOS-瑞和宝直发平台';
                        case "4000":
                            return 'MPOS-瑞众通';
                        case "2000":
                            return 'MPOS-瑞刷';
                        case "3000":
                            return 'MPOS-瑞刷活动';
                        case "0001":
                            return 'MPOS-瑞银信';
                        case "1001":
                            return 'MPOS-贴牌';
                        case "1111":
                            return 'MPOS-瑞银信活动';
                    }
                }
            },{
                title : '分期订单号',
                field : 'sourceId',
                align:'center',
                width:200
            },{
                title : '本月新增扣款金额',
                field : 'addDeductionAmt',
                align:'center',
                width:150
            },{
                title : '上月未扣足金额+上期调整金额',
                field : 'upperNotDeductionAmt',
                align:'center',
                width:190
            },{
                title : '本月扣款总金额',
                field : 'sumDeductionAmt',
                align:'center',
                width:150
            },{
                title : '本月应扣款金额',
                field : 'mustDeductionAmt',
                align:'center',
                width:150
            },{
                title : '本月机具实扣款金额',
                field : 'actualDeductionAmt',
                align:'center',
                width:150
            },{
                title : '本月未扣足金额',
                field : 'notDeductionAmt',
                align:'center',
                width:150
            },{
                title : '状态',
                field : 'stagingStatus',
                align:'center',
                width:150,
                formatter : function(value, row, index) {
                    switch (value) {
                        case "0":
                            return '未扣款';
                        case "1":
                            return '未审核';
                        case "2":
                            return '审批中';
                        case "3":
                            return '审批通过，未扣款';
                        case "4":
                            return '审批未通过，正常扣款';
                        case "5":
                            return '已扣款';
                    }
                }
            }, {
                field : 'action',
                title : '操作',
                width : 310,
                formatter : function(value, row, index) {
                    var str = '';
                    if(row.stagingStatus == '0'|| row.stagingStatus == '1'|| row.stagingStatus == '4'){
                        str += $.formatString('<a href="javascript:void(0)" class="activity-easyui-linkbutton-edit-tools" data-options="plain:true,iconCls:\'fi-social-myspace icon-red\'" onclick="applyAdjustment(\'{0}\');" >申请扣款调整</a>', row.id);
                        str += "&nbsp;&nbsp;&nbsp;&nbsp"
                    }
                    if(row.stagingStatus == '2'|| row.stagingStatus == '4'){
                        str += $.formatString('<a href="javascript:void(0)" class="easyui-linkbutton-query-tools" data-options="plain:true,iconCls:\'fi-magnifying-glass\'"  onclick="showActivity(\'{0}\');">查看审批进度</a>', row.id);
                        str += "&nbsp;&nbsp;&nbsp;&nbsp"
                    }
                    if(row.stagingStatus == '3'|| row.stagingStatus == '5'){
                        if(row.sumDeductionAmt != row.mustDeductionAmt){
                            str += $.formatString('<a href="javascript:void(0)"  class="easyui-linkbutton-add-tools" data-options="plain:true,iconCls:\'fi-magnifying-glass\'" onclick="queryDetail(\'{0}\');" >调整部分扣款明细</a>', row.id);
                        }
                    }
                    return str;
                }
            }
            ]],
            onLoadSuccess:function(data){
                $('.activity-easyui-linkbutton-edit-tools').linkbutton({text:'申请扣款调整'});
                $('.easyui-linkbutton-query-tools').linkbutton({text:'查看审批进度'});
                $('.easyui-linkbutton-add-tools').linkbutton({text:'调整部分扣款明细'});
            }
        });
    });

    function showActivity(id) {
        addTab({
            title : '机具扣款申请调整审批进度',
            border : false,
            closable : true,
            fit : true,
            href : '/toolsActivity/gotoTaskApproval?id='+id
        });
    }

    function applyAdjustment(id) {
        parent.$.modalDialog({
            title : '申请调整',
            width : 400,
            height : 380,
            href : '${path }/toolsDeduct/editPage?id='+id,
            buttons : [ {
                text : '申请',
                handler : function() {
                    parent.$.modalDialog.openner_dataGrid = toolsDeductListGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                    var f = parent.$.modalDialog.handler.find('#toolsDeductEditForm');
                    f.submit();
                }
            } ]
        });
    }
    function queryDetail(id) {
        parent.$.modalDialog({
            title : '调整部分下月扣款明细',
            width : 400,
            height : 200,
            href : '${path }/toolsDeduct/detail/page?id='+id
        });
    }

    function searchToolsData() {
        toolsDeductListGrid.datagrid('load', $.serializeObject($('#toolsDeductForm')));
    }
    function cleanToolsData() {
        $('#toolsDeductForm input').val('');
        toolsDeductListGrid.datagrid('load', {});
    }

    function myformatter(date){
        var y = date.getFullYear();
        var m = date.getMonth()+1;
        var d = date.getDate();
        return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
    }

    function myparser(s) {
        if (!s) return new Date();
        var ss = (s.split('-'));
        var y = parseInt(ss[0], 10);
        var m = parseInt(ss[1], 10);
        var d = parseInt(ss[2], 10);
        if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
            return new Date(y, m - 1, d);
        } else {
            return new Date();
        }
    }
    $("#deductionDateStart,#deductionDateEnd").datebox({
        required:true,
        formatter: function(date){
            var y = date.getFullYear();
            var m = date.getMonth()+1;
            var d = date.getDate();
            return y+"-"+(m<10?('0'+m):m);
        },
        parser: function(s){
            var t = Date.parse(s);
            if (!isNaN(t)){
                return new Date(t);
            } else {
                return new Date();
            }
        }
    })
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div id="" data-options="region:'west',border:true,title:'业务平台列表'"  style="width:100%;overflow: hidden; ">
        <table id="toolsDeductList" data-options="fit:true,border:false"></table>
    </div>
    <div data-options="region:'north',border:false" style="height: 40px; overflow: hidden;background-color: #fff">
        <form id ="toolsDeductForm" method="post">
            <table>
                <tr>
                    <th>日期:</th>
                    <td><input id ="deductionDateStart" name="deductionDateStart" >&nbsp;至</td>
                    <td><input id="deductionDateEnd" name="deductionDateEnd" ></td>
                    <th>分期订单:</th>
                    <td><input id ="sourceId" name="sourceId" ></td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchToolsData();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanToolsData();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>

