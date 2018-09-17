package com.ryx.credit.cms.controller.agent;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.pojo.admin.CUser;
import com.ryx.credit.pojo.admin.agent.AgentPlatFormSyn;
import com.ryx.credit.service.IUserService;
import com.ryx.credit.service.agent.AgentNotifyService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @ClassName AgentNotifyController
 * @Description lrr
 * @Author RYX
 * @Date 2018/6/11
 **/
@RequestMapping("notification")
@Controller
public class AgentNotifyController extends BaseController {
    private static Logger logger = LoggerFactory.getLogger(AgentBusinfoController.class);

    @Autowired
    private AgentNotifyService agentNotifyService;
    @Autowired
    private IUserService userService;

    @RequestMapping(value = {"/", "index"})
    public String index(HttpServletRequest request) {
        return "agent/agentNotifyQuery";
    }

    @ResponseBody
    @RequestMapping(value = {"/", "agentNotifyQuery"})
    public Object agentNotifyQuery(HttpServletRequest request,AgentPlatFormSyn agentPlatFormSyn) {
        Page page = pageProcess(request);
        PageInfo pageInfo = agentNotifyService.queryList(page, agentPlatFormSyn);
        List<AgentPlatFormSyn> rows = pageInfo.getRows();
        for (AgentPlatFormSyn row : rows) {
            Pattern pattern = Pattern.compile("[0-9]*$");
            Matcher isNum = pattern.matcher(row.getcUser());
            if(isNum.matches() ){
                CUser user = userService.selectById(Integer.parseInt(row.getcUser()));
                if(null!=user)
                row.setcUser(user.getName());
            }
        }
        request.setAttribute("ablePlatForm", ServiceFactory.businessPlatformService.queryAblePlatForm());
        return pageInfo;
    }

    /**
     * 手动通知
     * @param busId
     */
    @RequestMapping("manualNotify")
    @ResponseBody
    public void manualNotify(String busId){
        agentNotifyService.asynNotifyPlatform(busId);
    }


    @RequestMapping("manualEnterInUpdateLevelNotify")
    @ResponseBody
    public void manualEnterInUpdateLevelNotify(String id){
        logger.info("用户{}调用manualEnterInUpdateLevelNotify{}",getUserId()+"",id);
        try {
            agentNotifyService.userNotifyPlatformLevelAndUpdateAsynById(id,getUserId()+"");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @RequestMapping("manualEnterInUpdateNotify")
    @ResponseBody
    public void manualEnterInUpdateNotify(String busId){
        logger.info("用户{}manualEnterInUpdateNotify{}",getUserId()+"",busId);
        try {
            agentNotifyService.notifyPlatformUpadteByBusId(busId,getUserId()+"");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 手动通知
     * @param
     */
    @RequestMapping("manualNotifyAll")
    @ResponseBody
    public void manualNotifyAll(){
        agentNotifyService.asynNotifyPlatform();
    }

}
