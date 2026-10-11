import { CommonManager } from './../common/CommonManager';
import { ResManager } from './../common/ResManager';
import { RedKey } from './../common/RedDotDefine';
import { EventDispatcher } from '../util/EventDispatcher';
import { Config } from '../common/Config';
import { ServerTimeModel } from '../serverTime/ServerTimeModel';
import { RoleManager } from './RoleManager';
import { ActivityIconManager } from './ActivityIconManager';
import { FirstRechargeModel } from './FirstRechargeModel';
import { VipModel } from './VipModel';
import { KaifuActivityModel } from './KaifuActivityModel';
import { WeekCardModel } from './WeekCardModel';
import { TopVipModel } from './TopVipModel';
import { CustomActivityModel } from './CustomActivityModel';
import { Message } from '../sysInfo/SysInfoController';
import { ErlangParser } from '../util/ErlangParser';
import { FestivalModel } from './FestivalModel';
import { OneDollarSpikeModel } from './OneDollarSpikeModel';
import { TimeUtil } from '../util/TimeUtil';
import { DragonBallModel } from './DragonBallModel';
export interface IFeature {
    id: number;
    func: number;
    name: string;
    order: number;
    is_redot_show: boolean;
    is_top: boolean;
    top_tips: string;
    red_model_type: keyof typeof RedKey;
}
export interface ISkillAwakeTask {
    taskid: number;
    combat: number;
}
export const MainStrongerEvent = {
    /**
     * args:
     * strongerNum 变强数量
     */
    UPDATE: 'MainStrongerEventUPDATE',
    /**
     * 初始化配置成功
     */
    INIT_CONFIG_SUCCESS: 'INIT_CONFIG_SUCCESS',
    /**
     * 推关失败引导
     */
    AUTO_BRUSH_SHOW_ARROW: 'SHOWAUTO_BRUSH_SHOW_ARROW_ARROW'
};
export class MainStrongerModel extends EventDispatcher {
    private static _ins: MainStrongerModel;
    cfg: {
        FeatureBinding: {
            [id: number]: IFeature;
        };
        SkillAwakeTask: {
            [id: number]: ISkillAwakeTask;
        };
    };
    SkillAwakeTask: ISkillAwakeTask[];
    FeatureBindingCfg: IFeature[];
    strongerNum: number;
    isBubbleOpen: boolean = false;
    featureList: IFeature[];
    taskVo: ITaskVo;
    isHideBoard: boolean = false
    static get ins() {
        if (!MainStrongerModel._ins) {
            MainStrongerModel._ins = new MainStrongerModel();
            MainStrongerModel._ins.initConfig();
        }
        return MainStrongerModel._ins;
    }
    static BannerMaxNum = 8

    initConfig() {
        ResManager.GetInstance().LoadGameConfig(this, 'ConfigFeatureBinding', true, null, (cfg) => {
            this.cfg = cfg;
            this.FeatureBindingCfg = Object.values(this.cfg.FeatureBinding);
            this.SkillAwakeTask = Object.values(this.cfg.SkillAwakeTask).sort((a, b) => a.taskid - b.taskid);
            this.Fire(MainStrongerEvent.INIT_CONFIG_SUCCESS, cfg);
        });
    }

    insertFeature(feature: IFeature) {
        if (feature.func && !CommonManager.GetInstance().OpenFunCanJump(feature.func)) {
            return;
        }
        this.featureList.push(feature);
        this.featureList = this.featureList.sort((a, b) => {
            let is_topA = a.is_top ? 1 : 0;
            let is_topB = b.is_top ? 1 : 0;
            let orderA = a.order || -1;
            let orderB = b.order || -1;
            return +(is_topA < is_topB) || +(is_topA == is_topB) - 1 || +(orderA < orderB) || +(orderA == orderB) - 1 || a.id - b.id;
        });
    }

    getBubbleContent() {
        let f = this.featureList[0];
        if (f) {
            if (f.is_top) {
                return f.top_tips || '有大量战力可以提升';
            }
        }
        return '有大量战力可以提升';
    }

