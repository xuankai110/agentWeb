<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<div id="profitByFinance_list_ConditionToolbar" style="display: none;">
    <form  method="post" action="" id ="profitByFinance_list_ConditionToolbar_searchform" >
        <table>
            <tr>
                   <%-- <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="showAgentInfoSelectDialog({data:this,callBack:function(item,data){
                            if(item){
                                 $($(data).parent('td').find('#agName')).textbox('setText',item.agName);
                                 $($(data).parent('td').find('#agentId')).textbox('setText',item.id);
                            }
                        }})">检索代理商</a>--%>
                <th>代理商编号</th>
                <td><input id="agentId" name="agentId" type="text" class="easyui-textbox" data-options="prompt:'代理商编号'" value="" style="width:180px;"></td>
                <th>代理商名称</th>
                 <td><input id="agentName" name="agentName" type="text" class="easyui-textbox" data-options="prompt:'代理商名称'" style="width:180px;"></td>
                       <th>月份:</th>
                       <td>
                           <input id="profitDateStart" name="profitDateStart">
                       </td>
                       <th>-</th>
                       <td><input id="profitDateEnd" name="profitDateEnd"></td>
                <td>
                    <a  class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchprofitByFinance_list()">查询</a>
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanAgentListSearchForm();">清空</a>
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-check',plain:true" onclick="commitFinal();">终审</a>
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-check',plain:true" onclick="payMoney();">出款</a>
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-print',plain:true" onclick="exportProfitMonthDetail();">导出出款文件</a>
                </td>
            </tr>
        </table>
    </form>
