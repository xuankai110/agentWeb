package com.ryx.credit.profit.jobs;

import com.alibaba.fastjson.JSONObject;
import com.ryx.credit.common.enumc.TabId;
import com.ryx.credit.common.result.AgentResult;
import com.ryx.credit.common.util.AppConfig;
import com.ryx.credit.common.util.HttpClientUtil;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.commons.utils.StringUtils;
import com.ryx.credit.service.dict.IdService;
import com.ryx.credit.service.profit.IPosProfitDataService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * @author zhaodw
 * @Title: TranDataJob
 * @ProjectName agentManage
 * @Description: 获取交易数据，对数据进行差异核对
 * @date 2018/7/2911:34
 */
@Service("tranDataJob")
@Transactional(rollbackFor = Exception.class)
public class TranDataJob {

    private static final Logger LOG = Logger.getLogger(TranDataJob.class);

    private static final  String URL =  AppConfig.getProperty("check_tran_url");

    @Autowired
    private IPosProfitDataService posProfitDataService;


    @Autowired
    private IdService idService;

    @Scheduled(cron = "0 0 12 10 * ?")
    public void deal() {
        String settleMonth = LocalDate.now().plusMonths(-1).format(DateTimeFormatter.BASIC_ISO_DATE).substring(0,6);
        LOG.info("分润月份"+settleMonth);
        LOG.info("获取分润数据");
        try {
            AgentResult agentResult = posProfitDataService.getPosProfitDate(settleMonth);
            if (agentResult != null && agentResult.getData() != null) {
                JSONObject json = JSONObject.parseObject(agentResult.getData().toString());
                if (json != null) {
                    BigDecimal tranAmt = BigDecimal.ZERO;
                    BigDecimal zyssAmt = BigDecimal.ZERO;
                    JSONObject jsonObject = getTranData(settleMonth);
                    if (jsonObject != null && jsonObject.containsKey("info")) {
                        JSONObject tranData = jsonObject.getJSONObject("info");
                        zyssAmt = tranData.getBigDecimal("zyssAmt")==null?BigDecimal.ZERO:tranData.getBigDecimal("zyssAmt");;// 自营代理手刷总金额
                        BigDecimal zydlPosAmt = tranData.getBigDecimal("zydlPosAmt")==null?BigDecimal.ZERO:tranData.getBigDecimal("zydlPosAmt");;// 自营代理pos总金额
                        BigDecimal zyPosAmt = tranData.getBigDecimal("zyPosAmt")==null?BigDecimal.ZERO:tranData.getBigDecimal("zyPosAmt");//自营交易总金额
                        BigDecimal hyxJwAmt = tranData.getBigDecimal("hyxPosJwAmt")==null?BigDecimal.ZERO:tranData.getBigDecimal("hyxPosJwAmt");//汇银讯境外卡交易总金额
                        BigDecimal orgJwAmt = tranData.getBigDecimal("dlPosJwAmt")==null?BigDecimal.ZERO:tranData.getBigDecimal("dlPosJwAmt");//代理商境外卡交易总金额
                        tranAmt = zydlPosAmt.subtract(zyPosAmt).subtract(hyxJwAmt).subtract(orgJwAmt);
                    }
                    //insertOrUpdate(json, settleMonth, tranAmt, zyssAmt);//新增二维码
                }else{
                    LOG.error("月份："+settleMonth+"，二维码提供的没有获取到数据");
                }
            }
        }catch (Exception e) {
            e.printStackTrace();
            LOG.error("分润数据处理失败");
            throw new RuntimeException("分润数据处理失败");
        }
    }



    /***
     * @Description: 获取POS交易数据
     * @Param:  settleMonth 分润月份
     * @return:  数据json对象
     * @Author: zhaodw
     * @Date: 2018/8/2
     */
    private JSONObject getTranData(String settleMonth) {
        LOG.info("获取POS交易数据");
        JSONObject json = new JSONObject();
        json.put("tranType","22");
        json.put("tranMon",   settleMonth);
        String result = HttpClientUtil.doPostJson(URL, json.toJSONString());
        if (StringUtils.isNotBlank(result)) {
            return  JSONObject.parseObject(result);
        }
        return null;
    }

}