    getBannerList(){
        let config_banner_cfg = Config.PRELOAD_SERVER_CONFIG.config_banner_cfg
        if(!config_banner_cfg) return 

        let list = []
        for(let key in config_banner_cfg){
            var v = config_banner_cfg[key]
            if(this.checkBannerState(v)){
                list.push(v)
            }
        }

        list.sort(function(a, b){
            return a.show_id - b.show_id
        })

        return list
    }

    checkBannerState(cfg, show_tips?){
        if(!cfg) return false

        let bool = true
        let tips = ""


        //开服天数
        if(cfg.open_day != '[]'){
            let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
            var cond = ErlangParser.GetInstance().Parse(cfg.open_day)
            var cond_state = false
            for(let v of cond){
                if(v[0] <= open_day && v[1] >= open_day){
                    cond_state = true
                    break
                }
            }
            if(!cond_state){
                bool = false
                tips = "开服天数不足"
            }
        }


        //合服天数
        if(bool && cfg.merger_day != '[]'){
            let merger_day = ServerTimeModel.GetInstance().GetMergeServerDay()
            var cond = ErlangParser.GetInstance().Parse(cfg.merger_day)
            var cond_state = false
            for(let v of cond){
                if(v[0] <= merger_day && v[1] >= merger_day){
                    cond_state = true
                    break
                }
            }
            if(!cond_state){
                bool = false
                tips = "合服天数不足"
            }
        }


        //等级判断
        if(bool && cfg.lv != '0'){
            let level = RoleManager.GetInstance().GetMainRoleLevel()
            if(level < cfg.lv){
                bool = false
                tips = "等级不足"
            }
        }


        //图标判断
        if(bool && cfg.img_condition != '0'){
            let icon = ActivityIconManager.GetInstance().getIconInfo(cfg.img_condition)
            if(!icon){
                bool = false
                tips = "不存在图标" + cfg.img_condition
            }
        }

        //条件判断
        if(bool && cfg.fun_condition != '[]'){
            var cond = ErlangParser.GetInstance().Parse(cfg.fun_condition)
            var cond_state = true
            for(let v of cond){
                switch(v[0]){
                    case 'first_charge':
                        var has_first = FirstRechargeModel.GetInstance().IsDoneFirstRecharge()
                        if(has_first){
                            if(v[1] == '1'){
                                cond_state = true
                            }
                            else{
                                cond_state = false
                                tips = "已首充"

                            }
                        }
                        else{
                            if(v[1] == '1'){
                                cond_state = false
                                tips = "未首充"
                            }
                            else{
                                cond_state = true
                            }
                        }
                        break
                    case 'v4_card':
                        var has_v4_card = VipModel.GetInstance().GetNobleCardState()
                        if(has_v4_card == 99){
                            if(v[1] == '1'){
                                cond_state = true
                            }
                            else{
                                cond_state = false
                                tips = "已开特权卡"

                            }
                        }
                        else{
                            if(v[1] == '1'){
                                cond_state = false
                                tips = "未开特权卡"
                            }
                            else{
                                cond_state = true
                            }
                        }
                        break
                    case 'month_card':
                        var has_month_card = KaifuActivityModel.GetInstance().CheckHaveMonthCard()
                        if(has_month_card){
                            if(v[1] == '1'){
                                cond_state = true
                            }
                            else{
                                cond_state = false
                                tips = "已开月卡"

                            }
                        }
                        else{
                            if(v[1] == '1'){
                                cond_state = false
                                tips = "未开月卡"
                            }
                            else{
                                cond_state = true
                            }
                        }
                        break
                    case 'week_card':
                        let week_card = WeekCardModel.GetInstance().GetWeekCardData()
			            if(week_card  && week_card.is_activity == 1) {
                            if(v[1] == '1'){
                                cond_state = true
                            }
                            else{
                                cond_state = false
                                tips = "已开周卡"

                            }
                        }else{
                            if(v[1] == '1'){
                                cond_state = false
                                tips = "未开周卡"
                            }
                            else{
                                cond_state = true
                            }
                        }
                        break
                    case 'svip':
                        let open_state = false
                        let my_top_vip_vo = TopVipModel.GetInstance().my_top_vip_vo
                        if(my_top_vip_vo && my_top_vip_vo.supvip_type > 0){
                            if(my_top_vip_vo.supvip_type == 1 && TimeUtil.getServerTime() < my_top_vip_vo.supvip_time){
                                open_state  = true
                            }else if(my_top_vip_vo.supvip_type == 2){
                                open_state = true
                            }
                        }
                        if(open_state){
                            if(v[1] == '1'){
                                cond_state = true
                            }
                            else{
                                cond_state = false
                                tips = "已开至尊VIP"

                            }
                        }
                        else{
                            if(v[1] == '1'){
                                cond_state = false
                                tips = "未开至尊VIP"
                            }
                            else{
                                cond_state = true
                            }
                        }
                        break
                    case 'festival':
                        if(FestivalModel.GetInstance().GetFestivalIsBuy()){
                            if(v[1] == '1'){
                                cond_state = true
                            }
                            else{
                                cond_state = false
                                tips = "已开高级祭典"

                            }
                        }
                        else{
                            if(v[1] == '1'){
                                cond_state = false
                                tips = "未开高级祭典"
                            }
                            else{
                                cond_state = true
                            }
                        }
                        break
                    case 'dragon_statue':
                        var has_first = FirstRechargeModel.GetInstance().IsDoneFirstRecharge()
                        if(has_first){
                            var statue_state = DragonBallModel.GetInstance().GetStatueActiveState()
                            if(statue_state){
                                if(v[1] == '1'){
                                    cond_state = true
                                }
                                else{
                                    cond_state = false
                                    tips = "已激活雕像"
                                }
                            }
                            else{
                                if(v[1] == '1'){
                                    cond_state = false
                                    tips = "未激活雕像"
                                }
                                else{
                                    cond_state = true
                                }
                            }
                        }
                        else{
                            cond_state = false
                            tips = "未首充"
                        }
                        break
                    case 'dragon_ball_gift':
                        var has_first = FirstRechargeModel.GetInstance().IsDoneFirstRecharge()
                        if(has_first){
                            var statue_state = DragonBallModel.GetInstance().GetStatueActiveState()
                            var gift_data = DragonBallModel.GetInstance().dragon_gift_data
                            if(gift_data && statue_state && v[1] == gift_data.id){
                                cond_state = true
                            }
                            else{
                                cond_state = false
                                tips = "礼包未开启"
                            }
                        }else{
                            cond_state = false
                            tips = "未首充"
                        }
                        break
                }
                if(!cond_state){
                    bool = false
                    break
                }
            }
        }


        //定制活动判断
        if(bool && cfg.act_condition != '[]'){
            var cond = ErlangParser.GetInstance().Parse(cfg.act_condition)
            var cond_state = true
            for(let v of cond){
                var act_data = CustomActivityModel.GetInstance().GetActDataByShowID(v[0], v[1])
                if(act_data){
                    switch(Number(v[0])){
                        case Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.DAILY_DIRECT_PURCHASE:
                            if(OneDollarSpikeModel.GetInstance().GetDollarSpikeAllBuy(act_data.base_type, act_data.sub_type)){
                                cond_state = false
                                tips = "已购买全部档位"
                            }
                            break
                    }
                    if(!cond_state){
                        break
                    }
                }
                else{
                    cond_state = false
                    tips = "活动未开启"
                    break
                }
            }
            if(!cond_state){
                bool = false
            }
        }

        //跳转的功能开启判断
        if (bool && cfg.skip_id && !CommonManager.GetInstance().OpenFunCanJump(cfg.skip_id)) {
            bool = false
            tips = "功能未开启"
        }

        if(show_tips && tips){
            Message.show(tips)
        }

        return bool
    }
}

window['MainStrongerModel'] = MainStrongerModel;
