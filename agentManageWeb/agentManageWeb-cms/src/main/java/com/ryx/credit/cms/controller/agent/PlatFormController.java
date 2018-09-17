package com.ryx.credit.cms.controller.agent;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.common.enumc.Status;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.pojo.admin.agent.PlatForm;
import com.ryx.credit.service.agent.PlatFormService;
import org.codehaus.groovy.runtime.powerassert.SourceText;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.sound.midi.Soundbank;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author Lihl
 * @Date 2018/07/19
 * 业务平台
 */
@Controller
@RequestMapping("/platForm")
public class PlatFormController extends BaseController{
    @Resource
    private PlatFormService platformService;


    @GetMapping("/selectPlatform")
    public String selectPlatform() {
        return "agent/platForm";
    }

    /**
     * 分页展示
     */
    @PostMapping("/platFormList")
    @ResponseBody
    public Object platFormList(PlatForm platForm, Integer page, Integer rows, String sort, String order) {
        PageInfo pageInfo = new PageInfo(page, rows, sort, order);
        Map<String, Object> condition = new HashMap<String, Object>();
        if(platForm.getId()!=null){
            condition.put("id", platForm.getId());
        }
        if(platForm.getPlatformNum()!=null){
            condition.put("platformNum", platForm.getPlatformNum());
        }
        if(platForm.getPlatformName()!=null){
            condition.put("platformName", platForm.getPlatformName());
        }
        if(platForm.getcTime()!=null){
            condition.put("cTime", platForm.getcTime());
        }
        if(platForm.getcUtime()!=null){
            condition.put("cUtime", platForm.getcUtime());
        }
        if(platForm.getcUser()!=null){
            condition.put("cUser", platForm.getcUser());
        }
        if(platForm.getVersion()!=null){
            condition.put("version", platForm.getVersion());
        }
        if(platForm.getPlatformType()!=null){
            condition.put("platformType", platForm.getPlatformType());
        }
        if(platForm.getPlatformStatus()!=null){
            condition.put("platformStatus", platForm.getPlatformStatus());
        }
//        condition.put("platformStatus", Status.STATUS_1.status);
        condition.put("status", Status.STATUS_1.status);
        pageInfo.setCondition(condition);

        return platformService.platFormList(pageInfo);
    }

    @GetMapping("/addPlatFormPage")
    public String addPlatFormPage() {
        return "agent/platFormAdd";
    }

    /**
     * 新增
     */
    @RequestMapping("/addPlatForm")
    @ResponseBody
    public Object addPlatForm(PlatForm platForm) {
        platForm.setcTime(new Date());    // 创建时间
        platForm.setcUtime(new Date());    // 更新时间
        platformService.insertPlatForm(platForm);

        return renderSuccess("添加成功！");
    }

    /**
     * 删除
     * （编辑此条数据的状态）
     */
    @RequestMapping("/deletePlatForm")
    @ResponseBody
    public Object deletePlatForm(PlatForm platForm){
        platformService.updateByPrimaryKeySelective(platForm);

        return renderSuccess("编辑状态成功！");
    }

    @RequestMapping("/editPlatFormPage")
    public String editProductSharePage(String id, Model model){
        PlatForm platForm = platformService.selectByPrimaryKey(id);
//        if(platForm.getcTime() != null){
//            Timestamp cTime = new Timestamp(platForm.getcTime().getTime());  //创建时间
//            platForm.setcTime(cTime);
//        }
//        if(platForm.getcUtime() != null){
//            Timestamp cUtime = new Timestamp(platForm.getcUtime().getTime());  //更新时间
//            platForm.setcTime(cUtime);
//        }
        model.addAttribute("PlatForm",platForm);
        return "agent/platFormEdit";
    }

    /**
     * 编辑
     */
    @RequestMapping("/editPlatForm")
    @ResponseBody
    public Object editProductShare(PlatForm platForm){
        platForm.setcUtime(new Date());    // 更新时间
        platformService.updateByPrimaryKey(platForm);

        return renderSuccess("编辑成功！");
    }

}
