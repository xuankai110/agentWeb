package com.ryx.credit.cms.controller.profit;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ImportExcelUtil;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.common.util.ResultVO;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.profit.pojo.ProfitSupply;
import com.ryx.credit.profit.service.ProfitSupplyService;
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
import java.util.ArrayList;
import java.util.List;
import java.util.TreeMap;

/**
 * @Author Lihl
 * @Date 2018/08/02
 * 分润管理：补款数据维护
 */
@Controller
@RequestMapping("/profitSupply")
public class ProfitSupplyController extends BaseController{

    private static final Logger logger = LoggerFactory.getLogger(ProfitSupplyController.class);

    @Resource
    private ProfitSupplyService profitSupplyService;

    @RequestMapping(value = "pageList")
    public String profitSupplyPage() {
        return "profit/supply/profitSupplyList";
    }

    /**
     * 1、分页展示
     */
    @RequestMapping(value = "getList")
    @ResponseBody
    public Object getProfitSupplyList(HttpServletRequest request, ProfitSupply profitSupply){
        String agentPid = ServiceFactory.redisService.hGet("agent",getUserId().toString());
        Page page = pageProcess(request);
        if (StringUtils.isNotBlank(agentPid)) {
            profitSupply.setAgentPid(agentPid);
        }
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), null, null);
        TreeMap map = getRequestParameter(request);
        map.put("begin", page.getBegin());
        map.put("end", page.getEnd());
        return profitSupplyService.getProfitSupplyList(map, pageInfo);
    }

    @RequestMapping("/importPage")
    public String importPage(){
        return "profit/supply/profitSupplyImport";
    }

    /**
     * 补款数据维护:
     * 1、导入补款数据
     */
    @RequestMapping(value = "importFile")
    @ResponseBody
    public ResultVO importFile(@RequestParam(value = "file", required = false)MultipartFile[] files){
        if ("".equals(files[0].getOriginalFilename())||null==files[0].getOriginalFilename()) {
            return ResultVO.fail("文件不能为空");
        }
        try {
            String userid = getUserId() + "";
            for (MultipartFile file : files) {
                String filename = file.getOriginalFilename();
                logger.info("用户{}文件{}", userid, filename);
                Workbook workbook = ImportExcelUtil.getWorkbook(file.getInputStream(), filename);
                try {
                    if (null == workbook) {
                        logger.info("用户{}消息", userid, "创建Excel工作薄为空");
                        return ResultVO.fail("创建Excel工作薄为空");
                    }
                    Sheet sheet = null;
                    Row row = null;
                    Cell cell = null;
                    for (int i = 0; i < workbook.getNumberOfSheets(); i++) {
                        sheet = workbook.getSheetAt(i);
                        if (sheet == null) {
                            continue;
                        }
                        List list = new ArrayList<List<Object>>();
                        // 遍历当前sheet中的所有行
                        for (int j = sheet.getFirstRowNum(); j < sheet.getLastRowNum() + 1; j++) { // 这里的加一是因为下面的循环跳过取第一行表头的数据内容了
                            row = sheet.getRow(j);
                            if (row == null || row.getFirstCellNum() == j) {
                                continue;
                            }
                            // 遍历所有的列
                            List<Object> li = new ArrayList<Object>();
                            for (int y = row.getFirstCellNum(); y < row.getLastCellNum(); y++) {
                                cell = row.getCell(y);
                                if(null == cell){
                                    li.add("");
                                }else{
                                    li.add(ImportExcelUtil.getCellValue(cell));
                                }
                            }
                            if(li.size()>0) {
                                list.add(li);
                            }else{
                                logger.info("用户{}导入dubbo调用{}, 数据类型{}数据为空", userid, list.size());
                            }
                        }
                        logger.info("用户{}导入dubbo调用{}, 数据类型{}", userid, list.size());
                        List<String> resd = profitSupplyService.importSupplyList(list);
                        logger.info("用户{}导入dubbo调用结果返回{},数据类型{}", userid, resd.size());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    logger.info("导入补款数据异常：",e.getMessage());
                    return ResultVO.fail(e.getMessage());
                }finally {
                    workbook.close();
                }
            }
            return ResultVO.success("导入成功");
        } catch (Exception e) {
            e.printStackTrace();
            return ResultVO.fail(e.getMessage());
        }
    }


}
