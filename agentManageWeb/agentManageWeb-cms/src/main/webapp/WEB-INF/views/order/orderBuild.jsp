<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<script type="text/javascript">
    //活动信息
    var activity_all = ${allActivityList};
    //商品表格
    var buildOrder_product ;
    //自定义异常
    function BuildOrderException(message, code){
        this.msg = message;
        this.code = code;
    }

    $(function() {

        $.extend($.fn.datagrid.defaults.editors, {
            text: {
                init: function(container, options){
                    var input = $('<input type="text" class="datagrid-editable-input" oninput="numChange(this)" >').appendTo(container);
                    return input;
                },
                destroy: function(target){
                    $(target).remove();
                },
                getValue: function(target){
                    return $(target).val();
                },
                setValue: function(target, value){
                    $(target).val(value);
                },
                resize: function(target, width){
                    $(target)._outerWidth(width);
                }
            },
            combobox:{
                init: function(container, options){
                    var proId = $(container).parent().parent().parent().parent().parent().parent().find("td[field='id']").children().text();
                    var agentId = $('#agentId').val();
                    var activity = [];
                    $.ajaxL({
                        type: "POST",
                        url: basePath+"/activity/queryProductCanActivity",
                        dataType:'json',
                        async:false,
                        data: {agentId:agentId,proId:proId},
                        beforeSend:function(){
                            progressLoad();
                        },
                        success: function(msg){
                            if(msg && msg.length>0){
                                activity.push('<select style="height:20px;" onchange="activityChange(this)">');
                                activity.push('<options>');
                                activity.push('<option value="" price="">--请选择--</option>');
                                for (var i=0;i<msg.length;i++){
                                    activity.push('<option value="'+msg[i].id+'" price="'+msg[i].price+'">');
                                    activity.push(msg[i].activityName+"/型号:"+msg[i].proModel+"/价格:"+msg[i].price+"/元");
                                    activity.push('</option>');
                                }
                                activity.push('</options>');
                                activity.push('</select>');
                            }else{
                            }
                        },
                        complete:function(){
                            progressClose();
                        }
                    });
                    var input = $(activity.join('')).appendTo(container);
                    return input;
                },
                destroy: function(target){
                    $(target).remove();
                },
                getValue: function(target){
                    return $(target).val();
                },
                setValue: function(target, value){
                    $(target).val(value);
                },
                resize: function(target, width){
                    $(target)._outerWidth(width);
                }
            }
        });
        //商品信息
        buildOrder_product =  $('#buildOrder_product').datagrid({
            idField:'id' , //只要创建数据表格 就必须要加 ifField
            fit:false ,
            width:'100%',
            fitColumns:true ,
            striped: true , //隔行变色特性
            loadMsg: '数据正在加载,请耐心的等待...' ,
            rownumbers:true ,
            columns:[[
                {
                    field:'id' ,
                    title:'商品代码',
                    width:200
                },{
                    field:'name' ,
                    title:'商品名称',
                    width:200
                },{
                    field:'price' ,
                    title:'商品价格',
                    width:200
                },{
                    field:'num' ,
                    title:'商品数量',
                    width:200,
                    editor:'text'
                },{
                    field:'activity' ,
                    title:'活动',
                    width:300,
                    editor:'combobox'
                }, {
                    field: 'action',
                    title: '操作',
                    width: 350,
                    formatter: function (value, row, index) {
                        var str = '';
                        str += $.formatString('<a href="javascript:void(0)" class="orderbuild_deletefromproduces-up-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-trash icon-blue\'" onclick="deleteFromProducts({0})" >删除</a>',index);
                        return str;
                    }
                }
            ]],
            onLoadSuccess:function(data){
                 for (var i in data.rows){
                     buildOrder_product.datagrid("beginEdit",i);
                 }
                $('.orderbuild_deletefromproduces-up-easyui-linkbutton-edit').linkbutton({text:'删除'});

            }
        });

        //平台修改
        $("#orderPlatform").combobox({
            onChange: function (n,o) {
                        var rows  = buildOrder_product.datagrid("getRows");
                        if(rows.length>0){
                                if($("#orderPlatform").attr("oldValue")!=n){
                                    parent.$.messager.confirm('询问', '确认修改平台么，商品将被清空？', function(b) {
                                        if (b) {
                                            platformChangeDelProduct();
                                        }else{
                                            $("#orderPlatform").attr("oldValue",o);
                                            $("#orderPlatform").combobox("setValue",o);
                                        }
                                    });
                                }
                        }
                    $("#orderPlatform").attr("oldValue",n);
            }
        });



        //结算方式控制分期显示
        $("#paymentMethod").combobox({
            onChange: function (n,o) {
                switch (n){
                    case 'FKFQ':
                        $("#shoufu_model").css("display","none");
                        $("#shifu_model").css("display","none");
                        $("#fenqi_model").css("display","");
                        break;
                    case 'FRFQ':
                        $("#shoufu_model").css("display","none");
                        $("#shifu_model").css("display","none");
                        $("#fenqi_model").css("display","");
                        break;
                    case 'SF1':
                        $("#shoufu_model").css("display","");
                        $("#shifu_model").css("display","");
                        $("#fenqi_model").css("display","");
                        break;
                    case 'SF2':
                        $("#shoufu_model").css("display","");
                        $("#shifu_model").css("display","");
                        $("#fenqi_model").css("display","");
                        break;
                    case 'XXDK':
                        $("#shoufu_model").css("display","none");
                        $("#shifu_model").css("display","");
                        $("#fenqi_model").css("display","none");
                        break;
                    case 'QT':
                        $("#shoufu_model").css("display","none");
                        $("#shifu_model").css("display","none");
                        $("#fenqi_model").css("display","none");
                        break;
                }
            },
            onLoadSuccess:function(){
                var val = $(this).combobox('getData');
                if(val.length>0){
                    $(this).combobox("setValue",val[0].value);
                }
            }
        });
    });


    function platformChangeDelProduct(){
        var rows  = buildOrder_product.datagrid("getRows");
        if(rows.length>0){
            //清空商品
            for (var i=rows.length-1 ;i>=0;i--){
                buildOrder_product.datagrid("deleteRow",i);
            }
        }

    }

    //数字变更事件
    function numChange(t){
        if($(t).val()<=0){
            $(t).val(1);
        }
        pan_panel_sumAmount();
    }

    //活动变更
    function activityChange(t){
        pan_panel_sumAmount();
    }

    //从商品口选择商品
    function selectProduct(item,data){
        //检查是否已经存在
        var rows  = buildOrder_product.datagrid("getRows");
        for (var i in rows){
          if(rows[i].id==item.id){
              info("已存在此商品:"+item.proName);
              return ;
          }
        }
        //添加行
        buildOrder_product.datagrid("appendRow",{id:item.id,name:item.proName,price:item.proPrice,num:1,activity:''});
        rows  = buildOrder_product.datagrid("getRows");
        //启用编辑
        for (var i in rows){
            buildOrder_product.datagrid("beginEdit",i);
        }
        //更新按钮
        $('.orderbuild_addcat-up-easyui-linkbutton-edit').linkbutton({text:'商品分配'});
        $('.orderbuild_deletefromproduces-up-easyui-linkbutton-edit').linkbutton({text:'删除'});
        buildOrder_product.datagrid("resize");
        //计算订单金额
        pan_panel_sumAmount();

    }
    //获取商品列表中的商品数据
    function getProductData(id){
      //获取商商品数据
      var rows  = buildOrder_product.datagrid("getRows");

      for (var i in rows){

          var ed = buildOrder_product.datagrid("getEditor",{index:i,field:'num'});
          rows[i].num=$(ed.target).val();

          var activity_ed = buildOrder_product.datagrid("getEditor",{index:i,field:'activity'});

          rows[i].activity= ($(activity_ed.target).val()==null||$(activity_ed.target).val()==undefined ||$(activity_ed.target).val().length==0)?"": $(activity_ed.target).val();

          rows[i].activity_price= $(activity_ed.target).find("option:selected").attr("price");

          if(id && id!=undefined && rows[i].id==id){
              return rows[i];
          }
      }

      return rows;
    }
    //获取数据要存储的商品信息
    function getDbProductData(){
        //获取商商品数据
        var rows  =getProductData();

        var arr = [];

        for (var i in rows){
            arr.push({
                proId:rows[i].id,
                proPrice:rows[i].price,
                proRelPrice:(rows[i].activity_price==undefined || rows[i].activity_price=='')?rows[i].price:rows[i].activity_price,
                proNum:rows[i].num,
                activity:rows[i].activity,
                sendNum:0
            });
        }
        return arr;
    }
    //删除商品从商品列表中
    function deleteFromProducts(index){
        //删除行数据
        buildOrder_product.datagrid("deleteRow",index);
        var rows  = buildOrder_product.datagrid("getRows");
        buildOrder_product.datagrid("loadData",rows);
        //计算订单金额
        pan_panel_sumAmount();
        // TODO 同事删除购物车中的商品
    }
    //添加到购物车
    function addCart(id){
        //点击的商品信息
        var product = getProductData(id);
        //购物车中的这个商品的数量
        var catProductNum = getCartProductInfo(id);
        if(product.num <= catProductNum){
            catProductNum = product.num;
        }
        product.catProductNum = catProductNum;
        //数量检查
        var panel = getActiveCart();

        if(panel!=undefined){
            //检查是否有此商品
             if($(panel).find(".panel-body table").find("td[name='id'][value='"+id+"']").length==0){
                 $(panel).find(".panel-body table").append(loadCartProductHtml(product));
                 $('.orderbuild_deletefromaddressproduces-up-easyui-linkbutton-edit').linkbutton({text:'删除'});
             }else{
                 info("该地址已有此商品");
             }
        }else{
            info("请指定收货地址");
        }
    }
    //获取当前激活的购物车
    function getActiveCart(){
        var my_panels =  $("div[name='address_panel']").find(".panel");
        for(var i=0;i<my_panels.length;i++){
            if($(my_panels[i]).find(".panel-tool .fi-arrow-down").hasClass("icon-red")){
                return my_panels[i];
            }
        }
        return undefined;
    }
    //获取购物车中这个商品的信息
    function getCartProductInfo(id){
          var products =  $("#address_panel").find("td[name='id']");
          var taltalnum = 0;
          for(var i=0;i<products.length;i++){
              var product = products[i];
              if($(product).attr("value")==id){
                  var num = $(product).parent('tr').find("input[name='num']").val();
                  if(num!=undefined && num.length>0){
                      taltalnum =taltalnum + parseInt(num);
                  }
              }
          }
        return taltalnum;
    }
    //删除收货地址
    function removeAddress(t){
        $(t).parent().parent().remove();
    }
    //装载购物车商品html
    function loadCartProductHtml(product){

        var arr = [];
        arr.push('<tr>');
//        arr.push('<td style="display: none;">编号:</td>');
        arr.push('<td name="id" value="'+product.id+'" style="text-align: left;width: 100px;display: none;" >'+product.id+'</td>');
//        arr.push('<td >名称:</td>');
        arr.push('<td name="name" style="text-align: left;width: 100px;" colspan="3">'+product.name+'</td>');
        arr.push('<td >发货量:</td>');
        arr.push('<td name="num" style="width: 100px;"><input type="number" name="num" value="'+(product.num-product.catProductNum)+'"/></td>');
        arr.push('<td name="action"><a href="javascript:;" onclick="$(this).parent().parent().remove();" class="orderbuild_deletefromaddressproduces-up-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-trash icon-blue\'">删除</a></td>');
        arr.push('</tr>');
        return arr.join("");
    }

