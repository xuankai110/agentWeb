package com.ryx.credit.cms.controller.profit;

import com.ryx.credit.cms.controller.BaseController;
import com.ryx.credit.cms.util.ExcelUtil;
import com.ryx.credit.cms.util.ImportExcelUtil;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.common.util.ResultVO;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.profit.pojo.ProfitDeduction;
import com.ryx.credit.profit.service.ProfitDeductionService;
import com.ryx.credit.profit.service.StagingService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Set;

/**
 * 其他扣款
 *
 * @author zhaodw
 * @create 2018/7/24
 * @since 1.0.0
 */
@Controller
@RequestMapping("/profit/other/")
public class ProfitOtherDeductionController extends BaseController {

    private static final Logger LOGGER = Logger.getLogger(ProfitOtherDeductionController.class);

    @Autowired
    private ProfitDeductionService profitDeductionServiceImpl;

    @Autowired
    private StagingService stagingServiceImpl;

    /***
    * @Description: 加载管理页面
    * @Author: zhaodw
    * @Date: 2018/8/3
    */
    @RequestMapping("gotoProfitDeductionList")
    public String gotoProfitDeductionList(Model model) {
        LOGGER.info("加载其他扣款管理页面。");
        // 终审后不能做修改
        String finalStatus = ServiceFactory.redisService.getValue("commitFinal");
        if (StringUtils.isBlank(finalStatus)) {
            model.addAttribute("noEdit","0");
        }else{
            model.addAttribute("noEdit","1");
        }
        return "profit/otherDeduction/profitOtherDeductionList";
    }

    /***
    * @Description:  加载新增页面
    * @Author: zhaodw
    * @Date: 2018/8/3
    */
    @RequestMapping("gotoAddPage")
    public String gotoAddPage() {
        LOGGER.info("加载导入页面。");
        return "profit/otherDeduction/importDeduction";
    }

    /**
     * 获取扣款列表
     *
     * @param request
     * @param profitDeduction 扣款参数
     * @return 扣款数据
     */
    @RequestMapping(value = "getProfitDeductionList", method = RequestMethod.POST)
    @ResponseBody
    public PageInfo getProfitDeductionList(HttpServletRequest request, ProfitDeduction profitDeduction) {
        LOGGER.info("加载其他扣款列表数据。");
        Page page = pageProcess(request);
        profitDeduction.setDeductionType("03");
        String agentPid = ServiceFactory.redisService.hGet("agent",getUserId().toString());
        if (StringUtils.isNotBlank(agentPid)) {
            profitDeduction.setAgentPid(agentPid);
        }else{
//            Set<String> roles = getShiroUser().getRoles();
//            if(roles !=null && !roles.contains("财务审批")) {
//                profitDeduction.setAgentId("null");
//            }
        }
        PageInfo resultPageInfo = profitDeductionServiceImpl.getProfitDeductionList(profitDeduction, page);
        return resultPageInfo;
    }


    /***
     * @Description: 导入excel
     * @Param:
     * @return:
     * @Author: zhaodw
     * @Date: 2018/7/31
     */
    @RequestMapping("importDeduction")
    @ResponseBody
    public ResultVO importDeduction(@RequestParam(value = "file", required = false) MultipartFile file, HttpServletRequest request) {
        if (null == file) {
            return ResultVO.fail("文件不能为空");
        }
        try {
            List<List<Object>> deductionist = ExcelUtil.getListByExcel(file.getInputStream(), file.getOriginalFilename());
            profitDeductionServiceImpl.batchInsertOtherDeduction(deductionist, getUserId().toString());
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.info("导入失败。");
            return ResultVO.success("导入失败。");
        }
        return ResultVO.success("导入成功。");

    }


}
