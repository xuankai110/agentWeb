package com.ryx.credit.cms.controller.profit;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.profit.pojo.PosRewardTemplate;
import com.ryx.credit.profit.service.PosRewardTemplateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

/**
 * 〈pos奖励模板〉
 *
 * @author zhaodw
 * @create 2018/7/24
 * @since 1.0.0
 */
@Controller
@RequestMapping("/posRewardTemp")
public class PosTemplateController extends BaseController {

    @Autowired
    private PosRewardTemplateService posRewardTemplateService;

    @RequestMapping("/pageList")
    public String rewardTempPage() {
        return "profit/rewardTemp/rewardTempList";
    }

    @RequestMapping("/list")
    @ResponseBody
    public Object getRewardTemplateList(HttpServletRequest request) {
        Page page = pageProcess(request);
        PageInfo pageInfo = posRewardTemplateService.getPosRewardTemplateList(page);
        return pageInfo;
    }

    @RequestMapping("/editPage")
    public ModelAndView getPosRewardTemplate(String id) {
        if (StringUtils.isNotBlank(id)) {
            PosRewardTemplate posRewardTemplate = posRewardTemplateService.getPosRewardTemplate(id);
            ModelAndView modelAndView = new ModelAndView();
            modelAndView.setViewName("profit/rewardTemp/rewardTempEdit");
            modelAndView.addObject("posRewardTemplate", posRewardTemplate);
            return modelAndView;
        }
        return null;
    }

    @RequestMapping("/edit")
    @ResponseBody
    public Object editPosRewardTemplate(PosRewardTemplate posRewardTemplate) {
        if (posRewardTemplate == null) {
            return renderError("系统异常，请联系维护人员！");
        }
        if(StringUtils.isBlank(posRewardTemplate.getActivityValid())
                || StringUtils.isBlank(posRewardTemplate.getCreditTranContrastMonth())
                || StringUtils.isBlank(posRewardTemplate.getTranContrastMonth())
                || StringUtils.isBlank(posRewardTemplate.getProportion().toString())
                || StringUtils.isBlank(posRewardTemplate.getTranTotalEnd().toString())
                || StringUtils.isBlank(posRewardTemplate.getTranTotalStart().toString())){
            return renderError("请填写完毕");
        }
        try {
            posRewardTemplate.setUpdateTime(new Date());
            posRewardTemplate.setOperUser(getShiroUser().getLoginName());
            posRewardTemplateService.updatePosRewardTemplate(posRewardTemplate);
            return renderSuccess("Pos奖励模板修改成功！");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return renderError("系统异常，请联系维护人员！");
    }

    @RequestMapping("/addPage")
    public ModelAndView addPosRewardTemplatePage() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("profit/rewardTemp/rewardTempAdd");
        return modelAndView;
    }

    @RequestMapping("/add")
    @ResponseBody
    public Object addPosRewardTemplate(PosRewardTemplate posRewardTemplate) {
        if (posRewardTemplate == null) {
            return renderError("系统异常，请联系维护人员！");
        }
        if(StringUtils.isBlank(posRewardTemplate.getActivityValid())
                || StringUtils.isBlank(posRewardTemplate.getCreditTranContrastMonth())
                || StringUtils.isBlank(posRewardTemplate.getTranContrastMonth())
                || StringUtils.isBlank(posRewardTemplate.getProportion().toString())
                || StringUtils.isBlank(posRewardTemplate.getTranTotalEnd().toString())
                || StringUtils.isBlank(posRewardTemplate.getTranTotalStart().toString())){
            return renderError("请填写完毕");
        }
        try {
            posRewardTemplate.setCreateTime(new Date());
            posRewardTemplate.setUpdateTime(new Date());
            posRewardTemplate.setOperUser(getShiroUser().getLoginName());
            posRewardTemplateService.insertPosRewardTemplate(posRewardTemplate);
            return renderSuccess("Pos奖励模板修改成功！");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return renderError("系统异常，请联系维护人员！");
    }
}
