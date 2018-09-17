<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
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
    });

    $("#tranContrastMonth,#creditTranContrastMonth").datebox({
        required:true,
        formatter: function(date){
            var y = date.getFullYear();
            var m = date.getMonth()+1;
            var d = date.getDate();
            return y+"-"+(m<10?('0'+m):m);
        },
        parser: function(s){
            var t = Date.parse(s);
            if (!isNaN(t)){
                return new Date(t);
            } else {
                return new Date();
            }
        }
    })

    $("#activityValidId").datebox({
        required:true,
        formatter: function(date){
            var y = date.getFullYear();
            var m = date.getMonth()+1;
            var d = date.getDate();
            var dataVal=y+"-"+(m<10?('0'+m):m);
            var dataActivity =$("#activityValid").val();
            if(dataActivity == '' || dataActivity ==undefined || dataActivity == null){
                document.getElementById("activityValid").value=dataVal;
            } else {
                if(dataActivity.indexOf(dataVal)!=-1){
                    parent.$.messager.alert('提示', "该活动月份已经存在", 'error');
                } else {
                    document.getElementById("activityValid").value=dataActivity+"~"+dataVal;
                }
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
    })

</script>
<div class="easyui-layout" data-options="fit:true,border:false" >
    <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;" >
        <form id="posRewardTempAddForm" method="post">
            <table class="grid">
                <tr>
                    <td>交易对比月份：</td>
                    <td><input type="text" id="tranContrastMonth" name="tranContrastMonth"   placeholder="请输入对交易比月份" class="easyui-validatebox" data-options="required:true"></td>
                </tr>
                <tr>
                    <td>对比交易金额（万）：</td>
                    <td>
                        <input type="text" id="tranTotalStart" name="tranTotalStart"   placeholder="请输入对比交易金额起(万)" class="easyui-numberbox"  class="easyui-validatebox" data-options="required:true,min:0,precision:2">&nbsp;至&nbsp;
                        <input type="text" id="tranTotalEnd" name="tranTotalEnd"   placeholder="请输入对比交易金额止(万)" class="easyui-numberbox"  class="easyui-validatebox" data-options="required:true,min:0.01,precision:2">
                    </td>
                </tr>
                <tr>
                    <td>贷记交易量对比月：</td>
                    <td><input type="text" id="creditTranContrastMonth" name="creditTranContrastMonth" placeholder="请输入贷记交易量对比月" class="easyui-validatebox" data-options="required:true"></td>
                </tr>
                <tr>
                    <td>奖励比例：</td>
                    <td><input type="text" id="proportion" name="proportion"  class="easyui-numberbox"  placeholder="请输入奖励比例" class="easyui-validatebox" data-options="required:true,min:0,precision:4"></td>
                </tr>
                <tr>
                    <td>活动生效月份：</td>
                    <td>
                        <input type="text" id="activityValid" style="width:300px;" name="activityValid" value="" maxlength="48"  placeholder="请选择活动生效日期" class="easyui-validatebox" data-options="required:true">
                        <button id="activityValidId"/>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