</script>
<div>
    <div  class="easyui-panel" title="填写订单"
         style="background:#fafafa;"
         data-options="">
        <%--//填写订单布局--%>
        <div data-options="region:'north',title:'填写订单',split:true,iconCls:'icon-ok'" style="">
            <table style="vertical-align: middle;margin: 10px;">
                <tr>
                    <td >代理商:</td>
                    <td width="300px">
                        <input id="agName" name="agName" type="text" <c:if test="${isagent.isOK()}">value="${isagent.data.agName}"</c:if> class="easyui-textbox" readonly="readonly"  data-options="prompt:'请选择代理商'" />
                        <input type="hidden" name="agentId" <c:if test="${isagent.isOK()}">value="${isagent.data.id}"</c:if> id="agentId" />
                        <c:if test="${!isagent.isOK()}">
                            <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="showAgentInfoSelectDialog({data:this,callBack:agentSelectOrderBuild})">检索代理商</a>
                            <script type="application/javascript">
                                function agentSelectOrderBuild(item,data){
                                    if(item){
                                        $($(data).parent('td').find('#agName')).textbox('setText',item.agName);
                                        $($(data).parent('td').find('input[name=\'agentId\']')).val(item.id);
                                        $.ajaxL({
                                            type:'POST',
                                            url: basePath+'/orderbuild/orderAgentPlatformBus',
                                            dataType:'json',
                                            contentType:'application/json;charset=UTF-8',
                                            data:{agentId:item.id},
                                            beforeSend : function() {
                                                progressLoad();
                                            },
                                            success:function(data){

                                                //删除商品
                                                platformChangeDelProduct();

                                                $('#orderPlatform').combobox({
                                                    url:'/orderbuild/orderAgentPlatformBus?agentId='+item.id,
                                                    valueField:'ID',
                                                    textField:'FIELDSHOW',
                                                    onBeforeLoad:function(){
                                                        progressLoad();
                                                    },
                                                    onLoadSuccess:function(){
                                                        progressClose();
                                                        $('#orderPlatform').combobox("change");
                                                    }
                                                });
                                            },
                                            complete:function(){
                                                progressClose();
                                            }
                                        });
                                    }
                                }
                            </script>
                        </c:if>
                    </td>
                    <td >业务平台:</td>
                    <td width="300px">
                        <select name="orderPlatform" style="width: 100%;" class="easyui-combobox" id="orderPlatform" data-options="valueField: 'id',textField: 'text',">
                            <c:forEach items="${listPlateform}" var="listPlateformItem">
                                <option value="${listPlateformItem.ID}" >${listPlateformItem.FIELDSHOW}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
            </table>
        </div>
    </div>
        <%--//商品布局--%>
            <div name="product_panel" id="product_panel"  class="easyui-panel"  title="请选择商品并编辑商品数量" style="background:#fafafa;min-height: 100px;" data-options="iconCls:'fi-wrench',tools:'#buildOrder_product_tt'">
                <table data-options="fit:true,border:false" id="buildOrder_product"></table>
            </div>
            <div id="buildOrder_product_tt">
                <a href="javascript:void(0)" class="fi-plus" style="margin-right: 50px;" onclick="showProductSelectDialog_buildOrder()" title="选择商品"></a>
                <%--<a href="javascript:void(0)" class="fi-plus" onclick="javascript:getProductData()" title="获取数据"></a>--%>
                <script type="application/javascript">
                    function showProductSelectDialog_buildOrder(){
                        if($('#orderPlatform').combobox('getValue')==undefined || $('#orderPlatform').combobox('getValue').length==0){
                            info("请选择业务平台");
                            return;
                        }
                        if($('#agentId').val()==undefined || $('#agentId').val().length==0){
                            info("请选代理商");
                            return;
                        }
                        showProductSelectDialog({data:{platformBusId:$('#orderPlatform').combobox('getValue')},callBack:selectProduct});
                    }
                </script>
            </div>

            <%--//收货地址布局--%>
            <%--<div name="address_panel" id="address_panel" class="easyui-panel" title="请选择收货信息" style="background:#fafafa;margin: auto;min-height: 100px;display: none;"  data-options="iconCls:'fi-wrench',tools:'#buildOrder_address_tt'">--%>
            <%--</div>--%>
            <div id="buildOrder_address_tt" style="display: none;">
                <%--<a href="javascript:void(0)" class="fi-plus" style="margin-right: 50px;"  onclick="showAddressInfoSelectDialog({data:'',callBack:showAddressInfoSelectDialog_callBack})" title="选择地址"></a>--%>
                <script type="application/javascript">
                    //地址选择添加
                    function showAddressInfoSelectDialog_callBack(item,data){
                        //检查是否已经添加过地址
                        var my_panels =  $("div[name='address_panel']").find(".panel div[id='"+item.id+"']");
                        if(my_panels.length>0){
                            info("地址已存在");
                            return;
                        }

                        //添加面板
                        var html =  $("div[name='build_order_address_templet']").html();
                        $("div[name='address_panel']").append(html);

                        //面板初始化
                        var title = item.addrRealname+":"+item.addrMobile+":"+item.addrProvinceString+":"+item.addrCityString+":"+item.addrDistrictString;
                        $("div[name='address_panel'] div:last").panel({
                            id:item.id,
                            title:title,
                            iconCls:'fi-shopping-cart',
                            tools:[{
                                iconCls:'fi-arrow-down icon-gray',//fi-arrow-down icon-red
                                handler:function(){
                                    if($(this).hasClass("icon-gray")){
                                        var arr_down =  $("div[name='address_panel']").find(".fi-arrow-down");
                                        for(var i=0;i<arr_down.length;i++){
                                            if($(arr_down[i]).hasClass("icon-red")){
                                                $(arr_down[i]).removeClass("icon-red");
                                                $(arr_down[i]).addClass("icon-gray");
                                            }
                                        }
                                        $(this).removeClass("icon-gray");
                                        $(this).addClass("icon-red");
                                    }else if($(this).hasClass("icon-red")){
                                        $(this).removeClass("icon-red");
                                        $(this).addClass("icon-gray");
                                    }
                                }
                            },{
                                iconCls:'fi-italic',
                                handler:function(){
                                }
                            },{
                                iconCls:'fi-x',
                                handler:function(){
                                    $(this).parent().parent().parent().remove();
                                }
                            },{
                                iconCls:'fi-italic',
                                handler:function(){
                                }
                            }]
                        });

                    }

                    /**
                     * 获取地址模块待提交的数据
                     * @returns {Array}
                     */
                    function getAdressProduceInfoData(){
                        var arr = [];
                        var address =   $("div[name='address_panel']").find(".panel-body");
                        for(var i=0 ;i<address.length;i++){
                            var addressid =   $(address[i]).attr("id");
                            var trs = $(address[i]).find("tr");
                            var products = [];
                            for(var j=0 ;j<trs.length;j++){
                                var trs_item_id =   $(trs[j]).find("td[name='id']").attr("value");
                                var trs_item_num =   $(trs[j]).find("input[name='num']").val();
                                if(trs_item_id==undefined || trs_item_id.length==0){
                                    throw new BuildOrderException("地址ID为空",1);
                                }
                                if(trs_item_num==undefined || trs_item_id.length==0 || trs_item_num <= 0){
                                    throw new BuildOrderException("地址内商品数量为空",1);
                                }
                                products.push({proId: trs_item_id, proNum: trs_item_num});

                            }
                            if(products.length==0){
                                throw new BuildOrderException("地址中必须添加商品",1);
                            }
                            arr.push({addressId:addressid,oReceiptPros:products})
                        }
                        return arr;
                    }
                </script>
            </div>
    <%--结算信息布局--%>
    <div class="easyui-panel" title="结算配置" data-options="iconCls:'icon-ok',footer:'#pay_panel_ft'"  name="pay_panel">
        <table style="width: 100%;border-collapse:separate; border-spacing:0px 10px;">
            <tr>
                <td style="text-align: right;width: 100px;"><label for="oAmo">订单金额:</label></td>
                <td> <input class="easyui-numberbox" type="text" name="oAmo" id="oAmo" value="0" readonly="readonly" data-options="min:0,precision:2" />/元</td>
                <td style="text-align: right;"><label for="paymentMethod">结算方式:</label></td>
                <td >
                    <select  class="easyui-combobox" name="paymentMethod" style="width:150px;" id="paymentMethod">
                        <c:forEach var="settlementTypeItem" items="${settlementType}" >
                            <option value="${settlementTypeItem.dItemvalue}">${settlementTypeItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td style="text-align: right;"><label for="collectCompany">收款公司:</label></td>
                <td >
                    <select  class="easyui-combobox" name="collectCompany"  style="width:150px;"  id="collectCompany">
                        <c:forEach var="recCompListItem" items="${recCompList}" >
                            <option value="${recCompListItem.id}">${recCompListItem.comName}</option>
                        </c:forEach>
                    </select>
                </td>
                <td colspan="1">
                    &nbsp;
                </td>
            </tr>

            <tr id="fenqi_model">
                <td style="text-align: right;"><label for="downPaymentCount">分期期数:</label></td>
                <td>
                    <select  class="easyui-combobox" name="downPaymentCount" style="width:150px;" id="downPaymentCount">
                        <c:forEach var="v"  begin="1"  end="6" step="1">
                            <option value="${v}">${v}期</option>
                        </c:forEach>
                    </select>
                </td>
                <td style="text-align: right;"><label for="downPaymentDate">分期开始时间:</label></td>
                <td>  <input class="easyui-datebox" type="text" name="downPaymentDate" id="downPaymentDate" data-options="required:true"  /></td>
                <td>
                    <%--<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-magnifying-glass'" onclick="alert('开发中');" >分期计划</a>--%>
                </td>
                <td colspan="2" >
                    &nbsp;
                </td>
            </tr>
            <tr id="shoufu_model">
                <td style="text-align: right;width: 150px;"><label for="downPayment">首付金额:</label></td>
                <td> <input class="easyui-numberbox" type="text" name="downPayment" id="downPayment" value="0" data-options="required:true,min:0,precision:2" />/元</td>
                <td colspan="5" >
                    &nbsp;
                </td>
            </tr>
            <tr id="shifu_model">
                <td style="text-align: right;width: 150px;"><label for="downPayment">实付金额:</label></td>
                <td> <input class="easyui-numberbox" type="text" name="actualReceipt" id="actualReceipt" value="0" data-options="min:0,precision:2" />/元</td>
                <td style="text-align: right;width: 150px;"><label for="downPaymentUser">打款人:</label></td>
                <td> <input class="easyui-textbox" type="text" name="downPaymentUser" id="downPaymentUser" value=""  /></td>
                <td colspan="3" >
                    &nbsp;
                </td>
            </tr>
            <tr id="danbaodaili_model">
                <td style="text-align: right;width: 150px;"><label for="downPayment">结算价:</label></td>
                <td >
                    <input class="easyui-numberbox" value="" name="settlementPrice" id="settlementPrice" data-options="min:0,precision:2">
                    &nbsp;&nbsp;&nbsp;&nbsp;
                </td>
                <td style="text-align: right;width: 150px;"><label for="downPayment">担保代理商:</label></td>
                <td >
                    <input class="easyui-textbox" value="" readonly="readonly" data-options="prompt:'请选择担保代理商'" name="guaranteeAgent" id="guaranteeAgent">
                    <input type="hidden" value="" name="guaranteeAgentId" id="guaranteeAgentId">
                    &nbsp;&nbsp;&nbsp;&nbsp;
                </td>
                <td colspan="3">
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="showAgentInfoSelectDialog({data:this,callBack:function(item,data){
                            if(item){
                                 $($(data).parent('td').parent('tr').find('#guaranteeAgent')).textbox('setText',item.agName);
                                 $($(data).parent('td').parent('tr').find('#guaranteeAgentId')).val(item.id);
                            }
                        }})">检索代理商</a>
                </td>
            </tr>
            <tr>
                <td style="text-align: right;"><label for="buildOrderAttrList">打款截图:</label></td>
                <td colspan="7" id="buildOrderAttrList"> </td>
                <td >
                    <a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-multiple'" onclick="multFileUpload(buildOrderAddattr);" >添加凭证</a>
                    <script type="application/javascript">

                        //添加附件
                        function buildOrderAddattr(data){
                            var jsondata = eval(data);
                            for(var i=0;i<jsondata.length ;i++){
                                $("#buildOrderAttrList").append("<span onclick='removeBuildOrderAddattr(this)'>"+jsondata[i].attName+"<input type='hidden' name='buildOrderAttrListFile' value='"+jsondata[i].id+"' /></span>&nbsp;&nbsp;&nbsp;&nbsp;");
                            }
                        }
                        //删除附件
                        function removeBuildOrderAddattr(t){
                            parent.$.messager.confirm('询问', '确定删除附件么？', function(b) {
                                if (b) {
                                    $(t).remove();
                                }
                            });
                        }
                        //获取附件信息
                        function getBuildOrderAddattrs(){
                            var attachments = [];
                            var inputs = $("#buildOrderAttrList").find("input[name='buildOrderAttrListFile']");
                            for(var i=0;i<inputs.length;i++){
                                var id =  $(inputs[i]).val();
                                attachments.push({id:id});
                            }
                            return attachments;
                        }
                    </script>
                </td>
            </tr>
            <tr>
                <td style="text-align: right;"><label for="remark">备注:</label></td>
                <td colspan="8">
                    <input class="easyui-textbox" data-options="multiline:true,prompt:'1、填写申请奖励信息，申请考核信息；2、填写抵扣费用申请信息；'" value="" style="width:80%;height:100px" name="remark" id="remark"/>
                </td>

            </tr>
        </table>
    </div>
    <div id="pay_panel_ft" style="padding:10px;">
        <table style="width: 100%;">
            <tr>
                <td colspan="2" style="margin: auto;text-align: center;">
                    <a href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'fi-save'" style="width: 100px;" onclick="saveOrder()">暂存订单</a>
                </td>
                <td colspan="2" style="margin: auto;text-align: center;">
                    <a href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'fi-torsos-female-male'"  style="width: 100px;" onclick="saveOrder(approveOrder)">提交审批</a>
                </td>
            </tr>
        </table>
        <script type="application/javascript">
            //计算订单金额
            function pan_panel_sumAmount(){
                var rows = getDbProductData();
                var amount = 0.00;
                for(var i in rows){
                    if(rows[i].proNum && rows[i].proNum >= 0){
                        amount = amount + (parseFloat(rows[i].proRelPrice)) * parseInt(rows[i].proNum) ;
                    }
                }
                amount = parseFloat(amount).toFixed(2);
                $("#oAmo").numberbox('setValue',amount);
            }
            //订单保存
            function saveOrder(callBack){
                try{

                    //地址数据
                    // var address_data  = getAdressProduceInfoData();
                    //产品数据
                    var product_data = getDbProductData();
                    //代理商
                    var agentId = $("#agentId").val();
                    if(agentId==undefined|| agentId.length==0){
                        throw new BuildOrderException("请指定代理商",1);
                    }
                    //平台信息
                    var orderPlatform = $("#orderPlatform").combobox("getValue");
                    if(orderPlatform==undefined|| orderPlatform.length==0){
                        throw new BuildOrderException("请指定业务平台",1);
                    }
                    //订单金额
                    var oAmo = $("#oAmo").textbox("getValue");
                    //备注
                    var remark = $("#remark").textbox("getValue");
                    //收款公司
                    var collectCompany = $("#collectCompany").combobox("getValue");
                    //支付方式
                    var paymentMethod = $("#paymentMethod").combobox("getValue");
                    //首付
                    var downPayment = $("#downPayment").numberbox("getValue");
                    //首付分期
                    var downPaymentCount = $("#downPaymentCount").combobox("getValue");
                    //首付分期日期
                    var downPaymentDate = $("#downPaymentDate").datebox("getValue");
                    //打款人
                    var downPaymentUser = $("#downPaymentUser").textbox("getValue");
                    //附件信息
                    var attachments = getBuildOrderAddattrs();
                    //实际付款金额
                    var actualReceipt = $("#actualReceipt").numberbox("getValue");
                    //担保代理商
                    var guaranteeAgentId = $("#guaranteeAgentId").val();
                    //结算价
                    var settlementPrice = $("#settlementPrice").val();

                    //必须选择商品
                    if(product_data.length==0){
                        throw new BuildOrderException("请选择商品",1);
                    }
                    //结算信息
                    var paymentData = {
                        agentId:agentId,
                        payAmount:oAmo,
                        payMethod:paymentMethod,
                        downPayment:downPayment,
                        downPaymentCount:downPaymentCount,
                        downPaymentDate:downPaymentDate,
                        actualReceipt:actualReceipt,
                        remark:remark,
                        downPaymentUser:downPaymentUser,
                        collectCompany:collectCompany,
                        guaranteeAgent:guaranteeAgentId,
                        settlementPrice:settlementPrice
                    };
                    parent.$.messager.confirm('询问', '确认要添加？', function(b) {
                        if (b) {
                            $.ajaxL({
                                type: "POST",
                                url: basePath+"/orderbuild/buildOrder",
                                dataType:'json',
                                contentType:'application/json;charset=UTF-8',
                                data: JSON.stringify({
                                    agentId:agentId,//代理商ID
                                    orderPlatform:orderPlatform,//平台值
                                    oAmo:oAmo,
                                    paymentMethod:paymentData.payMethod,
                                    remark:remark,
                                    attachments:attachments,
                                    oSubOrder:product_data,//商品
                                    //oReceiptOrderList:address_data,//商品分配
                                    oPayment:paymentData//支付信息
                                }),
                                beforeSend : function() {
                                    progressLoad();
                                },
                                success: function(msg){

                                    if(msg.status=='200'){
                                        if(typeof  callBack == 'function'){
                                            callBack(msg.data);
                                        }else{
                                            info(msg.msg);
                                            $('#index_tabs').tabs('close',"代理商订货");
                                            orderList.datagrid('reload');
                                        }
                                        progressClose();
                                    }else{
                                        info(msg.msg);
                                    }
                                },
                                complete:function (XMLHttpRequest, textStatus) {
                                    progressClose();
                                }
                            });
                        }
                    });
                    //异常统一提示
                }catch (e){
                    if(e.code == 1){
                        info(e.msg);
                    }
                }
            }
            //订单保存并提交审核
            function approveOrder(data){
                if(data!=undefined)
                parent.$.messager.confirm('询问', '确认要提交审批？', function(b) {
                    if (b) {
                        $.ajaxL({
                            type: "GET",
                            url: "/orderbuild/startOrderReview",
                            dataType:'json',
                            data: {orderId:data},
                            success: function(msg){
                                info(msg.msg);
                               $('#index_tabs').tabs('close',"代理商订货");
                            },
                            complete:function (XMLHttpRequest, textStatus) {
                                orderList.datagrid('reload');
                                progressClose();
                            }
                        });
                    }
                });
            }


        </script>
    </div>
    <%--//地址模板--%>
    <div  title="" style="display: none;" name="build_order_address_templet">
        <div>
            <table style="width: 100%;">
            </table>
        </div>
    </div>
</div>
