package com.ryx.credit.cms.controller.agent;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ExcelExportSXXSSF;
import com.ryx.credit.cms.util.MyUtil;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.enumc.AttachmentRelType;
import com.ryx.credit.common.enumc.BusActRelBusType;
import com.ryx.credit.common.enumc.DictGroup;
import com.ryx.credit.common.exception.ProcessException;
import com.ryx.credit.common.util.FastMap;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.common.util.ResultVO;
import com.ryx.credit.pojo.admin.agent.*;
import com.ryx.credit.pojo.admin.vo.AgentVo;
import com.ryx.credit.pojo.admin.vo.AgentoutVo;
import com.ryx.credit.service.IUserService;
import com.ryx.credit.service.agent.*;
import com.ryx.credit.service.dict.DictOptionsService;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedOutputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by cx on 2018/5/23.
 */
@RequestMapping("agentEnter")
@Controller
public class AgentEnterController extends BaseController {


    private static Logger logger = LoggerFactory.getLogger(AgentBusinfoController.class);

    @Autowired
    private AgentService agentService;
    @Autowired
    private DictOptionsService dictOptionsService;
    @Autowired
    private AgentQueryService agentQueryService;
    @Autowired
    private BusinessPlatformService businessPlatformService;
    @Autowired
    private AgentEnterService agentEnterService;
    @Autowired
    private ApaycompService apaycompService;
    @Autowired
    private DateChangeReqService dateChangeReqService;
    @Autowired
    private AgentAssProtocolService agentAssProtocolService;
    @Autowired
    private TaskApprovalService taskApprovalService;
    @Autowired
    private AgentActivityController agentActivityController;
    @Autowired
    private IUserService iUserService;


