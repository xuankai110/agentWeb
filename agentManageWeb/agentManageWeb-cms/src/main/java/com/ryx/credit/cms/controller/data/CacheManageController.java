package com.ryx.credit.cms.controller.data;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ServiceFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by RYX on 2018/7/18.
 */
@RequestMapping("cache")
@Controller
public class CacheManageController extends BaseController{

    @RequestMapping("delNetInCache")
    @ResponseBody
    public String delNetInCache(){
        ServiceFactory.redisService.delete("DICT_GROUP");
        return "操作成功";
    }

    @RequestMapping("delOrderCache")
    @ResponseBody
    public String delOrderCache(){
        ServiceFactory.redisService.delete("ORDER_DICT_GROUP");
        return "操作成功";
    }

}
