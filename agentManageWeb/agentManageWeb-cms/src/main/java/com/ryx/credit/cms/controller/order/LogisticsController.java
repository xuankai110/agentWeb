package com.ryx.credit.cms.controller.order;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ImportExcelUtil;
import com.ryx.credit.common.exception.MessageException;
import com.ryx.credit.common.util.*;
import com.ryx.credit.pojo.admin.order.OOrder;
import com.ryx.credit.service.agent.AgentService;
import com.ryx.credit.service.order.OLogisticsService;
import com.ryx.credit.service.order.OrderService;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * @Author Lihl
 * @Date 2018/07/23
 * 排单管理：物流信息
 */
@Controller
@RequestMapping("/logistics")
public class LogisticsController extends BaseController{
    private static final Logger logger = LoggerFactory.getLogger(LogisticsController.class);
    @Resource
    private OLogisticsService oLogisticsService;
    @Resource
    private AgentService agentService;
    @Resource
    private OrderService orderService;


    private static String EXPORT_Logistics_PATH = AppConfig.getProperty("export.path");

    @GetMapping("/selectOLogistics")
    public String selectOLogistics() {
        return "order/oLogistics";
    }

    /**
     * 订单物流列表
     * /logistics/orderLogisticsDialog?orderId=
     * @param request
     * @param orderId
     * @return
     * @throws Exception
     */
    @GetMapping("/orderLogisticsDialog")
    public String orderLogisticsDialog(HttpServletRequest request,String orderId,String agentId) throws Exception{
        if(StringUtils.isEmpty(orderId)){
            throw new Exception("订单ID不可为空");
        }
        OOrder order  = orderService.getById(orderId);
        if(!order.getAgentId().equals(agentId)){
            throw new Exception("信息错误");
        }
        request.setAttribute("orderId",orderId);
        return "order/orderLogistics";
    }

    /**
     * 物流信息:
     * 分页展示
     */
    @RequestMapping("/oLogisticsList")
    @ResponseBody
    public Object oLogisticsList(HttpServletRequest request){
        Page page = pageProcess(request);
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), null, null);
        TreeMap map = getRequestParameter(request);
        map.put("begin", page.getBegin());
        map.put("end", page.getEnd());
        map.put("returnId", request.getParameter("returnId"));
        map.put("AGENT_ID", getAgentId());
        return oLogisticsService.getOLogisticsList(map, pageInfo);
    }

    /**
     * 物流信息:
     * 分页展示
     */
    @RequestMapping("/oLogisticsListRefund")
    @ResponseBody
    public Object oLogisticsListRefund(HttpServletRequest request){
        Page page = pageProcess(request);
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), null, null);
        TreeMap map = getRequestParameter(request);
        map.put("begin", page.getBegin());
        map.put("end", page.getEnd());
        map.put("returnId", request.getParameter("returnId"));
        return oLogisticsService.getOLogisticsList(map, pageInfo);
    }

    /**
     * 物流信息:
     * 导出物流信息
     */
    @RequestMapping("/exportOLogistics")
    public void exportOLogistics(HttpServletRequest request, HttpServletResponse response){
        TreeMap map = getRequestParameter(request);
        PageInfo pageInfo = oLogisticsService.getOLogisticsList(map, new PageInfo());
        Map<String, Object> param = new HashMap<String, Object>(6);

        String title = "排单编号,排单状态,订单编号,商品编号,商品名称,商品数量,已排单数量,订货厂家,订货数量,发货数量,机型,计划发货日期,实际发货时间,收货人姓名,收货单状态,退货子订单编号,物流公司,物流类型,物流单号,起始SN序列号,结束SN序列号";
        String column = "PLAN_NUM,PLAN_ORDER_STATUS,ORDER_ID,PRO_CODE,PRO_NAME,PRO_NUM,SEND_NUM,PRO_COM,PLAN_PRO_NUM,SEND_PRO_NUM,MODEL,SEND_DATE,REAL_SEND_DATE,ADDR_REALNAME,RECEIPT_STATUS,RETURN_ORDER_DETAIL_ID,LOG_COM,LOG_TYPE,W_NUMBER,SN_BEGIN_NUM,SN_END_NUM";

        param.put("path", EXPORT_Logistics_PATH);
        param.put("title", title);
        param.put("column", column);
        param.put("dataList", pageInfo.getRows());
        param.put("response", response);
        ExcelUtil.downLoadExcel(param);
    }

    @RequestMapping("/importPage")
    public String importPage(){
        return "order/oLogisticsImport";
    }

    /**
     * 物流信息:
     * 导入物流信息
     */
    @RequestMapping("/importOLogistics")
    @ResponseBody
    public ResultVO importOLogistics(@RequestParam(value = "file", required = false)MultipartFile[] files){
        if (null == files) {
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
                        List<String> resd = oLogisticsService.addList(list, userid);
                        logger.info("用户{}导入dubbo调用结果返回{},数据类型{}", userid, resd.size());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    if(e instanceof MessageException){
                        String msg = ((MessageException) e).getMsg();
                        return ResultVO.fail(msg);
                    }
                    logger.info("导入物流异常：",e.getMessage());
                    return ResultVO.fail(e.getMessage());
                }finally {
                    workbook.close();
                }
            }
            return ResultVO.success(null);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultVO.fail(e.getMessage());
        }
    }

}
