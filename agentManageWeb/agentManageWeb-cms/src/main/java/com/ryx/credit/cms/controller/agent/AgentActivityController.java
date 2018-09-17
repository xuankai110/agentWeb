package com.ryx.credit.cms.controller.agent;

import com.alibaba.fastjson.JSONObject;
import com.ryx.credit.activity.entity.ActHiVarinst;
import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.common.enumc.AgStatus;
import com.ryx.credit.common.enumc.AttachmentRelType;
import com.ryx.credit.common.result.AgentResult;
import com.ryx.credit.common.util.JsonUtil;
import com.ryx.credit.common.util.JsonUtils;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.ResultVO;
import com.ryx.credit.pojo.admin.CUser;
import com.ryx.credit.pojo.admin.agent.*;
import com.ryx.credit.pojo.admin.vo.*;
import com.ryx.credit.service.ActHiVarinstService;
import com.ryx.credit.service.ActivityService;
import com.ryx.credit.service.IUserService;
import com.ryx.credit.service.agent.*;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.*;

/**
 * Created by cx on 2018/5/29.
 */
@RequestMapping("agActivity")
@Controller
public class AgentActivityController extends BaseController {

    protected Logger logger = LogManager.getLogger(this.getClass());

    @Autowired
    private AgentQueryService agentQueryService;
    @Autowired
    private BusinessPlatformService businessPlatformService;
    @Autowired
    private AgentEnterService agentEnterService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private TaskApprovalService taskApprovalService;
    @Autowired
    private ActHiVarinstService actHiVarinstService;
    @Autowired
    private DateChangeReqService dateChangeReqService;
    @Autowired
    private IUserService userService;


