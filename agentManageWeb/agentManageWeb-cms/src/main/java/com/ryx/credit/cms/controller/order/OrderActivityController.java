package com.ryx.credit.cms.controller.order;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.controller.DateUtil;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.enumc.DictGroup;
import com.ryx.credit.common.exception.MessageException;
import com.ryx.credit.common.result.AgentResult;
import com.ryx.credit.common.util.*;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.pojo.admin.CUser;
import com.ryx.credit.pojo.admin.agent.Dict;
import com.ryx.credit.pojo.admin.agent.PlatForm;
import com.ryx.credit.pojo.admin.order.OActivity;
import com.ryx.credit.pojo.admin.order.OProduct;
import com.ryx.credit.pojo.admin.vo.OActivityVo;
import com.ryx.credit.service.IUserService;
import com.ryx.credit.service.dict.DictOptionsService;
import com.ryx.credit.service.order.OrderActivityService;
import com.ryx.credit.service.order.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.List;

/**
 * 活动控制层
 *
 * @version V1.0
 * @Description:
 * @author: Liudh
 * @date: 2018/7/16 18:30
 */
@RequestMapping("activity")
@Controller
public class OrderActivityController extends BaseController {

    @Autowired
    private OrderActivityService orderActivityService;
    @Autowired
    private DictOptionsService dictOptionsService;
    @Autowired
    private IUserService userService;
    @Autowired
    private ProductService productService;


    @RequestMapping(value = "toActivityList")
    public String toActivityList(HttpServletRequest request, OProduct product) {
        List<PlatForm> platFormList = ServiceFactory.businessPlatformService.queryAblePlatForm();
        request.setAttribute("platFormList", platFormList);
        return "order/activityList";
    }

    @RequestMapping(value = "activityList")
    @ResponseBody
    public Object activityList(HttpServletRequest request, OActivity activity) {
        Page pageInfo = pageProcess(request);
        PageInfo resultPageInfo = orderActivityService.activityList(activity, pageInfo);
        List<OActivity> rows = resultPageInfo.getRows();
        rows.forEach(row -> {
            Dict dict = dictOptionsService.findDictByValue(DictGroup.ORDER.name(), DictGroup.MODEL_TYPE.name(), row.getProType());
            if (dict != null)
                row.setProType(dict.getdItemname());
            if (StringUtils.isNotBlank(row.getcUser())) {
                CUser cUser = userService.selectById(row.getcUser());
                row.setcUser(cUser.getName());
            }
            if (StringUtils.isNotBlank(row.getuUser())) {
                CUser uUser = userService.selectById(row.getuUser());
                row.setuUser(uUser.getName());
            }
            String productName = productService.findNameById(row.getProductId());
            if (StringUtils.isNotBlank(productName)) {
                row.setProductId(productName);
            }
            if (null != row.getActivityWay()) {
                Dict disDict = dictOptionsService.findDictByValue(DictGroup.ORDER.name(), DictGroup.ACTIVITY_DIS_TYPE.name(), row.getActivityWay());
                if (disDict != null)
                    row.setActivityWay(disDict.getdItemname());
            }
            if (null != row.getVender()) {
                Dict dictByValue = dictOptionsService.findDictByValue(DictGroup.ORDER.name(), DictGroup.MANUFACTURER.name(), row.getVender());
                if (null != dictByValue)
                    row.setVender(dictByValue.getdItemname());
            }
            if (null != row.getActivityCondition()) {
                Dict dictByValue = dictOptionsService.findDictByValue(DictGroup.ORDER.name(), DictGroup.ACTIVITY_CONDITION.name(), row.getActivityCondition());
                if (null != dictByValue)
                    row.setActivityCondition(dictByValue.getdItemname());
            }
        });
        return resultPageInfo;
    }


    @RequestMapping(value = "toActivityAdd")
    public String toActivityAdd(HttpServletRequest request, OActivity activity) {
        orderDictData(request);
        List<OProduct> productList = productService.allProductList(new OProduct());
        if (null != productList && productList.size() > 0) {
            for (OProduct oProduct : productList) {
                Dict dictByValue = dictOptionsService.findDictByValue(DictGroup.ORDER.name(), DictGroup.MANUFACTURER.name(), oProduct.getProCom());
                if (null!=dictByValue)
                oProduct.setName(dictByValue.getdItemname());
                Dict byValue = dictOptionsService.findDictByValue(DictGroup.ORDER.name(), DictGroup.MODEL_TYPE.name(), oProduct.getProType());
                if (null!=byValue)
                oProduct.setProTypeName(byValue.getdItemname());
            }
        }
        request.setAttribute("productList", productList);
        return "order/activityAdd";
    }