</div>
<div  class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',fit:true,border:false">
        <table id="profitByFinance_list_ConditionDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<script type="text/javascript">
    var profitByFinance_list_ConditionDataGrid;



    $(function() {


        //代理商表格
        profitByFinance_list_ConditionDataGrid = $('#profitByFinance_list_ConditionDataGrid').datagrid({
            url : '${path}/profit/profitFList',
            rownumbers : true,
            striped : true,
            pagination : true,
            iconCls:'icon-edit',
            singleSelect : true,
            editors:$.fn.datagrid.defaults.editors,
            idField : 'id',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            columns : [ [ {
                title : '分润日期',
                align:'center',
                field : 'profitDate'
            },{
                title : '商户编号',
                align:'center',
                field : 'agentId'
            },{
                title : '上级商户编号',
                align:'center',
                field : 'parentAgentId'
            },{
                title : '付款交易额(pos交易额+二维码交易额+云闪付+银联二维)',
                align:'center',
                field : 'tranAmt'
            },{
                title : '出款交易额(S0+D1)',
                align:'center',
                field : 'payAmt'
            },{
                title : '付款交易分润比例',
                align:'center',
                field : 'tranProfitScale'
            },{
                title : '出款交易分润比例',
                align:'center',
                field : 'payProfitScale'
            },{
                title : '付款交易分润额',
                align:'center',
                field : 'tranProfitAmt'
            },{
                title : '出款交易分润额',
                align:'center',
                field : 'payProfitAmt'
            },{
                title : '瑞银信分润',
                align:'center',
                field : 'ryxProfitAmt'
            },{
                title : '瑞银信活动分润',
                align:'center',
                field : 'ryxHdProfitAmt'
            },{
                title : '贴牌分润',
                align:'center',
                field : 'tpProfitAmt'
            },{
                title : '瑞刷分润',
                align:'center',
                field : 'rsProfitAmt'
            },{
                title : '瑞刷活动分润',
                align:'center',
                field : 'rsHdProfitAmt'
            },{
                title : '瑞和宝分润',
                align:'center',
                field : 'rhbProfitAmt'
            },{
                title : '直发平台分润',
                align:'center',
                field : 'zfProfitAmt'
            },{
                title : 'POS直签补差分润',
                align:'center',
                field : 'posZqSupplyProfitAmt'
            },{
                title : '手刷直签补差分润',
                align:'center',
                field : 'mposZqSupplyProfitAmt'
            },{
                title : '分润汇总',
                align:'center',
                field : 'profitSumAmt'
            },{
                title : 'POS退单应扣款',
                align:'center',
                field : 'posTdMustDeductionAmt'
            },{
                title : 'POS退单实扣款',
                align:'center',
                field : 'posTdRealDeductionAmt'
            },{
                title : '手刷退单应扣',
                align:'center',
                field : 'mposTdMustDeductionAmt'
            },{
                title : '手刷退单实扣',
                align:'center',
                field : 'mposTdRealDeductionAmt'
            },{
                title : '瑞和宝订购应扣总额',
                align:'center',
                field : 'rhbDgMustDeductionAmt'
            },{
                title : '瑞和宝订购实扣',
                align:'center',
                field : 'rhbDgRealDeductionAmt'
            },{
                title : 'POS订购应扣总额',
                align:'center',
                field : 'posDgMustDeductionAmt'
            },{
                title : 'POS订购实扣',
                align:'center',
                field : 'posDgRealDeductionAmt'
            },{
                title : '智能POS订购应扣总额',
                align:'center',
                field : 'zposDgMustDeductionAmt'
            },{
                title : '智能POS订购实扣',
                align:'center',
                field : 'zposTdRealDeductionAmt'
            },{
                title : 'POS考核扣款(新国都、瑞易送)',
                align:'center',
                field : 'posKhDeductionAmt'
            },{
                title : '手刷考核扣款(小蓝牙、MPOS)',
                align:'center',
                field : 'mposKhDeductionAmt'
            },{
                title : '商业保理扣款',
                align:'center',
                field : 'buDeductionAmt'
            },{
                title : '其他扣款',
                align:'center',
                field : 'otherDeductionAmt'
            },{
                title : 'POS退单补款',
                align:'center',
                field : 'posTdSupplyAmt'
            },{
                title : '手刷退单补款',
                align:'center',
                field : 'mposTdSupplyAmt'
            },{
                title : '其他补款',
                align:'center',
                field : 'otherSupplyAmt'
            },{
                title : 'POS奖励',
                align:'center',
                field : 'posRewardAmt'
            },{
                title : '扣当月之前税额（包含当月日结分润）',
                align:'center',
                field : 'deductionTaxMonthAgoAmt'
            },{
                title : '扣本月税额',
                align:'center',
                field : 'deductionTaxMonthAmt'
            },{
                title : '补下级税点',
                align:'center',
                field : 'supplyTaxAmt'
            },{
                title : '实发分润',
                align:'center',
                field : 'realProfitAmt'
            },{
                title : '本月分润',
                align:'center',
                field : 'profitMonthAmt'
            },{
                title : '账号',
                align:'center',
                field : 'accountId'
            },{
                title : '户名',
                align:'center',
                field : 'accountName'
            },{
                title : '开户行',
                align:'center',
                field : 'openBankName'
            },{
                title : '邮箱地址',
                align:'center',
                field : 'email'
            },{
                title : '联行号',
                align:'center',
                field : 'bankCode'
            },{
                title : '总行行号',
                align:'center',
                field : 'uTime'
            },{
                title : '打款状态',
                align:'center',
                field : 'payStatus'
            },{
                title : '分润状态',
                align:'center',
                field : 'status',
                formatter : function(value, row, index) {
                    switch (value) {
                        case "0":
                            return '正常';
                        case "1":
                            return '冻结';
                        case "2":
                            return '解冻审批中';
                        case "3":
                            return '解冻审批失败';
                        case "4":
                            return '未分润';
                        case "5":
                            return '已分润';
                        case "6":
                            return '打款失败';
                    }
                }
            },{
                title : '备注',
                align:'center',
                field : 'remark'
            }/*,{
                title : '审核记录',
                align:'center',
                field : 'status1',
                formatter : function(value, row, index) {
                    if (row.status=='2' || row.status=='4') {
                        return $.formatString('<a href="javascript:void(0)" class="easyui-linkbutton-add" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="queryApproval(\'{0}\');" >查看</a>', row.id);
                    }else{
                        return "";
                    }
                }
            }*/,{
                field : 'action',
                title : '操作',
                width : 350,
                formatter : function(value, row, index) {

                    var str = '';

                    str += $.formatString('<a href="javascript:void(0)" class="activity-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="queryProfitDetail(\'{0},{1}\');" >明细</a>', row.agentId, row.id);

                    str += "&nbsp;&nbsp;||&nbsp;&nbsp;"+$.formatString('<a href="javascript:void(0)" class="profitByFinance_save-look-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="frozen(\'{0}\',\'{1}\');" >冻结</a>',row.id,row.status);

                    return str;
                }
            }  ] ],
            onLoadSuccess:function(data){

            },
            onDblClickRow:function(dataIndex,rowData){
            },
            onBeforeEdit:function(index,row){
                row.editing = true;
            },
            onAfterEdit:function(index,row){
                row.editing = false;
                saveRowAction(row);
            },
            onCancelEdit:function(index,row){
                row.editing = false;
            },
            toolbar : '#profitByFinance_list_ConditionToolbar'
        });


        //代理商入网form
        $("#angetEnterInFormDialog").click(function(){
            addTab({
                title : '代理商操作-新签代理商',
                border : false,
                closable : true,
                fit : true,
                href:'/agentEnter/agentForm'
            });
        });


    });

    function queryProfitDetail(agentId) {
        addTab({
            title : '明细数据展示',
            border : false,
            closable : true,
            fit : true,
            href:'/monthProfit/detail/page?agentId='+agentId
        });
    }

    function getRowIndex(target){
        var tr = $(target).closest('tr.datagrid-row');
        return parseInt(tr.attr('datagrid-row-index'));
    }

    function editrow(index){
        profitByFinance_list_ConditionDataGrid.datagrid('beginEdit', index);
    }
    function saverow(index){
        var rows = profitByFinance_list_ConditionDataGrid.datagrid('getRows');    // get current page rows
        var row = rows[index];    // your row data
        $.messager.confirm('确定','你确定冻结['+row.agentName+"]的分润么",function(r){
            profitByFinance_list_ConditionDataGrid.datagrid('endEdit', index);
        });
    }
    function cancelrow(index){
        profitByFinance_list_ConditionDataGrid.datagrid('cancelEdit', index);
    }

    /**
     * 出款
     **/
    function payMoney() {
        parent.$.messager.confirm('询问', '确认要进行出款吗？', function(b) {
            if (b) {
                $.ajax({
                    url :"${path}/monthProfit/payMoney",
                    type:'POST',
                    dataType:'json',
                    success:function(result){
                        if (result.success) {
                            parent.$.messager.alert('提示', result.msg, 'info');
                        } else {
                            parent.$.messager.alert('错误', result.msg, 'error');
                        }
                    },
                    error:function(data){
                        alertMsg("系统异常，请联系管理员！");
                    }
                });
            }
        });
    }
    function exportProfitMonthDetail() {
        $('#profitByFinance_list_ConditionToolbar_searchform').form({
            url: '${path }/monthProfit/export',
            onSubmit: function (result) {

            }
        });
        $('#profitByFinance_list_ConditionToolbar_searchform').submit();
    }
    /**
     * 终审
     **/
    function commitFinal() {
        parent.$.messager.confirm('询问', '确认要提交终审，后续不能再进行任务修改操作？', function(b) {
            if (b) {
                $.ajax({
                    url :"${path}/monthProfit/commitFinal",
                    type:'POST',
                    dataType:'json',
                    success:function(result){
                        if (result.success) {
                            parent.$.messager.alert('提示', result.msg, 'info');
                        } else {
                            parent.$.messager.alert('错误', result.msg, 'error');
                        }
                    },
                    error:function(data){
                        alertMsg("系统异常，请联系管理员！");
                    }
                });
            }
        });
    }

    function frozen(id,status) {
        if(status=="1"){
            parent.$.messager.alert('提示', "该状态为已冻结!", 'info');
        }
        if(status != "1"){
            parent.$.modalDialog({
                title : '冻结',
                width : 400,
                height : 220,
                href : '${path }/profit/frozenProfit?id=' + id,
                buttons : [ {
                    text : '确定',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = profitByFinance_list_ConditionDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#custEditForm');
                        f.submit();
                    }
                } ]
            });
        }
    }

    //日期查询
    $("#profitDateStart,#profitDateEnd").datebox({
        required: true,
        formatter: function (date) {
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            var d = date.getDate();
            return y + (m < 10 ? ('0' + m) : m);
        },
        parser: function (s) {
        }
    })


    /**
     * 搜索事件
     */
    function searchprofitByFinance_list() {
        profitByFinance_list_ConditionDataGrid.datagrid('load', $.serializeObject($('#profitByFinance_list_ConditionToolbar_searchform')));
    }


    function agentQuery(id,agStatus) {
        addTab({
            title : '代理商操作-查看'+id,
            border : false,
            closable : true,
            fit : true,
            href:'/agentEnter/agentQuery?id='+id+"&agStatus="+agStatus
        });
    }



    //地区选择
    function returnSelectForSearchBaseRegion(data,options){
        $(options.target).prev("input").val(data.id);
        $(options.target).prev("input").prev("input").val(data.text);
    }

    function cleanAgentListSearchForm() {
        $('#profitByFinance_list_ConditionToolbar_searchform input').val('');
        $("[name='agStatus']").val('');
        profitByFinance_list_ConditionDataGrid.datagrid('load', {});
    }

    function onprofitByFinanceClickCell(index,field,value){

    }

    function onprofitByFinanceAfterEdit(index, row, changes){


    }


</script>
