package com.ryx.credit.cms.controller.profit;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.util.AppConfig;
import com.ryx.credit.common.util.ExcelUtil;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.profit.pojo.*;
import com.ryx.credit.profit.service.ProfitMonthService;
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
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.lang.reflect.Field;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * 月度分润
 *
 * @author zhaodw
 * @create 2018/7/24
 * @since 1.0.0
 */
@Controller
@RequestMapping("/monthProfit")
public class ProfitMonthController extends BaseController {
    Logger LOG = LoggerFactory.getLogger(ProfitMonthController.class);
    @Autowired
    private ProfitMonthService profitMonthService;
    @Autowired
    private IUserService userService;
    private static String PROFIT_EXECL_PATH = AppConfig.getProperty("profit.path");
    private static String PROFIT_MONTH_TITLE = AppConfig.getProperty("profitMonth.title");
    private static String PROFIT_MONTH_COLUME = AppConfig.getProperty("profitMonth.column");
    private static String PROFIT_MONTH_DETAIL_TITLE = AppConfig.getProperty("profitMonth.detail.title");
    private static String PROFIT_MONTH_DETAIL_COLUME = AppConfig.getProperty("profitMonth.detail.column");
    private static String TITLE = "商户编号,商户名称,卡号,户名,行号,行名,账户类型,金额,用途,出款账户编号";
    private static String COLUME = "agentId,agentName,accountId,accountName,bankCode,openBankName,payStatus,realProfitAmt,remark,payCompany";
    /**代理商*/
    private static final String AGENT ="agent";

    @RequestMapping("/pageList")
    public String profitPage() {
        return "profit/monthProfit/monthProfitList";
    }