    /**
     * agent入网信息录入
     * agentEnter/index
     *
     * @return
     */
    @RequestMapping(value = {"/", "index"})
    public String enterView(HttpServletRequest request) {
        List<Dict> agStatusList = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.AG_STATUS_S.name());
        List<PlatForm> platFormList = ServiceFactory.businessPlatformService.queryAblePlatForm();
        request.setAttribute("agStatusList", agStatusList);
        request.setAttribute("platFormList", platFormList);
        request.setAttribute("userId",String.valueOf(getUserId()));
        return "agent/agentNetIn";
    }


    /**
     * 代理商单表列表
     * agentEnter/agentList
     *
     * @param request
     * @param response
     * @param agent
     * @return
     */
    @ResponseBody
    @RequestMapping(value = {"agentList", "list"})
    public PageInfo angetList(HttpServletRequest request, HttpServletResponse response, Agent agent) {
        Page page = pageProcess(request);
        agent.setcUser(String.valueOf(getUserId()));
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), null, null);
        pageInfo = agentService.queryAgentList(pageInfo, agent);
        return pageInfo;
    }


    @ResponseBody
    @RequestMapping(value = "agentAll")
    public PageInfo agentAll(HttpServletRequest request) {
        Page pageInfo = pageProcess(request);
        FastMap par = FastMap.fastMap("agUniqNum", request.getParameter("agUniqNum"))
                .putKeyV("agName", request.getParameter("agName"))
                .putKeyV("busPlatform", request.getParameter("busPlatform"))
                .putKeyV("busNum", request.getParameter("busNum"))
                .putKeyV("agStatus", request.getParameter("agStatus"))
                .putKeyV("time", request.getParameter("time"))
                .putKeyV("agDocDistrict", request.getParameter("agDocDistrict"))
                .putKeyV("flag", request.getParameter("flag"));
        Long userId = getUserId();
        PageInfo info = agentService.queryAgentAll(pageInfo, par,userId);
        return info;
    }


    /**
     * 代理商入网表单
     * agentEnter/agentForm
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = {"agentForm", "form"})
    public String agentNetInFormView(HttpServletRequest request, HttpServletResponse response) {
        optionsData(request);
        List<AssProtoCol> ass = agentAssProtocolService.queryProtocol(null, null);
        request.setAttribute("ass", ass);
        //当前登录用户所属省区
        List<Map<String, Object>> userOrg = iUserService.orgCode(getUserId());
        if (userOrg.size() > 0) {
            request.setAttribute("userOrg", userOrg.get(0));
        }
        return "agent/agentNetInForm";
    }


    /**
     * 代理商入网信息保存
     * agentEnter/agentEnterIn
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = {"agentEnterIn"}, method = RequestMethod.POST)
    public ResultVO agentEnterIn(HttpServletRequest request, HttpServletResponse response,
                                 @RequestBody AgentVo agentVo) {
        try {
            Agent a = agentVo.getAgent();
            a.setcUser(getUserId() + "");
            ResultVO res = agentEnterService.agentEnterIn(agentVo);
            return res;
        } catch (ProcessException e) {
            return ResultVO.fail(e.getMsg());
        }


    }

    /**
     * 代理商保存并审核
     */


    @ResponseBody
    @RequestMapping(value = {"saveAndaudit"}, method = RequestMethod.POST)
    public ResultVO saveAndaudit(HttpServletRequest request, HttpServletResponse response,
                                 @RequestBody AgentVo agentVo) {

        try {
            ResultVO rv = new ResultVO();
            Agent a = agentVo.getAgent();
            a.setcUser(getUserId() + "");
            ResultVO res = agentEnterService.agentEnterIn(agentVo);
            if (null != res.getObj()) {
                AgentVo agentVos = (AgentVo) res.getObj();
                String agentId = agentVos.getAgent().getId();
                rv = agentEnterService.startAgentEnterActivity(agentId, getUserId() + "");
            }
            return rv;
        } catch (ProcessException e) {
            return ResultVO.fail(e.getMessage());
        }

    }

    /**
     * 代理商入网查看
     * /agentEnter/agentQuery
     *
     * @return
     */
    @RequestMapping(value = {"agentQuery"})
    public String agentQuery(String id, String agStatus, Model model, HttpServletRequest request) {
        selectAll(id, model, request);
        request.setAttribute("agStatus", agStatus);
        request.setAttribute("busIdImg", id);
        request.setAttribute("busTypeImg", BusActRelBusType.Agent.name());
        BusActRel busActRel = taskApprovalService.queryBusActRel(id, BusActRelBusType.Agent.name(), agStatus);
        List<Map<String, Object>> actRecordList = null;
        if (busActRel != null) {
            actRecordList = agentActivityController.queryApprovalRecord(busActRel.getActivId());
        }
        request.setAttribute("actRecordList", actRecordList);
        return "agent/agentQuery";
    }


    /**
     * /agentEnter/agentByid?id={agentid}
     *
     * @param id
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = {"agentByid"})
    public String agentByid(String id, Model model, HttpServletRequest request) {
        selectAll(id, model, request);
        return "agent/agentEdit";
    }

    /**
     * 信息展示
     * /agentEnter/agentInfo?id={agentid}
     *
     * @param id
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = {"agentInfo"})
    public String agentInfo(String id, Model model, HttpServletRequest request) {
        selectAll(id, model, request);
        return "agent/agentInfo";
    }

    /**
     * 代理商入网修改
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = {"agentEdit"}, method = RequestMethod.POST)
    public ResultVO agentEdit(HttpServletRequest request, HttpServletResponse response,
                              @RequestBody AgentVo agentVo) {
        try {
            return agentEnterService.updateAgentVo(agentVo, getUserId() + "");
        } catch (Exception e) {
            logger.info("代理商修改错误{}{}{}", getUserId() + "", agentVo.getAgent().getId(), e.getMessage());
            e.printStackTrace();
            return ResultVO.fail(e.getMessage());
        }

    }

    /**
     * 代理商入网的导出
     */
    @RequestMapping("exportAgent")
    public void exportUserHistory(HttpServletResponse response, HttpServletRequest request) throws Exception {
        FastMap par = FastMap.fastMap("agUniqNum", request.getParameter("agUniqNum"))
                .putKeyV("agName", request.getParameter("agName"))
                .putKeyV("busPlatform", request.getParameter("busPlatform"))
                .putKeyV("busNum", request.getParameter("busNum"))
                .putKeyV("agStatus", request.getParameter("agStatus"))
                .putKeyV("time", request.getParameter("time"))
                .putKeyV("agDocDistrict", request.getParameter("agDocDistrict"))
                .putKeyV("flag", request.getParameter("flag"));
        Long userId = getUserId();
        List<AgentoutVo> list = agentEnterService.exportAgent(par,userId);
        String filePath = "C:/upload/";
        String filePrefix = "TH";
        int flushRows = 100;
        List<String> fieldNames = null;
        List<String> fieldCodes = null;
        //指导导出数据的title
        fieldNames = new ArrayList<String>();
        fieldCodes = new ArrayList<String>();
        fieldNames.add("编号");
        fieldCodes.add("id");
        fieldNames.add("代理商");
        fieldCodes.add("agName");
        fieldNames.add("代理商唯一编号");
        fieldCodes.add("agUniqNum");
        fieldNames.add("公司负责人");
        fieldCodes.add("agHead");

        fieldNames.add("业务平台");
        fieldCodes.add("busPlatform");
        fieldNames.add("业务平台编号");
        fieldCodes.add("busNum");
        fieldNames.add("类型");
        fieldCodes.add("busType");
        fieldNames.add("直属上级代理");
        fieldCodes.add("busParent");
        fieldNames.add("二阶上级代理");
        fieldCodes.add("twoParentId");
        fieldNames.add("三阶上级代理");
        fieldCodes.add("threeParentId");


        fieldNames.add("风险承担所属代理商");
        fieldCodes.add("busRiskParent");
        fieldNames.add("激活及返现所属代理商");
        fieldCodes.add("busActivationParent");
        fieldNames.add("是否直发");
        fieldCodes.add("busSentDirectly");
        fieldNames.add("是否独立考核");
        fieldCodes.add("busIndeAss");
        fieldNames.add("业务范围");
        fieldCodes.add("busScope");
        fieldNames.add("业务区域");
        fieldCodes.add("busRegion");


        fieldNames.add("收款账户类型");
        fieldCodes.add("cloString");
        fieldNames.add("收款账户名");
        fieldCodes.add("cloRealname");
        fieldNames.add("收款账号");
        fieldCodes.add("cloBankAccount");
        fieldNames.add("收款开户总行");
        fieldCodes.add("cloBank");
        fieldNames.add("开户地区");
        fieldCodes.add("bankRegion");
        fieldNames.add("收款开户支行");
        fieldCodes.add("cloBankBranch");
        fieldNames.add("总行联行号");
        fieldCodes.add("allLineNum");
        fieldNames.add("支行联行号");
        fieldCodes.add("branchLineNum");
        fieldNames.add("税点");
        fieldCodes.add("point");
        fieldNames.add("是否开具分润发票");
        fieldCodes.add("yesOrNo");
        fieldNames.add("打款公司");
        fieldCodes.add("cloPayCompany");


        ExcelExportSXXSSF excelExportSXXSSF;
        excelExportSXXSSF = ExcelExportSXXSSF.start(filePath, "/upload/", filePrefix, fieldNames, fieldCodes, flushRows);
        //执行导出
        excelExportSXXSSF.writeDatasByObject(list);
        String filename = filePrefix + "_" + MyUtil.getCurrentTimeStr() + ".xlsx";
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-disposition", "attachment;filename=" + filename);
        OutputStream outputStream = new BufferedOutputStream(response.getOutputStream());
        excelExportSXXSSF.getWb().write(outputStream);
        outputStream.flush();
        outputStream.close();
    }

    public void selectAll(String id, Model model, HttpServletRequest request) {
        Agent agent = agentQueryService.informationQuery(id);
        List<AgentColinfo> agentColinfos = agentQueryService.proceedsQuery(id);
        List<Capital> capitals = agentQueryService.paymentQuery(id);
        List<AgentContract> agentContracts = agentQueryService.compactQuery(id);
        List<AgentBusInfo> agentBusInfos = agentQueryService.businessQuery(id);
        List<Attachment> attachment = agentQueryService.accessoryQuery(id, AttachmentRelType.Agent.name());

        List<String> busIds = new ArrayList<>();
        for (AgentBusInfo agentBusInfo : agentBusInfos) {
            busIds.add(agentBusInfo.getId());
        }
        List<AssProtoColRel> assProtoColRelList = new ArrayList<>();
        if (busIds.size() > 0) {
            assProtoColRelList = agentAssProtocolService.queryProtoColByBusIds(busIds);
        }
        List<AssProtoCol> ass = agentAssProtocolService.queryProtocol(null, null);
        model.addAttribute("assProtoColRelList", assProtoColRelList);
        model.addAttribute("ass", ass);
        model.addAttribute("agent", agent);
        model.addAttribute("agentColinfos", agentColinfos);
        model.addAttribute("capitals", capitals);
        model.addAttribute("agentContracts", agentContracts);
        model.addAttribute("agentBusInfos", agentBusInfos);
        model.addAttribute("attachment", attachment);
        optionsData(request);
    }
}
