<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="easyui-panel" title="代理商基本信息"  data-options="iconCls:'fi-results'">
    <form id="agentBasics">
        <table class="grid">

            <tr>
                <td>代理商名称<input name="id" type="hidden" value="${agent.id}"/></td>
                <td style="width:180px">
                    <input name="agName" id="agentName" type="text"  class="easyui-validatebox"  style="width:120px;" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission>    data-options="required:true" value="${agent.agName}">
                    <a href="javascript:void(0);" onclick="industrialAuth()">工商认证</a></td>
                    <input name="caStatus" id="caStatus" type="hidden" value="${agent.caStatus}">
                </td>
                <td>公司性质</td>
                <td>
                    <select name="agNature" style="width:160px;height:21px" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo"> disabled="true"   readonly="readonly"</shiro:lacksPermission>>
                        <c:forEach items="${agNatureType}" var="agnatureTypeItem"  >
                            <option value="${agnatureTypeItem.dItemvalue}" <c:if test="${agnatureTypeItem.dItemvalue==agent.agNature}">selected="selected"</c:if>>${agnatureTypeItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>注册资本</td>
                <td><input name="agCapital" type="text"  class="easyui-validatebox"  style="width:120px;"  data-options="required:true,validType:['length[1,20]','Money']" value="${agent.agCapital}" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission>>/万元</td>
                <td>营业执照</td>
                <td><input name="agBusLic" type="text"  class="easyui-validatebox"  style="width:120px;"   data-options="required:true,validType:'length[1,30]'" value="${agent.agBusLic}" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission>></td>
            </tr>
            <tr>
                <td>营业执照开始时间</td>
                <td><input name="agBusLicb" type="text"  class="easyui-datebox" editable="false" placeholder="请输入"  value=" <fmt:formatDate pattern="yyyy-MM-dd" value="${agent.agBusLicb}" />"  style="width:120px;"  data-options="required:true" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission>/></td>
                <td>营业执照到期日</td>
                <td><input name="agBusLice" type="text"  class="easyui-datebox" editable="false" placeholder="请输入" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${agent.agBusLice}" />"  style="width:120px;"  data-options="required:true"<shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission>/></td>
                <td>负责人</td>
                <td><input name="agHead" type="text"  class="easyui-validatebox"  style="width:120px;" value="${agent.agHead}"   data-options="required:true,validType:['length[1,6]','CHS']" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission> /></td>
                <td>负责人联系电话</td>
                <td><input name="agHeadMobile" type="text"  class="easyui-validatebox"  style="width:120px;"  value="${agent.agHeadMobile}"  data-options="required:true,validType:['length[7,12]','Mobile']" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission> /></td>
            </tr>
            <tr>
                <td>法人证件类型</td>
                <td>
                    <select name="agLegalCertype" style="width:160px;height:21px" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo"> disabled="true" </shiro:lacksPermission> >
                        <c:forEach items="${certType}" var="CertTypeItem" varStatus="certTypeStatus" >
                            <option value="${CertTypeItem.dItemvalue}" <c:if test="${CertTypeItem.dItemvalue== agent.agLegalCertype}"> selected="selected"</c:if>>${CertTypeItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>法人证件号</td>
                <td><input name="agLegalCernum" type="text"  class="easyui-validatebox" value="${agent.agLegalCernum}" editable="false" placeholder="请输入"   style="width:120px;" data-options="required:true,validType:'length[1,20]'" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission> /></td>
                <td>法人姓名</td>
                <td><input name="agLegal" type="text"  class="easyui-validatebox"  value="${agent.agLegal}" style="width:120px;"   data-options="required:true,validType:['length[1,10]','CHS']" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission> ></td>
                <td>法人联系电话</td>
                <td><input name="agLegalMobile" type="text"  class="easyui-validatebox" value="${agent.agLegalMobile}"  style="width:120px;" data-options="required:true,validType:['length[7,12]','Mobile']" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission> ></td>
            </tr>
            <tr>
                <td>注册地址</td>
                <td colspan="7"><input name="agRegAdd" type="text"  class="easyui-validatebox" value="${agent.agRegAdd}"  style="width:80%;"   data-options="required:true,validType:'length[1,333]'" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission> /></td>
            </tr>
            <tr>
                <%--<td>税点</td>--%>
                <%--<td><input name="cloTaxPoint" type="text"  class="easyui-validatebox"  style="width:80%;" value="${agent.cloTaxPoint}" readonly="readonly" data-options="required:true,validType:['length[1,11]','Money']" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission> /></td>--%>
                <td>营业范围</td>
                <td><input name="agBusScope" type="text"  class="easyui-validatebox"  style="width:80%;" value="${agent.agBusScope}" data-options="required:true,validType:'length[1,333]'" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission> /></td>
                <td>业务对接大区</td>
                <td>
                    <input type="text"  class="easyui-validatebox" id="agDocDistrict1" style="width:60%;"  data-options="required:true" readonly="readonly" value="<agent:show type="dept" busId="${agent.agDocDistrict}"/>" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission> />
                    <input name="agDocDistrict" type="hidden" id="agDocDistrict2" value="${agent.agDocDistrict}"/>
                    <shiro:hasPermission name="/agentEnter/agentEdit/baseInfo">
                        <a href="javascript:void(0);" onclick="showRegionFrame({target:this,callBack:returnBaseRegion},'/region/departmentTree',false)">选择</a>
                    </shiro:hasPermission>
                    <a href="javascript:void(0);" onclick="del(this)">清除</a>
                </td>
                <td>业务对接省区</td>
                <td>
                    <input type="text"  class="easyui-validatebox" id="agDocPro1" style="width:60%;"  data-options="required:true" readonly="readonly" value="<agent:show type="dept" busId="${agent.agDocPro}" />" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission> />
                    <input name="agDocPro" type="hidden" value="${agent.agDocPro}" id="agDocPro2"/>
                    <shiro:hasPermission name="/agentEnter/agentEdit/baseInfo">
                        <a href="javascript:void(0);" onclick="showRegionFrame({target:this,callBack:returnBaseRegion,pid:$(this).parent().prev('td').prev('td').children('input[name=\'agDocDistrict\']').val()},'/region/departmentTree',false)">选择</a>
                    </shiro:hasPermission>
                    <a href="javascript:void(0);" onclick="del(this)">清除</a>
                   </td>
            </tr>
            <tr>
                <td>备注</td>
                <td colspan="5"><input name="agRemark" type="text"  class="easyui-validatebox" value="${agent.agRemark}"  style="width:80%;" data-options="validType:['length[1,66]','CHS']" <shiro:lacksPermission name="/agentEnter/agentEdit/baseInfo">readonly="readonly"</shiro:lacksPermission> /></td>
                <td>是否有效</td>
                <td>
                    <select name="status" style="width:160px;height:21px" >
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                            <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
        </table>
    </form>
</div>
<script type="text/javascript">

    //获取form数据
    function get_editAgentBasics_FormData(){
        return baseData = $.serializeObject($("#agentBasics"));
    }
    //地区选择
    function returnBaseRegion(data,options){
        $(options.target).prev("input").val(data.id);
        $(options.target).prev("input").prev("input").val(data.text);
    }

</script>