    @RequestMapping("/list")
    @ResponseBody
    public Object getProfitMonthList(HttpServletRequest request, ProfitDetailMonth profitDetailMonth) {
        Page page = pageProcess(request);
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), null, null);
        Long userId = getUserId();
        List<Map<String, Object>>  userlist = userService.orgCode(userId);
        if(userlist == null || userlist.isEmpty()){
            return pageInfo;
        }
        Map<String, Object> map = userlist.get(0);
        LOG.info("部门编号：{}", map.get("ORGANIZATIONCODE"));
        map.get("ORGANIZATIONCODE");
        if(map.get("ORGANIZATIONCODE") == null){
            return pageInfo;
        } else if(Objects.equals(map.get("ORGANIZATIONCODE"),AGENT)){
            String agentId = getAgentId();
            LOG.info("userId编号：{}，代理商编号：{}", userId, agentId);
            profitDetailMonth.setAgentId(agentId);
        }
        List<ProfitDetailMonth> list = profitMonthService.getProfitDetailMonthList(map, page, profitDetailMonth);
        int count = profitMonthService.getProfitDetailMonthCount(map, profitDetailMonth);
        pageInfo.setRows(list);
        pageInfo.setTotal(count);
        return pageInfo;
    }

    @RequestMapping("/detail/page")
    public ModelAndView profitDetailPage(HttpServletRequest request, @RequestParam(value = "agentId") String agentId) {
        if (agentId.contains(",")) {
            HttpSession seeion = request.getSession();
            String[] val = agentId.split(",");
            seeion.setAttribute("profitAgentId", val[0]);
            seeion.setAttribute("profitDate", val[1]);
        }
        ModelAndView view = new ModelAndView();
        view.setViewName("profit/monthProfit/monthProfitDetailList");
        return view;
    }

    @RequestMapping("/detailList")
    @ResponseBody
    public Object getProfitMonthDetailList(HttpServletRequest request) {
        HttpSession seeion = request.getSession();
        String agentId = (String) seeion.getAttribute("profitAgentId");
        String profitDate = (String) seeion.getAttribute("profitDate");
        LOG.info("月分润明细查询获取session值，代理商AG码：{}，月份：{}", agentId, profitDate);
        Page page = pageProcess(request);
        TransProfitDetail transProfitDetail = new TransProfitDetail();
        transProfitDetail.setProfitDate(profitDate);
        transProfitDetail.setAgentId(agentId);
        List<TransProfitDetail> list = profitMonthService.getTransProfitDetail(page, transProfitDetail);
        long count = profitMonthService.getTransProfitDetailCount(transProfitDetail);
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), null, null);
        pageInfo.setRows(list);
        pageInfo.setTotal(new Long(count).intValue());
        return pageInfo;
    }

    @RequestMapping("/export/profit/detail")
    public void exportProfitMonth(HttpServletRequest request, ProfitMonth profitMonth, HttpServletResponse response) {
        HttpSession seeion = request.getSession();
        String agentId = (String) seeion.getAttribute("profitAgentId");
        String profitDate = (String) seeion.getAttribute("profitDate");
        String agentPid = (String) seeion.getAttribute("profitAgentPid");
        LOG.info("月分润明细查询获取session值，agentId：{}，profitId：{}", agentId, profitDate);

        TransProfitDetail transProfitDetail = new TransProfitDetail();
        transProfitDetail.setBusNum(agentId);
        transProfitDetail.setProfitDate(profitDate);
        transProfitDetail.setAgentId(agentPid);
        List<TransProfitDetail> list = profitMonthService.getTransProfitDetail(null, transProfitDetail);
        List<Map<String, Object>> respList = new ArrayList<Map<String, Object>>(list.size());
        list.forEach(profit -> {respList.add(convertBeanToMap(profit));});
        Map<String, Object> param = new HashMap<String, Object>(5);
        param.put("path", PROFIT_EXECL_PATH);
        param.put("title", PROFIT_MONTH_DETAIL_TITLE);
        param.put("column", PROFIT_MONTH_DETAIL_COLUME);
        param.put("dataList", respList);
        param.put("response", response);
        ExcelUtil.downLoadExcel(param);
    }

    @RequestMapping("/export/profit/month")
    public void exportProfitMonthDetail(HttpServletRequest request, HttpServletResponse response, ProfitDetailMonth profitDetailMonth) {
        List<ProfitDetailMonth> list = null;
        List<Map<String, Object>>  userlist = userService.orgCode(getUserId());
        if(userlist != null && !userlist.isEmpty()){
            Map<String, Object> map = userlist.get(0);
            LOG.info("部门编号：{}", map.get("ORGANIZATIONCODE"));
            if(map.get("ORGANIZATIONCODE") == null){
                list = new ArrayList<ProfitDetailMonth>();
            } else if(Objects.equals(map.get("ORGANIZATIONCODE"),AGENT)){
                profitDetailMonth.setAgentId(getAgentId());
                list = profitMonthService.getProfitDetailMonthList(map,null, profitDetailMonth);
            }
        }
        List<Map<String, Object>> finalReqList = new ArrayList<Map<String, Object>>(list.size());
        if (list != null && !list.isEmpty()) {
            list.forEach(profitDetail -> {finalReqList.add(convertBeanToMap(profitDetail));});
        }

        Map<String, Object> param = new HashMap<String, Object>(5);
        param.put("path", PROFIT_EXECL_PATH);
        param.put("title", PROFIT_MONTH_TITLE);
        param.put("column", PROFIT_MONTH_COLUME);
        param.put("dataList", finalReqList);
        param.put("response", response);
        ExcelUtil.downLoadExcel(param);
    }

    public static Map<String, Object> convertBeanToMap(Object bean) {
        HashMap<String, Object> data = new HashMap<String, Object>(55);
        try {
            Field[] fields = bean.getClass().getDeclaredFields();
            for (Field field : fields) {
                field.setAccessible(true);
                data.put(field.getName(), field.get(bean));
            }
            return data;
        } catch (SecurityException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return data;
    }

    /***
     * @Description: 执行终审操作
     * @return:
     * @Author: zhaodw
     * @Date: 2018/8/14
     */
    @RequestMapping("/commitFinal")
    @ResponseBody
    public Object commitFinal(HttpServletRequest request, HttpServletResponse response) {
        String finalStatus = ServiceFactory.redisService.getValue("commitFinal");
        if (StringUtils.isBlank(finalStatus)) {
            ServiceFactory.redisService.setValue("commitFinal", "1", 10000000L);
            new Thread(() -> {
                profitMonthService.computeProfitAmt();
            }).start();
            return renderSuccess("终审成功。");
        }
        return renderSuccess("终审已经执行过。");
    }

    /***
     * @Description: 执行出款操作
     * @return:
     * @Author: zhaodw
     * @Date: 2018/8/14
     */
    @RequestMapping("/payMoney")
    @ResponseBody
    public Object payMoney(HttpServletRequest request, HttpServletResponse response) {
        String finalStatus = ServiceFactory.redisService.getValue("commitFinal");
        if (StringUtils.isNotBlank(finalStatus)) {
            try {
                profitMonthService.payMoney();
                ServiceFactory.redisService.setValue("payStatus", "1", 10000000L);
            }catch (Exception e) {
                e.printStackTrace();
                return renderSuccess("执行失败。");
            }
        }else{
            return renderSuccess("请先执行终审。");
        }
        return renderSuccess("执行成功。");
    }

    /**
     * 导出出款excel
     */
    @RequestMapping("export")
    public void exportProdeduction(HttpServletRequest request, HttpServletResponse response) {
        String finalStatus = ServiceFactory.redisService.getValue("commitFinal");
        if (StringUtils.isNotBlank(finalStatus)) {
            String profitDate = LocalDate.now().plusMonths(-1).format(DateTimeFormatter.BASIC_ISO_DATE).substring(0, 6);
            ProfitDetailMonth detailMonth = new ProfitDetailMonth();
            detailMonth.setStatus("4");
            detailMonth.setProfitDate(profitDate);
            List<ProfitDetailMonth> profitDetailMonthList = profitMonthService.getProfitDetailMonthList(null,null, detailMonth);
            List<Map<String, Object>> dataMaps = new ArrayList<>(profitDetailMonthList.size());
            profitDetailMonthList.forEach(profitDetailMonth -> {
                Map<String, Object> dataMap = ProfitMonthController.convertBeanToMap(profitDetailMonth);
                if ("1".equals(profitDetailMonth.getPayStatus())) {
                    dataMap.put("payStatus", "2");
                } else {
                    dataMap.put("payStatus", "0");
                }
                dataMaps.add(dataMap);
            });

            Map<String, Object> param = new HashMap<>(10);
            param.put("path", PROFIT_EXECL_PATH);
            param.put("title", TITLE);
            param.put("column", COLUME);
            param.put("dataList", dataMaps);
            param.put("response", response);
            ExcelUtil.downLoadExcel(param);
            new Thread(() -> {
                profitMonthService.payMoney();
            }).start();
        }
    }


    @RequestMapping("/freeze/page")
    public ModelAndView freezePage(HttpServletRequest request, @RequestParam(value = "id") String id) {
        ProfitDetailMonth profitDetailMonth = profitMonthService.getProfitDetailMonth(id);
        ModelAndView view = new ModelAndView();
        view.setViewName("profit/monthProfit/profitUnfreeze");
        view.addObject("profitMonth", profitDetailMonth);
        return view;
    }

    @RequestMapping("/unfreeze")
    @ResponseBody
    public Object unfreeze(ProfitUnfreeze profitUnfreeze){
        try {
            if(profitUnfreeze == null){
                return  renderError("系统异常，请联系维护人员！");
            }
            String finalStatus = ServiceFactory.redisService.getValue("commitFinal");
            if(Objects.equals("1", finalStatus)){
                return  renderError("已经终审，暂不能进行解冻！");
            }
            profitUnfreeze = profitMonthService.insertProfitUnfreeze(profitUnfreeze);
            String userId = String.valueOf(getUserId());
            String workId = "thawCity";
            Set<String> roles = getShiroUser().getRoles();
            if(roles !=null && roles.contains("代理商")) {
                workId = "thawAgent";
            }
            profitMonthService.apptlyProfitUnfreeze(profitUnfreeze, userId, workId);
            return  renderSuccess("解冻申请已提交！");
        } catch (Exception e) {
            e.printStackTrace();
            return  renderError("系统异常，请联系维护人员！");
        }
    }

    @RequestMapping("/editUnfreeze")
    @ResponseBody
    public Object editUnfreeze(ProfitUnfreeze profitUnfreeze){
        try {
            if(profitUnfreeze == null){
                return  renderError("系统异常，请联系维护人员！");
            }
            String finalStatus = ServiceFactory.redisService.getValue("commitFinal");
            if(Objects.equals("1", finalStatus)){
                return  renderError("已经终审，暂不能进行修改信息！");
            }
            profitMonthService.editProfitUnfreeze(profitUnfreeze);
            return  renderSuccess("解冻申请编辑成功！");
        } catch (Exception e) {
            e.printStackTrace();
            return  renderError("系统异常，请联系维护人员！");
        }
    }
}