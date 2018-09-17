package com.ryx.credit.cms.controller.order;

import com.alibaba.fastjson.JSONObject;
import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ImportExcelUtil;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.enumc.AdjustType;
import com.ryx.credit.common.enumc.BusActRelBusType;
import com.ryx.credit.common.enumc.DictGroup;
import com.ryx.credit.common.enumc.PamentSrcType;
import com.ryx.credit.common.exception.MessageException;
import com.ryx.credit.common.exception.ProcessException;
import com.ryx.credit.common.result.AgentResult;
import com.ryx.credit.common.util.Constants;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.common.util.ResultVO;
import com.ryx.credit.pojo.admin.agent.Dict;
import com.ryx.credit.pojo.admin.agent.PayComp;
import com.ryx.credit.pojo.admin.agent.PlatForm;
import com.ryx.credit.pojo.admin.order.*;
import com.ryx.credit.pojo.admin.vo.AgentVo;
import com.ryx.credit.pojo.admin.vo.OrderFormVo;
import com.ryx.credit.pojo.admin.vo.OsupplementVo;
import com.ryx.credit.service.agent.BusinessPlatformService;
import com.ryx.credit.service.agent.TaskApprovalService;
import com.ryx.credit.service.order.IAccountAdjustService;
import com.ryx.credit.service.order.IOrderReturnService;
import com.ryx.credit.service.order.OLogisticsService;
import com.ryx.credit.service.order.OrderService;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.FileInputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author: Zhang Lei
 * @Description: 退货
 * @Date: 9:52 2018/7/25
 */
