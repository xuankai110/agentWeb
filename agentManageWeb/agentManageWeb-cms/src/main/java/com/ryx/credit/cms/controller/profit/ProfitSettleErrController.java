package com.ryx.credit.cms.controller.profit;

import com.fasterxml.jackson.databind.util.BeanUtil;
import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.profit.pojo.ProfitDeduction;
import com.ryx.credit.profit.pojo.ProfitSettleErrLs;
import com.ryx.credit.profit.service.ProfitDeductionService;
import com.ryx.credit.profit.service.ProfitSettleErrLsService;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 退单管理页面逻辑处理
 * @author zhaodw
 * @create 2018/7/24
 * @since 1.0.0
 */
@Controller
@RequestMapping("/profit/settleErr/")
public class ProfitSettleErrController extends BaseController {

    private static  final  Logger LOGGER = Logger.getLogger(ProfitSettleErrController.class);

    @Autowired
    private ProfitSettleErrLsService profitSettleErrLsServiceImpl;

    @Autowired
    private ProfitDeductionService profitDeductionServiceImpl;

    /***
    * @Description:  加载列表页面
    * @Author: zhaodw
    * @Date: 2018/8/3
    */
    @RequestMapping("gotoProfitSettleErrList")
    public String gotoProfitSettleErrList(Model model, String sourceId) {
        LOGGER.info("加载退单管理页面。");
        model.addAttribute("sourceId",sourceId);
        ProfitDeduction profitDeduction =profitDeductionServiceImpl.getProfitDeductionById(sourceId);
        model.addAttribute("agentPid",profitDeduction.getAgentPid());
        model.addAttribute("parentAgentPid",profitDeduction.getParentAgentPid());
        return "profit/settleErrls/profitSettleErrList";
    }

    /***
    * @Description:  加载数据列表
    * @Author: zhaodw
    * @Date: 2018/8/3
    */
    @RequestMapping(value = "getProfitSettleErrList", method = RequestMethod.POST)
    @ResponseBody
    public PageInfo getProfitSettleErrList(HttpServletRequest request, ProfitSettleErrLs profitSettleErrLs)
    {
        LOGGER.info("加载退单列表数据。");
        Page page = pageProcess(request);
        PageInfo resultPageInfo = profitSettleErrLsServiceImpl.getProfitSettleErrList(profitSettleErrLs, page);
        if (resultPageInfo.getTotal() > 0) {
            final String agentPid = request.getParameter("agentPid");
            final String parentAgentPid = request.getParameter("parentAgentPid");
            List<ProfitSettleErrLs> profitSettleErrLsList = resultPageInfo.getRows();
            resultPageInfo.setRows(profitSettleErrLsList.stream().map(profitSettleErrLs1 -> {
                Map<String, String> settleErrMap = null;
                try {
                    settleErrMap = BeanUtils.describe(profitSettleErrLs1);
                    settleErrMap.put("agentPid", agentPid);
                    settleErrMap.put("parentAgentPid", parentAgentPid);

                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                } catch (InvocationTargetException e) {
                    e.printStackTrace();
                } catch (NoSuchMethodException e) {
                    e.printStackTrace();
                }
                return settleErrMap;

            }).collect(Collectors.toList()));
        }
        return resultPageInfo;
    }

}
