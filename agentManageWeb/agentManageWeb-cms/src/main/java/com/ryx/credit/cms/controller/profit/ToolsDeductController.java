package com.ryx.credit.cms.controller.profit;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.commons.shiro.ShiroUser;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.profit.pojo.PosRewardTemplate;
import com.ryx.credit.profit.pojo.ProfitDeduction;
import com.ryx.credit.profit.pojo.ProfitStagingDetail;
import com.ryx.credit.profit.service.ProfitDeductionService;
import com.ryx.credit.profit.service.StagingService;
import com.ryx.credit.profit.service.ToolsDeductService;
import com.ryx.credit.service.IUserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * @author yangmx
 * @desc 机具押金分期扣款调整
 */
@Controller
@RequestMapping("/toolsDeduct")
public class ToolsDeductController extends BaseController {

    private static Logger LOG = LoggerFactory.getLogger(ToolsDeductController.class);
    @Autowired
    private ProfitDeductionService profitDeductionServiceImpl;
    @Autowired
    private ToolsDeductService toolsDeductService;
    @Autowired
    private StagingService stagingServiceImpl;
    @Autowired
    private IUserService userService;
    private static final String FINANCE ="finance";

    @RequestMapping("/pageList")
    public String rewardTempPage() {
        return "profit/toolsDeduct/toolsDeductList";
    }

    @RequestMapping("/list")
    @ResponseBody
    public Object getToolsDeductList(HttpServletRequest request, ProfitDeduction profitDeduction){
        Page page = pageProcess(request);
        if(profitDeduction != null){
            profitDeduction.setDeductionType("02");
        }
        Long userId = getUserId();
        String agentId = getAgentId();
        LOG.info("userId编号：{}，代理商编号：{}", userId, agentId);
        /**
         * 当前用户部门，财务部门不做限制
         */
        List<Map<String, Object>>  list = userService.orgCode(userId);
        if(list == null || list.isEmpty()){
            return new PageInfo();
        }
        Map<String, Object> map = list.get(0);
        LOG.info("部门编号：{}", map.get("ORGANIZATIONCODE"));
        if(Objects.equals(map.get("ORGANIZATIONCODE"),FINANCE)){
            return profitDeductionServiceImpl.getProfitDeductionList(profitDeduction, page);
        }

        if(StringUtils.isBlank(agentId)){
            return new PageInfo();
        } else {
            profitDeduction.setAgentPid(agentId);
            return profitDeductionServiceImpl.getProfitDeductionList(profitDeduction, page);
        }
    }

    @RequestMapping("/editPage")
    public ModelAndView getToolsDeduct(String id){
        if(StringUtils.isNotBlank(id)){
            ProfitDeduction profitDeduction = profitDeductionServiceImpl.getProfitDeductionById(id);
            ModelAndView modelAndView = new ModelAndView();
            modelAndView.setViewName("profit/toolsDeduct/toolsDeductEdit");
            modelAndView.addObject("profitDeduction" ,profitDeduction);
            return modelAndView;
        }
        return null;
    }

    /**
     * 创建审批流
     * @param profitDeduction
     * @return
     */
    @RequestMapping("/edit")
    @ResponseBody
    public Object editToolsDeduct(ProfitDeduction profitDeduction){
        if(profitDeduction == null ){
            return  renderError("系统异常，请联系维护人员！");
        }
        try {
            if(profitDeduction.getMustDeductionAmt().compareTo(profitDeduction.getSumDeductionAmt()) == 1){
                return renderError("申请失败，申请金额大于总扣款金额。");
            }
            if(profitDeduction.getMustDeductionAmt().compareTo(profitDeduction.getSumDeductionAmt()) == 0){
                return renderError("请重新输入调整金额。");
            }
            Set<String> roles = getShiroUser().getRoles();
            String workId = null;
            if(roles !=null && roles.contains("代理商")) {
                workId = "toolsInstallmentAgent";
            }else {
                workId = "toolsInstallmentCity";
            }
            toolsDeductService.applyAdjustment(profitDeduction, String.valueOf(getUserId()), workId);
            return  renderSuccess("调整申请成功！");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return renderError("系统异常，请联系维护人员！");
    }

    /**
     * 审批修改申请信息
     */
    @RequestMapping("/editToolDeduct")
    @ResponseBody
    public Object editToolDeduct(HttpServletRequest request, ProfitDeduction profitDeduction){
        if(profitDeduction == null ){
            return  renderError("系统异常，请联系维护人员！");
        }
        if(profitDeduction.getStagingStatus().equals("5")){
            return  renderError("系统已自动扣款，扣款金额已经不能重新调整");
        }
        try {
            String detailId = request.getParameter("detailId");
            LOG.info("机具扣款审批修改，明细ID：{}", detailId);
            LOG.info("机具扣款审批修改，扣款ID：{}", profitDeduction.getId());

            toolsDeductService.editToolDeduct(profitDeduction, detailId);
            return  renderSuccess("申请信息修改成功！");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return renderError("系统异常，请联系维护人员！");
    }

    @RequestMapping("/detail/page")
    public ModelAndView showDetailPage(HttpServletRequest request, @RequestParam(value = "id") String id){
        if(StringUtils.isNotBlank(id)){
            Page page = pageProcess(request);
            ProfitStagingDetail profitStagingDetail = new ProfitStagingDetail();
            profitStagingDetail.setStagId(id);
            PageInfo pageInfo = stagingServiceImpl.getStagingDetailList(profitStagingDetail, page);
            List<ProfitStagingDetail> list = pageInfo.getRows();
            ModelAndView modelAndView = new ModelAndView();
            modelAndView.setViewName("profit/toolsDeduct/toolsDeductDetailList");
            if(list != null && !list.isEmpty()){
                modelAndView.addObject("profitDeduction", list.get(0));
                return modelAndView;
            }
        }
        return null;
    }
}
