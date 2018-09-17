<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    var orderList;
    $(function() {
        orderList = $('#orderList').datagrid({
            url : '${path }/order/orderList',
            striped : true,
            rownumbers : true,
            pagination : true,
            singleSelect : true,
            fit : true,
            idField : 'ID',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            columns : [ [{
				title : '平台',
				field : 'PLATFORM_NAME'
			},{
                title : '订单编号',
                field : 'ID'
            },{
                title : '订单号',
                field : 'O_NUM'
            },{
                title : '代理商',
                field : 'AG_NAME'
            },{
                title : '支付方式',
                field : 'PAYMENT_METHOD',
                formatter : function(value, row, index) {
                    if(db_options.settlementType!=undefined && db_options.settlementType.length>0){
                        for(var i=0;i< db_options.settlementType.length;i++){
                            if(value==db_options.settlementType[i].dItemvalue){
                                return db_options.settlementType[i].dItemname;
                            }
                        }
                    }
                }
            },{
                title : '应付金额',
                field : 'PAY_AMO',
                formatter : function(value, row, index) {
                    return value.toFixed(2)+'/￥';
                }
            },{
                title : '待付金额',
                field : 'OUTSTANDING_AMOUNT',
                formatter : function(value, row, index) {
                    return  value.toFixed(2)+'/￥';
                }
            },{
                title : '欠款',
                field : 'QK',
                formatter : function(value, row, index) {
					return  (value > 0)? ('<span style="color: red">'+value.toFixed(2)+'/￥</span>') :value.toFixed(2)+'/￥';
                }
            },{
                title : '待配货',
                field : 'DPD',
                formatter : function(value, row, index) {
                        return value+"件";
                }
            },{
                title : '审批状态',
                field : 'REVIEW_STATUS',
                formatter : function(value, row, index) {
                    if(db_options.agStatuss!=undefined && db_options.agStatusi.length > 0 ){
                        for(var i=0; i < db_options.agStatusi.length; i++){
                            if(value==db_options.agStatusi[i].dItemvalue){
                                return db_options.agStatusi[i].dItemname;
                            }
                        }
                    }
                }
            },{
                title : '创建时间',
                field : 'C_TIME'
            }, {
                field : 'action',
                title : '操作',
                width : 300,
                formatter : function(value, row, index) {
                    var str = '';

                    //查看
                    str += $.formatString('<a href="javascript:void(0)" class="order-easyui-linkbutton-look" data-options="plain:true,iconCls:\'fi-page\'" onclick="orderView(\'{0}\');" >查看</a>', row.ID);
					<shiro:hasPermission name="/order/orderEidt">
					//新建
					if(row.REVIEW_STATUS==1){
                        str += $.formatString('||<a href="javascript:void(0)" class="order-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-torsos-all\'" onclick="orderViewStartActivity(\'{0}\');" >提交审批</a>', row.ID);
                        str += $.formatString('||<a href="javascript:void(0)" class="order-easyui-linkbutton-update" data-options="plain:true,iconCls:\'fi-pencil\'" onclick="xiugaiAction(\'{0}\',\'{1}\');" >修改</a>', row.ID,row.AGENTID);
                    }
                    </shiro:hasPermission>
					<shiro:hasPermission name="/order/shipments">
                    //配货
                    if(row.REVIEW_STATUS==3){
                        str += $.formatString('||<a href="javascript:void(0)" class="order-easyui-linkbutton-peihuo" data-options="plain:true,iconCls:\'fi-folder-add icon-yellow\'" onclick="peihuo(\'{0}\',\'{1}\');" >配货</a>', row.ID,row.AGENTID);
                    }
                    </shiro:hasPermission>
					<shiro:hasPermission name="/order/sumpplement">
                    //是否欠款
                    if(row.QK!='0'){
                        str += $.formatString('||<a href="javascript:void(0)" class="order-easyui-linkbutton-BK" data-options="plain:true,iconCls:\'fi-yen  icon-yellow\'" onclick="bukuanAction(\'{0}\',\'{1}\');" >补款</a>', row.ID,row.AGENTID);
                    }
					</shiro:hasPermission>
					<shiro:hasPermission name="/order/logistics">
                    //物流
                    if(row.REVIEW_STATUS==3){
                        str += $.formatString('||<a href="javascript:void(0)" class="order-easyui-linkbutton-wuliu" data-options="plain:true,iconCls:\'fi-shopping-cart\'" onclick="wuliu(\'{0}\',\'{1}\');" >物流信息</a>', row.ID,row.AGENTID);
                    }
                    </shiro:hasPermission>
                    return str;
                }
            }]],
            onLoadSuccess: function (data) {
                $('.order-easyui-linkbutton-look').linkbutton({text: '查看'});
                $('.order-easyui-linkbutton-edit').linkbutton({text: '提交审批'});
                $('.order-easyui-linkbutton-BK').linkbutton({text: '补款'});
                $('.order-easyui-linkbutton-update').linkbutton({text: '修改'});
                $('.order-easyui-linkbutton-peihuo').linkbutton({text: '配货'});
                $('.order-easyui-linkbutton-wuliu').linkbutton({text: '物流'});
            },
            toolbar : '#orderToolbar'
        });

    });

   function searchOrder() {
       orderList.datagrid('load', $.serializeObject($('#searchOrderForm')));
	}

	function cleanOrder() {
		$('#searchOrderForm input').val('');
        orderList.datagrid('load', {});
	}

    function RefreshCloudHomePageTab() {
        orderList.datagrid('reload');
    }

    //订单详情
    function orderView(id){
        addTab({
            title : '订单:'+id,
            border : false,
            closable : true,
            fit : true,
            href:'/orderbuild/orderApprView?orderId='+id
        });
	}
	//订单构建
    function buildOrder(){
        addTab({
            title : '代理商订货',
            border : false,
            closable : true,
            fit : true,
            href:'${path}/orderbuild/buildview'
        });
	}

	//提交审批
	function orderViewStartActivity(id){
        parent.$.messager.confirm('询问', '确认要提交审批？', function(b) {
            if (b) {
                $.ajaxL({
                    type: "GET",
                    url: "/orderbuild/startOrderReview",
                    dataType:'json',
                    data: {orderId:id},
                    beforeSend:function(){
                        progressLoad();
					},
                    success: function(msg){
                        if(msg.status==200){
                            orderList.datagrid('load', $.serializeObject($('#searchOrderForm')));
						}
                        info(msg.msg);
                    },
                    complete:function (XMLHttpRequest, textStatus) {
                        orderList.datagrid('load', $.serializeObject($('#searchOrderForm')));
                        progressClose();
                    }
                });
            }
        });
	}

    /**
	 * 补款操作
     * @param id
     */
	function bukuanAction(id,agentId){
	    //根据订单信息查询需要补款的付款明细
        $.ajaxL({
            type: "GET",
            url: "/orderbuild/queryOrderForOSupplementPaymentdetail",
            dataType:'json',
            data: {orderId:id,agentId:agentId},
            beforeSend:function(){
                progressLoad();
            },
            success: function(msg){
                console.log(msg);
                if(msg.status==200){
                    addTab({
                        title: '补款审批申请',
                        border: false,
                        closable: true,
                        fit: true,
                        href: "${path}/supplement/supplementAddDialog?srcId="+msg.data.paymentDetails.id+"&pkType=1&remark=OrderNum-"+msg.data.order.oNum+"&agentId="+msg.data.order.agentId+"&payAmount="+msg.data.paymentDetails.payAmount
                    });
                }else{
                    info(msg.msg);
				}
            },
            complete:function (XMLHttpRequest, textStatus) {
                progressClose();
            }
        });


	}

	function peihuo(id,agentId){
        //根据订单信息查询需要补款的付款明细
        parent.$.modalDialog({
            title : '配货',
            width : 800,
            height : 600,
            href :  "${path}/order/distributionView?orderId="+id+"&agentId="+agentId
        });
        <%--addTab({--%>
            <%--title: '配货',--%>
            <%--border: false,--%>
            <%--closable: true,--%>
            <%--fit: true,--%>
            <%--href: "${path}/order/distributionView?orderId="+id+"&agentId="+agentId--%>
        <%--});--%>
	}

    function wuliu(id,agentId){
        //根据订单信息查询需要补款的付款明细
        parent.$.modalDialog({
            title : '物流',
            width : 900,
            height : 500,
            href :  "${path}/logistics/orderLogisticsDialog?orderId="+id+"&agentId="+agentId
        });
        <%--addTab({--%>
        <%--title: '配货',--%>
        <%--border: false,--%>
        <%--closable: true,--%>
        <%--fit: true,--%>
        <%--href: "${path}/order/distributionView?orderId="+id+"&agentId="+agentId--%>
        <%--});--%>
    }

    function xiugaiAction(id,agentId){
        //根据订单信息查询需要补款的付款明细
                    addTab({
                        title: '订单修改',
                        border: false,
                        closable: true,
                        fit: true,
                        href: "${path}/order/updateOrderView?orderId="+id+"&agentId="+agentId
                    });
    }

    // 导出数据
    function exportOrderFun(){
        $('#searchOrderForm').form({
            url : '${path }/order/exportOrder',
            onSubmit : function() {
                return $(this).form('validate');
            }
        });
        $('#searchOrderForm').submit();
    }

    function order_myformatter(date){
            var y = date.getFullYear();
            var m = date.getMonth()+1;
            var d = date.getDate();
            return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
        }
    function order_myparser(s){
        if (!s) return new Date();
        var ss = (s.split('-'));
        var y = parseInt(ss[0],10);
        var m = parseInt(ss[1],10);
        var d = parseInt(ss[2],10);
        if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
            return new Date(y,m-1,d);
        } else {
            return new Date();
        }
    }
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div id="" data-options="region:'west',border:true,title:'我的订单11'"  style="width:100%;overflow: hidden; ">
		<table id="orderList" data-options="fit:true,border:false"></table>
	</div>
    <div data-options="region:'north',border:false" style="height: 35px; overflow: hidden;background-color: #fff">
	   <form id ="searchOrderForm">
			<table>
				<tr>
					<th>订单编号:</th>
					<td><input name="id" style="line-height:17px;border:1px solid #ccc;width: 50px;"></td>
					<th>订单号:</th>
					<td><input name="oNum" style="line-height:17px;border:1px solid #ccc;width: 50px;"></td>
					<th>代理商名称:</th>
					<td><input name="agName" style="line-height:17px;border:1px solid #ccc;width: 50px;"></td>
					<th>下单时间:</th>
					<td>
						<input name="beginTime" style="line-height:17px;border:1px solid #ccc" class="easyui-datebox" data-options="prompt:'下单开始时间',formatter:order_myformatter,parser:order_myparser,"/>
						<input name="endTime"   style="line-height:17px;border:1px solid #ccc" class="easyui-datebox" data-options="prompt:'下单结束时间',formatter:order_myformatter,parser:order_myparser,"/>
					</td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="searchOrder();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cleanOrder();">清空</a>
                    </td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>
						<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-print',plain:true" onclick="exportOrderFun();">导出订单信息</a>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>
<div id="orderToolbar">
	<%--订货--%>
	<shiro:hasPermission name="order_buildorder">
	<a onclick="buildOrder()" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-folder-add icon-green'">订货</a>
	</shiro:hasPermission>
</div>

