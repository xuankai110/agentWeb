<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $("#totalConsMonthMany").datebox({
        required : true,
        formatter: function(date){
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            var d = date.getDate();
            var dataVal = y + "-" + (m<10?('0'+m):m);
            var dataActivity = $("#totalConsMonth").val();
            if(dataActivity == '' || dataActivity == undefined || dataActivity == null){
                document.getElementById("totalConsMonth").value = dataVal;
            } else {
                document.getElementById("totalConsMonth").value = dataActivity+"~"+dataVal;
            }
        },
        parser: function(s){
            var t = Date.parse(s);
            if (!isNaN(t)){
                return new Date(t);
            } else {
                return new Date();
            }
        }
    });

    $("#totalEndMonth").datebox({
        required : true,
        formatter: function(date){
            var y = date.getFullYear();
            var m = date.getMonth()+1;
            var d = date.getDate();
            return y + "-" + (m<10?('0'+m):m);
        },
        parser: function(s){
            var t = Date.parse(s);
            if (!isNaN(t)){
                return new Date(t);
            } else {
                return new Date();
            }
        }
    });
</script>
<div class="easyui-panel" title="POS奖励考核申请修改" data-options="iconCls:'fi-results'">
    <form id="posRewardEditFrom" method="post">
        <table class="grid">
            <input type="hidden" name="id" value="${posReward.id}">
            <tr>
                <td>代理商唯一码：</td>
                <td>${posReward.agentPid}</td>
            </tr>
            <tr>
                <td>代理商名称：</td>
                <td>${posReward.agentName}</td>
            </tr>
            <tr>
                <td>交易总额对比月：</td>
                <td>
                    <input type="text" id="totalConsMonth" name="totalConsMonth" value="${posReward.totalConsMonth}" maxlength="48" style="width:300px;" placeholder="请选择交易总额对比月" class="easyui-validatebox" data-options="required:true">
                    <button id="totalConsMonthMany"/>
                </td>
            </tr>
            <tr>
                <td>对比交易金额（万）：</td>
                <td><input name="growAmt" value="${posReward.growAmt}" data-options="required:true"></td>
            </tr>
            <tr>
                <td>奖励比例：</td>
                <td><input name="rewardScale" value="${posReward.rewardScale}" data-options="required:true,min:0,precision:4"></td>
            </tr>
            <tr>
                <td>奖励考核日期</td>
                <td><input id="totalEndMonth" name="totalEndMonth" value="${posReward.totalEndMonth}" tyle="width:300px;" placeholder="请选择奖励考核日期" class="easyui-validatebox" data-options="required:true"></td>
            </tr>
        </table>
    </form>
</div>