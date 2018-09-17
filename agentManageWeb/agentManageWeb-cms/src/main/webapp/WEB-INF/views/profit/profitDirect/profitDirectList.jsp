<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>

<script type="text/javascript">
    var logisticsA;
    $(function() {
        logisticsA = $('#ID').datagrid({
            url : '${path }/profitDirect/getList',
            striped : true,
            rownumbers : true,
            pagination : true,
            singleSelect : true,
            fit : true,
            idField : 'ID',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            columns : [ [ {
                title : '代理商编号',
                field : 'AGENT_ID'
            } , {
                title : '代理商名称',
                field : 'AGENT_NAME'
            } , {
                title : '月份',
                field : 'TRANS_MONTH'
            } , {
                title : '上级代理商名称',
                field : 'PARENT_AGENT_NAME'
            } , {
                title : '一级代理商名称',
                field : 'FRIST_AGENT_NAME'
            } , {
                title : '直发交易额',
                field : 'TRANS_AMT'
            } , {
                title : '直发手续费',
                field : 'TRANS_FEE'
            } , {
                title : '直发分润',
                field : 'PROFIT_AMT'
            } , {
                title : '退单补款',
                field : 'SUPPLY_AMT'
            }, {
                title : '退单扣款',
                field : 'BUCKLE_AMT'
            }, {
                title : '应发分润',
                field : 'SHOULD_PROFIT'
            }, {
                title : '实发分润',
                field : 'ACTUAL_PROFIT'
            }, {
                title : '月份',
                field : 'TRANS_MONTH'
            }, {
                title : '邮箱',
                field : 'AGENT_EMAIL'
            }, {
                title : '账号',
                field : 'ACCOUNT_CODE'
            }, {
                title : '户名',
                field : 'ACCOUNT_NAME'
            }, {
                title : '开户行',
                field : 'BANK_OPEN'
            }, {
                title : '银行号',
                field : 'BANK_CODE'
            }, {
                title : '总行行号',
                field : 'BOSS_CODE'
            }, {
                title : '应找上级扣款',
                field : 'PARENT_BUCKLE'
            }, {
                title : '冻结状态',
                field : 'STATUS',
                formatter : function(value, row, index) {
                switch (value) {
                case "1":
                    return '冻结';
                case "2":
                    return '未冻结';
                }
             }
            }

            ] ],
            toolbar : '#profitDirectToolbar'
        });
    });

    /**
     * 搜索事件
     */
    function searchProfitDirect() {
        logisticsA.datagrid('load', $.serializeObject($('#ProfitDirectForm')));
    }
    /**
     * 清空事件
     */
    function cleanProfitDirect() {
        $('#ProfitDirectForm input').val('');
        logisticsA.datagrid('load', {});
    }

    // 导入数据
    $("#importProfitDirect").click(function(){
        parent.$.modalDialog({
            title : '导入保理数据',
            width : 300,
            height : 110,
            href : "/profitDirect/importPage",
            buttons : [ {
                text : '确定',
                handler : function() {
                    var fun = parent.$.modalDialog.handler.find('#importFileForm');
                    fun.submit();
                }
            } ]
        });
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div id="" data-options="region:'west',border:true,title:'业务平台列表'" style="width:100%;overflow: hidden; ">
        <table id="ID" data-options="fit:true,border:false"></table>
    </div>
    <div data-options="region:'north',border:false" style="height: 32px; overflow: hidden;background-color: #fff">
        <%--<form id ="ProfitDirectForm" method="post">
            <table>
                <tr>
                    <th>代理商编号：</th>
                    <td><input name="AGENT_ID" id="AGENT_ID" style="line-height:17px;border:1px solid #ccc;width:160px;"></td>
                    <td>&nbsp;&nbsp;&nbsp;</td>
                    <th>代理商名称：</th>
                    <td><input name="AGENT_NAME" id="AGENT_NAME" style="line-height:17px;border:1px solid #ccc;width:160px;"></td>
                    <td>&nbsp;&nbsp;&nbsp;</td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchProfitDirect();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanProfitDirect();">清空</a>
                    </td>
                    
                </tr>
            </table>
        </form>--%>
            <form method="post" action="${path}/profitDirect/exportProfitDirect" id ="ProfitDirectForm"  >
                    <table>
                        <tr>
                            <th>代理商名称：</th>
                            <td><input name="AGENT_NAME" id="AGENT_NAME" style="line-height:17px;border:1px solid #ccc;width:160px;"></td>
                            <td>&nbsp;&nbsp;&nbsp;</td>
                            <th>代理商编号：</th>
                            <td><input name="AGENT_ID" id="AGENT_ID" style="line-height:17px;border:1px solid #ccc;width:160px;"></td>
                            <td>&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchProfitDirect();">查询</a>
                                <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanProfitDirect();">清空</a>
                            </td>
                            <!-- 新增导出-->
                            <td>
                                <button type="submit" class="easyui-linkbutton"  data-options="iconCls:'icon-print',plain:true," >导出</button>
                            </td>
                        </tr>
                    </table>
            </form>
    </div>
</div>
