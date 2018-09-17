package com.ryx.credit.cms.controller.profit;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ExcelExportSXXSSF;
import com.ryx.credit.cms.util.ImportExcelUtil;
import com.ryx.credit.cms.util.MyUtil;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.common.util.ResultVO;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.profit.pojo.ProfitDirect;
import com.ryx.credit.profit.service.IProfitDirectService;
import com.ryx.credit.profit.service.ProfitFactorService;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedOutputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.TreeMap;

/**
 * @Author Wangy
 * @Date 2018/08/06
 * 分润管理：直发分润展示
 */
@Controller
@RequestMapping("/profitDirect")
public class ProfitDirectController extends BaseController{

    private static final Logger logger = LoggerFactory.getLogger(ProfitDirectController.class);

    @Resource
    private IProfitDirectService directService;

    @RequestMapping(value = "pageList")
    public String profitFactorPage() {
        return "profit/profitDirect/profitDirectList";
    }

    /**
     * 1、分页展示
     */
    @RequestMapping(value = "getList")
    @ResponseBody
    public Object getProfitFactorList(HttpServletRequest request, ProfitDirect profitDirect){
        String agentPid = ServiceFactory.redisService.hGet("agent",getUserId().toString());
        Page page = pageProcess(request);
        if (StringUtils.isNotBlank(agentPid)) {
            profitDirect.setFristAgentPid(agentPid);
        }
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), null, null);
        TreeMap map = getRequestParameter(request);
        map.put("begin", page.getBegin());
        map.put("end", page.getEnd());
        return directService.getProfitDirectList(map, pageInfo);
    }

    /**
     * 页面导出
     */
    @RequestMapping(value = "exportProfitDirect")
    public void exportProfitD(ProfitDirect record, HttpServletResponse response, HttpServletRequest request) throws Exception {
        List<ProfitDirect> list = directService.exportProfitDirect(record);

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
        fieldNames.add("月份");
        fieldCodes.add("transMonth");
        fieldNames.add("上级代理商名称");
        fieldCodes.add("parentAgentName");
        fieldNames.add("一级代理商名称");
        fieldCodes.add("fristAgentName");
        fieldNames.add("直发交易额");
        fieldCodes.add("transAmt");
        fieldNames.add("直发手续费");
        fieldCodes.add("transFee");
        fieldNames.add("直发分润");
        fieldCodes.add("profitAmt");
        fieldNames.add("退单补款");
        fieldCodes.add("supplyAmt");
        fieldNames.add("退单扣款");
        fieldCodes.add("buckleAmt");
        fieldNames.add("应发分润");
        fieldCodes.add("shouldProfit");
        fieldNames.add("实发分润");
        fieldCodes.add("actualProfit");
        fieldNames.add("月份");
        fieldCodes.add("transMonth");
        fieldNames.add("邮箱");
        fieldCodes.add("agentEmail");
        fieldNames.add("账号");
        fieldCodes.add("accountCode");
        fieldNames.add("户名");
        fieldCodes.add("accountName");
        fieldNames.add("开户行");
        fieldCodes.add("bankOpen");
        fieldNames.add("银行号");
        fieldCodes.add("bankCode");
        fieldNames.add("总行行号");
        fieldCodes.add("bossCode");
        fieldNames.add("应找上级扣款");
        fieldCodes.add("parentBuckle");
        fieldNames.add("冻结状态");
        fieldCodes.add("status");
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
