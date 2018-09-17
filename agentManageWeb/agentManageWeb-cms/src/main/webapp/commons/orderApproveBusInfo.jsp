<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="easyui-panel" title="审批业务数据" data-options="iconCls:'fi-results'">
    <form id="orderTableId">
        <table class="grid">
              <input type="hidden" name="id" value="${oPayment.id}" id="order_approve_pamentId">
              <input type="hidden" name="agentId" value="${data.agent.id}" id="order_approve_agentId">
               <%--省区审核风险代理商和结算价--%>
            <shiro:hasPermission name="order_apr_Permission_guaranteeAgent_setprice">
                    <tr>
                        <td style="text-align: right;width: 100px;">结算价:</td>
                        <td width="200px">
                            <input class="easyui-numberbox" value="${data.oPayment.settlementPrice}" name="settlementPrice" id="settlementPrice"  prompt="结算价" data-options="min:0,precision:2">
                        </td>
                        <td style="text-align: right;width: 100px;">担保代理商:</td>
                        <td >
                            <input class="easyui-textbox" value="<agent:show type="agent" busId="${data.oPayment.guaranteeAgent}"/>" name="agName" id="guaranteeAgent">
                            <input type="hidden" name="approve_guaranteeAgentId" value="${data.oPayment.guaranteeAgent}" id="approve_guaranteeAgentId">
                        </td>
                        <td colspan="3">
                            <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="showAgentInfoSelectDialog({data:this,callBack:function(item,data){
                                    if(item){
                                         $($(data).parent('td').parent('tr').find('#guaranteeAgent')).textbox('setText',item.agName);
                                         $($(data).parent('td').parent('tr').find('#approve_guaranteeAgentId')).val(item.id);
                                    }
                                }})">检索代理商</a>
                        </td>
                    </tr>
            </shiro:hasPermission>
            <shiro:hasPermission name="order_apr_Permission_isCloInvoice">
                <%--业务部审核分是否开具发票--%>
                <tr>
                    <td style="text-align: right;width: 100px;">是否开具分润发票:</td>
                    <td colspan="6">
                        <input type="radio" value="1" name="isCloInvoice" checked="checked" />是
                        <input type="radio" value="0" name="isCloInvoice" />否
                    </td>
                </tr>
            </shiro:hasPermission>
            <shiro:hasPermission name="order_apr_Permission_shareTemplet">
                <%--业务部审核分润模板 并包含省区大区权限--%>
                <tr>
                    <td style="text-align: right;width: 100px;">分润模板:</td>
                    <td colspan="6">
                        <input class="easyui-textbox" value="${data.oPayment.shareTemplet}" name="shareTemplet" id="shareTemplet"  prompt="分润模板"/>
                    </td>
                </tr>
            </shiro:hasPermission>
            <shiro:hasPermission name="order_apr_Permission_collectCompany">
            <%--财务审核收款信息--%>
            <tr>
                <td style="text-align: right;width: 100px;"><label for="collectCompany">收款公司:</label></td>
                <td>
                    <select class="easyui-combobox" name="collectCompany" id="collectCompany">
                        <c:forEach var="recCompListItem" items="${recCompList}">
                            <option value="${recCompListItem.id}"  <c:if test="${data.oPayment.collectCompany==recCompListItem.id}">selected="selected"</c:if>     >${recCompListItem.comName}</option>
                        </c:forEach>
                    </select>
                </td>
                <td style="text-align: right;width: 100px;">收款时间:</td>
                <td>
                    <input style="border:1px solid #ccc" class="easyui-datebox" editable="false" value="<c:if test="${!empty data.oPayment.actualReceiptDate}"><fmt:formatDate pattern="yyyy-MM-dd" value="${data.oPayment.actualReceiptDate}" /></c:if>" name="actualReceiptDate" id="actualReceiptDate">
                </td>
                <td style="text-align: right;width: 100px;">收款金额:</td>
                <td colspan="2">
                    <input class="easyui-numberbox" value="${data.oPayment.actualReceipt}" name="actualReceipt" prompt="实际收款金额" id="actualReceipt" data-options="min:0,precision:2">/元
                </td>
            </tr>
            </shiro:hasPermission>
            <shiro:hasPermission name="order_apr_Permission_deductionType">
            <%--抵扣信息--%>
                    <tr>
                        <td style="text-align: right;width: 100px;">
                            <select id="deductionType" name="deductionType" class="easyui-combobox"  >
                                <options>
                                    <option value="">--请选择--</option>
                                    <c:forEach items="${capitalType}" var="capitalTypeItem">
                                        <option value="${capitalTypeItem.dItemvalue}">${capitalTypeItem.dItemname}</option>
                                    </c:forEach>
                                </options>
                            </select>
                        </td>
                        <td >余额: <input type="text" id="order_apr_busniss_capital_all" readonly="readonly" />/元</td>
                        <td style="text-align: right;width: 100px;">可用余额:</td>
                        <td ><input type="text" id="order_apr_busniss_capital_can" readonly="readonly" />/元</td>
                        <td style="text-align: right;width: 100px;">设置抵扣金额:</td>
                        <td colspan="2">
                            <input class="easyui-numberbox" value="0" name="deductionAmount" prompt="设置抵扣金额" id="deductionAmount" data-options="min:0,precision:2" />/元
                        </td>
                    </tr>
                     <script type="application/javascript">
                        $(function(){
                             $("#deductionType").combobox({
                                 /**
                                  * 抵扣类型变更
                                  */
                                 onChange: function (n,o) {
                                     if(n!=undefined && n.length>0){
                                         $.ajaxL({
                                             type: "GET",
                                             url: "/orderbuild/queryAgentCanCapital",
                                             dataType:'json',
                                             data:{
                                                 agentId:$("#order_approve_agentId").val(),
                                                 type:$("#deductionType").combobox('getValue')
                                             },
                                             beforeSend :function(){
                                                 progressLoad();
                                             },
                                             success: function(data){
                                                 if(data.status==200){
                                                     $("#order_apr_busniss_capital_all").val(data.data.all);
                                                     $("#order_apr_busniss_capital_can").val(data.data.can);
                                                 }else{
                                                     $("#order_apr_busniss_capital_all").val(0);
                                                     $("#order_apr_busniss_capital_can").val(0);
                                                 }
                                             },
                                             complete:function (XMLHttpRequest, textStatus) {
                                                 progressClose();
                                             }
                                         });
                                     }else{
                                         $("#order_apr_busniss_capital_all").val(0);
                                         $("#order_apr_busniss_capital_can").val(0);
                                     }

                                 }
                             });
                        });
                     </script>
            </shiro:hasPermission>
        </table>
    </form>
