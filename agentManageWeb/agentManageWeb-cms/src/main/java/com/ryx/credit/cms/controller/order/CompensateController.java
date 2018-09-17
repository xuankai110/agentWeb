package com.ryx.credit.cms.controller.order;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ImportExcelUtil;
import com.ryx.credit.common.enumc.*;
import com.ryx.credit.common.exception.MessageException;
import com.ryx.credit.common.exception.ProcessException;
import com.ryx.credit.common.result.AgentResult;
import com.ryx.credit.common.util.*;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.pojo.admin.order.*;
import com.ryx.credit.pojo.admin.vo.AgentVo;
import com.ryx.credit.pojo.admin.vo.ORefundPriceDiffVo;
import com.ryx.credit.service.dict.DictOptionsService;
import com.ryx.credit.service.order.CompensateService;
import com.ryx.credit.service.order.IAccountAdjustService;
import com.ryx.credit.service.order.OrderActivityService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 补差价控制层
 * @version V1.0
 * @Description:
 * @author: Liudh
 * @date: 2018/7/24 15:30
 */
@RequestMapping("compensate")
@Controller
public class CompensateController extends BaseController{

    private static Logger log = LoggerFactory.getLogger(CompensateController.class);
    @Autowired
    private CompensateService compensateService;
    @Autowired
    private IAccountAdjustService accountAdjustService;

    @RequestMapping(value = "toRefundPriceDiffList")
    public String toRefundPriceDiffList(HttpServletRequest request,ORefundPriceDiff refundPriceDiff){
        optionsData(request);
        return "order/refundPriceDiffList";
    }

    @RequestMapping(value = "refundPriceDiffList")
    @ResponseBody
    public Object refundPriceDiffList(HttpServletRequest request,ORefundPriceDiffVo refundPriceDiff){
        Page pageInfo = pageProcess(request);
        refundPriceDiff.setcUser(String.valueOf(getUserId()));
        PageInfo resultPageInfo = compensateService.compensateList(refundPriceDiff,pageInfo);
        List<ORefundPriceDiff> rows = resultPageInfo.getRows();
        rows.forEach(row->{
            row.setApplyCompName(PriceDiffType.getContentByValue(row.getApplyCompType()));
            row.setRelCompName(PriceDiffType.getContentByValue(row.getRelCompType()));
        });
        return resultPageInfo;
    }

    @RequestMapping(value = "toCompensateAmtAddPage")
    public String toCompensateAmtAddPage(HttpServletRequest request){
        return "order/compensateAmtAdd";
    }

    @RequestMapping(value ="analysisFile")
    @ResponseBody
    public Object analysisFile(@RequestParam(value = "file", required = false) MultipartFile file, HttpServletRequest request) {
        if(file.getSize()==0){
            return renderError("请上传文件");
        }
        List<Map<String, Object>> resultList = new ArrayList<>();
        try {
            InputStream in = file.getInputStream();
            List<List<Object>> excelList = ImportExcelUtil.getListByExcel(in, file.getOriginalFilename());
            if(null==excelList || excelList.size()==0){
                return renderError("文档记录为空");
            }
            for (List<Object> objects : excelList) {
                try {
                    List<Map<String, Object>> compensateList = compensateService.getOrderMsgByExcel(objects,getUserId());
                    for (Map<String, Object> stringObjectMap : compensateList) {
                        stringObjectMap.put("SUM_PROPRICE",new BigDecimal(stringObjectMap.get("SETTLEMENT_PRICE").toString()).multiply(new BigDecimal(stringObjectMap.get("PRO_NUM").toString())));
                        resultList.add(stringObjectMap);
                    }
                } catch (ProcessException e) {
                    return JsonUtil.objectToJson(renderError(e.getMessage()));
                }
            }
            String toJson = JsonUtil.objectToJson(resultList);
            return toJson;
        } catch (Exception e) {
            return JsonUtil.objectToJson(renderError("excel解析异常"));
        }
    }

    private Object priceDiff(AgentVo agentVo){
        List<ORefundPriceDiffDetail> refundPriceDiffDetailList = agentVo.getRefundPriceDiffDetailList();
        BigDecimal sumCalPrice = new BigDecimal(0);
        for (ORefundPriceDiffDetail row : refundPriceDiffDetailList) {
            if(StringUtils.isNotBlank(row.getActivityRealId())) {
                BigDecimal calPrice = compensateService.calculatePriceDiff(row.getBeginSn(),row.getEndSn(),row.getActivityFrontId(), row.getActivityRealId(), row.getChangeCount());
                sumCalPrice = sumCalPrice.add(calPrice);
            }
        }
        return sumCalPrice;
    }

