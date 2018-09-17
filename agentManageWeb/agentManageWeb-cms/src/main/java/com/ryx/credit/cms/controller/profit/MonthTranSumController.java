package com.ryx.credit.cms.controller.profit;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.profit.exceptions.StagingException;
import com.ryx.credit.profit.pojo.ProfitDeduction;
import com.ryx.credit.profit.pojo.ProfitOrganTranMonth;
import com.ryx.credit.profit.pojo.ProfitStaging;
import com.ryx.credit.profit.pojo.ProfitStagingDetail;
import com.ryx.credit.profit.service.ProfitOrganTranMonthService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Set;

/**
 * 余额交易汇总核对
 * @author zhaodw
 * @create 2018/7/24
 * @since 1.0.0
 */
@Controller
@RequestMapping("/profit/tran/check/")
public class MonthTranSumController extends BaseController {

    private static  final  Logger LOGGER = Logger.getLogger(MonthTranSumController.class);

    @Autowired
    private ProfitOrganTranMonthService profitOrganTranMonthServiceImpl;

    /**
     * 加载列表
     * @return 页面url
     */
    @RequestMapping("gotoMonthTranSumList")
    public String gotoMonthTranSumList(Model model) {
        LOGGER.info("加载分期列表页面。");
        // 终审后不能做修改
        String finalStatus = ServiceFactory.redisService.getValue("commitFinal");
        if (StringUtils.isBlank(finalStatus)) {
            model.addAttribute("noEdit","0");
        }else{
            model.addAttribute("noEdit","1");
        }
        return "profit/tran/monthTranSumList";
    }

    /***
     * 加载列表数据
    * @Author: zhaodw
    * @Date: 2018/8/3
    */
    @RequestMapping(value = "getMonthTranSumList", method = RequestMethod.POST)
    @ResponseBody
    public PageInfo getMonthTranSumList(HttpServletRequest request, ProfitOrganTranMonth profitOrganTranMonth)
    {
        LOGGER.info("加载交易列表数据。");
        Page page = pageProcess(request);
        PageInfo resultPageInfo = profitOrganTranMonthServiceImpl.getProfitOrganTranMonthList(profitOrganTranMonth, page);
        return resultPageInfo;
    }


    /***
    * @Description: 导入
    * @Author: zhaodw
    * @Date: 2018/8/3
    */
    @RequestMapping(value = "importData", method = RequestMethod.POST)
    @ResponseBody
    public Object edit(HttpServletRequest request, ProfitStaging profitStaging)
    {
        try {
            profitOrganTranMonthServiceImpl.importData();
             return renderSuccess("操作成功！");
        }catch (Exception e) {
            LOGGER.error(e.getMessage());
            e.printStackTrace();
        }
        return renderError("操作失败！");
    }

}
