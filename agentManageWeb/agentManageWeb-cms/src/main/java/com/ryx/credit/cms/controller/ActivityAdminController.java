package com.ryx.credit.cms.controller;

import com.alibaba.fastjson.JSONObject;
import com.ryx.credit.activity.entity.ActRuTask;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.enumc.BusActRelBusType;
import com.ryx.credit.common.enumc.DictGroup;
import com.ryx.credit.common.enumc.PkType;
import com.ryx.credit.common.exception.ProcessException;
import com.ryx.credit.common.util.FastMap;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.commons.shiro.ShiroUser;
import com.ryx.credit.pojo.admin.agent.*;
import com.ryx.credit.pojo.admin.order.OOrder;
import com.ryx.credit.pojo.admin.order.ORefundPriceDiff;
import com.ryx.credit.pojo.admin.order.OSupplement;
import com.ryx.credit.profit.pojo.*;
import com.ryx.credit.profit.service.*;
import com.ryx.credit.service.ActRuTaskService;
import com.ryx.credit.service.ActUtilService;
import com.ryx.credit.service.ActivityService;
import com.ryx.credit.service.IUserService;
import com.ryx.credit.service.agent.AgentQueryService;
import com.ryx.credit.service.agent.AgentService;
import com.ryx.credit.service.agent.BusActRelService;
import com.ryx.credit.service.order.OSupplementService;
import org.activiti.engine.task.Task;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.regex.Pattern;

/**
 * ActivityAdminController
 * Created by IntelliJ IDEA.
 *
 * @author Wang Qi
 * @Date 2018/5/29
 * @Time: 10:43
 * @description: ActivityAdminController
 * To change this template use File | Settings | File Templates.
 */
@Controller
@RequestMapping("/activity")
public class ActivityAdminController extends BaseController {
    protected Logger logger = LogManager.getLogger(this.getClass());
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActUtilService actUtilService;
    @Autowired
    private AgentQueryService agentQueryService;
    @Autowired
    private IUserService iUserService;
    @Autowired
    private AgentService agentService;
    @Autowired
    private BusActRelService busActRelService;
    @Autowired
    private ActRuTaskService actRuTaskService;


