package com.ryx.credit.cms.controller.profit;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ExcelExportSXXSSF;
import com.ryx.credit.cms.util.MyUtil;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.enumc.RewardStatus;
import com.ryx.credit.common.exception.ProcessException;
import com.ryx.credit.common.result.AgentResult;
import com.ryx.credit.common.util.JsonUtil;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.common.util.ResultVO;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.pojo.admin.agent.AgentColinfo;
import com.ryx.credit.profit.pojo.*;
import com.ryx.credit.profit.service.*;
import com.ryx.credit.service.IUserService;
import com.ryx.credit.service.agent.AgentColinfoService;
import com.ryx.credit.service.agent.AgentService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedOutputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.util.*;

import static java.lang.String.valueOf;

/**
 * 优惠政策控制层
 * @version V1.0
 * @Description:
 * @author: WANGY
 * @date: 2018/7/23 15:30
 */
@RequestMapping("discount")
@Controller
public class DiscountController extends BaseController{

    private static Logger LOG = LoggerFactory.getLogger(DiscountController.class);
    @Autowired
    private IPosRewardService rewardService;
    @Autowired
    private IPosCheckService checkService;
    @Autowired
    private IPTaxAdjustService taxAdjustService;
    @Autowired
    private IUserService iUserService;
    @Autowired
    private AgentService agentService;
    @Autowired
    private AgentColinfoService agentColinfoService;

    @ResponseBody
    @RequestMapping(value = "posTaxList")
    public Object posTaxList(HttpServletRequest request, PTaxAdjust pTaxAdjust){
        String agentPid = ServiceFactory.redisService.hGet("agent",getUserId().toString());
        Page page = pageProcess(request);
        if (StringUtils.isNotBlank(agentPid)) {
            pTaxAdjust.setAgentPid(agentPid);
        }else{
//            Set<String> roles = getShiroUser().getRoles();
//            if(roles !=null && !roles.contains("财务审批")) {
//                posCheck.setAgentId("null");
//            }
        }
        PageInfo info = taxAdjustService.PTaxAdjustList(pTaxAdjust,page);
        return info;
    }
    @RequestMapping(value = {"posTax"})
    public String posTax(HttpServletRequest request){
        return "discount/posTax";
    }

    @RequestMapping(value = {"posReward"})
    public String posReward(HttpServletRequest request){
        return "discount/posReward";
    }

    @ResponseBody
    @RequestMapping(value = "posRewardList")
    public Object posRewardList(HttpServletRequest request, PosReward posReward){
        String agentPid = ServiceFactory.redisService.hGet("agent",getUserId().toString());
        Page page = pageProcess(request);
        if (StringUtils.isNotBlank(agentPid)) {
            posReward.setAgentPid(agentPid);
        }
        PageInfo pageInfo = rewardService.posRewardList(posReward,page);
        return pageInfo;
    }

    @RequestMapping(value = {"posCheck"})
    public String posCheck(HttpServletRequest request){
        return "discount/posCheck";
    }

    @ResponseBody
    @RequestMapping(value = "posCheckList")
    public Object posCheckList(HttpServletRequest request, PosCheck posCheck){
        String agentPid = ServiceFactory.redisService.hGet("agent", getUserId().toString());
        Page page = pageProcess(request);
        if (StringUtils.isNotBlank(agentPid)) {
            posCheck.setAgentPid(agentPid);
        }
        PageInfo pageInfo = checkService.PosCheckList(posCheck,page);
        return pageInfo;
    }

