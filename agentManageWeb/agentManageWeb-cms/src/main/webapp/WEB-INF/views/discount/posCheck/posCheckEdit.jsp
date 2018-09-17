<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<div class="easyui-panel" title="分润比例考核申请修改" data-options="iconCls:'fi-results'">
    <form id="posCheckEditFrom" method="post">
        <table class="grid">
            <input type="hidden" name="id" value="${posCheck.id}">
            <tr>
                <td>代理商唯一码：</td>
                <td>${posCheck.agentPid}</td>
            </tr>
            <tr>
                <td>代理商名称：</td>
                <td>${posCheck.agentName}</td>
            </tr>
            <tr>
                <td>考核日期：</td>
                <td><input name="checkDateS" value="${posCheck.checkDateS}" placeholder="起始日期" class="easyui-datebox" data-options="required:true"></td>
                <td>&nbsp;至&nbsp;</td>
                <td><input name="checkDateE" value="${posCheck.checkDateE}" placeholder="截止日期" class="easyui-datebox" data-options="required:true"></td>
            </tr>
            <tr>
                <td>交易总额（万）：</td>
                <td><input name="totalAmt" value="${posCheck.totalAmt}" data-options="required:true"></td>
            </tr>
            <tr>
                <td>机具订货量：</td>
                <td><input name="posOrders" value="${posCheck.posOrders}" data-options="required:true"></td>
            </tr>
            <tr>
                <td>分润比例：</td>
                <td><input name="profitScale" value="${posCheck.profitScale}" data-options="required:true,min:0,precision:4"></td>
            </tr>
        </table>
    </form>
</div>