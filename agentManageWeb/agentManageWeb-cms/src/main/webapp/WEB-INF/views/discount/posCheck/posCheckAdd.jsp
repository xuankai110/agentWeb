<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    $(function() {
        $('#posCheckAddForm').form({
            url : '${path}/discount/addCheck',
            onSubmit : function() {
                var isValid = $(this).form('validate');
                if (!isValid) {
                }
                return isValid;
            },
            success : function(result) {
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
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="申请信息" style="overflow: hidden;padding: 3px;">
        <form id="posCheckAddForm" method="post">
            <table class="grid">
                <tr>
                    <td>代理商唯一码：</td>
                    <td>
                        <input id="agentPid" name="agentPid" type="text" <c:if test="${isagent.isOK()}">value="${isagent.data.agUniqNum}"</c:if> class="easyui-textbox" data-options="required:true" style="width:200px;" />
                    </td>
                    <td></td><td></td>
                </tr>
                <tr>
                    <td>代理商名称：</td>
                    <td>
                        <input id="agentName" name="agentName" type="text" <c:if test="${isagent.isOK()}">value="${isagent.data.agName}"</c:if> class="easyui-textbox" data-options="required:true" style="width:200px;" />
                    </td>
                    <td></td><td></td>
                </tr>
                <tr>
                    <td>考核日期：</td>
                    <td><input name="checkDateS" placeholder="起始日期" class="easyui-datebox" data-options="required:true"></td>
                    <td>&nbsp;至&nbsp;</td>
                    <td><input name="checkDateE" placeholder="截止日期" class="easyui-datebox" data-options="required:true"></td>
                </tr>
                <tr>
                    <td>交易总额（万）：</td>
                    <td><input name="totalAmt" class="easyui-validatebox" data-options="required:true" style="width:200px;"></td>
                    <td></td><td></td>
                </tr>
                <tr>
                    <td>机具订货量：</td>
                    <td><input name="posOrders" class="easyui-validatebox" data-options="required:true" style="width:200px;"></td>
                    <td></td><td></td>
                </tr>
                <tr>
                    <td>分润比例：</td>
                    <td><input name="profitScale" class="easyui-validatebox" data-options="required:true,min:0,precision:4" style="width:200px;"></td>
                    <td></td><td></td>
                </tr>
            </table>
        </form>
    </div>
</div>
<%--<div class="easyui-layout" data-options="fit:true,border:true" >
    <div data-options="region:'center',border:false" style="padding: 3px;" >
        <form id="posCheckAddForm" method="post">
            <input type="hidden" name="id" value="${posCheck.id}" />
            <table class="grid">
                <tr>
                    <td>姓名：</td>
                    <td>
                        <input name="addrRealname" maxlength="15" type="text" placeholder="请输入姓名" class="easyui-validatebox"  style="width:160px;" value="${posCheck.addrRealname}">
                        <span style="color: red;">*</span>
                    </td>
                    <td>联系电话：</td>
                    <td colspan="3">
                        <input name="addrMobile" maxlength="15" type="text" placeholder="请输入联系电话" class="easyui-validatebox"  style="width:160px;" value="${posCheck.addrMobile}">
                        <span style="color: red;">*</span>
                    </td>
                </tr>
                <tr>
                    <td>省：</td>
                    <td>
                        <select class="easyui-combobox"  name="addrProvince"   style="width:160px;" id="posCheckAddForm_addrProvince"  addrv="${posCheck.addrProvince}" >
                        </select>
                        <span style="color: red;">*</span>
                    </td>
                    <td>市：</td>
                    <td>
                        <select class="easyui-combobox"  name="addrCity"   style="width:160px;" id="posCheckAddForm_addrCity"  addrv="${posCheck.addrCity}">
                        </select>
                        <span style="color: red;">*</span>
                    </td>
                    <td>区：</td>
                    <td>
                        <select class="easyui-combobox"  name="addrDistrict"   style="width:160px;" id="posCheckAddForm_addrDistrict" addrv="${posCheck.addrDistrict}">
                        </select>
                        <span style="color: red;">*</span>
                    </td>
                </tr>
                <tr>
                    <td>详细地址：</td>
                    <td colspan="5">
                        <input name="addrDetail"  type="text" placeholder="请输入详细地址" class="easyui-validatebox"  style="width:98%;" value="${posCheck.addrDetail}">
                        <span style="color: red;">*</span>
                    </td>

                </tr>
                <tr>
                    <td>邮编：</td>
                    <td><input name="zipCode"  type="text" placeholder="请输入" class="easyui-validatebox"  style="width:160px;"  value="${posCheck.zipCode}"><span style="color: red;">*</span></td>
                    <td>备注：</td>
                    <td><input name="remark"  type="text" placeholder="请输入" class="easyui-validatebox"  style="width:160px;" value="${posCheck.remark}" ><span style="color: red;">*</span></td>
                    <td>默认地址：</td>
                    <td>
                        <select class="easyui-combobox"  editable="false" name="isdefault" style="width:160px;" >
                            <option value="1"  <c:if test="${posCheck.isdefault eq 1}">selected="selected"</c:if>  >是</option>
                            <option value="0"  <c:if test="${posCheck.isdefault eq 0}">selected="selected"</c:if>>否</option>
                        </select>
                    </td>
                </tr>

            </table>
        </form>
    </div>
</div>--%>
