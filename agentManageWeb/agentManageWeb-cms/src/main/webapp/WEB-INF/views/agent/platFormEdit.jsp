<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
        $('#platFormEditForm').form({
            url : '${path }/platForm/editPlatForm',
            onSubmit : function() {
                progressLoad();
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                return isValid;

            },
            success : function(result) {
                progressClose();
                result = $.parseJSON(result);
                if (result.success) {
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.messager.alert('提示', result.msg, 'info');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('错误', result.msg, 'error');
                }
            }
        });

    });
</script>
<div style="padding: 3px;">
    <form id="platFormEditForm" method="post">
        <input type="hidden" id="id" name="id" value="${PlatForm.id}">
        <table class="grid">
            <tr>
                <td>平台号</td>
                <td><input id="platformNum" name="platformNum" value="${PlatForm.platformNum}" type="text" class="easyui-validatebox" style="width:160px;"></td>
                <td>平台名称</td>
                <td><input id="platformName" name="platformName" value="${PlatForm.platformName}" type="text" class="easyui-validatebox" style="width:160px;"></td>
            </tr>
            <tr>
                <td>操作员</td>
                <td><input id="cUser" name="cUser" value="${PlatForm.cUser}" type="text" class="easyui-validatebox" style="width:160px;"></td>
                <td>平台状态</td>
                <td><input id="platformStatus" name="platformStatus" value="${PlatForm.platformStatus}" type="text" class="easyui-validatebox" style="width:160px;"></td>
            </tr>
            <tr>
                <td>状态</td>
                <td><input id="status" name="status" value="${PlatForm.status}" type="text" class="easyui-validatebox" style="width:160px;"></td>
                <td>版本信息</td>
                <td><input id="version" name="version" value="${PlatForm.version}" type="text" class="easyui-validatebox" style="width:160px;"></td>
            </tr>
            <tr>
                <td>平台类型</td>
                <td><input id="platformType" name="platformType" value="${PlatForm.platformType}" type="text" class="easyui-validatebox" style="width:160px;"></td>
            </tr>
        </table>
    </form>
</div>
