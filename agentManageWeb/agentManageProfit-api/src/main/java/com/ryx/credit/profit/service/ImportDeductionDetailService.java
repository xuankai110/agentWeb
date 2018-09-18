package com.ryx.credit.profit.service;

import com.ryx.credit.common.util.Page;
import com.ryx.credit.common.util.PageInfo;
import com.ryx.credit.profit.pojo.ImportDeductionDetail;

/**
 * @author zhaodw
 * @Title: ImportDeductionDetailService
 * @ProjectName agentManage
 * @Description: 导入扣款接口
 * @date 2018/7/2417:27
 */
public interface ImportDeductionDetailService {


    /*** 
    * @Description: 新增导入扣款信息
    * @Param:  stagingDetail 扣款信息
    * @Author: zhaodw
    * @Date: 2018/7/31 
    */ 
    void insetImportDeductionDetail(ImportDeductionDetail importDeductionDetail);
}
