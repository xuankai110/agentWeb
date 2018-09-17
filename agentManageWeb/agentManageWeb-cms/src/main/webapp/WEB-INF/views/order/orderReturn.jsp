<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>

<div class="easyui-panel" data-options="iconCls:'fi-results'">
    <div data-options="region:'north',title:'填写订单',split:true,iconCls:'icon-ok'" style="">
        <form id="uploadForm" enctype="multipart/form-data" method="post">
            <table style="vertical-align: middle;">
                <tr>
                    <td>
                        <input type="file" id="file" name="file" style="width: 200px"/>
                        <a class="easyui-linkbutton" data-options="iconCls:'fi-upload'" onclick="uploadFormSubmit()">上传SN号</a>
                        &nbsp;&nbsp;&nbsp;&nbsp;<a href="/static/template/refundModal.xlsx">下载模板</a>
                    </td>
                </tr>
            </table>
        </form>

    </div>
</div>


<div class="easyui-panel" title="退货信息" style="background:#fafafa;"
     data-options="iconCls:'fi-results',tools:'#Agentcapital_model_tools'">

    <table class="grid" style="width: 100%">
        <thead>
        <tr>
            <td><b>订单编号</b></td>
            <td><b>商品</b></td>
            <td><b>采购单价</b></td>
            <td><b>退货数量</b></td>
            <td><b>终端开始SN</b></td>
            <td><b>终端结束SN</b></td>
            <td><b>厂家</b></td>
            <td><b>机型</b></td>
        </tr>
        </thead>
        <tbody id="tbody_orders">
        </tbody>
    </table>
    <form method="post" id="form_sq">
        <input type="hidden" name="goodsReturnAmo" id="goodsReturnAmo">
        <input type="hidden" name="productsJson" id="productsJson">
        <table class="grid" style="width: 100%;margin-top: 20px">
            <tr>
                <td colspan="4"><span style="color: red" id="span_totalPrice"></span></td>
            </tr>
            <tr>
                <td colspan="4">退发票： <input style="margin-left: 20px" type="radio" name="retInvoice" value="1">是 <input
                        style="margin-left: 20px" type="radio" name="retInvoice" value="0">否
                </td>
            </tr>
            <tr>
                <td colspan="4">退收据： <input style="margin-left: 20px" type="radio" name="retReceipt" value="1">是 <input
                        style="margin-left: 20px" type="radio" name="retReceipt" value="0">否
                </td>
            </tr>
            <tr>
                <td colspan="4">申请备注：<textarea rows="4" cols="120" name="applyRemark"></textarea></td>
            </tr>
            </tbody>
        </table>
    </form>
</div>
<div style="padding-top: 20px;text-align: center">
    <a href="#" class="easyui-linkbutton" data-options="" style="width:80px;" onclick="sqFormSubmit()">提交申请</a>&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="#" class="easyui-linkbutton" data-options="" style="width:80px" onclick="cancel()">取消申请</a>
</div>


<script type="text/javascript">
    $(function () {
        $('#uploadForm').form({
            url: '${path }/order/return/analysisFile',
            onSubmit: function () {
                var isValid = $(this).form('validate');
                if (!isValid) {

                }
                return isValid;

            },
            success: function (result) {
                result = $.parseJSON(result);
                if (result.resCode == '1') {
                    var obj = result.obj.list;
                    if (obj) {
                        var str = "";
                        for (var i = 0; i < obj.length; i++) {
                            var o = obj[i];
                            if(o==null){
                                parent.$.messager.alert('错误', '未找到SN信息', 'error');
                                return;
                            }
                            str = str + "<tr><td>" + o.orderId + "</td>";
                            str = str + "<td>" + o.proName + "</td>";
                            str = str + "<td>" + o.proPrice + "</td>";
                            str = str + "<td>" + o.count + "</td>";
                            str = str + "<td>" + o.startSn + "</td>";
                            str = str + "<td>" + o.endSn + "</td>";
                            str = str + "<td>" + o.proCom + "</td>";
                            str = str + "<td>" + o.proType + "</td>";
                            str = str + "</tr>";
                        }
                        $("#tbody_orders").empty();
                        $("#tbody_orders").append(str);
                        $("#span_totalPrice").text("退货申请总金额：" + result.obj.totalAmt + "元");
                        $("#productsJson").val(JSON.stringify(result.obj.list));
                        $("#goodsReturnAmo").val(result.obj.totalAmt);
                    }
                } else {
                    parent.$.messager.alert('错误', result.resInfo, 'error');
                }
            }
        });
    });


    $(function () {
        $('#form_sq').form({
            url: '${path }/order/return/apply',
            onSubmit: function () {
                var isValid = $(this).form('validate');
                if (!isValid) {

                }
                return isValid;

            },
            success: function (result) {
                result = $.parseJSON(result);
                if (result.success) {
                    parent.$.messager.alert('提示', result.msg, 'info');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('错误', result.msg, 'error');
                }
            }
        });
    });

    function uploadFormSubmit() {
        $('#uploadForm').submit();
    }

    function sqFormSubmit() {
        $('#form_sq').submit();
    }

    function cancel() {
        parent.$.modalDialog.handler.dialog('close');
    }


</script>