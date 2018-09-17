<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    var profitSettleList;
    $(function () {
        profitSettleList = $('#profitSettleList${sourceId}').datagrid({
            url: '${path }/profit/settleErr/getProfitSettleErrList?sourceId=${sourceId}&agentPid=${agentPid}&parentAgentPid=${parentAgentPid}',
            striped: true,
            rownumbers: true,
            pagination: true,
            singleSelect: true,
            fit: true,
            idField: 'id',
            pageSize: 20,
            pageList: [10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
            columns: [[{
                title: 'id',
                field: 'id',
                hidden: true
            }, {
                title: '登账编号',
                field: 'errCode',
                width: 80
            }, {
                title: '退单日期',
                field: 'chargebackDate',
                width: 130
            }, {
                title: '交易日期',
                field: 'tranDate',
                width: 130
            }, {
                title: '一级代理商唯一码',
                field: 'parentAgentPid',
                width: 130
            }, {
                title: '代理商唯一码',
                field: 'agentPid',
                width: 130
            }, {
                title: '商户编号',
                field: 'merchId',
                width: 130
            }, {
                title: '商户名称',
                field: 'merchName',
                width: 130
            }, {
                title: '交易金额',
                field: 'tranAmt',
                width: 130
            }, {
                title: '交易净额',
                field: 'netAmt',
                width: 130
            }, {
                title: '销账金额',
                field: 'offsetBalanceAmt',
                width: 130
            }, {
                title: '剩余未销账金额',
                field: 'balanceAmt',
                width: 130
            }, {
                title: '实扣分润',
                field: 'realDeductAmt',
                width: 130
            }, {
                title: '记损',
                field: 'lossAmt',
                width: 130
            }, {
                title: '补还分润',
                field: 'makeAmt',
                width: 130
            }, {
                title: '分润标识',
                field: 'fenrunFlag',
                width: 130
            }, {
                title: '登帐类型',
                field: 'longShortType',
                width: 130
            }, {
                title: '备注',
                field: 'errDesc',
                width: 130
            }, {
                title: '差错状态',
                field: 'errFlag',
                width: 130
            }, {
                title: '交易卡号',
                field: 'cardNo',
                width: 130
            }, {
                title: '检索参考号',
                field: 'hostLs',
                width: 130
            } , {
                title: '出款日期',
                field: 'balanceDate',
                width: 130
            }, {
                title: '合作模式',
                field: 'cooperationMode',
                width: 130
            }, {
                title: '省份',
                field: 'provinces',
                width: 130
            } , {
                title: '业务类型',
                field: 'businessType',
                width: 130
            }, {
                title: '应扣分润',
                field: 'mustDeductionAmt',
                width: 130
            }, {
                title: '应补分润',
                field: 'mustSupplyAmt',
                width: 130
            }, {
                title: '应冲抵分润',
                field: 'mustCdAmt',
                width: 130
            }, {
                title: '应收未收',
                field: 'yswsAmt',
                width: 130
            }, {
                title: '用户编号',
                field: 'hbMerchId',
                width: 130
            }, {
                title: '归属机构',
                field: 'hbOrg',
                width: 130
            }, {
                title: '姓名',
                field: 'hbName',
                width: 130
            }, {
                title: '手机号',
                field: 'hbPhone',
                width: 130
            }, {
                title: '终端号',
                field: 'hbTermId',
                width: 130
            }
            ]],
            toolbar: '#settleErrToolbar'
        });

    });

    function searchSettleErr() {
        profitSettleList.datagrid('load', $.serializeObject($('#searchSettleErrForm${sourceId}')));
    }

    function cleanhDedcution() {
        $('#searchSettleErrForm input').val('');
        profitSettleList.datagrid('load', {});
    }

    $("#tranDateStart,#tranDateEnd").datebox({
        required: true,
        formatter: function (date) {
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            var d = date.getDate();
            return y + (m < 10 ? ('0' + m) : m) + (d < 10 ? ('0' + d) : d);
        },
        parser: function (s) {
        }
    })
    <%--function exportDedcution() {--%>
    <%--$('#searchSettleErrForm').form({--%>
    <%--url : '${path }/profit/settleErr/export',--%>
    <%--onSubmit : function() {--%>
    <%--return $(this).form('validate');--%>
    <%--}--%>
    <%--});--%>
    <%--$('#searchSettleErrForm').submit();--%>
    <%--}--%>
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div id="" data-options="region:'west',border:true,title:'业务平台列表'" style="width:100%;overflow: hidden; ">
        <table id="profitSettleList${sourceId}" data-options="fit:true,border:false"></table>
    </div>
    <div data-options="region:'north',border:false" style="height: 40px; overflow: hidden;background-color: #fff">
        <form id="searchSettleErrForm${sourceId}">
            <table>
                <tr>
                    <th>交易日期:</th>
                    <td>
                        <input id="tranDateStart" name="tranDateStart" class="easyui-datebox">
                    </td>
                    <th>-</th>
                    <td><input id="tranDateEnd" name="tranDateEnd" class="easyui-datebox"></td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchSettleErr();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanhDedcution();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>