    /**
     * 计算差价
     * @param agentVo
     * @return
     */
    @ResponseBody
    @RequestMapping(value = {"calculatePriceDiff"}, method = RequestMethod.POST)
    public Object calculatePriceDiff(@RequestBody AgentVo agentVo) {
        Object obj = priceDiff(agentVo);
        return obj;
    }

    @ResponseBody
    @RequestMapping(value = {"compensateAmtSave"}, method = RequestMethod.POST)
    public Object compensateAmtSave(@RequestBody AgentVo agentVo,HttpServletRequest request, HttpServletResponse response) {

        String sumCalPrice = String.valueOf(priceDiff(agentVo));
        ORefundPriceDiff oRefundPriceDiff = agentVo.getoRefundPriceDiff();
        oRefundPriceDiff.setApplyCompType(sumCalPrice.contains("-")?PriceDiffType.DETAIN_AMT.getValue():PriceDiffType.REPAIR_AMT.getValue());
        oRefundPriceDiff.setApplyCompAmt(sumCalPrice.contains("-")?new BigDecimal(sumCalPrice.substring(1)):new BigDecimal(sumCalPrice));
        AgentResult agentResult = compensateService.compensateAmtSave(oRefundPriceDiff, agentVo.getRefundPriceDiffDetailList(),agentVo.getRefundPriceDiffFile(), String.valueOf(getUserId()));
        if(agentVo.getFlag().equals("2")){
            return startCompensate(String.valueOf(agentResult.getData()));
        }
        if(agentResult.isOK()){
            return AgentResult.ok("处理成功！");
        }
        return AgentResult.fail("处理失败！");
    }


    /**
     * 启动审批
     * @param compId
     * @return
     */
    @ResponseBody
    @RequestMapping("startCompensate")
    public AgentResult startCompensate(String compId){
        AgentResult result = new AgentResult(500, "参数错误", "");
        try {
            result = compensateService.startCompensateActiviy(compId,String.valueOf(getUserId()));
        }catch (MessageException e) {
            return AgentResult.fail(e.getMsg());
        }catch (Exception e) {
            return AgentResult.fail(e.getMessage());
        }
        return result;
    }

