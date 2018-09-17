package com.ryx.credit.cms.controller.profit;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.util.AppConfig;
import com.ryx.credit.common.util.ExcelUtil;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.profit.pojo.ProfitDeduction;
import com.ryx.credit.profit.service.ProfitDeductionService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * 退单管理页面逻辑处理
 * @author zhaodw
 * @create 2018/7/24
 * @since 1.0.0
 */
@Controller
@RequestMapping("/profit/deduction/")
public class ProfitDeductionController extends BaseController {

    private static  final  Logger LOGGER = Logger.getLogger(ProfitDeductionController.class);

    public static  final  String OS_WINDOW = "window";

    public static  final  String OS_LIUNX = "liunx";

    private static String TITLE = "月份,上月未扣足,本月新增,总应扣,本月应扣,本月实扣,未扣足,备注";
    private static String COLUME = "deductionDate,upperNotDeductionAmt,addDeductionAmt,sumDeductionAmt,mustDeductionAmt,actualDeductionAmt,notDeductionAmt,remark";
    private static String F_TITLE = "代理商编号,代理商名称,月份,上月未扣足,本月新增,总应扣,本月应扣,本月实扣,未扣足,备注";
    private static String F_COLUME = "agentPid,agentName,deductionDate,upperNotDeductionAmt,addDeductionAmt,sumDeductionAmt,mustDeductionAmt,actualDeductionAmt,notDeductionAmt,remark";

    private static String OS = System.getProperty("os.name").toLowerCase();

    /**
     * 获取操作系统类型
     * @return 操作系统类型
     */
    public static String getOsName() {
        if (OS.contains(OS_WINDOW)){
            return OS_WINDOW;
        }else{
            return OS_LIUNX;
        }
    }

    private static String PATH = AppConfig.getProperty(getOsName()+".deduction.path");


    @Autowired
    private ProfitDeductionService profitDeductionServiceImpl;

    /***
    * @Description: 加载管理页面
    * @Author: zhaodw
    * @Date: 2018/8/3
    */
    @RequestMapping("gotoProfitDeductionList")
    public String gotoProfitDeductionList(Model model) {
        LOGGER.info("加载退单管理页面。");
        // 终审后不能做修改
        String finalStatus = ServiceFactory.redisService.getValue("commitFinal");
        if (StringUtils.isBlank(finalStatus)) {
            model.addAttribute("noEdit","0");
        }else{
            model.addAttribute("noEdit","1");
        }
        return "profit/settleErrls/profitDeductionList";
    }

    /**
     * 获取扣款列表
     * @param request
     * @param profitDeduction 扣款参数
     * @return 扣款数据
     */
    @RequestMapping(value = "getProfitDeductionList", method = RequestMethod.POST)
    @ResponseBody
    public PageInfo getProfitDeductionList(HttpServletRequest request, ProfitDeduction profitDeduction)
    {
        LOGGER.info("加载退单列表数据。");
        String agentPid = ServiceFactory.redisService.hGet("agent",getUserId().toString());
        Page page = pageProcess(request);
        profitDeduction.setDeductionType("01");
        if (StringUtils.isNotBlank(agentPid)) {
            profitDeduction.setAgentPid(agentPid);
        }else{
//            Set<String> roles = getShiroUser().getRoles();
//            if(roles !=null && !roles.contains("财务审批")) {
//                profitDeduction.setAgentId("null");
//            }
        }
        PageInfo resultPageInfo = profitDeductionServiceImpl.getProfitDeductionList(profitDeduction,page);
        return resultPageInfo;
    }

    /**
     * 导出
     * @param request
     * @param response
     */
    @RequestMapping("export")
    public void exportProdeduction(HttpServletRequest request, HttpServletResponse response, ProfitDeduction profitDeduction) {
        String agent = request.getParameter("agent");
        profitDeduction.setDeductionType("01");
        String agentPid = ServiceFactory.redisService.hGet("agent",getUserId().toString());
        if (StringUtils.isNotBlank(agentPid)) {
            profitDeduction.setAgentPid(agentPid);
        }
        PageInfo resultPageInfo = profitDeductionServiceImpl.getProfitDeductionList(profitDeduction,null);
        List<Map<String, Object>> deductions = new ArrayList<>(resultPageInfo.getTotal());
        resultPageInfo.getRows().forEach(profitdeduction -> {deductions.add(ProfitMonthController.convertBeanToMap(profitdeduction));});
        Map<String, Object> param = new HashMap<>(10);
        param.put("path", PATH);
        if ("0".equals(agent)) {
            param.put("title", TITLE);
            param.put("column", COLUME);
        }else{
            param.put("title", F_TITLE);
            param.put("column", F_COLUME);
        }
        param.put("dataList", deductions);
        param.put("response", response);
        ExcelUtil.downLoadExcel(param);
    }

}