@RequestMapping("order/return")
@Controller
public class OrderReturnController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(OrderReturnController.class);

    @Resource
    private BusinessPlatformService businessPlatformService;
    @Resource
    private IOrderReturnService orderReturnService;
    @Resource
    OLogisticsService oLogisticService;
    @Resource
    IAccountAdjustService accountAdjustService;
    @Autowired
    private TaskApprovalService taskApprovalService;

    /**
     * @Author: Zhang Lei
     * @Description: 申请退货页面
     * @Date: 9:53 2018/7/25
     */
    @RequestMapping("/page/create")
    public String createPage(HttpServletRequest request) {
        return "order/orderReturn";
    }

    /**
     * @Author: Zhang Lei
     * @Description: 退货列表页面
     * @Date: 9:53 2018/7/25
     */
    @RequestMapping("/page/list")
    public String listPage(HttpServletRequest request) {
        return "order/orderReturnList";
    }


    /**
     * @Author: Zhang Lei
     * @Description: 退货工作流审批界面
     * @Date: 9:53 2018/7/25
     */
    @RequestMapping("/page/auditView")
    public String auditView(HttpServletRequest request, Model model, String returnId) {
        Map<String, Object> map = orderReturnService.view(returnId);
        //退货单
        OReturnOrder returnOrder = (OReturnOrder) map.get("returnOrder");
        model.addAttribute("returnOrder", returnOrder);
        //退货单明细
        model.addAttribute("returnDetails", map.get("returnDetails"));
        //扣款明细
        model.addAttribute("deductCapitals", map.get("deductCapitals"));
        //已排单明细
        model.addAttribute("receiptPlans", map.get("receiptPlans"));

        //查询是否有调账记录
        Map<String, Object> oAccountAdjusts = accountAdjustService.getAccountAdjustDetail(returnId, AdjustType.TKTH.adjustType, String.valueOf(getUserId()), returnOrder.getAgentId());
        model.addAttribute("oAccountAdjusts", oAccountAdjusts);

        if (oAccountAdjusts == null || oAccountAdjusts.size() <= 0) {
            model.addAttribute("haveAdjusted", false);
            //没有做过调账时，才进行调账预算
            String sid = request.getParameter("sid");
            if (sid.equals("sid-4528CEA4-998C-4854-827B-1842BBA5DB4B")) {
                Map<String, Object> adjustmap = accountAdjustService.adjust(false, returnOrder.getReturnAmo(), AdjustType.TKTH.adjustType, 1, returnOrder.getAgentId(), String.valueOf(getUserId()), returnId, PamentSrcType.TUIKUAN_DIKOU.code);
                model.addAttribute("planNows_df", adjustmap.get("planNows_df"));
                model.addAttribute("planNows_complate", adjustmap.get("planNows_complate"));
                model.addAttribute("takeoutList", adjustmap.get("takeoutList"));
                model.addAttribute("planNews", adjustmap.get("planNews"));
                model.addAttribute("takeAmt", adjustmap.get("takeAmt"));
                model.addAttribute("refund", adjustmap.get("refund"));
                model.addAttribute("planNows", adjustmap.get("planNows"));
            }
        } else {
            model.addAttribute("haveAdjusted", true);
        }

        optionsData(request);
        return "order/orderReturnAudit";
    }


    /**
     * @Author: Zhang Lei
     * @Description: 退货详情查看带流程图（代理商使用）
     * @Date: 9:53 2018/7/25
     */
    @RequestMapping("/page/viewAgentIndex")
    public String viewAgentIndex(HttpServletRequest request, Model model, String returnId) {
        request.setAttribute("rt", returnId);
        request.setAttribute("busTypeImg", BusActRelBusType.refund.name());
        List<Map<String, Object>> actRecordList = queryApprovalRecord(returnId, BusActRelBusType.refund.name());
        request.setAttribute("actRecordList", actRecordList);
        optionsData(request);
        return "order/orderReturnAuditAgentView";
    }

    /**
     * @Author: Zhang Lei
     * @Description: 退货修改（工作流退回修改订单信息页面）
     * @Date: 9:53 2018/7/25
     */
    @RequestMapping("/page/orderReturnEdit")
    public String orderReturnEdit(HttpServletRequest request, Model model, String returnId) {
        Map<String, Object> map = orderReturnService.view(returnId);
        //退货单
        OReturnOrder returnOrder = (OReturnOrder) map.get("returnOrder");
        model.addAttribute("returnOrder", returnOrder);
        //退货单明细
        model.addAttribute("returnDetails", map.get("returnDetails"));
        optionsData(request);
        return "order/orderReturnEdit";
    }


    /**
     * @Author: Zhang Lei
     * @Description: 退货明细页面-代理商审批
     * @Date: 9:53 2018/7/25
     */
    @RequestMapping("/page/viewAgent")
    public String viewAgent(HttpServletRequest request, Model model, String rt) {
        Map<String, Object> map = orderReturnService.view(rt);
        //退货单
        OReturnOrder returnOrder = (OReturnOrder) map.get("returnOrder");
        model.addAttribute("returnOrder", returnOrder);
        //退货单明细
        model.addAttribute("returnDetails", map.get("returnDetails"));
        //扣款明细
        model.addAttribute("deductCapitals", map.get("deductCapitals"));
        //已排单明细
        model.addAttribute("receiptPlans", map.get("receiptPlans"));

        //查询是否有调账记录
        Map<String, Object> oAccountAdjusts = accountAdjustService.getAccountAdjustDetail(rt, AdjustType.TKTH.adjustType, String.valueOf(getUserId()), returnOrder.getAgentId());
        model.addAttribute("oAccountAdjusts", oAccountAdjusts);

        optionsData(request);
        return "order/orderReturnAuditAgent";
    }


    /**
     * @Author: Zhang Lei
     * @Description: 排单查询页面
     * @Date: 9:53 2018/7/25
     */
    @RequestMapping("/page/planerList")
    public String planerList(HttpServletRequest request) {
        return "order/orderReturnPlannerList";
    }


    /**
     * @Author: Zhang Lei
     * @Description: 退货列表查询
     * @Date: 14:14 2018/7/25
     */
    @RequestMapping(value = "/list")
    @ResponseBody
    public Object list(HttpServletRequest request, OReturnOrder returnOrder) {
        String agentId = getAgentId();
        returnOrder.setAgentId(agentId);
        Page page = pageProcess(request);
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), null, null);
        pageInfo = orderReturnService.orderList(returnOrder, pageInfo);
        return pageInfo;
    }


    /**
     * @Author: Zhang Lei
     * @Description: 解析SN上传文件
     * @Date: 19:39 2018/7/25
     */
    @RequestMapping(value = "/analysisFile")
    @ResponseBody
    public ResultVO analysisFile(@RequestParam(value = "file", required = false) MultipartFile file, HttpServletRequest request) {
        /*if (file == null) {
            return ResultVO.fail("请上传文件");
        }

        String agentId = getAgentId();

        try {
            InputStream in = file.getInputStream();
            List<List<Object>> excelList = ImportExcelUtil.getListByExcel(in, file.getOriginalFilename());
            if (null == excelList || excelList.size() == 0) {
                return ResultVO.fail("文档记录为空");
            }

            //返回对象
            Map<String, Object> retMap = new HashMap<>();
            //根据 "订单编号_商品编号" 作为唯一ID，统计每行退货信息
            List<Map<String, Object>> retList = new ArrayList<>();
            //所有退货商品总价格
            BigDecimal totalAmt = BigDecimal.ZERO;


            try {
                for (List<Object> objects : excelList) {
                    String startSn = (String) objects.get(0);
                    String endSn = (String) objects.get(1);
                    Integer begins = Integer.parseInt((String) objects.get(2));
                    Integer finish = Integer.parseInt((String) objects.get(3));

                    //每行ID
                    String orderId_productId = "";
                    Map<String, Object> newLine_detail = null;

                    //解析此行SN明细列表
                    List<String> snList = oLogisticService.idList(startSn, endSn, begins, finish);

                    for (String sn : snList) {
                        //根据sn查询物流信息
                        Map<String, Object> map = oLogisticService.getLogisticsBySn(sn, agentId);

                        //每个sn的订单物流明细
                        String norderId = (String) map.get("ORDERID");
                        String ordernum = (String) map.get("ORDERNUM");
                        String proId = (String) map.get("PROID");
                        String proName = (String) map.get("PRONAME");
                        String protype = (String) map.get("PROTYPE");
                        BigDecimal proprice = (BigDecimal) map.get("PROPRICE");
                        String proCom = (String) map.get("PROCOM");
                        String proModel = (String) map.get("PROMODEL");
                        String planId = (String) map.get("PLANID");
                        String receiptId = (String) map.get("RECEIPTID");

                        totalAmt = totalAmt.add(proprice);


                        // 新一个 "订单_商品"
                        if (!orderId_productId.equals(norderId + "_" + proId)) {
                            orderId_productId = norderId + "_" + proId;
                            if (newLine_detail != null) {
                                retList.add(newLine_detail);
                            }

                            //生成一个订单中一个商品信息
                            newLine_detail = new HashMap<>();
                            newLine_detail.put("id", orderId_productId);
                            newLine_detail.put("startSn", sn);
                            newLine_detail.put("endSn", sn);
                            newLine_detail.put("orderId", norderId);
                            newLine_detail.put("proName", proName);
                            newLine_detail.put("proPrice", proprice);
                            newLine_detail.put("proType", protype);
                            newLine_detail.put("count", 1);
                            newLine_detail.put("totalPrice", proprice);
                            newLine_detail.put("proCom", proCom);
                            newLine_detail.put("proModel", proModel);
                            newLine_detail.put("planId", planId);
                            newLine_detail.put("receiptId", receiptId);
                            newLine_detail.put("begins", begins);
                            newLine_detail.put("finish", finish);
                            newLine_detail.put("ordernum", ordernum);

                        } else {
                            //还是同一个 "订单_商品",  累加一个订单中一个商品的数量，总价
                            newLine_detail.put("endSn", sn);
                            newLine_detail.put("count", (int) newLine_detail.get("count") + 1);
                            newLine_detail.put("totalPrice", ((BigDecimal) newLine_detail.get("totalPrice")).add(proprice));
                        }
                    }
                    retList.add(newLine_detail);
                }


            } catch (ProcessException e) {
                return ResultVO.fail(e.getMessage());
            } catch (MessageException e) {
                return ResultVO.fail(e.getMessage());
            }

            //返回总金额和每行退货信息
            retMap.put("list", retList);
            retMap.put("totalAmt", totalAmt);
            return ResultVO.success(retMap);

        } catch (Exception e) {
            e.printStackTrace();
        }*/

        return ResultVO.fail("解析excel文件失败");
    }


    /**
     * @Author: Zhang Lei
     * @Description: 退货申请
     * @Date: 19:39 2018/7/25
     */
    @RequestMapping(value = "/apply")
    @ResponseBody
    public Object apply(String productsJson, HttpServletRequest request, OReturnOrder returnOrder) {

        if (StringUtils.isEmpty(productsJson)) {
            return renderError("请先上传SN号");
        }

        try {
            String agentId = getAgentId();
            returnOrder.setAgentId(agentId);
            returnOrder.setReturnAmo(returnOrder.getGoodsReturnAmo());
            orderReturnService.apply(agentId, returnOrder, productsJson, getUserId() + "");
        } catch (ProcessException e) {
            return renderError(e.getMessage());
        } catch (Exception e) {
            return renderError(Constants.FAIL_MSG);
        }

        return renderSuccess("退货申请成功");
    }

    /**
     * @Author: Zhang Lei
     * @Description: 退货订单修改
     * @Date: 19:39 2018/7/25
     */
    @RequestMapping(value = "/applyEdit")
    @ResponseBody
    public Object applyEdit(String productsJson, HttpServletRequest request, OReturnOrder returnOrder) {

        if (StringUtils.isEmpty(productsJson)) {
            return renderError("请先上传SN号");
        }

        try {
            String agentId = getAgentId();
            returnOrder.setAgentId(agentId);
            returnOrder.setReturnAmo(returnOrder.getGoodsReturnAmo());
            orderReturnService.applyEdit(agentId, returnOrder, productsJson, getUserId() + "");
        } catch (ProcessException e) {
            return renderError(e.getMessage());
        } catch (Exception e) {
            return renderError(Constants.FAIL_MSG);
        }

        return renderSuccess("退货信息修改成功，确认无误后，请进行提交操作重新进入审批流程");
    }


    /**
     * @Author: Zhang Lei
     * @Description: 退货详情查询
     * @Date: 19:39 2018/7/25
     */
    @RequestMapping(value = "/view")
    @ResponseBody
    public ResultVO view(String returnId, HttpServletRequest request, String agentId) {

        if (StringUtils.isEmpty(returnId)) {
            return ResultVO.fail("退货标识不能为空");
        }
        Map<String, Object> map = null;

        try {
            map = orderReturnService.view(returnId);
        } catch (ProcessException e) {
            return ResultVO.fail(e.getMessage());
        } catch (Exception e) {
            return ResultVO.fail(Constants.FAIL_MSG);
        }

        return ResultVO.success(map);
    }


    /**
     * @Author: Zhang Lei
     * @Description: 保存扣款款项
     * @Date: 14:14 2018/7/25
     */
    @RequestMapping(value = "/saveCut")
    @ResponseBody
    public ResultVO saveCut(HttpServletRequest request, String returnId, String amt, String ctype) {
        Map<String, Object> map = null;
        try {
            map = orderReturnService.saveCut(returnId, amt, ctype);
        } catch (Exception e) {
            return ResultVO.fail(Constants.FAIL_MSG);
        }
        return ResultVO.success(map);
    }

    /**
     * @Author: Zhang Lei
     * @Description: 删除扣款款项
     * @Date: 14:14 2018/7/25
     */
    @RequestMapping(value = "/delCut")
    @ResponseBody
    public ResultVO delCut(HttpServletRequest request, String returnId, String cutId) {
        Map<String, Object> map = null;
        try {
            map = orderReturnService.delCut(returnId, cutId, getUserId() + "");
        } catch (Exception e) {
            return ResultVO.fail(Constants.FAIL_MSG);
        }
        return ResultVO.success(map);
    }


    /**
     * @Author: Zhang Lei
     * @Description: 执行扣款计划
     * @Date: 19:39 2018/7/25
     */
    @RequestMapping(value = "/doPayPlan")
    @ResponseBody
    public Object doPayPlan(HttpServletRequest request, String returnId) {
        Map<String, Object> map = orderReturnService.view(returnId);
        //退货单
        OReturnOrder returnOrder = (OReturnOrder) map.get("returnOrder");
        try {
            accountAdjustService.adjust(true, returnOrder.getReturnAmo(), AdjustType.TKTH.adjustType, 1, returnOrder.getAgentId(), String.valueOf(getUserId()), returnId, PamentSrcType.TUIKUAN_DIKOU.code);
        } catch (ProcessException e) {
            return renderError(e.getMessage());
        } catch (Exception e) {
            return renderError(Constants.FAIL_MSG);
        }

        return renderSuccess("执行退货方案成功");
    }


    /**
     * @Author: Zhang Lei
     * @Description: 工作流审批查看界面
     * @Date: 19:39 2018/7/25
     */
    @RequestMapping(value = "/approvalView")
    public String approvalView(HttpServletRequest request, String taskId, String proIns, String busType, String busId, String sid) {

        //审批任务需要
        request.setAttribute("taskId", taskId);
        request.setAttribute("proIns", proIns);
        request.setAttribute("busType", busType);
        request.setAttribute("busId", busId);
        request.setAttribute("sid", sid);

        List<Map<String, Object>> actRecordList = queryApprovalRecord(busId, BusActRelBusType.refund.name());
        request.setAttribute("actRecordList", actRecordList);

        //通用参数
        optionsData(request);

        return "activity/OrderReturnApproval";
    }


    /**
     * 处理任务
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("/taskApproval")
    public ResultVO taskApproval(HttpServletRequest request, HttpServletResponse response, @RequestBody AgentVo agentVo) {

        AgentResult result = null;
        String failmsg = "处理失败";
        try {
            result = orderReturnService.approvalTask(agentVo, String.valueOf(getUserId()));
            if (!result.isOK()){
                failmsg =  result.getMsg();
            }
        } catch (ProcessException e) {
            failmsg = e.getMessage();
        } catch (Exception e) {
            logger.info("taskApproval处理任务异常:" + e.getMessage());
            e.printStackTrace();
        } finally {
            if (result == null) {
                return ResultVO.fail(failmsg);
            }
            if (result.isOK()) {
                return ResultVO.success("处理成功");
            } else {
                return ResultVO.fail(failmsg);
            }
        }
    }



}
