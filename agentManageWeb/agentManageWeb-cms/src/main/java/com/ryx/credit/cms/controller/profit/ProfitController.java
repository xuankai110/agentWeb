package com.ryx.credit.cms.controller.profit;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ExcelExportSXXSSF;
import com.ryx.credit.cms.util.MyUtil;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.common.util.ResultVO;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.profit.pojo.ProfitDay;
import com.ryx.credit.profit.pojo.ProfitDetailMonth;
import com.ryx.credit.profit.pojo.ProfitDirect;
import com.ryx.credit.profit.pojo.ProfitMonth;
import com.ryx.credit.profit.service.IProfitDService;
import com.ryx.credit.profit.service.IProfitDirectService;
import com.ryx.credit.profit.service.ProfitMonthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedOutputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;


/**
 * 分潤控制层
 * @version V1.0
 * @Description:
 * @author: WANGY
 * @date: 2018/7/23 15:30
 */
@RequestMapping("profit")
@Controller
public class ProfitController extends BaseController{

    @Autowired
    private IProfitDService profitDService;
    @Autowired
    private ProfitMonthService profitMonthService;
    @Autowired
    private IProfitDirectService profitDirectService;
    @RequestMapping(value = "toProfitDList")
    public String toProfitDList(HttpServletRequest request,ProfitDay day){
        return "profit/profitDList";
    }
    /**
     * 日分润管理-代理商
     * @LiuQY
     * */
    @RequestMapping(value = "toProfitDListAgent")
    public String toProfitDListAgent(HttpServletRequest request,ProfitDay day){
        return "profit/profitDListAgent";
    }

    @RequestMapping(value = "profitDList")
    @ResponseBody
    public Object profitDList(HttpServletRequest request,ProfitDay day,ProfitDay profitDay){
        String agentPid = ServiceFactory.redisService.hGet("agent",getUserId().toString());
        Page pageInfo = pageProcess(request);
        if (StringUtils.isNotBlank(agentPid)) {
            profitDay.setAgentPid(agentPid);
        }
        PageInfo resultPageInfo = profitDService.profitDList(day,pageInfo);
        return resultPageInfo;
    }
    /**
     * 日分润管理-代理商
     * @LiuQY
     * */
    @RequestMapping(value = "profitDListAgent")
    @ResponseBody
    public Object profitDListAgent(HttpServletRequest request,ProfitDay day){
        Page pageInfo = pageProcess(request);
        PageInfo resultPageInfo = profitDService.profitDList(day,pageInfo);
        return resultPageInfo;
    }

    /*@ResponseBody
    @RequestMapping(value = "profitLList")
    public Object profitLList(HttpServletRequest request, ProfitMonth profitMonth){
        Page page = pageProcess(request);
        List<ProfitMonth> list = profitMonthService.getProfitMonthList(page, profitMonth);
        int count = profitMonthService.getProfitMonthCount(profitMonth);
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), null, null);
        pageInfo.setRows(list);
        pageInfo.setTotal(count);
        return pageInfo;
    }*/

    @RequestMapping(value = {"profitByLeader"})
    public String profitByLeader(HttpServletRequest request){

        return "profit/profitByLeader";
    }

    @ResponseBody
    @RequestMapping(value = "profitFList")
    public Object profitFList(HttpServletRequest request, ProfitDetailMonth profitDetailMonth){
        String agentPid = ServiceFactory.redisService.hGet("agent",getUserId().toString());
        Page page = pageProcess(request);
        if (StringUtils.isNotBlank(agentPid)) {
            profitDetailMonth.setAgentPid(agentPid);
        }
        List<ProfitDetailMonth> list = profitMonthService.getProfitMonthList(page, profitDetailMonth);
        int count = profitMonthService.getProfitMonthCount(profitDetailMonth);
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), null, null);
        pageInfo.setRows(list);
        pageInfo.setTotal(count);
        return pageInfo;
    }

    @RequestMapping(value = {"profitByFinance"})
    public String profitByFinance(HttpServletRequest request){
        return "profit/profitByFinance";
    }

    /**
     * 调整机具扣款
     * @param id
     *p:调整后金额
     * @return
     */
    @ResponseBody
    @RequestMapping(value = {"updatePosBack"})
    public ResultVO updatePosBack(@RequestParam("id")String id, @RequestParam("p")BigDecimal p){
        /*Agent agent = agentService.getAgentById(id);
        agent.setCloTaxPoint(p);
        if(1==agentService.updateAgent(agent)){
            return ResultVO.success(null);
        }*/
        return ResultVO.fail("调整失败请重试");
    }

    /**
     * 冻结分润
     * @param id
     * @return
     */
   /* @ResponseBody
    @RequestMapping(value = {"frozenProfit"})
    public ResultVO frozenProfit(@RequestParam("id")String id){
        ProfitMonth profitM = profitMonthService.selectByPrimaryKey(id);
        profitM.setStatus("1");//冻结
        if(1==profitMonthService.updateByPrimaryKeySelective(profitM)){
            return ResultVO.success("冻结成功");
        }
        return ResultVO.fail("调整失败请重试");
    }*/
    /**
     * 冻结分润，填写冻结原因
     * @param id
     * @author LiuQY
     */
    @RequestMapping(value = {"frozenProfit"})
    public String editPage(Model model, String id) {
        ProfitDetailMonth profitM = profitMonthService.selectByPrimaryKey(id);
        model.addAttribute("profitM", profitM);
        return "profit/profitEdit";
    }

    /**
     * 冻结分润，修改所关联直发分润状态
     * @param remark
     * @author LiuQY
     */
    @RequestMapping("/profit_refuse")
    public Object edit_refuse(ProfitDetailMonth profitM, String remark) {
        profitM.setRemark(remark);
        profitM.setStatus("1");
        profitMonthService.updateByPrimaryKeySelective(profitM);
        ProfitDirect profitDirect = new ProfitDirect();
        profitDirect.setFristAgentPid(profitM.getAgentPid());
        List<ProfitDirect>  list = profitDirectService.selectByFristAgentPid(profitDirect);
        if(list.size() > 0){
            for (ProfitDirect profitDirectSingleList:list){
                if(profitDirectSingleList != null){
                    profitDirectSingleList.setStatus("1");
                    profitDirectService.updateByStatus(profitDirectSingleList);
                }
            }
        }
       return ResultVO.success("冻结成功");
    }




    /**
     * 代理商日分润的导出
     */
    @RequestMapping("exportProfitD")
    public void exportProfitD(ProfitDay day, HttpServletResponse response, HttpServletRequest request) throws Exception {
        List<ProfitDay> list = profitDService.exportProfitD(day);

        String filePath = "C:/upload/";
        String filePrefix = "PD";
        int flushRows = 100;
        List<String> fieldNames = null;
        List<String> fieldCodes = null;
        //指导导出数据的title
        fieldNames = new ArrayList<String>();
        fieldCodes = new ArrayList<String>();
        fieldNames.add("代理商编号");
        fieldCodes.add("agentId");

        fieldNames.add("代理商名称");
        fieldCodes.add("agentName");

        fieldNames.add("交易时间");
        fieldCodes.add("returnMoney");

        fieldNames.add("回盘时间");
        fieldNames.add("应发金额");
        fieldNames.add("冻结金额");
        fieldNames.add("成功金额");
        fieldNames.add("失败金额");
        fieldNames.add("实发金额");
        fieldNames.add("补款");
        fieldCodes.add("returnMoney");

        fieldNames.add("返现金额");
        fieldCodes.add("returnMoney");



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
}
