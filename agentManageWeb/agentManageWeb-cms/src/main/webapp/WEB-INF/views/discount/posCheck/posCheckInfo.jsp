<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="easyui-panel" title="分润比例考核申请信息" data-options="iconCls:'fi-results'">
    <table class="grid">
        <tr>
            <td width="200px">代理商唯一码：</td>
            <td>${posCheck.agentPid}</td>
        </tr>
        <tr>
            <td width="200px">代理商名称：</td>
            <td>${posCheck.agentName}</td>
        </tr>
        <tr>
            <td width="200px">考核起始日期：</td>
            <td>${posCheck.checkDateS}</td>
        </tr>
        <tr>
            <td width="200px">考核截止日期：</td>
            <td>${posCheck.checkDateE}</td>
        </tr>
        <tr>
            <td width="200px">交易总额（万）：</td>
            <td>${posCheck.totalAmt}</td>
        </tr>
        <tr>
            <td width="200px">机具订货量：</td>
            <td>${posCheck.posOrders}</td>
        </tr>
        <tr>
            <td width="200px">分润比例：</td>
            <td>${posCheck.profitScale}</td>
        </tr>
    </table>
</div>