    @RequestMapping("/activityList.htmls")
    @ResponseBody
    public Object activityList(final HttpServletRequest request,
                               final HttpServletResponse response) {
        Page page = pageProcess(request);
        List<Map<String, Object>>  org = iUserService.orgCode(getUserId());
        if(org.size()==0){throw new ProcessException("部门信息未找到");}
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), "seq", "desc");
        List<Dict>  disc = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(),DictGroup.ACTIVITY_TASK_REX.name());
        String group = null;
        for (Dict dict : disc) {
            if (Pattern.matches(dict.getdItemvalue(), org.get(0).get("ORGANIZATIONCODE") + "")) {
                group = dict.getdItemname();
                break;
            }
        }
        List<TaskObject> taskObjects = new ArrayList<>();
        if(org.get(0).get("ORGANIZATIONCODE").equals("agent")){
            Map<String, Object> param = new HashMap<>();
            param.put("cUser",getUserId());
            param.put("group","agent");
            List<Map<String, Object>> listMap = actRuTaskService.queryMyTask(param);
            for (Map<String, Object> map : listMap) {
                String id = String.valueOf(map.get("ID_"));
                String name = String.valueOf(map.get("NAME_"));
                String activId = String.valueOf(map.get("ACTIV_ID"));
                ActRuTask art = actUtilService.queryTaskInfo(id);
                TaskObject taskObject =new TaskObject();
                taskObject.setName(name);
                taskObject.setId(id);
                taskObject.setExecutionId(activId);
                taskObject.setProcInstId(art.getProcInstId()+"");
                taskObject.setCreateTime(art.getCreateTime());
                taskObject.setAssignee(art.getAssignee()+"");
                taskObject.setSid(art.getTaskDefKey()+"");
                BusActRel busActRel = busActRelService.findById(String.valueOf(art.getProcInstId()));
                try {
                    taskObject = busDispose(busActRel, taskObject);
                } catch (Exception e) {
                    continue;
                }
                taskObjects.add(taskObject);
            }
            pageInfo.setTotal(listMap.size());
        }else{
            List<Task> taskList = activityService.findMyPersonTask(null,group);
            for(Task task :taskList){
                ActRuTask art = actUtilService.queryTaskInfo(task.getId());
                TaskObject taskObject =new TaskObject();
                taskObject.setName(task.getName());
                taskObject.setId(task.getId());
                taskObject.setExecutionId(task.getExecutionId());
                taskObject.setProcInstId(art.getProcInstId()+"");
                taskObject.setCreateTime(art.getCreateTime());
                taskObject.setAssignee(art.getAssignee()+"");
                taskObject.setSid(art.getTaskDefKey()+"");
                BusActRel busActRel = busActRelService.findById(String.valueOf(art.getProcInstId()));
                try {
                    taskObject = busDispose(busActRel, taskObject);
                } catch (Exception e) {
                    continue;
                }
                taskObjects.add(taskObject);
            }
            pageInfo.setTotal(taskList.size());
        }
        ShiroUser shiroUser = getShiroUser();
        Set<String> urlSet = shiroUser.getUrlSet();
        List<TaskObject> resultTask = new ArrayList<>();
        for (TaskObject taskObject : taskObjects) {
            for (String url : urlSet) {
                if(url.equals(BusActRelBusType.refund.key) && taskObject.getBusType().equals(BusActRelBusType.refund.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.Agent.key) && taskObject.getBusType().equals(BusActRelBusType.Agent.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.Business.key) && taskObject.getBusType().equals(BusActRelBusType.Business.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.DC_Agent.key) && taskObject.getBusType().equals(BusActRelBusType.DC_Agent.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.DC_Colinfo.key) && taskObject.getBusType().equals(BusActRelBusType.DC_Colinfo.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.ORDER.key) && taskObject.getBusType().equals(BusActRelBusType.ORDER.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.STAGING.key) && taskObject.getBusType().equals(BusActRelBusType.STAGING.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.OTHER_DEDUCTION.key) && taskObject.getBusType().equals(BusActRelBusType.OTHER_DEDUCTION.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.THAW.key) && taskObject.getBusType().equals(BusActRelBusType.THAW.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.PkType.key) && taskObject.getBusType().equals(BusActRelBusType.PkType.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.TOOLS.key) && taskObject.getBusType().equals(BusActRelBusType.TOOLS.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.COMPENSATE.key) && taskObject.getBusType().equals(BusActRelBusType.COMPENSATE.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.POSTAX.key) && taskObject.getBusType().equals(BusActRelBusType.POSTAX.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.POSCHECK.key) && taskObject.getBusType().equals(BusActRelBusType.POSCHECK.name())){
                    resultTask.add(taskObject);
                    continue;
                }
                if(url.equals(BusActRelBusType.POSREWARD.key) && taskObject.getBusType().equals(BusActRelBusType.POSREWARD.name())){
                    resultTask.add(taskObject);
                    continue;
                }
            }
        }
        pageInfo.setRows(resultTask);
        pageInfo.setFrom(0);
        return pageInfo;
    }

    private TaskObject busDispose(BusActRel busActRel,TaskObject taskObject)throws Exception {
        if(busActRel != null && (busActRel.getBusType().equals(BusActRelBusType.STAGING.name()) || busActRel.getBusType().equals(BusActRelBusType.OTHER_DEDUCTION.name()))) {

        } else{
            Map data = agentQueryService.queryInfoByProInsId(taskObject.getProcInstId());
            if (data != null) {
                BusActRel rel = (BusActRel) data.get("rel");
                if (rel.getBusType().equals(BusActRelBusType.Agent.name())) {
                    Agent agnet = (Agent) data.get("agent");
                    taskObject.setBusData(agnet.getAgName());
                    taskObject.setBusType(rel.getBusType());
                    taskObject.setBusId(agnet.getId());
                }
                if (rel.getBusType().equals(BusActRelBusType.Business.name())) {
                    AgentBusInfo agnetBusInfo = (AgentBusInfo) data.get("angetBusInfo");
                    Agent agent = agentQueryService.informationQuery(agnetBusInfo.getAgentId());
                    taskObject.setBusData(agent.getAgName());
                    taskObject.setBusType(rel.getBusType());
                    taskObject.setBusId(agnetBusInfo.getId());
                }
                if (rel.getBusType().equals(BusActRelBusType.DC_Agent.name())) {
                    DateChangeRequest dateChangeRequest = (DateChangeRequest) data.get("DateChangeRequest");
                    Agent agent = agentQueryService.informationQuery(dateChangeRequest.getDataId());
                    taskObject.setBusData(agent.getAgName());
                    taskObject.setBusType(rel.getBusType());
                    taskObject.setBusId(dateChangeRequest.getId());
                }
                if (rel.getBusType().equals(BusActRelBusType.DC_Colinfo.name())) {
                    DateChangeRequest dateChangeRequest = (DateChangeRequest) data.get("DateChangeRequest");
                    Agent agent = agentQueryService.informationQuery(dateChangeRequest.getDataId());
                    taskObject.setBusData(agent.getAgName());
                    taskObject.setBusType(rel.getBusType());
                    taskObject.setBusId(dateChangeRequest.getId());
                }
                if(rel.getBusType().equals(BusActRelBusType.PkType.name())) {
                    OSupplement oSupplement = (OSupplement) data.get("OSupplement");
                    taskObject.setBusData(PkType.gePkTypeValue(oSupplement.getPkType()));
                    taskObject.setBusType(rel.getBusType());
                    taskObject.setBusId(oSupplement.getId());
                }
                if(rel.getBusType().equals(BusActRelBusType.ORDER.name())) {
                    OOrder oOrder = (OOrder) data.get("OOrder");
                    taskObject.setBusData(BusActRelBusType.ORDER.msg+":"+oOrder.getoNum());
                    taskObject.setBusType(rel.getBusType());
                    taskObject.setBusId(busActRel.getBusId());
                }
                if(rel.getBusType().equals(BusActRelBusType.COMPENSATE.name())) {
                    ORefundPriceDiff refundPriceDiff = (ORefundPriceDiff) data.get("refundrPriceDiff");
                    taskObject.setBusData(refundPriceDiff.getId());
                    taskObject.setBusType(rel.getBusType());
                    taskObject.setBusId(busActRel.getBusId());
                }
                if(rel.getBusType().equals(BusActRelBusType.refund.name())) {
                    taskObject.setBusData(BusActRelBusType.refund.msg+":"+rel.getBusId());
                    taskObject.setBusType(rel.getBusType());
                    taskObject.setBusId(busActRel.getBusId());
                }
            }
        }
        return taskObject;
    }

    @RequestMapping("/toList.htmls")
    public Object toList(final HttpServletRequest request,
                         final HttpServletResponse response
    ){
        return "activity/activityList";
    }

}