    /**
     * 跳转审核页面
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RequestMapping("approvalCompensateView")
    public String approvalCompensateView(HttpServletRequest request, HttpServletResponse response,Model model) {
        try {
            optionsData(request);
            String taskId = request.getParameter("taskId");
            String proIns = request.getParameter("proIns");
            String busType = request.getParameter("busType");
            String agentBusId = request.getParameter("busId");
            ORefundPriceDiff oRefundPriceDiff = compensateService.queryRefDiffDetail(agentBusId);
            request.setAttribute("oRefundPriceDiff",oRefundPriceDiff);
            request.setAttribute("taskId", taskId);
            request.setAttribute("proIns", proIns);
            List<Map<String, Object>> actRecordList = queryApprovalRecord(agentBusId, BusActRelBusType.COMPENSATE.name());
            request.setAttribute("actRecordList", actRecordList);
            request.setAttribute("agentBusId", agentBusId);
            Map<String, Object> adjust = accountAdjustService.adjust(false,oRefundPriceDiff.getRelCompAmt(), AdjustType.TCJ.name(),
                    1, oRefundPriceDiff.getRefundPriceDiffDetailList().get(0).getAgentId(), String.valueOf(getUserId()),
                    oRefundPriceDiff.getId(), PamentSrcType.TUICHAJIA_DIKOU.code);
            request.setAttribute("machineDebtAmt",adjust.get("takeAmt"));
        } catch (ProcessException e) {
            e.printStackTrace();
            log.info("查看审批任务异常",e.getMessage());
        }  catch (Exception e) {
            e.printStackTrace();
        }
        return "activity/compensateApproval";
    }

    /**
     * 处理任务
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("taskApproval")
    public ResultVO taskApproval(@RequestBody AgentVo agentVo,HttpServletRequest request, HttpServletResponse response){

        AgentResult result = null;
        try {
            result = compensateService.approvalTask(agentVo, String.valueOf(getUserId()));
        } catch (Exception e) {
            log.info("compensate.taskApproval处理任务异常:"+e.getMessage());
            e.printStackTrace();
        } finally {
            if(result==null){
                return ResultVO.fail("处理失败");
            }
            if(result.isOK()){
                return ResultVO.success("处理成功");
            }else{
                return ResultVO.fail("处理失败");
            }
        }
    }

    /**
     * 退补差价查看
     * @param id
     * @param reviewStatus
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = {"refundPriceDiffQuery"})
    public String compensateQuery(String id, String reviewStatus, Model model, HttpServletRequest request) {
        optionsData(request);
        ORefundPriceDiff oRefundPriceDiff = compensateService.queryRefDiffDetail(id);
        request.setAttribute("reviewStatus", reviewStatus);
        request.setAttribute("busIdImg", id);
        request.setAttribute("busTypeImg", BusActRelBusType.COMPENSATE.name());
        request.setAttribute("oRefundPriceDiff",oRefundPriceDiff);
        List<Map<String, Object>> actRecordList = queryApprovalRecord(id, BusActRelBusType.COMPENSATE.name());
        request.setAttribute("actRecordList", actRecordList);
        return "order/refundPriceDiffQuery";
    }

    /**
     * 抵扣
     * @param request
     * @param oRefundPriceDiff
     * @param isRealAdjust
     * @param adjustAmt
     * @return
     */
    @RequestMapping(value = {"adjust"})
    @ResponseBody
    public Object adjust(HttpServletRequest request,ORefundPriceDiff oRefundPriceDiff,Boolean isRealAdjust,BigDecimal adjustAmt){
        try {
            if(StringUtils.isBlank(oRefundPriceDiff.getId())){
                String agentBusId = request.getParameter("busId");
                if(StringUtils.isBlank(agentBusId)){
                    return renderError("业务id为空");
                }
                oRefundPriceDiff = compensateService.queryRefDiffDetail(agentBusId);
            }
            if(null==adjustAmt){
                return renderError("金额有误");
            }
            if(null==isRealAdjust){
                return renderError("参数有误");
            }
            log.info("扣除机具欠款请求参数：isRealAdjust：{},adjustAmt:{},agentId:{},UserId:{},priceDiffId:{}",isRealAdjust,adjustAmt,oRefundPriceDiff.getRefundPriceDiffDetailList().get(0).getAgentId(),String.valueOf(getUserId()),oRefundPriceDiff.getId());
            Map<String, Object> adjust = accountAdjustService.adjust(isRealAdjust,adjustAmt, AdjustType.TCJ.name(), 1,
                    oRefundPriceDiff.getRefundPriceDiffDetailList().get(0).getAgentId(),
                    String.valueOf(getUserId()), oRefundPriceDiff.getId(), PamentSrcType.TUICHAJIA_DIKOU.code);
            log.info("扣除机具欠款返回：{}",adjust);
        } catch (ProcessException e) {
            return renderError(e.getMessage());
        } catch (Exception e) {
            return renderError(Constants.FAIL_MSG);
        }
        return renderSuccess("执行扣款计划成功");
    }

    @RequestMapping(value = "toCompensateAmtEditPage")
    public String toCompensateAmtEditPage(HttpServletRequest request,String id){
        optionsData(request);
        ORefundPriceDiff oRefundPriceDiff = compensateService.queryRefDiffDetail(id);
        request.setAttribute("oRefundPriceDiff",oRefundPriceDiff);
        return "order/compensateAmtEdit";
    }


    @ResponseBody
    @RequestMapping(value = {"compensateAmtEdit"}, method = RequestMethod.POST)
    public AgentResult compensateAmtEdit(@RequestBody AgentVo agentVo,HttpServletRequest request, HttpServletResponse response) {

        List<ORefundPriceDiffDetail> refundPriceDiffDetailList = agentVo.getRefundPriceDiffDetailList();
        ORefundPriceDiff oRefundPriceDiff = agentVo.getoRefundPriceDiff();
        String sumCalPrice = String.valueOf(priceDiff(agentVo));
        oRefundPriceDiff.setApplyCompType(sumCalPrice.contains("-")?PriceDiffType.DETAIN_AMT.getValue():PriceDiffType.REPAIR_AMT.getValue());
        oRefundPriceDiff.setApplyCompAmt(sumCalPrice.contains("-")?new BigDecimal(sumCalPrice.substring(1)):new BigDecimal(sumCalPrice));
        oRefundPriceDiff.setRelCompType(oRefundPriceDiff.getApplyCompType());
        oRefundPriceDiff.setRelCompAmt(oRefundPriceDiff.getApplyCompAmt());
        AgentResult agentResult = compensateService.compensateAmtEdit(agentVo.getoRefundPriceDiff(), refundPriceDiffDetailList, agentVo.getRefundPriceDiffFile(), String.valueOf(getUserId()));
        return agentResult;
    }
}
