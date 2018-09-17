package com.ryx.credit.cms.controller.order;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.ryx.credit.cms.controller.*;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.enumc.DictGroup;
import com.ryx.credit.common.enumc.OReceiptStatus;
import com.ryx.credit.common.exception.MessageException;
import com.ryx.credit.common.exception.ProcessException;
import com.ryx.credit.common.result.AgentResult;
import com.ryx.credit.common.util.*;
import com.ryx.credit.common.util.DateUtils;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.pojo.admin.agent.Dict;
import com.ryx.credit.pojo.admin.agent.PayComp;
import com.ryx.credit.pojo.admin.agent.PlatForm;
import com.ryx.credit.pojo.admin.order.*;
import com.ryx.credit.pojo.admin.vo.OrderFormVo;
import com.ryx.credit.service.IUserService;
import com.ryx.credit.service.agent.AgentBusinfoService;
import com.ryx.credit.service.agent.AgentService;
import com.ryx.credit.service.agent.BusinessPlatformService;
import com.ryx.credit.service.order.AddressService;
import com.ryx.credit.service.order.OrderActivityService;
import com.ryx.credit.service.order.OrderService;
import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.commons.lang3.time.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

/**
 * 订单控制层
 * @version V1.0
 * @Description:
 * @author: Liudh
 * @date: 2018/7/16 15:30
 */
@RequestMapping("order")
@Controller
public class OrderController extends BaseController{

    private static final Logger logger = LoggerFactory.getLogger(OrderController.class);
    @Autowired
    private IUserService userService;
    @Autowired
    private OrderService orderService;
    @Autowired
    private OrderActivityService orderActivityService;
    @Autowired
    private BusinessPlatformService businessPlatformService;
    @Autowired
    private AddressService addressService;
    @Autowired
    private AgentService agentService;
    @Autowired
    private AgentBusinfoService agentBusinfoService;

    private static String EXPORT_Order_PATH = AppConfig.getProperty("export.path");


    @RequestMapping(value = "toOrderList")
    public String toOrderList(HttpServletRequest request,OProduct product){
        return "order/orderList";
    }

    /**
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "orderList")
    @ResponseBody
    public Object orderList(HttpServletRequest request){

        Page pageInfo = pageProcess(request);

        FastMap par = FastMap.fastMap("oNum",request.getParameter("oNum"))
                .putKeyV("agentId",request.getParameter("agentId"))
                .putKeyV("agName",request.getParameter("agName"))
                 .putKeyV("id",request.getParameter("id"));

        if(StringUtils.isNotBlank(request.getParameter("beginTime")) && StringUtils.isNotBlank(request.getParameter("endTime"))){
            par.putKeyV("beginTime", request.getParameter("beginTime"));
            par.putKeyV("endTime",request.getParameter("endTime"));
        }

        //查询当前用户的订单
        par.putKeyV("userId",getUserId());

        //查询所在部门的订单
        List<Map<String, Object>>  list = userService.orgCode(getUserId());
        if(list.size()>0 && null!=(list.get(0).get("ORGID"))) {
            par.putKeyV("doc", list.get(0).get("ORGID"));
        }
        PageInfo resultPageInfo = orderService.orderList(par,pageInfo);
        return resultPageInfo;
    }


    /**
     * order/toALLOrderList
     * @param request
     * @param product
     * @return
     */
    @RequestMapping(value = "toALLOrderList")
    public String toALLOrderList(HttpServletRequest request,OProduct product){
        return "order/allOrderList";
    }

    @RequestMapping(value = "allOrderList")
    @ResponseBody
    public Object allOrderList(HttpServletRequest request){
        Page pageInfo = pageProcess(request);
        FastMap par = FastMap.fastMap("oNum",request.getParameter("oNum"))
                .putKeyV("agentId",request.getParameter("agentId"))
                .putKeyV("agName",request.getParameter("agName"))
                .putKeyV("id",request.getParameter("id"));
        if(StringUtils.isNotBlank(request.getParameter("beginTime")) && StringUtils.isNotBlank(request.getParameter("endTime"))){
            par.putKeyV("beginTime", request.getParameter("beginTime"));
            par.putKeyV("endTime",request.getParameter("endTime"));
        }
        PageInfo resultPageInfo = orderService.allOderList(par,pageInfo);
        return resultPageInfo;
    }


    /**
     * /order/toAgentOrderList
     * @param request
     * @param product
     * @return
     */
    @RequestMapping(value = "toAgentOrderList")
    public String toAgentOrderList(HttpServletRequest request,OProduct product){
        return "order/agentOrderList";
    }