</div>
<script>


    function get_subApproval_FormDataItem_order_busInfo() {

            var data =  {};
            if($("#orderTableId").find("input[name='agentId']").length>0)
                data.guaranteeAgent = $("#orderTableId").find("#approve_guaranteeAgentId").val();

            if($("#settlementPrice").length>0)
                data.settlementPrice = $("#settlementPrice").numberbox('getValue') ;

            if($("#shareTemplet").length>0)
                data.shareTemplet=$("#shareTemplet").textbox('getValue');

            if($("#orderTableId").find("input:radio:checked").length>0)
                data.isCloInvoice = $("#orderTableId").find("input:radio:checked").val();

            if($("#collectCompany").length>0)
                data.collectCompany = $("#collectCompany").combobox("getValue");

            if($("#actualReceiptDate").length>0)
                data.actualReceiptDate = $("#actualReceiptDate").datebox('getValue');

            if($("#actualReceipt").length>0)
                data.actualReceipt = $("#actualReceipt").numberbox('getValue');

            if($("#deductionAmount").length>0)
                data.deductionAmount = $("#deductionAmount").numberbox('getValue');

            if($("#deductionType").length>0)
                data.deductionType = $("#deductionType").combobox("getValue");

            if($("#order_approve_pamentId").length>0)
                data.id = $("#order_approve_pamentId").val();

            return data;

    }
</script>
