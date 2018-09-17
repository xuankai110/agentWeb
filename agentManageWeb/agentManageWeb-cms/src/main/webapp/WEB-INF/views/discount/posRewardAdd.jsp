<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    $(function() {
        $('#posRewardTempAddForm').form({
            url : '${path }/posRewardTemp/add',
            onSubmit : function() {
            },
            success : function(result) {
                progressClose();
                result = $.parseJSON(result);
                if (result.success) {
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('错误', result.msg, 'error');
                }
            }
        });
        $('#posRewardAddForm').form({
            url : '${path }/discount/addReward',
            onSubmit : function() {
            },
            success : function(result) {
                progressClose();
                result = $.parseJSON(result);
                if (result.success) {
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('错误', result.msg, 'error');
                }
            }
        });
    });

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
            var m = date.getMonth() + 1;
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
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="申请信息" style="overflow: hidden;padding: 3px;">
        <form id="posRewardAddForm" method="post">
            <table class="grid">
                <tr>
                    <td>代理商唯一码：</td>
                    <td>
                        <input id="agentPid" name="agentPid" type="text" <c:if test="${isagent.isOK()}">value="${isagent.data.agUniqNum}"</c:if> class="easyui-textbox" data-options="required:true" style="width:200px;" />
                    </td>
                </tr>
                <tr>
                    <td>代理商名称：</td>
                    <td>
                        <input id="agentName" name="agentName" type="text" <c:if test="${isagent.isOK()}">value="${isagent.data.agName}"</c:if> class="easyui-textbox" data-options="required:true" style="width:200px;" />
                    </td>
                </tr>
                <tr>
                    <td>交易总额对比月：</td>
                    <td>
                        <input type="text" id="totalConsMonth" name="totalConsMonth" maxlength="48" placeholder="请选择交易总额对比月" class="easyui-validatebox" data-options="required:true" style="width:300px;">
                        <button id="totalConsMonthMany"/>
                    </td>
                </tr>
                <tr>
                    <td>对比交易金额（万）：</td>
                    <td><input name="growAmt" class="easyui-validatebox" data-options="required:true" style="width:200px;"></td>
                </tr>
                <tr>
                    <td>奖励比例：</td>
                    <td><input name="rewardScale" class="easyui-validatebox" data-options="required:true,min:0,precision:4" style="width:200px;"></td>
                </tr>
                <tr>
                    <td>奖励考核日期</td>
                    <td><input id="totalEndMonth" name="totalEndMonth" placeholder="请选择奖励考核日期" class="easyui-validatebox" data-options="required:true" style="width:200px;"></td>
                </tr>
            </table>
        </form>
    </div>
</div>