    /**
     * 冻结分润
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = {"frozenProfit"})
    public ResultVO frozenProfit(@RequestParam("id")String id){
       /* ProfitMonth profitM = profitMonthService.selectByPrimaryKey(id);
        profitM.setStatus("1");//冻结
        if(1==profitMonthService.updateByPrimaryKeySelective(profitM)){
            return ResultVO.success("冻结成功");
        }*/
        return ResultVO.fail("调整失败请重试");
    }

    /**
     * 校验代理商原税点
     * discount/queryPoint
     * @param agentId
     * @return
     */
    @RequestMapping("queryPoint")
    @ResponseBody
    public Object queryPoint(String agentId) {
        AgentColinfo verAgent = new AgentColinfo();
        verAgent.setAgentId(agentId);
        AgentColinfo colinfo = agentColinfoService.queryPoint(verAgent);    // 检索代理商信息
        if (colinfo != null) {
            return renderSuccess(JsonUtil.objectToJson(colinfo));
        } else {
            return renderError("代理商不存在或未通过审核");
        }
    }

    /**
     * 税点调整申请表单
     * agentEnter/agentForm
     * @param request
     * @param pTaxAdjust
     * @return
     */
    @RequestMapping(value = {"posTaxForm", "form"})
    public String agentNetInFormView(HttpServletRequest request, PTaxAdjust pTaxAdjust) {
        optionsData(request);
        //当前登录用户所属省区
        List<Map<String, Object>> userOrg = iUserService.orgCode(getUserId());
        if (userOrg.size() > 0) {
            request.setAttribute("userOrg", userOrg.get(0));
        }
        return "discount/posTaxInForm";
    }

    /**
     * 税点调整申请
     * agentEnter/agentEnterIn
     * @return
     */
    @ResponseBody
    @RequestMapping(value = {"posTaxEnterIn"}, method = RequestMethod.POST)
    public ResultVO agentEnterIn(HttpServletRequest request, @RequestParam("agNam")String agNam, @RequestParam("agNum")String agNum,
                                 @RequestParam("old")String old, @RequestParam("ing")String ing) {

        TreeMap<String, String> treeMap = getRequestParameter(request);
        PTaxAdjust pTaxAdjust = taxAdjustService.selectByAgentPid(agNum);
        if(null != pTaxAdjust){
            return ResultVO.fail("请勿重复申请!");
        }
        pTaxAdjust = new PTaxAdjust();
        try {
            pTaxAdjust.setUserId(getUserId() + "");
            pTaxAdjust.setTaxStatus(RewardStatus.REVIEWING.getStatus());
            pTaxAdjust.setAgentPid(agNum);
            pTaxAdjust.setAgentName(agNam);
            pTaxAdjust.setTaxOld(new BigDecimal(old));
            pTaxAdjust.setTaxIng(new BigDecimal(ing));
            ResultVO res = taxAdjustService.posTaxEnterIn(pTaxAdjust);
            return res;
        } catch (ProcessException e) {
            return ResultVO.fail(e.getMessage());
        }
    }

    @RequestMapping("/editPosTaxPage")
    public ModelAndView getPosTaxData(String id){
        if(StringUtils.isNotBlank(id)){
            PTaxAdjust pTaxAdjust = taxAdjustService.getPosTaxById(id);
            ModelAndView modelAndView = new ModelAndView();
            modelAndView.setViewName("discount/posTaxInfo");
            modelAndView.addObject("taxAdjust" ,pTaxAdjust);
            return modelAndView;
        }
        return null;
    }

    /**
     * 驳回修改--税点调整
     * 审批修改申请信息
     */
    @RequestMapping("/editPosTaxRegect")
    @ResponseBody
    public Object editPosTaxRegect(PTaxAdjust pTaxAdjust){
        if(pTaxAdjust == null ){
            return renderError("系统异常，请联系维护人员！");
        }
        try {
            taxAdjustService.editPosTaxRegect(pTaxAdjust);
            return renderSuccess("税点调整申请信息修改成功！");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return renderError("系统异常，请联系维护人员！");
    }


    /**
     * 代理商日分润的导出
     */
    @RequestMapping("exportProfitD")
    public void exportProfitD(ProfitDay day, HttpServletResponse response, HttpServletRequest request) throws Exception {
        List<ProfitDay> list = null;//profitDService.exportProfitD(day);

        String filePath = "C:/upload/";
        String filePrefix = "PD";
        int flushRows = 100;
        List<String> fieldNames = null;
        List<String> fieldCodes = null;
        //指导导出数据的title
        fieldNames = new ArrayList<String>();
        fieldCodes = new ArrayList<String>();
        fieldNames.add("编号");
        fieldCodes.add("agentId");
        fieldNames.add("代理商");
        fieldCodes.add("agentName");
        fieldNames.add("代理商唯一编号");
        fieldCodes.add("agentPid");
        fieldNames.add("交易时间");
        fieldCodes.add("transDate");
        fieldNames.add("出款时间");
        fieldCodes.add("remitDate");
        fieldNames.add("瑞和宝MPOS分润");
        fieldCodes.add("rhbProfit");
        fieldNames.add("直发平台MPOS分润");
        fieldCodes.add("zfProfit");
        fieldNames.add("分润总和");
        fieldCodes.add("totalProfit");


        ExcelExportSXXSSF excelExportSXXSSF;
        excelExportSXXSSF = ExcelExportSXXSSF.start(filePath, "/upload/", filePrefix, fieldNames, fieldCodes, flushRows);
        //执行导出
        excelExportSXXSSF.writeDatasByObject(list);
        String filename = filePrefix + "_" + MyUtil.getCurrentTimeStr() + ".xls";
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-disposition", "attachment;filename=" + filename);
        OutputStream outputStream = new BufferedOutputStream(response.getOutputStream());
        excelExportSXXSSF.getWb().write(outputStream);
        outputStream.flush();
        outputStream.close();
    }



    /**
     * 优惠政策申请：
     * 1、POS奖励考核申请----------------------------------申请审批
     * @return
     */
    @RequestMapping("/addPage")
    public ModelAndView getPosReward(HttpServletRequest request){
        ModelAndView modelAndView = new ModelAndView();
        AgentResult result = agentService.isAgent(getUserId()+"");
        request.setAttribute("isagent", result);
        modelAndView.setViewName("discount/posRewardAdd");
        return modelAndView;
    }

    /**
     * 创建审批流--POS奖励考核
     * @param posReward
     * @param totalConsMonth
     * @param totalEndMonth
     * @return
     */
    @RequestMapping("/addReward")
    @ResponseBody
    public Object addPosReward(PosReward posReward, String totalConsMonth, String totalEndMonth){
        if(posReward == null ){
            return renderError("系统异常，请联系维护人员！");
        }
        List<PosReward> rewardExample = null;
        if(totalConsMonth.contains("~")){
            String[] str = totalConsMonth.split("~");
            for (int i = 0; i < str.length; i++) {
                posReward.setTotalConsMonth(str[i]);
                rewardExample = rewardService.selectByMonth(posReward);
                if(null != rewardExample && !rewardExample.isEmpty()){
                    return renderError("此交易月已申请，不能重复申请!");
                }
            }
        } else {
            posReward.setTotalConsMonth(totalConsMonth);
            rewardExample = rewardService.selectByMonth(posReward);
            if(null != rewardExample && !rewardExample.isEmpty()){
                return renderError("此交易月已申请，不能重复申请!");
            }
        }
        if(StringUtils.isBlank(posReward.getTotalConsMonth())
                || StringUtils.isBlank(posReward.getTotalEndMonth())
                || StringUtils.isBlank(posReward.getAgentPid().toString())
                || StringUtils.isBlank(posReward.getAgentName().toString())
                || StringUtils.isBlank(posReward.getRewardScale().toString())){
            return renderError("请填写完毕！");
        }
        try {
            Set<String> roles = getShiroUser().getRoles();
            String workId = null;
            if(roles !=null && roles.contains("代理商")) {
                workId = "posRewardAgent";
            }else {
                workId = "posRewardCity";
            }
            posReward.setTotalConsMonth(totalConsMonth); //交易总额对比月
            posReward.setTotalEndMonth(totalEndMonth);  //奖励考核日期
            rewardService.applyPosReward(posReward, valueOf(getUserId()), workId);
            return renderSuccess("奖励考核申请成功！");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return renderError("系统异常，请联系维护人员！");
    }

    @RequestMapping("/editPage")
    public ModelAndView getData(String id){
        if(StringUtils.isNotBlank(id)){
            PosReward posReward = rewardService.getPosRewardById(id);
            ModelAndView modelAndView = new ModelAndView();
            modelAndView.setViewName("discount/posRewardInfo");
            modelAndView.addObject("posReward" ,posReward);
            return modelAndView;
        }
        return null;
    }

    /**
     * 驳回修改--POS奖励考核
     * 审批修改申请信息
     */
    @RequestMapping("/editRewardRegect")
    @ResponseBody
    public Object editRewardRegect(PosReward posReward, String totalConsMonth){
        if(posReward == null ){
            return renderError("系统异常，请联系维护人员！");
        }
        try {
            rewardService.editRewardRegect(posReward);
            return renderSuccess("奖励考核申请信息修改成功！");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return renderError("系统异常，请联系维护人员！");
    }



    /**
     * 优惠政策申请：
     * 1、分润比例考核申请----------------------------------申请审批
     * @return
     */
    @RequestMapping("/addCheckPage")
    public ModelAndView getPosCheck(HttpServletRequest request){
        ModelAndView modelAndView = new ModelAndView();
        AgentResult result = agentService.isAgent(getUserId()+"");
        request.setAttribute("isagent", result);
        modelAndView.setViewName("discount/posCheck/posCheckAdd");
        return modelAndView;
    }

    /**
     * 创建审批流--分润比例考核
     * @param posCheck
     * @param checkDateS
     * @param checkDateE
     * @return
     */
    @RequestMapping("/addCheck")
    @ResponseBody
    public Object addPosCheck(PosCheck posCheck, String checkDateS, String checkDateE, BigDecimal profitScale){
        if(posCheck == null ){
            return renderError("系统异常，请联系维护人员！");
        }
        try {
            Set<String> roles = getShiroUser().getRoles();
            String workId = null;
            if(roles !=null && roles.contains("代理商")) {
                workId = "posCheckAgent";
            }else {
                workId = "posCheckCity";
            }
            posCheck.setCheckDateS(checkDateS); //考核起始日期
            posCheck.setCheckDateE(checkDateE);  //考核截止日期
            BigDecimal scale = new BigDecimal(String.valueOf(profitScale));
            posCheck.setProfitScale(scale);
            checkService.applyPosCheck(posCheck, valueOf(getUserId()), workId);
            return renderSuccess("分润比例考核申请成功！");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return renderError("系统异常，请联系维护人员！");
    }

    @RequestMapping("/editCheckPage")
    public ModelAndView getCheckData(String id){
        if(StringUtils.isNotBlank(id)){
            PosCheck posCheck = checkService.getPosCheckById(id);
            ModelAndView modelAndView = new ModelAndView();
            modelAndView.setViewName("discount/posCheck/posCheckInfo");
            modelAndView.addObject("posCheck" ,posCheck);
            return modelAndView;
        }
        return null;
    }

    /**
     * 驳回修改--分润比例考核
     * 审批修改申请信息
     */
    @RequestMapping("/editCheckRegect")
    @ResponseBody
    public Object editCheckRegect(PosCheck posCheck){
        if(posCheck == null ){
            return renderError("系统异常，请联系维护人员！");
        }
        try {
            checkService.editCheckRegect(posCheck);
            return renderSuccess("分润比例考核申请信息修改成功！");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return renderError("系统异常，请联系维护人员！");
    }


}
