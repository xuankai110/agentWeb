package com.ryx.credit.cms.controller.agent;

import com.alibaba.fastjson.JSONObject;
import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.common.enumc.AttachmentRelType;
import com.ryx.credit.common.enumc.DataChangeApyType;
import com.ryx.credit.common.util.FastMap;
import com.ryx.credit.common.util.ResultVO;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.pojo.admin.agent.*;
import com.ryx.credit.pojo.admin.vo.AgentBusInfoVo;
import com.ryx.credit.pojo.admin.vo.AgentVo;
import com.ryx.credit.service.agent.*;
import com.ryx.credit.service.dict.DictOptionsService;
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
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by cx on 2018/6/6.
 * AgentUpdateApyController
 */
@RequestMapping("agentUpdateApy")
@Controller
public class AgentUpdateApyController  extends BaseController {


    private static Logger logger  = LoggerFactory.getLogger(AgentUpdateApyController.class);

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
    private AgentBusinfoService agentBusinfoService;


    /**
     *  /agentUpdateApy/agentBaseUpdateApyView
     * @param id
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = {"agentBaseUpdateApyView"})
    public String agentByid(String id, Model model, HttpServletRequest request){
        selectAll(id,model,request);
        return "agent/agentUpdateApy";
    }


    /**
     *  /agentUpdateApy/agentBaseUpdateApyView
     * @param id
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = {"agentByidForUpdateColInfoView"})
    public String agentByidForUpdateColInfo(String id, Model model, HttpServletRequest request){
        selectAll(id,model,request);
        return "agent/agentUpdateColInfoApy";
    }



    /**
     *代理商入网修改申请
     * /agentUpdateApy/agentBaseUpdateApy
     * @return
     */
    @ResponseBody
    @RequestMapping(value = {"agentBaseUpdateApy"},method = RequestMethod.POST)
    public ResultVO agentBaseUpdateApy(HttpServletRequest request, HttpServletResponse response,
                              @RequestBody AgentVo agentVo){
        try {

            Map olddata = selectAll(agentVo.getAgent().getId(),null,request);
            if(agentVo!=null){
                List<AgentBusInfoVo> busInfoVos =  agentVo.getBusInfoVoList();
                if(busInfoVos!=null){
                    for (AgentBusInfoVo busInfoVo : busInfoVos) {
                        if(StringUtils.isNotBlank(busInfoVo.getId()) && StringUtils.isNotBlank(busInfoVo.getBusParent())){
                            AgentBusInfo agentBusInfo =   agentBusinfoService.getById(busInfoVo.getBusParent());
                            if(agentBusInfo!=null && StringUtils.isNotBlank(busInfoVo.getBusPlatform())){
                                if(!agentBusInfo.getBusPlatform().equals(busInfoVo.getBusPlatform())){
                                   return ResultVO.fail("业务平台上级和业务平台类型不匹配，请检查"+busInfoVo.getBusNum()+"业务上级");
                                }
                            }
                        }
                    }
                }
            }
            String data = JSONObject.toJSONString(agentVo);
            String old = JSONObject.toJSONString(olddata);
            return dateChangeReqService.dateChangeReqIn(data,old,agentVo.getAgent().getId(), DataChangeApyType.DC_Agent.name(),getUserId()+"");
        } catch (Exception e) {
            logger.info("代理商修改错误{}{}{}",getUserId()+"",agentVo.getAgent().getId(),e.getMessage());
            e.printStackTrace();
            return ResultVO.fail(e.getMessage());
        }

    }
    /**
     * 代理商入网收款信息修改
     * /agentUpdateApy/agentColInfoUpdateApy
     * @return
     */
    @ResponseBody
    @RequestMapping(value = {"agentColInfoUpdateApy"},method = RequestMethod.POST)
    public ResultVO agentColInfoUpdateApy(HttpServletRequest request, HttpServletResponse response,
                                       @RequestBody AgentVo agentVo){
        try {
            String data = JSONObject.toJSONString(agentVo);
            String old = JSONObject.toJSONString(selectAll(agentVo.getAgent().getId(),null,request));
            return dateChangeReqService.dateChangeReqIn(data,old,agentVo.getAgent().getId(), DataChangeApyType.DC_Colinfo.name(),getUserId()+"");
        } catch (Exception e) {
            logger.info("代理商修改错误{}{}{}",getUserId()+"",agentVo.getAgent().getId(),e.getMessage());
            e.printStackTrace();
            return ResultVO.fail(e.getMessage());
        }

    }






    public Map selectAll(String id, Model model, HttpServletRequest request){
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
        if(busIds.size()>0) {
            assProtoColRelList = agentAssProtocolService.queryProtoColByBusIds(busIds);
        }
        List<AssProtoCol> ass = agentAssProtocolService.queryProtocol(null, null);
        if(model!=null) {
            model.addAttribute("assProtoColRelList", assProtoColRelList);
            model.addAttribute("ass", ass);
            model.addAttribute("agent", agent);
            model.addAttribute("agentColinfos", agentColinfos);
            model.addAttribute("capitals", capitals);
            model.addAttribute("agentContracts", agentContracts);
            model.addAttribute("agentBusInfos", agentBusInfos);
            model.addAttribute("attachment", attachment);
        }
        optionsData(request);
        return FastMap.fastMap("agent",agent)
                .putKeyV("capitalVoList",capitals)
                .putKeyV("contractVoList",agentContracts)
                .putKeyV("busInfoVoList",agentBusInfos)
                .putKeyV("colinfoVoList",agentColinfos);
    }


}
