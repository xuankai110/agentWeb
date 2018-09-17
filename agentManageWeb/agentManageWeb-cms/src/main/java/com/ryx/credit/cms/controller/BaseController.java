package com.ryx.credit.cms.controller;

import com.alibaba.fastjson.JSONObject;
import com.ryx.credit.activity.entity.ActHiVarinst;
import com.ryx.credit.cms.util.IDUtils;
import com.ryx.credit.cms.util.ServiceFactory;
import com.ryx.credit.common.enumc.DictGroup;
import com.ryx.credit.common.util.*;
import com.ryx.credit.commons.result.Result;
import com.ryx.credit.commons.shiro.ShiroUser;

import com.ryx.credit.pojo.admin.CUser;
import com.ryx.credit.pojo.admin.agent.BusActRel;
import com.ryx.credit.pojo.admin.agent.Dict;
import com.ryx.credit.pojo.admin.agent.PlatForm;
import com.ryx.credit.service.ActHiVarinstService;
import com.ryx.credit.service.IUserService;
import com.ryx.credit.service.agent.BusActRelService;
import com.ryx.credit.service.dict.DictOptionsService;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 *
 * 基础controller
 *
 * @author wangqi
 * @version 1.0
 * @date 2015年8月5日 下午14:18:17
 * @since 1.0
 */
@ControllerAdvice
public class BaseController {


    private String PICTURE_PATH = AppConfig.getProperty("picture.path");
    private String PICTURE_IMG_PATH = AppConfig.getProperty("picture.img.path");

    @Autowired
    private BusActRelService busActRelService;
    @Autowired
    private ActHiVarinstService actHiVarinstService;
    @Autowired
    private IUserService  iUserService;



    /**
     * log日志
     */
    private static final Logger log = Logger.getLogger(BaseController.class);
    public TreeMap getRequestParameter(HttpServletRequest request){
        Map<String, String[]> hashMap = request.getParameterMap();
        TreeMap<String, String> treeMap = new TreeMap();
        for (String key : hashMap.keySet()) {
            if (StringUtils.isBlank(key)) continue;
            treeMap.put(key, hashMap.get(key)[0]);
            log.info("parameters--"+key+":"+hashMap.get(key)[0]);
        }
        return  treeMap;
    }


    /**
     * 处理分页用到的信息
     * @param req 需要从request中获取数据
     * @return
     */
    protected Page pageProcess(HttpServletRequest req) {
        int numPerPage = null==req.getParameter("rows")?20:Integer.parseInt(req.getParameter("rows"));
        int currentPage = null==req.getParameter("page")?1:Integer.parseInt(req.getParameter("page"));
        Page page = new Page();
        page.setCurrent(currentPage);
        page.setLength(numPerPage);
        page.setBegin((currentPage-1)*numPerPage);
        page.setEnd(currentPage*numPerPage);
        return page;
    }

    /**
     * 处理分页用到的信息
     * @param req 需要从request中获取数据
     * @return
     */
    protected Page pageProcessAll(HttpServletRequest req,int size) {
        int numPerPage = null==req.getParameter("rows")?size:Integer.parseInt(req.getParameter("numPerPage"));
        int currentPage = null==req.getParameter("page")?1:Integer.parseInt(req.getParameter("pageNum"));
        Page page = new Page();
        page.setCurrent(currentPage);
        page.setLength(numPerPage);
        page.setBegin((currentPage-1)*numPerPage);
        page.setEnd(currentPage*numPerPage);
        return page;
    }

    /**
     * 处理分页用到的信息
     * @param size 需要从request中获取数据
     * @return
     */
    protected Page pageProcessAll(int size) {
        int numPerPage = size;
        int currentPage = 1;
        Page page = new Page();
        page.setCurrent(currentPage);
        page.setLength(numPerPage);
        page.setBegin((currentPage-1)*numPerPage);
        page.setEnd(currentPage*numPerPage);
        return page;
    }

