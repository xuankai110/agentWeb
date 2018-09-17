package com.ryx.credit.cms.controller.order;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.enumc.DictGroup;
import com.ryx.credit.common.enumc.PlannerStatus;
import com.ryx.credit.common.util.AppConfig;
import com.ryx.credit.common.util.ExcelUtil;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.pojo.admin.agent.Dict;
import com.ryx.credit.pojo.admin.order.ReceiptPlan;
import com.ryx.credit.service.order.ReceiptPlanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.*;

/**
 * @author yangmx
 * @desc 已排单查询
 */
@Controller
@RequestMapping("/receiptPlan")
public class ReceiptPlanController extends BaseController{

    @Autowired
    private ReceiptPlanService receiptPlanService;

    private static String EXPORT_PLAN_EXECL_PATH = AppConfig.getProperty("export.path");

    @GetMapping("/listPage")
    public String viewJsp(HttpServletRequest request){
        return "order/receiptPlanList";
    }

    @RequestMapping("/list")
    @ResponseBody
    public Object getPageList(HttpServletRequest request){
        List<ReceiptPlan> list = new ArrayList<ReceiptPlan>();
        for (PlannerStatus plannerStatus : PlannerStatus.values()) {
            ReceiptPlan receiptPlan = new ReceiptPlan();
            receiptPlan.setPlanOrderStatus(new BigDecimal(plannerStatus.getValue()));
            list.add(receiptPlan);
        }
        request.setAttribute("planList",list);
        Page page = pageProcess(request);
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), null, null);
        TreeMap map = getRequestParameter(request);
        map.put("begin", page.getBegin());
        map.put("end", page.getEnd());
        return  receiptPlanService.getReceiptPlanList(map, pageInfo);
    }

    @RequestMapping("/export")
    public void exportReceiptPlanWxecl(HttpServletRequest request, HttpServletResponse response){
        TreeMap map = getRequestParameter(request);
        PageInfo pageInfo = receiptPlanService.getReceiptPlanList(map, new PageInfo());
        Map<String, Object> param = new HashMap<String, Object>(6);

        String title = "排单编号,订单编号,商品编号,商品ID,商品名称,商品数量,已排单数量,订货厂家,订货数量,机型,收货人姓名,收货人联系电话,省,市,区,详细地址,地址备注,邮编,快递备注,发货数量,物流公司,物流单号,起始SN序列号,结束SN序列号,起始SN位数,结束SN位数";
        String column = "PLAN_NUM,ORDER_ID,PRO_CODE,PRO_ID,PRO_NAME,PRO_NUM,SEND_NUM,PRO_COM,PLAN_PRO_NUM,MODEL,ADDR_REALNAME,ADDR_MOBILE,NAME,CITY,DISTRICT,ADDR_DETAIL,REMARK,ZIP_CODE,EXPRESS_REMARK,g,a,b,c,d,e,f";

        param.put("path",EXPORT_PLAN_EXECL_PATH);
        param.put("title", title);
        param.put("column", column);
        param.put("dataList",pageInfo.getRows());
        param.put("response", response);
        ExcelUtil.downLoadExcel(param);
    }

}
