<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function () {
        $('#activityAddForm').form({
            url: '${path}/activity/activityAdd',
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
                eval("var data = " + result + ";");
                info(data.resInfo);
               if(data.resCode=='1'){
                   parent.$.modalDialog.handler.dialog('close');
                   activityList.datagrid('reload');
               }
            },

        });
    });
    $(function () {
        $("#testSelect").change(function () {
            var value = $("#testSelect").find("option:selected").attr("value");
            if (undefined == value) {
                $("#vender").val("");
                $("#proModel").val("");
                $("#venderName").val("");
                $("#proType").val("");
                $("#proTypeName").val("");
            }
            var proModel = $("#testSelect").find("option:selected").attr("proModel");
            var vender = $("#testSelect").find("option:selected").attr("vender");
            var name = $("#testSelect").find("option:selected").attr("name");
            var proType = $("#testSelect").find("option:selected").attr("proType");
            var proTypeName = $("#testSelect").find("option:selected").attr("proTypeName");
            $("#vender").val(vender);
            $("#proModel").val(proModel);
            $("#venderName").val(name);
            $("#proType").val(proType);
            $("#proTypeName").val(proTypeName);

        })
    })

</script>
<div class="easyui-layout" data-options="fit:true,border:true">
    <div data-options="region:'center',border:false" style="padding: 3px;">
        <form id="activityAddForm" method="post">
            <table class="grid">
                <tr>
                    <td>活动名称：</td>
                    <td><input name="activityName" maxlength="15" type="text" placeholder="请输入"
                               class="easyui-validatebox" data-options="required:true" style="width:160px;"></td>
                    <td>商品名称：</td>
                    <td>
                        <select name="productId" style="width: 165px" id="testSelect">
                            <option value="">---请选择---</option>
                            <c:forEach items="${productList}" var="product">
                                <option value="${product.id}" proModel="${product.proModel}"
                                        vender="${product.proCom}" name="${product.name}" proType="${product.proType}" proTypeName="${product.proTypeName}">${product.proName}/${product.name}/${product.proModel}/${product.proPrice}元</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>厂家：</td>
                    <td><input name="vender" maxlength="15" type="hidden" placeholder="请输入" class="easyui-validatebox"
                               style="width:160px;" id="vender" readonly="readonly">
                        <input name="name" maxlength="15" type="text" placeholder="请输入" class="easyui-validatebox"
                               style="width:160px;" id="venderName" readonly="readonly">
                    </td>
                    <td>型号：</td>
                    <td><input name="proModel" maxlength="15" type="text" placeholder="请输入" class="easyui-validatebox"
                               style="width:160px;" id="proModel" readonly="readonly"></td>
                </tr>
                <tr>
                    <td>规则编号：</td>
                    <td><input name="ruleId" maxlength="15" type="text" placeholder="请输入" class="easyui-validatebox"
                               style="width:160px;"></td>
                    <td>机具类型：</td>
                    <td>
                    <input name="proType" maxlength="15" type="hidden" placeholder="请输入" class="easyui-validatebox"
                           style="width:160px;" id="proType" readonly="readonly">
                    <input name="proTypeName" maxlength="15" type="text" placeholder="请输入" class="easyui-validatebox"
                           style="width:160px;" id="proTypeName" readonly="readonly">
                        <%--

                        <select class="easyui-combobox" name="proType" editable="false" style="width:160px;"
                                data-options="required:true">
                            <c:forEach items="${modelType}" var="modelTypeItem">
                                <option value="${modelTypeItem.dItemvalue}">${modelTypeItem.dItemname}</option>
                            </c:forEach>
                        </select>--%>
                    </td>
                </tr>
                <tr>
                    <td>优惠条件：</td>
                    <td>
                        <select class="easyui-combobox" name="activityWay" style="width:160px;height:21px">
                            <c:forEach items="${activityDisType}" var="activityDisItem">
                                <option value="${activityDisItem.dItemvalue}">${activityDisItem.dItemname}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>参与条件：</td>
                    <td>
                        <select class="easyui-combobox" name="activityCondition" style="width:160px;height:21px">
                            <c:forEach items="${activityCondition}" var="activityConItem">
                                <option value="${activityConItem.dItemvalue}">${activityConItem.dItemname}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>优惠方式：</td>
                    <td><input name="activityRule" maxlength="15" type="text" placeholder="请输入"
                               class="easyui-validatebox" style="width:160px;" data-options="required:true" ></td>
                    <td>价格：</td>
                    <td><input name="price" maxlength="15" type="text" placeholder="请输入" class="easyui-validatebox"
                               style="width:160px;"></td>
                </tr>
                <tr>
                    <td>开始时间</td>
                    <td><input name="beginTimeStr" id="beginTimeStr" type="text" class="easyui-datebox" editable="false"
                               placeholder="请输入"
                               style="width:160px;" data-options="required:true" value=""></td>
                    <td>结束时间</td>
                    <td><input name="endTimeStr" id="endTimeStr" type="text" class="easyui-datebox" editable="false"
                               placeholder="请输入"
                               style="width:160px;" data-options="required:true" value=""></td>
                </tr>
                <tr>
                    <td>平台类型:</td>
                    <td>
                        <select class="easyui-combobox" name="platform" style="width:160px;height:21px">
                            <c:forEach items="${ablePlatForm}" var="ablePlatFormItem">
                                <option value="${ablePlatFormItem.platformNum}">${ablePlatFormItem.platformName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>保价时间：</td>
                    <td>
                        <input name="gTime" maxlength="15" type="text" placeholder="请输入" class="easyui-numberbox"
                               style="width:150px;">天
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>