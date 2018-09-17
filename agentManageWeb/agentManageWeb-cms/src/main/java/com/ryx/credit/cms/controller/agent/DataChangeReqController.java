package com.ryx.credit.cms.controller.agent;

import com.alibaba.fastjson.JSONObject;
import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.common.enumc.AgStatus;
import com.ryx.credit.common.enumc.AttachmentRelType;
import com.ryx.credit.common.enumc.BusActRelBusType;
import com.ryx.credit.common.util.JsonUtils;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.common.util.ResultVO;
import com.ryx.credit.pojo.admin.agent.Agent;
import com.ryx.credit.pojo.admin.agent.Attachment;
import com.ryx.credit.pojo.admin.agent.BusActRel;
import com.ryx.credit.pojo.admin.agent.DateChangeRequest;
import com.ryx.credit.pojo.admin.vo.*;
import com.ryx.credit.service.agent.AgentQueryService;
import com.ryx.credit.service.agent.DataChangeActivityService;
import com.ryx.credit.service.agent.DateChangeReqService;
import com.ryx.credit.service.agent.TaskApprovalService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @ClassName DataChangeReqController
 * @Description TODO
 * @Author lrr
 * @Date 2018/6/6
 **/
@Controller
@RequestMapping("dataChangeReq")
public class DataChangeReqController extends BaseController {
    private static Logger log = LoggerFactory.getLogger(DataChangeReqController.class);

    @Autowired
    private DateChangeReqService dateChangeReqService;
    @Autowired
    private AgentQueryService agentQueryService;
    @Autowired
    private DataChangeActivityService dataChangeActivityService;
    @Autowired
    private TaskApprovalService taskApprovalService;
    @Autowired
    private AgentActivityController agentActivityController;

    @RequestMapping(value = {"/", "dataQuery"})
    public String enterView(HttpServletRequest request) {
        optionsData(request);
        return "agent/dataQuery";
    }

    @RequestMapping("queryData")
    @ResponseBody
    public Object queryData(HttpServletRequest request, DateChangeRequest dateChangeRequest) {
        Page pageInfo = pageProcess(request);
        PageInfo info = dateChangeReqService.queryData(pageInfo, dateChangeRequest);
        return info;
    }

    @RequestMapping(value = {"/", "selectById"})
    public Object selectById(HttpServletRequest request, String id, Model model) {
        DateChangeRequest dateChangeRequest = dateChangeReqService.getById(id);
        List<Attachment> attachmentList = null;
        if (null != dateChangeRequest.getDataContent()) {
            optionsData(request);
            AgentVo vo = JSONObject.parseObject(dateChangeRequest.getDataContent(), AgentVo.class);
            if (null != vo) {
                if (null != vo.getAgent()) {
                    Agent agent = vo.getAgent();
                    model.addAttribute("agent", agent);
                }
                if (null != vo.getBusInfoVoList() && vo.getBusInfoVoList().size() > 0) {
                    List<AgentBusInfoVo> agentBusInfos = vo.getBusInfoVoList();
                    model.addAttribute("agentBusInfos", agentBusInfos);
                }
                if (null != vo.getCapitalVoList() && vo.getCapitalVoList().size() > 0) {
                    List<CapitalVo> capitals = vo.getCapitalVoList();
                    model.addAttribute("capitals", capitals);
                }
                if (null != vo.getContractVoList() && vo.getContractVoList().size() > 0) {
                    List<AgentContractVo> agentContracts = vo.getContractVoList();
                    model.addAttribute("agentContracts", agentContracts);
                }
                if (null != vo.getColinfoVoList() && vo.getColinfoVoList().size() > 0) {
                    List<AgentColinfoVo> agentColinfos = vo.getColinfoVoList();
                    model.addAttribute("agentColinfos", agentColinfos);
                }
                if (null != vo.getAgentTableFile() && vo.getAgentTableFile().size() > 0) {
                    List<String> attachment = vo.getAgentTableFile();
                    for (String s : attachment) {
                        attachmentList = agentQueryService.accessoryQuery(s, AttachmentRelType.Agent.name());
                    }
                    model.addAttribute("attachment", attachmentList);
                }
            }
            request.setAttribute("agStatus",AgStatus.getAgStatusString(dateChangeRequest.getAppyStatus()));
            request.setAttribute("busIdImg",dateChangeRequest.getId());
            request.setAttribute("busTypeImg",dateChangeRequest.getDataType());
        }

        BusActRel busActRel = taskApprovalService.queryBusActRel(id, dateChangeRequest.getDataType(), AgStatus.getAgStatusString(dateChangeRequest.getAppyStatus()) );
        List<Map<String, Object>> actRecordList = null;
        if(busActRel!=null){
            actRecordList = agentActivityController.queryApprovalRecord(busActRel.getActivId());
        }
        request.setAttribute("actRecordList",actRecordList);

        return "agent/agentQuery";
    }
   @RequestMapping("startData")
   @ResponseBody
   public Object startData(String id,String userId) {
       try {
           ResultVO resultVO = dataChangeActivityService.startDataChangeActivity(id, getUserId()+"");
           return resultVO;
       } catch (Exception e) {
           e.printStackTrace();
           return ResultVO.fail(e.getMessage());
       }

   }
}
