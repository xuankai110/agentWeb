package com.ryx.credit.cms.controller.agent;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.enumc.AgStatus;
import com.ryx.credit.common.enumc.DictGroup;
import com.ryx.credit.common.util.FastMap;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.common.util.ResultVO;
import com.ryx.credit.pojo.admin.agent.Agent;
import com.ryx.credit.pojo.admin.agent.Dict;
import com.ryx.credit.service.agent.AgentBusinfoService;
import com.ryx.credit.service.agent.AgentService;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 代理商
 * Created by cx on 2018/5/23.
 */
@RequestMapping("abusinfo")
@Controller
public class AgentBusinfoController extends BaseController {


    private static Logger logger  = LoggerFactory.getLogger(AgentBusinfoController.class);


    @Autowired
    private AgentBusinfoService agentBusinfoService;
    @Autowired
    private AgentService agentService;


    /**
     * abusinfo/agentSelectDialogView
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "agentSelectDialogView")
    public String agentSelectDialogView(HttpServletRequest request, HttpServletResponse response){
         request.setAttribute("ablePlatForm", ServiceFactory.businessPlatformService.queryAblePlatForm());
         String  busPlatform = request.getParameter("busPlatform");
         request.setAttribute("busPlatform", busPlatform);
         return "agent/agentSelectDialog";
    }

    /**
     * 代理商选择
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "agentInfoSelectDialogView")
    public String agentInfoSelectDialogView(HttpServletRequest request, HttpServletResponse response){
        List<Dict> agStatusList = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.AG_STATUS_S.name());
        request.setAttribute("agStatusList", agStatusList);
        return "agent/agentInfoSelectDialog";
    }
    /**
     * 代理商业务选择
     * abusinfo/agentSelectDialog
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "agentSelectDialog")
    public PageInfo agentSelectDialog(HttpServletRequest request, HttpServletResponse response){
        String name = request.getParameter("name");
        String busPlatform = request.getParameter("busPlatform");
        String clo_review_status = request.getParameter("clo_review_status");

        if(StringUtils.isNotEmpty(name)){name = name.trim();}
        if(StringUtils.isEmpty(clo_review_status)){clo_review_status = "3";}

        Page page = pageProcess(request);
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), "seq", "desc");
        pageInfo= agentBusinfoService.agentBusInfoSelectViewList(FastMap.fastMap("search_name",name)
                .putKeyV("busPlatform",busPlatform)
                .putKeyV("clo_review_status",clo_review_status),pageInfo);
        return pageInfo;
    }


    /**
     * abusinfo/agentInfoSelectDialog
     * @param request
     * @param response
     * @param agent
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "agentInfoSelectDialog")
    public PageInfo agentInfoSelectDialog(HttpServletRequest request, HttpServletResponse response, Agent agent){
        Page page = pageProcess(request);
        agent.setAgStatus(AgStatus.Approved.name());
        PageInfo pageInfo = new PageInfo(page.getCurrent(), page.getLength(), null, null);
        pageInfo = agentService.queryAgentList(pageInfo, agent);
        return pageInfo;
    }






}
