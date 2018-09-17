<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="easyui-panel" title="代理商基本信息"  data-options="iconCls:'fi-results'">
    <table class="grid">
        <tr>
            <td>代理商名称</td>
            <td>${agent.agName}</td>
            <shiro:hasPermission name="/agent/businessDepShrio">
            <td>公司性质</td>
            <td>
                <c:forEach items="${agNatureType}" var="agNatureTypeItem">
                    <c:if test="${agNatureTypeItem.dItemvalue==agent.agNature}">${agNatureTypeItem.dItemname}</c:if>
                </c:forEach>
            </td>
            </shiro:hasPermission>
            <shiro:hasPermission name="/agent/businessDepShrio">
            <td>注册资本</td>
            <td>
                ${agent.agCapital}/万元
            </td>
            </shiro:hasPermission>
            <shiro:hasPermission name="/agent/businessDepShrio">
            <td>营业执照</td>
            <td>
                ${agent.agBusLic}
            </td>
            </shiro:hasPermission>
        </tr>
        <tr>
            <shiro:hasPermission name="/agent/businessDepShrio">
            <td>营业执照开始时间</td>
            <td>
                <fmt:formatDate pattern="yyyy-MM-dd" value="${agent.agBusLicb}" />
            </td>
            </shiro:hasPermission>
            <shiro:hasPermission name="/agent/businessDepShrio">
            <td>营业执照到期日</td>
            <td>
                <fmt:formatDate pattern="yyyy-MM-dd" value="${agent.agBusLice}" />
            </td>
            </shiro:hasPermission>
            <shiro:hasPermission name="/agent/businessDepShrio">
            <td>负责人</td>
            <td>
                <desensitization:show type="name" value="${agent.agHead}" jurisdiction="/agent/baseNameSee"/>
            </td>
            </shiro:hasPermission>
            <shiro:hasPermission name="/agent/businessDepShrio">
            <td>负责人联系电话</td>
            <td>
                <desensitization:show type="mobile" value="${agent.agHeadMobile}" jurisdiction="/agent/baseMobileSee"/>
            </td>
            </shiro:hasPermission>
        </tr>
        <tr>
            <shiro:hasPermission name="/agent/businessDepShrio">
            <td>法人证件类型</td>
            <td>
                <c:forEach items="${certType}" var="certTypeItem">
                    <c:if test="${certTypeItem.dItemvalue== agent.agLegalCertype}">${certTypeItem.dItemname}</c:if>
                </c:forEach>
            </td>
            </shiro:hasPermission>
            <shiro:hasPermission name="/agent/businessDepShrio">
            <td>法人证件号</td>
            <td>
                <desensitization:show type="card" value="${agent.agLegalCernum}" jurisdiction="/agent/baseCardSee"/>
            </td>
            </shiro:hasPermission>
            <shiro:hasPermission name="/agent/businessDepShrio">
            <td>法人姓名</td>
            <td>
                <desensitization:show type="name" value="${agent.agLegal}" jurisdiction="/agent/baseNameSee"/>
            </td>
            </shiro:hasPermission>
            <shiro:hasPermission name="/agent/businessDepShrio">
            <td>法人联系电话</td>
            <td>
                <desensitization:show type="mobile" value="${agent.agLegalMobile}" jurisdiction="/agent/baseMobileSee"/>
            </td>
            </shiro:hasPermission>
        </tr>
        <tr>
            <shiro:hasPermission name="/agent/businessDepShrio">
            <td>注册地址</td>
            <td colspan="7">
                <desensitization:show type="address" value="${agent.agRegAdd}" jurisdiction="/agent/baseAddressSee"/>
            </td>
            </shiro:hasPermission>
        </tr>
        <tr>
            <%--<td>税点</td>--%>
            <%--<td>${agent.cloTaxPoint}</td>--%>
            <td>业务对接大区</td>
            <td><agent:show type="dept" busId="${agent.agDocDistrict}" /></td>
            <td>业务对接省区</td>
            <td><agent:show type="dept" busId="${agent.agDocPro}" /></td>
        </tr>
        <shiro:hasPermission name="/agent/businessDepShrio">
        <tr>
            <td>营业范围</td>
            <td colspan="7">
                <input class="easyui-textbox" value="${agent.agBusScope}" style="width:100%;">
            </td>
        </tr>
        </shiro:hasPermission>
        <shiro:hasPermission name="/agent/businessDepShrio">
        <tr>
            <td>备注</td>
            <td colspan="7">
                ${agent.agRemark}
            </td>
        </tr>
        </shiro:hasPermission>
    </table>
</div>