    public List<String> uploadFiles(HttpServletRequest request,String userId){
        List list =new ArrayList();
        try {
            CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(request.getSession().getServletContext());
            if (multipartResolver.isMultipart(request)) {
                MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
                Iterator<String> iter = multiRequest.getFileNames();
                int i =1;
                while (iter.hasNext()) {
                    //记录上传过程起始时的时间，用来计算上传时间
                    int pre = (int) System.currentTimeMillis();
                    //取得上传文件
                    MultipartFile file = multiRequest.getFile(iter.next());
                    if (file != null) {
                        //取得当前上传文件的文件名称
                        String myFileName = file.getOriginalFilename();
                        //如果名称不为“”,说明该文件存在，否则说明该文件不存在
                        if (myFileName.trim() != "") {
                            String path_dir = AppConfig.getProperty("upload_path") + userId + "/" + DateUtils.dateToString(new
                                            Date()) + i+"/";
                            String path = path_dir+myFileName;
                            File localFile = new File(AppConfig.getProperty("USER_BASE_PATH") +path);
                            if (!localFile.getParentFile().exists()) {
                                //如果目标文件所在的目录不存在，则创建父目录
                                log.info("目标文件所在目录不存在，准备创建它！");
                                if (!localFile.getParentFile().mkdirs()) {
                                    log.info("创建目标文件所在目录失败！");
                                }
                            }
//                            try {
//                                TransferFileToFtp.transferToFtp(file.getInputStream(), file.getOriginalFilename(), path_dir);
//                                //给上传后的图片加读权限
//                                processService.excuteProcess755(CrowdfundUtil.getPropertiesByName("config.properties", "ng.static"));
//                            } catch (Exception e) {
//                                log.error("TransferFileToFtp",e);
//                            }
                            file.transferTo(localFile);
                            list.add(path);
                            i++;
                            //todo FTP上传

                        }
                    }
                    //记录上传该文件后的时间
                    int finaltime = (int) System.currentTimeMillis();
                    System.out.println(finaltime - pre);
                }

            }
        } catch (Exception e) {
            log.error("uploadFiles error",e);
        }
        return  list;
    }

    public Object renderSuccess(String msg) {
        Result result = new Result();
        result.setSuccess(true);
        result.setMsg(msg);
        return result;
    }
    
    public Object renderError(String msg) {
        Result result = new Result();
        result.setSuccess(false);
        result.setMsg(msg);
        return result;
    }

    /**
     * code
     * 100:长度异常
     * 200:正常
     * 300:缺失要素
     * 400:格式错误
     * 500:违反唯一约束
     */
    public Object renderResult(String code,String msg) {
        Result result = new Result();
        result.setCode(code);
        result.setMsg(msg);
        return result;
    }
    
    /**
     * 获取当前登录用户对象
     * @return {ShiroUser}
     */
    public ShiroUser getShiroUser() {
        return (ShiroUser) SecurityUtils.getSubject().getPrincipal();
    }

    /**
     * 获取当前登录用户id
     * @return {Long}
     */
    public Long getUserId() {
        return this.getShiroUser().getId();
    }

    /**
     * @Author: Zhang Lei
     * @Description: 获取代理商ID
     * @Date: 18:51 2018/8/1
     */
    public String getAgentId(){
        String agentId = null;
        agentId =  ServiceFactory.redisService.hGet("agent",getUserId()+"");
        return agentId;
    }

    /**
     * 获取当前登录用户名
     * @return {String}
     */
    public String getStaffName() {
        return this.getShiroUser().getName();
    }


    /**
     * 上传附件
     * @param file
     * @param merchId
     * @return
     */
    public String uploadPhoto(MultipartFile file, String merchId) {
        //上传服务器
        log.info("start uploadPhoto");
        String savePath = "";
        String imgPath = "";
        try {
            String fileName = file.getOriginalFilename();
            String rootPath = PICTURE_PATH;
            String picturePath = createStorePath(rootPath, merchId);
            String onlyId = IDUtils.genImageName();
            String suffix = fileName.substring(fileName.lastIndexOf("."), fileName.length());
            //保存附件
            savePath = rootPath + picturePath + File.separator + onlyId + suffix;
            log.info("上传附件 save root path：" + savePath);

            imgPath = picturePath + File.separator + onlyId + suffix;
            file.transferTo(new File(savePath));
            log.info("上传附件 服务器路径：" + savePath);
        } catch (Exception e) {
            log.info("io异常");
        }
        return imgPath.replace("\\","/");
    }

    private static String createStorePath(String servicePath, String path) {
        String yearDay = com.ryx.credit.common.util.DateUtil.getDays();
        String picturePath = "files" + File.separator + yearDay.substring(0, 4) + File.separator + yearDay.substring(4, 6) + File.separator + yearDay.substring(6, 8) + File.separator + path;
        String lastPath = servicePath + picturePath;
        File file = new File (lastPath);
        if(!file.exists()) {
            file.mkdirs();
        }
        return picturePath;
    }