    @RequestMapping(value = "activityAdd")
    @ResponseBody
    public ResultVO activityAdd(HttpServletRequest request, OActivityVo activityVo) throws MessageException {
       try {
           String userId = String.valueOf(getUserId());
           activityVo.setcUser(userId);
           activityVo.setuUser(userId);
           if (StringUtils.isNotBlank(activityVo.getBeginTimeStr())) {
               activityVo.setBeginTime(DateUtils.stringToDate(activityVo.getBeginTimeStr()));
           }
           if (StringUtils.isNotBlank(activityVo.getEndTimeStr())) {
               activityVo.setEndTime(DateUtils.stringToDate(activityVo.getEndTimeStr()));
           }
           ResultVO resultVO = orderActivityService.saveActivity(activityVo);
       }catch (Exception e) {
           e.printStackTrace();
           if(e instanceof MessageException){
               String msg = ((MessageException) e).getMsg();
               return ResultVO.fail(msg);
           }
           return ResultVO.fail(e.getMessage());
       }
        return ResultVO.success(null);
    }

    @RequestMapping(value = "toActivityEdit")
    public String toActivityEdit(HttpServletRequest request, OActivity activity) {
        orderDictData(request);
        List<OProduct> productList = productService.allProductList(new OProduct());
        if (null != productList && productList.size() > 0) {
            for (OProduct oProduct : productList) {
                Dict dictByValue = dictOptionsService.findDictByValue(DictGroup.ORDER.name(), DictGroup.MANUFACTURER.name(), oProduct.getProCom());
                if (null!=dictByValue)
                    oProduct.setName(dictByValue.getdItemname());
                Dict byValue = dictOptionsService.findDictByValue(DictGroup.ORDER.name(), DictGroup.MODEL_TYPE.name(), oProduct.getProType());
                if (null!=byValue)
                    oProduct.setProTypeName(byValue.getdItemname());
            }
        }
        OActivity oActivity = orderActivityService.findById(activity.getId());
        Dict dictByValue = dictOptionsService.findDictByValue(DictGroup.ORDER.name(), DictGroup.MANUFACTURER.name(), oActivity.getVender());
        if (StringUtils.isNotBlank(dictByValue.getdItemname())) {
            oActivity.setVenderName(dictByValue.getdItemname());
        }
        Dict byValue = dictOptionsService.findDictByValue(DictGroup.ORDER.name(), DictGroup.MODEL_TYPE.name(), oActivity.getProType());
        if (StringUtils.isNotBlank(byValue.getdItemname()))
            oActivity.setProTypeName(byValue.getdItemname());
        request.setAttribute("productList", productList);
        request.setAttribute("oActivity", oActivity);
        return "order/activityEdit";
    }

    @RequestMapping(value = "activityEdit")
    @ResponseBody
    public Object activityEdit(HttpServletRequest request, OActivityVo activityVo) {
        String userId = String.valueOf(getUserId());
        activityVo.setuUser(userId);
        if (StringUtils.isNotBlank(activityVo.getBeginTimeStr())) {
            activityVo.setBeginTime(DateUtils.stringToDate(activityVo.getBeginTimeStr()));
        }
        if (StringUtils.isNotBlank(activityVo.getEndTimeStr())) {
            activityVo.setEndTime(DateUtils.stringToDate(activityVo.getEndTimeStr()));
        }
        AgentResult agentResult = orderActivityService.updateActivity(activityVo);
        if (agentResult.isOK()) {
            return renderSuccess("修改成功！");
        }
        return renderSuccess("修改失败！");
    }


    @RequestMapping(value = "activityDel")
    @ResponseBody
    public Object activityDel(HttpServletRequest request, String id) {
        AgentResult agentResult = orderActivityService.deleteById(id);
        if (agentResult.isOK()) {
            return renderSuccess("删除成功！");
        }
        return renderSuccess("删除失败！");
    }


    /**
     * activity/queryAllActivity
     *
     * @return
     */
    @RequestMapping(value = "queryAllActivity")
    @ResponseBody
    public List<OActivity> queryAllActivity() {
        List<OActivity> allActivityList = orderActivityService.allActivity();
        if (null == allActivityList && allActivityList.size() == 0) {
            return Arrays.asList();
        }
        return allActivityList;
    }


    /**
     * 根据商品ID查询能够使用的活动信息
     * activity/queryProductCanActivity
     *
     * @param request
     * @param proId
     * @param agentId
     * @return
     */
    @RequestMapping(value = "queryProductCanActivity")
    @ResponseBody
    public List<OActivity> queryProductCanActivity(HttpServletRequest request,
                                                   @RequestParam("proId") String proId,
                                                   @RequestParam("agentId") String agentId) {
        return orderActivityService.productActivity(proId, agentId);
    }

}
