<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function () {
        $('#activityEditForm').form({
            url: '${path}/activity/activityEdit',
            onSubmit: function () {
                var beginTimeStr = $("#beginTimeStr").datebox("getValue");
                var endTimeStr = $("#endTimeStr").datebox("getValue");
                if (beginTimeStr > endTimeStr) {
                    info("开始时间不能大于结束时间！")
                    return false;
                }
                var isValid = $(this).form('validate');
                if (!isValid) {
                }
                return isValid;
            },
            success: function (result) {
                result = $.parseJSON(result);
                if (result.success) {
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.messager.alert('提示', result.msg, 'info');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('错误', result.msg, 'error');
                }
            }
        });
    });

    $(function () {
        $("#productSelect").change(function () {
            var value = $("#productSelect").find("option:selected").attr("value");
            if (undefined == value) {
                $("#venderEdit").val("");
                $("#proModelEdit").val("");
                $("#venderNameEdit").val("");
                $("#proTypeEdit").val("");
                $("#proTypeNameEdit").val("");
            }
            var proModel = $("#productSelect").find("option:selected").attr("proModelEdit");
            var vender = $("#productSelect").find("option:selected").attr("venderEdit");
            var name = $("#productSelect").find("option:selected").attr("name");
            var proType = $("#productSelect").find("option:selected").attr("proTypeEdit");
            var proTypeName = $("#productSelect").find("option:selected").attr("proTypeNameEdit");
            $("#venderEdit").val(vender);
            $("#proModelEdit").val(proModel);
            $("#venderNameEdit").val(name);
            $("#proTypeEdit").val(proType);
            $("#proTypeNameEdit").val(proTypeName);
        })
    })

</script>
<div class="easyui-layout" data-options="fit:true,border:true">
    <div data-options="region:'center',border:false" style="padding: 3px;">
        <form id="activityEditForm" method="post">
            <input type="hidden" name="id" value="${oActivity.id}">
            <table class="grid">
                <tr>
                    <td>活动名称：</td>
                    <td><input name="activityName" value="${oActivity.activityName}" maxlength="15" type="text"
                               placeholder="请输入" class="easyui-validatebox" data-options="required:true"
                               style="width:160px;"></td>
                    <td>商品名称：</td>
                    <td>
                        <select name="productId" data-options="width:120,height:29,editable:false,panelHeight:'auto'"
                                id="productSelect">
                            <c:forEach items="${productList}" var="product">
                                <option value="${product.id}" venderEdit="${product.proCom}" name="${product.name}"
                                        proModelEdit="${product.proModel}" proTypeEdit="${product.proType}"
                                        proTypeNameEdit="${product.proTypeName}"
                                        <c:if test="${oActivity.productId==product.id}">selected="selected"</c:if>>${product.proName}/${product.name}/${product.proModel}/${product.proPrice}元</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>厂家：</td>
                    <td><input name="vender" id="venderEdit" value="${oActivity.vender}" maxlength="15" type="hidden"
                               placeholder="请输入" class="easyui-validatebox" style="width:160px;">
                        <input name="name" maxlength="15" type="text" placeholder="请输入" class="easyui-validatebox"
                               style="width:160px;" id="venderNameEdit" readonly="readonly"
                               value="${oActivity.venderName}">
                    </td>
                    <td>型号：</td>
                    <td><input name="proModel" id="proModelEdit" value="${oActivity.proModel}" maxlength="15"
                               type="text" placeholder="请输入" class="easyui-validatebox" style="width:160px;"></td>
                </tr>
                <tr>
                    <td>规则编号：</td>
                    <td><input name="ruleId" value="${oActivity.ruleId}" maxlength="15" type="text" placeholder="请输入"
                               class="easyui-validatebox" style="width:160px;"></td>
                    <td>机具类型：</td>
                    <td>
                        <input name="proType" maxlength="15" type="hidden" placeholder="请输入" class="easyui-validatebox"
                               style="width:160px;" id="proTypeEdit" readonly="readonly" value="${oActivity.proType}">
                        <input name="proTypeName" maxlength="15" type="text" placeholder="请输入"
                               class="easyui-validatebox"
                               style="width:160px;" id="proTypeNameEdit" readonly="readonly"
                               value="${oActivity.proTypeName}">
                    </td>
                </tr>
                <tr>
                    <td>优惠条件：</td>
                    <td>
                        <select class="easyui-combobox" name="activityWay" style="width:160px;height:21px">
                            <c:forEach items="${activityDisType}" var="activityDisItem">
                                <option value="${activityDisItem.dItemvalue}"
                                        <c:if test="${oActivity.activityWay==activityDisItem.dItemvalue}">selected="selected"</c:if>>${activityDisItem.dItemname}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>参与条件：</td>
                    <td>
                        <select class="easyui-combobox" name="activityCondition" style="width:160px;height:21px">
                            <c:forEach items="${activityCondition}" var="activityConItem">
                                <option value="${activityConItem.dItemvalue}" <c:if test="${oActivity.activityCondition==activityConItem.dItemvalue}">selected="selected"</c:if>>${activityConItem.dItemname}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>优惠方式：</td>
                    <td><input name="activityRule" value="${oActivity.activityRule}" maxlength="15" type="text"
                               placeholder="请输入" class="easyui-validatebox" style="width:160px;"
                               data-options="required:true"></td>
                    <td>价格：</td>
                    <td><input name="price" value="${oActivity.price}" maxlength="15" type="text" placeholder="请输入"
                               class="easyui-validatebox" style="width:160px;"></td>
                </tr>
                <tr>
                    <td>开始时间</td>
                    <td><input name="beginTimeStr" id="beginTimeStr"
                               value="<fmt:formatDate pattern='yyyy-MM-dd' value='${oActivity.beginTime}' />"
                               type="text" class="easyui-datebox" editable="false" placeholder="请输入"
                               style="width:160px;" data-options="required:true"></td>
                    <td>结束时间</td>
                    <td><input name="endTimeStr" id="endTimeStr"
                               value="<fmt:formatDate pattern='yyyy-MM-dd' value='${oActivity.endTime}' />" type="text"
                               class="easyui-datebox" editable="false" placeholder="请输入"
                               style="width:160px;" data-options="required:true"></td>
                </tr>
                <tr>
                    <td>平台类型:</td>
                    <td>
                        <select class="easyui-combobox" name="platform" style="width:160px;height:21px">
                            <c:forEach items="${ablePlatForm}" var="ablePlatFormItem">
                                <option value="${ablePlatFormItem.platformNum}"
                                        <c:if test="${ablePlatFormItem.platformNum==oActivity.platform}">selected="selected"</c:if>>${ablePlatFormItem.platformName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>保价时间：</td>
                    <td>
                        <input name="gTime" value="${oActivity.gTime}" maxlength="15" type="text" placeholder="请输入"
                               class="easyui-numberbox" style="width:150px;">天
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>