    @RequestMapping(value = "agentOrderList")
    @ResponseBody
    public Object agentOrderList(HttpServletRequest request){
        Page pageInfo = pageProcess(request);
        FastMap par = FastMap.fastMap("oNum",request.getParameter("oNum"))
                .putKeyV("agentId",getAgentId())
                .putKeyV("id",request.getParameter("id"))
                .putKeyV("agUniqNum",request.getParameter("agUniqNum"));
        if(StringUtils.isNotBlank(request.getParameter("beginTime")) && StringUtils.isNotBlank(request.getParameter("endTime"))){
            par.putKeyV("beginTime", request.getParameter("beginTime"));
            par.putKeyV("endTime",request.getParameter("endTime"));
        }
        PageInfo resultPageInfo = orderService.agentOderList(par,pageInfo);
        return resultPageInfo;
    }







    @RequestMapping("/importPage")
    public String importPage(){
        return "order/oLogisticsImportReturn";
    }

    /**
     * 订单管理:
     * 导出订单信息
     */
    @RequestMapping(value = "exportOrder")
    @ResponseBody
    public void exportOrder(HttpServletRequest request, HttpServletResponse response){
        TreeMap map = getRequestParameter(request);
        PageInfo pageInfo = orderService.getOrderList(map, new PageInfo());
        Map<String, Object> param = new HashMap<String, Object>(6);
        
        String title = "订单日期,订单编号,代理商名称,唯一编号,产品,机型,数量,价格,总价,备注,联系人,电话,收货地址";
        String column = "O_APYTIME,O_NUM,AG_NAME,AG_UNIQ_NUM,PRO_NAME,MODEL,PRO_NUM,PRO_PRICE,O_AMO,EXPRESS_REMARK,ADDR_REALNAME,ADDR_MOBILE,ADDR_DETAIL";

        param.put("path", EXPORT_Order_PATH);
        param.put("title", title);
        param.put("column", column);
        param.put("dataList", pageInfo.getRows());
        param.put("response", response);
        ExcelUtil.downLoadExcel(param);
    }

    /**
     *  /order/updateOrderView
     * @param request
     * @param response
     * @param orderId
     * @param agentId
     * @return
     */
    @RequestMapping(value = "updateOrderView")
    public String updateOrderView(HttpServletRequest request,
                                  HttpServletResponse response,
                                  @RequestParam("orderId")String orderId,
                                  @RequestParam("agentId")String agentId){
        try {
            //业务平台参数
            List<PlatForm> platForms = businessPlatformService.queryAblePlatForm();
            request.setAttribute("platForms", platForms);
            //结算方式
            List<Dict> settlement_type = ServiceFactory.dictOptionsService.dictList(DictGroup.ORDER.name(), DictGroup.SETTLEMENT_TYPE.name());
            request.setAttribute("settlementType", settlement_type);
            //收款公司
            List<PayComp> payComp_list = ServiceFactory.apaycompService.recCompList();
            request.setAttribute("recCompList", payComp_list);
            List<OActivity> allActivityList = orderActivityService.allActivity();
            request.setAttribute("allActivityList", JSONArray.toJSONString(allActivityList));
            AgentResult res =  orderService.loadAgentInfo(orderId);
            if(res.isOK()) {
                request.setAttribute("data", res.getData());
            }
            AgentResult ar = agentService.isAgent(getUserId()+"");
            request.setAttribute("isagent", ar);

            List<Map> listPlateform = agentBusinfoService.agentBus(agentId);
            request.setAttribute("listPlateform", listPlateform);



        } catch (Exception e) {
            e.printStackTrace();
        }
        return "order/orderUpdate";
    }