    /**
     * 下拉选项
     * @param request
     */
    public Map optionsData(HttpServletRequest request){
        JSONObject obj = null ;
        try{
            String dict =  ServiceFactory.redisService.getValue("DICT_GROUP");
            if(StringUtils.isNotEmpty(dict)){
                try {
                    obj = JSONObject.parseObject(dict);
                    Set<String>  set = obj.keySet();
                    Iterator<String> ite = set.iterator();
                    while (ite.hasNext()){
                        String key = ite.next();
                        request.setAttribute(key,obj.get(key));
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    obj = null;
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(null==obj) {

                //选项数据
                List<Dict> certType = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.CERT_TYPE.name());
                List<Dict> agNatureType = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.AGNATURE_TYPE.name());
                List<Dict> capitalType = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.CAPITAL_TYPE.name());
                List<Dict> contractType = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.CONTRACT_TYPE.name());
                List<Dict> colInfoType = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.COLINFO_TYPE.name());
                List<Dict> yesOrNo = ServiceFactory.dictOptionsService.dictList(DictGroup.ALL.name(), DictGroup.YESORNO.name());
                List<Dict> busType = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.BUS_TYPE.name());
                List<Dict> approvalType = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT_AUDIT.name(), DictGroup.APPROVAL_TYPE.name());
                List<Dict> agentInStatus = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.AGENT_IN_STATUS.name());
                List<Dict> agStatuss = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.AG_STATUS_S.name());
                List<Dict> agStatusi = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.AG_STATUS_I.name());
                List<Dict> approvalPassType = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT_AUDIT.name(), DictGroup.APPROVAL_PASS_TYPE.name());
                List<Dict> busStatus = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.BUS_STATUS.name());
                List<Dict> data_change_type = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.DATA_CHANGE_TYPE.name());
                List<Dict> busActRelBustype = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.BUS_ACT_REL_BUSTYPE.name());
                List<Dict> useScope = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.USE_SCOPE.name());
                List<Dict> busScope = ServiceFactory.dictOptionsService.dictList(DictGroup.AGENT.name(), DictGroup.BUS_SCOPE.name());

                List<Dict> orderStatus = ServiceFactory.dictOptionsService.dictList(DictGroup.ORDER.name(), DictGroup.ORDER_STATUS.name());
                List<Dict> settlementType = ServiceFactory.dictOptionsService.dictList(DictGroup.ORDER.name(), DictGroup.SETTLEMENT_TYPE.name());
                List<Dict> paymenttype = ServiceFactory.dictOptionsService.dictList(DictGroup.ORDER.name(), DictGroup.PAYMENTTYPE.name());
                List<Dict> paymentstatus = ServiceFactory.dictOptionsService.dictList(DictGroup.ORDER.name(), DictGroup.PAYMENTSTATUS.name());
                List<Dict> cType = ServiceFactory.dictOptionsService.dictList(DictGroup.ORDER.name(), DictGroup.C_TYPE.name());
                List<Dict> paymentSrcTypes = ServiceFactory.dictOptionsService.dictList(DictGroup.ORDER.name(), DictGroup.PAYMENT_SRC_TYPE.name());

                request.setAttribute("orderStatus",orderStatus);
                request.setAttribute("settlementType",settlementType);
                request.setAttribute("paymentType",paymenttype);
                request.setAttribute("paymentStatus",paymentstatus);
                request.setAttribute("paymentSrcTypes",paymentSrcTypes);

                request.setAttribute("dataChangeType",data_change_type);
                request.setAttribute("ablePlatForm", ServiceFactory.businessPlatformService.queryAblePlatForm());
                request.setAttribute("compList", ServiceFactory.apaycompService.compList());
                request.setAttribute("certType", certType);
                request.setAttribute("agNatureType", agNatureType);
                request.setAttribute("capitalType", capitalType);//交款类型
                request.setAttribute("contractType", contractType);
                request.setAttribute("colInfoType", colInfoType);//收款账户类型
                request.setAttribute("yesOrNo", yesOrNo);
                request.setAttribute("busType", busType);
                request.setAttribute("approvalType", approvalType);
                request.setAttribute("agentInStatus", agentInStatus);
                request.setAttribute("agStatuss", agStatuss);
                request.setAttribute("agStatusi", agStatusi);
                request.setAttribute("approvalPassType", approvalPassType);
                request.setAttribute("busStatus", busStatus);
                request.setAttribute("dataChangeType", data_change_type);
                request.setAttribute("busActRelBustype", busActRelBustype);
                request.setAttribute("useScope", useScope);
                request.setAttribute("busScope", busScope);
                request.setAttribute("cType", cType);

                FastMap data = FastMap.fastMap("ablePlatForm", ServiceFactory.businessPlatformService.queryAblePlatForm())
                        .putKeyV("certType", certType)
                        .putKeyV("agNatureType", agNatureType)
                        .putKeyV("capitalType", capitalType)
                        .putKeyV("contractType", contractType)
                        .putKeyV("colInfoType", colInfoType)
                        .putKeyV("yesOrNo", yesOrNo)
                        .putKeyV("busType", busType)
                        .putKeyV("approvalType", approvalType)
                        .putKeyV("agentInStatus", agentInStatus)
                        .putKeyV("agStatuss", agStatuss)
                        .putKeyV("agStatusi", agStatusi)
                        .putKeyV("busStatus", busStatus)
                        .putKeyV("compList", ServiceFactory.apaycompService.compList())
                        .putKeyV("dataChangeType", data_change_type)
                        .putKeyV("busActRelBustype", busActRelBustype)
                        .putKeyV("approvalPassType",approvalPassType)
                        .putKeyV("useScope",useScope)
                        .putKeyV("busScope",busScope)
                        .putKeyV("orderStatus", orderStatus)
                        .putKeyV("settlementType",settlementType)
                        .putKeyV("paymentType",paymenttype)
                        .putKeyV("cType",cType)
                        .putKeyV("paymentSrcTypes",paymentSrcTypes)
                        .putKeyV("paymentStatus",paymentstatus);

                ServiceFactory.redisService.setNx("DICT_GROUP", JSONObject.toJSONString(data));

                return data;
            }else{
                return obj;
            }
        }

    }

    public Map orderDictData(HttpServletRequest request){
        JSONObject obj = null ;
        try{
            String dict =  ServiceFactory.redisService.getValue("ORDER_DICT_GROUP");
            if(StringUtils.isNotEmpty(dict)){
                try {
                    obj = JSONObject.parseObject(dict);
                    Set<String>  set = obj.keySet();
                    Iterator<String> ite = set.iterator();
                    while (ite.hasNext()){
                        String key = ite.next();
                        request.setAttribute(key,obj.get(key));
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    obj = null;
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(null==obj) {
                //选项数据
                List<Dict> modelType = ServiceFactory.dictOptionsService.dictList(DictGroup.ORDER.name(), DictGroup.MODEL_TYPE.name());
                List<Dict> manufacturer = ServiceFactory.dictOptionsService.dictList(DictGroup.ORDER.name(), DictGroup.MANUFACTURER.name());
                List<PlatForm> ablePlatForm = ServiceFactory.businessPlatformService.queryAblePlatForm();
                List<Dict> activityDisType = ServiceFactory.dictOptionsService.dictList(DictGroup.ORDER.name(), DictGroup.ACTIVITY_DIS_TYPE.name());
                List<Dict> activityCondition = ServiceFactory.dictOptionsService.dictList(DictGroup.ORDER.name(), DictGroup.ACTIVITY_CONDITION.name());
                request.setAttribute("modelType", modelType);
                request.setAttribute("manufacturer", manufacturer);
                request.setAttribute("ablePlatForm",ablePlatForm);
                request.setAttribute("activityDisType",activityDisType);
                request.setAttribute("activityCondition",activityCondition);

                FastMap data = FastMap.fastMap("modelType",modelType)
                        .putKeyV("ablePlatForm",ablePlatForm)
                        .putKeyV("activityDisType",activityDisType)
                        .putKeyV("manufacturer",manufacturer)
                        .putKeyV("activityCondition",activityCondition);

                ServiceFactory.redisService.setNx("ORDER_DICT_GROUP", JSONObject.toJSONString(data));
                return data;
            }else{
                return obj;
            }
        }

    }

    /**
     * 查询审批记录
     */
    public List<Map<String,Object>> queryApprovalRecord(String busId,String BusType){
        BusActRel busActRel =  busActRelService.findByBusIdAndType(busId,BusType);
        List<Map<String,Object>> actRecordList = new ArrayList<>();
        if(busActRel==null) return actRecordList;
        ActHiVarinst actHiVarinst = new ActHiVarinst();
        actHiVarinst.setProcInstId(busActRel.getActivId());
        actHiVarinst.setName("_ryx_wq");
        HashMap<String, Object> actHiVarinstMap = actHiVarinstService.configExample(new Page(), actHiVarinst);
        List<ActHiVarinst> list = (List<ActHiVarinst>)actHiVarinstMap.get("list");
        for (ActHiVarinst hiVarinst : list) {
            Map map = JsonUtils.parseJSON2Map(String.valueOf(hiVarinst.getText()));
            String approvalPerson = String.valueOf(map.get("approvalPerson"));
            CUser cUser = iUserService.selectById(approvalPerson);
            if(null!=cUser){
                map.put("approvalPerson",cUser.getName());
            }
            actRecordList.add(map);
        }
        return actRecordList;
    }


}
