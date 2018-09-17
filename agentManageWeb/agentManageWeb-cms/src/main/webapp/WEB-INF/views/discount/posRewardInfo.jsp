<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="easyui-panel" title="POS奖励申请信息" data-options="iconCls:'fi-results'">
    <table class="grid">
        <tr>
            <td width="200px">代理商唯一码：</td>
            <td>${posReward.agentPid}</td>
        </tr>
        <tr>
            <td width="200px">代理商名称：</td>
            <td>${posReward.agentName}</td>
        </tr>
        <tr>
            <td width="200px">交易总额对比月：</td>
            <td>${posReward.totalConsMonth}</td>
        </tr>
        <tr>
            <td width="200px">奖励考核日期：</td>
            <td>${posReward.totalEndMonth}</td>
        </tr>
        <tr>
            <td width="200px">对比交易金额（万）：</td>
            <td>${posReward.growAmt}</td>
        </tr>
        <tr>
            <td width="200px">贷记交易金额对比月：</td>
            <td>${posReward.creditConsMonth}</td>
        </tr>
        <tr>
            <td width="200px">奖励比例：</td>
            <td>${posReward.rewardScale}</td>
        </tr>
    </table>
</div>