    /**
     * /order/updateOrderAction
     * @param request
     * @param response
     * @param agentVo
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "updateOrderAction")
    public AgentResult updateOrderAction(HttpServletRequest request,
                                         HttpServletResponse response,
                                         @RequestBody OrderFormVo agentVo){
        try {
            logger.info("用户{}修改订单{}",JSONObject.toJSONString(agentVo));
            return  orderService.updateOrder(agentVo,getUserId()+"");
        } catch (Exception e) {
            e.printStackTrace();
            if(e instanceof MessageException){
                return AgentResult.fail(((MessageException)e).getMsg());
            }
            return AgentResult.fail("失败");
        }

    }


    /**
     * 订单配货界面
     * /order/distributionView
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "distributionView")
    public String distributionView(HttpServletRequest request,
                                   HttpServletResponse response){
        request.setAttribute("orderId",request.getParameter("orderId"));
        request.setAttribute("agentId",request.getParameter("agentId"));
        return "order/orderDistribution";
    }


    /**
     * 订单配货数据
     * /order/distributionView
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "distributionViewData")
    public AgentResult distributionViewData(HttpServletRequest request,
                                   HttpServletResponse response){
        List<Map<String, Object>> sub =   orderService.querySubOrderInfoList(request.getParameter("agentId"),request.getParameter("orderId"));
        List<Map<String, Object>> peiHuo =   orderService.queryHavePeiHuoProduct(request.getParameter("agentId"),request.getParameter("orderId"));
        PageInfo page = new PageInfo(1,Integer.MAX_VALUE);
        OAddress oa = new OAddress();
        oa.setuId(getUserId()+"");
        PageInfo pageInfo = addressService.queryAddressList(page,oa);
        return AgentResult.ok(FastMap.fastMap("sub",sub).putKeyV("peiHuo",peiHuo).putKeyV("address",pageInfo.getRows()));
    }


    /**
     * 配货操作
     * /order/peihuoAction
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "peihuoAction")
    public AgentResult peihuoAction(HttpServletRequest request,
                                    HttpServletResponse response,
                                    String orderId,
                                    String addressId,
                                    String agentId,
                                    String proId,
                                    Integer sendNum){
        if(StringUtils.isBlank(orderId)
                || StringUtils.isBlank(addressId)
                || StringUtils.isBlank(agentId)
                || StringUtils.isBlank(proId)
                || StringUtils.isBlank(proId)
                || sendNum==null
                || sendNum<=0) {

            return AgentResult.fail("参数错误");
        }

        if(!RegexUtil.checkInt(sendNum+"")){
            return AgentResult.fail("参数错误");
        }

        OReceiptOrder var1 = new OReceiptOrder();
        var1.setOrderId(orderId);
        var1.setAddressId(addressId);
        var1.setAgentId(agentId);
        var1.setuUser(getUserId()+"");
        OReceiptPro var2 = new OReceiptPro();
        var2.setProId(proId);
        var2.setcUser(getUserId()+"");
        var2.setuUser(getUserId()+"");
        int var3 = sendNum;
        try {
            return orderService.subOrderPeiHuo(var1,var2,var3);
        } catch (Exception e) {
            e.printStackTrace();
            if(e instanceof MessageException){
                return AgentResult.fail(((MessageException) e).getMsg());
            }
            return AgentResult.fail(e.getLocalizedMessage());
        }

    }


    /**
     * 更新发货商品
     * /order/updatepeihuoActionItem
     * @param request
     * @param response
     * @param id
     * @param proNum
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "updatepeihuoActionItem")
    public AgentResult updatepeihuoActionItem(HttpServletRequest request,
                                    HttpServletResponse response,
                                    String id,
                                    Integer proNum){
        if(StringUtils.isBlank(id)
                || proNum==null
                || proNum<0) {

            return AgentResult.fail("参数错误");
        }
        if(!RegexUtil.checkInt(proNum+"")){
            return AgentResult.fail("参数错误");
        }
        OReceiptPro var1 = new OReceiptPro();
        var1.setId(id);
        var1.setcUser(getUserId()+"");
        var1.setuUser(getUserId()+"");
        var1.setProNum(new BigDecimal(proNum));
        try {
            return orderService.subOrderPeiHuoUpdate(var1);
        } catch (Exception e) {
            e.printStackTrace();
            if(e instanceof MessageException){
                return AgentResult.fail(((MessageException) e).getMsg());
            }
            return AgentResult.fail(e.getLocalizedMessage());
        }

    }


    @ResponseBody
    @RequestMapping(value = "sureSendAction")
    public AgentResult updatepeihuoActionItem(HttpServletRequest request,
                                              HttpServletResponse response,
                                              String id){
        if(StringUtils.isBlank(id)) {

            return AgentResult.fail("参数错误");
        }

        OReceiptPro var1 = new OReceiptPro();
        var1.setId(id);
        var1.setcUser(getUserId()+"");
        var1.setuUser(getUserId()+"");
        var1.setReceiptProStatus(OReceiptStatus.WAITING_LIST.code);
        try {
            return orderService.subOrderPeiHuoUpdate(var1);
        } catch (Exception e) {
            e.printStackTrace();
            if(e instanceof MessageException){
                return AgentResult.fail(((MessageException) e).getMsg());
            }
            return AgentResult.fail(e.getLocalizedMessage());
        }

    }


    @ResponseBody
    @RequestMapping(value = "sureSendActionAll")
    public AgentResult sureSendActionAll(HttpServletRequest request,
                                              HttpServletResponse response,
                                              String orderId,
                                                     String agentId){
        if(StringUtils.isBlank(orderId)) {
            return AgentResult.fail("参数错误");
        }
        try {
            return orderService.subOrderPeiHuoUpdateStatus(orderId,agentId);
        } catch (Exception e) {
            e.printStackTrace();
            if(e instanceof MessageException){
                return AgentResult.fail(((MessageException) e).getMsg());
            }
            return AgentResult.fail(e.getLocalizedMessage());
        }

    }



}
