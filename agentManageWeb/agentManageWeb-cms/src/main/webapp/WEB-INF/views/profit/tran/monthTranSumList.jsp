<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    var tranList;
    $(function () {
        tranList = $('#tranList').datagrid({
            url: '${path }/profit/tran/check/getMonthTranSumList',
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
            },
                {
                    title: '月份',
                    field: 'profitDate',
                    width: 80
                }, {
                    title: '类型',
                    field: 'productName',
                    width: 130
                }, {
                    title: '清算',
                    field: 'settleAmt',
                    width: 130
                }, {
                    title: '业务平台',
                    field: 'tranAmt',
                    width: 130
                }, {
                    title: '差异',
                    field: 'differenceAmt',
                    width: 130
                }
            ]],
            onLoadSuccess: function (data) {
                $('.easyui-linkbutton-query').linkbutton();
                $('.easyui-linkbutton-add').linkbutton();
            },
            toolbar: '#otherDeductionToolbar'
        });

    });
  

    function searchTran() {
        tranList.datagrid('load', $.serializeObject($('#searchTranForm')));
    }

    function cleanhTran() {
        $('#searchTranForm input').val('');
        tranList.datagrid('load', {});
    }
    function importData () {
        $.ajaxL({
            type: "POST",
            url: '${path }/profit/tran/check/importData',
            dataType:'json',
            traditional:true,
            contentType:"application/x-www-form-urlencoded",
            beforeSend : function() {
                progressLoad();
            },
            success: function(msg){
                if (msg.success) {
                    alertMsg( msg.msg);
                }else {
                    alertMsg("系统异常，请联系运维人员！");
                }
            },
            complete:function (XMLHttpRequest, textStatus) {
                progressClose();
            }
        });
    }
    function alertMsg(msg) {
        parent.$.messager.alert('提示',msg, 'info');
    }
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
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div id="" data-options="region:'west',border:true,title:'业务平台列表'" style="width:100%;overflow: hidden; ">
        <table id="tranList" data-options="fit:true,border:false"></table>
    </div>
    <div data-options="region:'north',border:false" style="height: 40px; overflow: hidden;background-color: #fff">
        <form id="searchTranForm">
            <table>
                <tr>
                    <th>月份:</th>
                    <td>
                        <input id="profitDateStart" name="profitDateStart">
                    </td>
                    <th>-</th>
                    <td><input id="profitDateEnd" name="profitDateEnd"></td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchTran();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanhTran();">清空</a>
                        <c:if test="${noEdit==0}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           data-options="iconCls:'icon-print',plain:true" onclick="importData();">重新导入</a>
                        </c:if>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>


