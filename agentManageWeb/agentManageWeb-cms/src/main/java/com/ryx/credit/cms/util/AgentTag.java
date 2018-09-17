package com.ryx.credit.cms.util;

import com.ryx.credit.pojo.admin.COrganization;
import com.ryx.credit.pojo.admin.agent.Agent;
import com.ryx.credit.pojo.admin.agent.AgentBusInfo;
import com.ryx.credit.pojo.admin.agent.Region;
import com.ryx.credit.pojo.admin.bank.DPosRegion;
import org.apache.commons.lang.StringUtils;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;
import java.io.StringWriter;
import java.util.List;

/**
 * Created by cx on 2018/6/1.
 */
public class AgentTag extends SimpleTagSupport {


    private String busId;

    private String type;


    @Override
    public void doTag() throws JspException, IOException {
        try {
            if (StringUtils.isEmpty(busId)) {
                getJspContext().getOut().write("无");
                return;
            }
            switch (type) {
                case "region":
                    String regionName = ServiceFactory.regionService.getRegionName(busId);
                    if (regionName != null)
                        getJspContext().getOut().write(regionName + "");
                    else
                        getJspContext().getOut().write("无");
                    break;

                case "posRegion":
                    List<DPosRegion> dPosRegions = ServiceFactory.posRegionService.queryByCodes(busId);
                    String rname = "";
                    for (int i=0;i<dPosRegions.size();i++) {
                        rname = rname + dPosRegions.get(i).getName() + ((i!=dPosRegions.size()-1)?",":"");
                    }
                    getJspContext().getOut().write(rname);
                    break;
                case "regions":
                    String regionNames = ServiceFactory.regionService.getRegionsName(busId);
                    if (regionNames != null)
                        getJspContext().getOut().write(regionNames + "");
                    else
                        getJspContext().getOut().write("无");
                    break;
                case "dept":
                    COrganization organization = ServiceFactory.departmentService.getById(busId);
                    if (organization != null) {
                        getJspContext().getOut().write(organization.getName() + "");
                    } else {
                        getJspContext().getOut().write("无");
                    }
                    break;
                case "agentBusIdForAgent":
                    AgentBusInfo agentBusInfo = ServiceFactory.businessPlatformService.findById(busId);
                    if (agentBusInfo != null) {
                        Agent aget = ServiceFactory.agentService.getAgentById(agentBusInfo.getAgentId());
                        if (aget != null) {
                            getJspContext().getOut().write(aget.getAgName() + "");
                        } else {
                            getJspContext().getOut().write("无");
                        }
                    } else {
                        getJspContext().getOut().write("无");
                    }
                    break;
                case "agent":
                   Agent agent = ServiceFactory.agentService.getAgentById(busId);
                    if (agent != null) {
                            getJspContext().getOut().write(agent.getAgName() + "");
                    } else {
                        getJspContext().getOut().write("无");
                    }
                    break;
                default:
             /* 从内容体中使用消息 */
                    StringWriter sw = new StringWriter();
                    getJspBody().invoke(sw);
                    getJspContext().getOut().println(sw.toString());
                    break;
            }
        }catch (Exception e){
           e.printStackTrace();
           getJspContext().getOut().write("");
        }
    }


    public String getBusId() {
        return busId;
    }

    public void setBusId(String busId) {
        this.busId = busId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