    /**
     * 启动代理商入网流程
     *  agActivity/startAg
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("startAg")
    public ResultVO startAgentProcessing(HttpServletRequest request, HttpServletResponse response){
        try {
            String agentId = request.getParameter("agentId");
            ResultVO rv = agentEnterService.startAgentEnterActivity(agentId,getUserId()+"");
            return rv;
        } catch (Exception e) {
            e.printStackTrace();
            return ResultVO.fail(e.getMessage());
        }
    }


    /**
     * 启动业务审批
     * agActivity/startBus
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("startBus")
    public ResultVO startAgentBusProcessing(HttpServletRequest request, HttpServletResponse response){
        try {
            String busId = request.getParameter("busId");
            ResultVO rv = agentEnterService.startAgentBusiEnterActivity(busId,getUserId()+"");
            return rv;
        } catch (Exception e) {
            e.printStackTrace();
            return ResultVO.fail(e.getMessage());
        }
    }

    /**
     * 进入审批页面
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("toTaskApproval")
    public String toTaskApproval(HttpServletRequest request, HttpServletResponse response,Model model){
        String taskId = request.getParameter("taskId");
        String proIns = request.getParameter("proIns");
        String busTypes = request.getParameter("busType");
        String agentId = request.getParameter("busId");
        Agent agent = agentQueryService.informationQuery(agentId);
        List<AgentColinfo> agentColinfos = agentQueryService.proceedsQuery(agentId);
        List<Capital> capitals = agentQueryService.paymentQuery(agentId);
        List<AgentContract> agentContracts = agentQueryService.compactQuery(agentId);
        List<AgentBusInfo> agentBusInfos = agentQueryService.businessQuery(agentId);
        List<Attachment> attachment = agentQueryService.accessoryQuery(agentId, AttachmentRelType.Agent.name());

        //审核信息
        AgentBusInfo agentBusInfo = new AgentBusInfo();
        agentBusInfo.setAgentId(agentId);
        List<Map<String, Object>> agentBusInfoList = taskApprovalService.queryBusInfoAndRemit(agentBusInfo);
        request.setAttribute("agentBusInfoList", agentBusInfoList);

        model.addAttribute("agent",agent);
        model.addAttribute("agentColinfos",agentColinfos);
        model.addAttribute("capitals",capitals);
        model.addAttribute("agentContracts",agentContracts);
        model.addAttribute("agentBusInfos",agentBusInfos);
        model.addAttribute("attachment",attachment);
        optionsData(request);
        request.setAttribute("ablePlatForm",  businessPlatformService.queryAblePlatForm());
        request.setAttribute("taskId", taskId);
        request.setAttribute("proIns", proIns);
        request.setAttribute("actRecordList", queryApprovalRecord(proIns));
        return "activity/TaskApproval";
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
     * 进入业务审批页面
     *  agActivity/agentBusTaskApproval
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("agentBusTaskApproval")
    public String toAgentBusTaskApproval(HttpServletRequest request, HttpServletResponse response,Model model){
        String taskId = request.getParameter("taskId");
        String proIns = request.getParameter("proIns");
        String busType = request.getParameter("busType");
        String agentbusId = request.getParameter("busId");

        AgentBusInfo abi = businessPlatformService.findById(agentbusId);
        Agent agent = agentQueryService.informationQuery(abi.getAgentId());
        List<AgentColinfo> agentColinfos = agentQueryService.proceedsQuery(agent.getId());
        List<Attachment> attachment = agentQueryService.accessoryQuery(agent.getId(), AttachmentRelType.Agent.name());
        List<Capital> capitals = agentQueryService.paymentQuery(agent.getId());
        List<AgentContract> agentContracts = agentQueryService.compactQuery(agent.getId());

        List<AgentBusInfo> agentBusInfosForApprove = Arrays.asList(abi);
        //审核信息
        request.setAttribute("agentBusInfoList", taskApprovalService.queryBusInfoAndRemitByBusId(agentbusId));
        model.addAttribute("agent",agent);
        model.addAttribute("agentColinfos",agentColinfos);
        model.addAttribute("agentBusInfos",agentBusInfosForApprove);
        model.addAttribute("agentContracts",agentContracts);
        model.addAttribute("attachment",attachment);
        model.addAttribute("taskId",taskId);
        model.addAttribute("agentbusId",agentbusId);
        model.addAttribute("capitals",capitals);
        optionsData(request);
        request.setAttribute("actRecordList", queryApprovalRecord(proIns));
        return "activity/agentBusTaskApproval";
    }


    /**
     * 业务修改审批界面
     * /agActivity/dataChangerUpdateAprroval
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RequestMapping("dataChangerUpdateAprroval")
    public String toDataChangerUpdateAprrovalView(HttpServletRequest request, HttpServletResponse response,Model model){
        String taskId = request.getParameter("taskId");
        String proIns = request.getParameter("proIns");
        String busType = request.getParameter("busType");
        String busId = request.getParameter("busId");

        model.addAttribute("taskId",taskId);
        model.addAttribute("busId",busId);

        DateChangeRequest dateChangeRequest = dateChangeReqService.getById(busId);
        List<Attachment> attachmentList = null;
        if (null != dateChangeRequest.getDataContent()) {
            optionsData(request);
            JSONObject jsonObject = JSONObject.parseObject(dateChangeRequest.getDataContent());
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
        }
        return "activity/dataChangeApproval";
    }


    /**
     * 处理任务
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("taskApproval")
    public ResultVO taskApproval(HttpServletRequest request, HttpServletResponse response,@RequestBody AgentVo agentVo){

        AgentResult result = null;
        try {
            result = taskApprovalService.approvalTask(agentVo, String.valueOf(getUserId()));
        } catch (Exception e) {
            logger.info("taskApproval处理任务异常:"+e.getMessage());
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


    /**
     * 图片获取
     * agActivity/approvalImage?taskId=
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("approvalImage")
    public String approvalImage(HttpServletRequest request, HttpServletResponse response){
        try {
            String taskId = request.getParameter("taskId");
            Map dataRes = activityService.getImage(taskId);
            Object data =  dataRes.get("b");
            outImg(data,response);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 获取整体流程图
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("approvalActImage")
    public String approvalActImage(HttpServletRequest request, HttpServletResponse response){
        try {
            String busId = request.getParameter("busId");
            String busType = request.getParameter("busType");
            Map dataRes = taskApprovalService.findBusActByBusId(busId,busType,AgStatus.Approving.name());
            if(dataRes==null){
                return null;
            }
            Object data =  dataRes.get("b");
            outImg(data,response);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void outImg(Object data,HttpServletResponse response)throws IOException{
        if(data!=null){
            byte[] img = (byte[])data;
            response.setContentType("image/jpeg");
            OutputStream toClient = response.getOutputStream();
            InputStream in = new ByteArrayInputStream(img);
            int len;
            byte[] buf = new byte[1024];
            while ((len = in.read(buf, 0, 1024)) != -1) {
                toClient.write(buf, 0, len);
            }
            toClient.close();
        }
    }

}
