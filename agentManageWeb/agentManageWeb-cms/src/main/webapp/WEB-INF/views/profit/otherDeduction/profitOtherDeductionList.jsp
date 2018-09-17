<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    var profitOtherDedcutionList;
    $(function () {
        profitOtherDedcutionList = $('#profitOtherDedcutionList').datagrid({
            url: '${path }/profit/other/getProfitDeductionList',
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
                title: '上级代理商编号',
                field: 'parentAgentPid',
                width: 130
             },
                {
                    title: '代理商编号',
                    field: 'agentPid',
                    width: 130
                }, {
                    title: '代理商名称',
                    field: 'agentName',
                    width: 130
                },
                {
                    title: '月份',
                    field: 'deductionDate',
                    width: 80
                }, {
                    title: '上月未扣足',
                    field: 'upperNotDeductionAmt',
                    width: 80
                }, {
                    title: '本月新增',
                    field: 'addDeductionAmt',
                    width: 80
                }, {
                    title: '总应扣',
                    field: 'sumDeductionAmt',
                    width: 80
                }, {
                    title: '本月应扣',
                    field: 'mustDeductionAmt',
                    width: 80
                }, {
                    title: '本月实扣',
                    field: 'actualDeductionAmt',
                    width: 80
                }, {
                    title: '未扣足',
                    field: 'notDeductionAmt',
                    width: 130
                }, {
                    title: '扣款类型',
                    field: 'remark',
                    width: 130
                }, {
                    title: '创建时间',
                    field: 'createDateTime',
                    width: 130
                }, {
                    title: '扣款状态',
                    field: 'deductionStatus',
                    width: 130,
                    formatter: function (value, row) {
                        if (value == '1' ) {
                            return "已扣款";
                        }
                        return "未扣款";
                    }
                }, {
                    title: '审批记录',
                    field: 'stagingStatus1',
                    width: 130,
                    formatter: function (value, row) {
                        var str = '';
                        if (row.stagingStatus == '1' || row.stagingStatus == '2' || row.stagingStatus == '3' ) {
                            str += $.formatString('<a id="stagButton" href="javascript:void(0)" class="easyui-linkbutton-add" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="queryApproval(\'{0}\');" >查看</a>', row.id);
                        }
                        return str;
                    }
                }, {
                    field: 'action',
                    title: '操作',
                    width: 200,
                    formatter: function (value, row) {
                        var str = '';
                        var deductionStatus = row.deductionStatus;
                        if (row.stagingStatus == '0' && deductionStatus!='1') {
                            if (row.addDeductionAmt != null) {
                                if ('${noEdit}'==0) {
                                    str += $.formatString('<a id="stagButton" href="javascript:void(0)" class="easyui-linkbutton-add" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="applyStaging(\'{0}\');" >申请分期</a>', row.id);
                                }
                            }
                        } else if (row.stagingStatus == '3') {
                            str += $.formatString('<a id="stagButton" href="javascript:void(0)" class="easyui-linkbutton-add" data-options="plain:true,iconCls:\'fi-magnifying-glass\'" onclick="queryStaging(\'{0}\');" >查看分期</a>', row.id);
                        } else if (row.stagingStatus == '4') {
                            if ('${noEdit}'==0) {
                                str += $.formatString('<a id="stagButton" href="javascript:void(0)" class="easyui-linkbutton-add" data-options="plain:true,iconCls:\'fi-magnifying-glass\'" onclick="applyStaging(\'{0}\');" >审核不通过,重新申请</a>', row.id);
                            }
                        } else {
                        }
                        return str;
                    }
                }
            ]],
            onLoadSuccess: function (data) {
                $('.easyui-linkbutton-query').linkbutton();
                $('.easyui-linkbutton-add').linkbutton();
            },
            toolbar: '#otherDeductionToolbar'
        });

    });

    /**
     * 查看审批明细
     */
    function queryApproval(id) {
        addTab({
            title: '分期审批展示'+id,
            border: false,
            closable: true,
            fit: true,
            href: '${path}/stagActivity/gotoTaskApproval?sourceId=' + id
        });
    }

    /**
     * 查看'其他扣款明细
     */
    function queryDetail(id) {
        addTab({
            title: '其他扣款明细数据展示'+id,
            border: false,
            closable: true,
            fit: true,
            href: '${path}/profit/other/deduction/gotoDeductionDetailList?sourceId=' + id
        });
    }

    /**
     * 查看分期
     **/
    function queryStaging(id) {
        addTab({
            title: '分期明细数据展示'+id,
            border: false,
            closable: true,
            fit: true,
            href: '${path}/profit/staging/gotoStagingDetailList?sourceId=' + id
        });
    }

    /**
     * 申请分期
     */
    function applyStaging(id) {
        parent.$.modalDialog({
            title: '申请分期',
            width: 500,
            height: 300,
            href: '${path }/profit/staging/gotoAddPage?sourceId=' + id + '&stagType=2',
            buttons: [{
                text: '确定',
                handler: function () {
                    parent.$.modalDialog.openner_dataGrid = profitOtherDedcutionList;
                    var f = parent.$.modalDialog.handler.find('#stagingForm');
                    f.submit();
                }
            }]
        });
    }

    function searchDedcution() {
        profitOtherDedcutionList.datagrid('load', $.serializeObject($('#searchOtherDedcutionForm')));
    }

    function cleanhDedcution() {
        $('#searchOtherDedcutionForm input').val('');
        profitOtherDedcutionList.datagrid('load', {});
    }

    function RefreshCloudHomePageTab() {
        profitOtherDedcutionList.datagrid('reload');
    }

    function myformatter(date) {
        var y = date.getFullYear();
        var m = date.getMonth() + 1;
        var d = date.getDate();
        return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
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
        required: true,
        formatter: function (date) {
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            var d = date.getDate();
            return y + "-" + (m < 10 ? ('0' + m) : m);
        },
        parser: function (s) {
            var t = Date.parse(s);
            if (!isNaN(t)) {
                return new Date(t);
            } else {
                return new Date();
            }
        }
    })

    function importDedcution() {
        parent.$.modalDialog({
            title: '导入',
            width: 500,
            height: 100,
            href: '${path}/profit/other/gotoAddPage',
            buttons: [{
                text: '确定',
                handler: function () {
                    parent.$.modalDialog.openner_dataGrid = profitOtherDedcutionList;
                    var f = parent.$.modalDialog.handler.find('#importForm');
                    f.submit();
                }
            }]
        });
    }
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div id="" data-options="region:'west',border:true,title:'业务平台列表'" style="width:100%;overflow: hidden; ">
        <table id="profitOtherDedcutionList" data-options="fit:true,border:false"></table>
    </div>
    <div data-options="region:'north',border:false" style="height: 40px; overflow: hidden;background-color: #fff">
        <form id="searchOtherDedcutionForm">
            <table>
                <tr>
                    <th>月份:</th>
                    <td>
                        <input id="deductionDateStart" name="deductionDateStart">
                    </td>
                    <th>-</th>
                    <td><input id="deductionDateEnd" name="deductionDateEnd"></td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchDedcution();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanhDedcution();">清空</a>
                        <c:if test="${noEdit==0}">
                            <a href="javascript:void(0);" class="easyui-linkbutton"
                               data-options="iconCls:'icon-print',plain:true" onclick="importDedcution();">导入</a>
                        </c:if>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>


