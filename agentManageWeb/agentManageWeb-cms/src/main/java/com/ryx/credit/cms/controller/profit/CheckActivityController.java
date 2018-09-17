package com.ryx.credit.cms.controller.profit;

import com.ryx.credit.activity.entity.ActHiVarinst;
import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.enumc.DictGroup;
import com.ryx.credit.common.result.AgentResult;
import com.ryx.credit.common.util.JsonUtils;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.ResultVO;
import com.ryx.credit.pojo.admin.CUser;
import com.ryx.credit.pojo.admin.agent.BusActRel;
import com.ryx.credit.pojo.admin.agent.Dict;
import com.ryx.credit.pojo.admin.vo.AgentVo;
import com.ryx.credit.profit.pojo.PosCheck;
import com.ryx.credit.profit.service.IPosCheckService;
import com.ryx.credit.service.ActHiVarinstService;
import com.ryx.credit.service.IUserService;
import com.ryx.credit.service.agent.TaskApprovalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author Lihl
 * @Date 2018/08/08
 * @desc 分润比例考核申请
 */
@Controller
@RequestMapping("/checkActivity")
public class CheckActivityController extends BaseController{
    @Autowired
    private ActHiVarinstService actHiVarinstService;
    @Autowired
    private IUserService userService;
    @Autowired
    private TaskApprovalService taskApprovalService;
    @Autowired
    private IPosCheckService posCheckService;

    /**
     * 进入待审批页面
     * @param request
     * @param model
     * @return 加载奖励审批页面
     */
    @RequestMapping("/toTaskApproval")
    public String toTaskApproval(HttpServletRequest request, Model model){
        String taskId = request.getParameter("taskId");
        String proIns = request.getParameter("proIns");
        String thawId = request.getParameter("busId");
        optionsData(request);

        PosCheck check = posCheckService.getPosCheckById(thawId);
        model.addAttribute("posCheck", check);

        if (check != null) {
            PosCheck posCheck = posCheckService.getPosCheckById(check.getId());
            model.addAttribute("posCheck", posCheck);
        }

        //审批参数
        List<Dict> TOOLS_APR_BUSNISS = ServiceFactory.dictOptionsService.dictList(DictGroup.TOOLS.name(), DictGroup.TOOLS_APR_BUSNISS.name());
        List<Dict> TOOLS_APR_MARKET = ServiceFactory.dictOptionsService.dictList(DictGroup.TOOLS.name(), DictGroup.TOOLS_APR_MARKET.name());
        List<Dict> TOOLS_APR_BOSS = ServiceFactory.dictOptionsService.dictList(DictGroup.TOOLS.name(), DictGroup.TOOLS_APR_BOSS.name());
        List<Dict> TOOLS_APR_EXPAND = ServiceFactory.dictOptionsService.dictList(DictGroup.TOOLS.name(), DictGroup.TOOLS_APR_EXPAND.name());
        request.setAttribute("tools_apr_busniss", TOOLS_APR_BUSNISS);
        request.setAttribute("tools_apr_market", TOOLS_APR_MARKET);
        request.setAttribute("tools_apr_boss", TOOLS_APR_BOSS);
        request.setAttribute("tools_apr_expand", TOOLS_APR_EXPAND);
        request.setAttribute("actRecordList", queryApprovalRecord(proIns));
        model.addAttribute("taskId", taskId);
        model.addAttribute("proIns", proIns);
        return "discount/posCheck/checkTaskApproval";
    }

    /**
     * 查询审批记录
     * @param proIns
     */
    public List<Map<String,Object>> queryApprovalRecord(String proIns){
        ActHiVarinst actHiVarinst = new ActHiVarinst();
        actHiVarinst.setProcInstId(proIns);
        actHiVarinst.setName("_ryx_wq");
        HashMap<String, Object> actHiVarinstMap = actHiVarinstService.configExample(new Page(), actHiVarinst);
        List<Map<String,Object>> actRecordList = new ArrayList<>();
        List<ActHiVarinst> list = (List<ActHiVarinst>)actHiVarinstMap.get("list");
        for (ActHiVarinst hiVarinst : list) {
            Map map = JsonUtils.parseJSON2Map(String.valueOf(hiVarinst.getText()));
            String approvalPerson = String.valueOf(map.get("approvalPerson"));
            CUser cUser = userService.selectById(approvalPerson);
            if(null!=cUser){
                map.put("approvalPerson",cUser.getName());
            }
            actRecordList.add(map);
        }
        return actRecordList;
    }

    /**
     * 处理任务
     * @return
     */
    @ResponseBody
    @RequestMapping("/taskApproval")
    public ResultVO taskApproval(@RequestBody AgentVo agentVo){
        AgentResult result = null;
        try {
            result = posCheckService.approvalTask(agentVo, String.valueOf(getUserId()));
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if(result==null){
                return ResultVO.fail("处理失败");
            }
            if(result.isOK()){
                return ResultVO.success("处理成功");
            }else{
                return ResultVO.fail("处理失败");
            }
        }
    }

    @RequestMapping("/gotoTaskApproval")
    public ModelAndView gotoTaskApproval(HttpServletRequest request, @RequestParam(value = "id") String id){
        ModelAndView view = new ModelAndView();
        view.setViewName("discount/posCheck/posCheckPlan"); //查看分润比例考核 审批进度页面
        PosCheck check = posCheckService.getPosCheckById(id);
        view.addObject("posCheck", check);
        List<PosCheck> list = posCheckService.getPosCheckByDataId(id);
        if(list != null && !list.isEmpty()){
            PosCheck posCheck = list.get(0);
            view.addObject("posCheck", posCheck);
            BusActRel busActRel = new BusActRel();
            busActRel.setBusId(posCheck.getId());
            BusActRel rel = null;
            try {
                rel = taskApprovalService.queryBusActRel(busActRel);
                if (rel != null) {
                    view.addObject("actRecordList",queryApprovalRecord(rel.getActivId()));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        optionsData(request);
        return view;
    }


}
