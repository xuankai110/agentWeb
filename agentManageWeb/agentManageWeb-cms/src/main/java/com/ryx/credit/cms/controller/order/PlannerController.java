package com.ryx.credit.cms.controller.order;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.enumc.DictGroup;
import com.ryx.credit.common.exception.MessageException;
import com.ryx.credit.common.exception.ProcessException;
import com.ryx.credit.common.result.AgentResult;
import com.ryx.credit.common.util.Constants;
import com.ryx.credit.common.util.JsonUtil;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.pojo.admin.agent.Dict;
import com.ryx.credit.pojo.admin.order.*;
import com.ryx.credit.pojo.admin.vo.AgentVo;
import com.ryx.credit.service.order.PlannerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by RYX on 2018/7/20.
 */
@RequestMapping("planner")
@Controller
public class PlannerController extends BaseController {

    @Autowired
    private PlannerService plannerService;

    @RequestMapping(value = "toPlannerList")
    public String toPlannerList(HttpServletRequest request){
        List<Dict> dicts = ServiceFactory.dictOptionsService.dictList(DictGroup.ORDER.name(), DictGroup.MANUFACTURER.name());
        String manufacturerJson = JsonUtil.objectToJson(dicts);
        request.setAttribute("manufacturer",manufacturerJson);
        return "order/plannerList";
    }

    @RequestMapping(value = "plannerList")
    @ResponseBody
    public Object plannerList(HttpServletRequest request, OReceiptOrder receiptOrder,OReceiptPro receiptPro){
        Page pageInfo = pageProcess(request);
        PageInfo resultPageInfo = plannerService.queryPlannerList(receiptOrder,receiptPro,pageInfo);
        return resultPageInfo;
    }

    @RequestMapping(value = "savePlanner")
    @ResponseBody
    public Object savePlanner(ReceiptPlan receiptPlan,String receiptProId){
        try {
            receiptPlan.setProId(receiptProId);
            String userId = String.valueOf(getUserId());
            receiptPlan.setcUser(userId);
            receiptPlan.setUserId(userId);
            AgentResult agentResult = plannerService.savePlanner(receiptPlan, receiptProId);
            if(agentResult.isOK()){
                return renderSuccess("保存成功！");
            }
            return renderSuccess("保存失败！");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return renderSuccess("保存失败！");
    }


    @RequestMapping(value = "batchPlanner")
    @ResponseBody
    public Object batchPlanner(@RequestBody AgentVo agentVo){
        try {
            AgentResult agentResult =null;
            if(agentResult.isOK()){
                return renderSuccess("批量保存成功！");
            }
            return renderSuccess("批量保存失败！");
        } catch (ProcessException e) {
            return renderError(e.getMessage());
        } catch (Exception e) {
            return renderError(Constants.FAIL_MSG);
        }
    }
}