class TaskObject {
    private String id;
    private String executionId;
    private String name;
    private String procInstId;
    private String assignee;
    private Date createTime;
    private String busData;
    private String busType;
    private String busId;
    private String agName;
    private String agHead;
    private String agHeadMobile;
    private String agRegAdd;
    private String agRemark;
    private Date cTime;
    private String agDocPro;
    private String agDocDistrict;
    private String sid;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getExecutionId() {
        return executionId;
    }

    public void setExecutionId(String executionId) {
        this.executionId = executionId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


    public String getProcInstId() {
        return procInstId;
    }

    public void setProcInstId(String procInstId) {
        this.procInstId = procInstId;
    }

    public String getAssignee() {
        return assignee;
    }

    public void setAssignee(String assignee) {
        this.assignee = assignee;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }


    public String getBusData() {
        return busData;
    }

    public void setBusData(String busData) {
        this.busData = busData;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }


    public String getBusId() {
        return busId;
    }

    public void setBusId(String busId) {
        this.busId = busId;
    }

    public String getAgName() {
        return agName;
    }

    public void setAgName(String agName) {
        this.agName = agName;
    }

    public String getAgHead() {
        return agHead;
    }

    public void setAgHead(String agHead) {
        this.agHead = agHead;
    }

    public String getAgHeadMobile() {
        return agHeadMobile;
    }

    public void setAgHeadMobile(String agHeadMobile) {
        this.agHeadMobile = agHeadMobile;
    }

    public String getAgRegAdd() {
        return agRegAdd;
    }

    public void setAgRegAdd(String agRegAdd) {
        this.agRegAdd = agRegAdd;
    }

    public String getAgRemark() {
        return agRemark;
    }

    public void setAgRemark(String agRemark) {
        this.agRemark = agRemark;
    }

    public Date getcTime() {
        return cTime;
    }

    public void setcTime(Date cTime) {
        this.cTime = cTime;
    }

    public String getAgDocPro() {
        return agDocPro;
    }

    public void setAgDocPro(String agDocPro) {
        this.agDocPro = agDocPro;
    }

    public String getAgDocDistrict() {
        return agDocDistrict;
    }

    public void setAgDocDistrict(String agDocDistrict) {
        this.agDocDistrict = agDocDistrict;
    }

    public String getSid() {
        return sid;
    }

    public void setSid(String sid) {
        this.sid = sid;
    }
}
