import { CommonManager } from "./../common/CommonManager"
import { KaifuActivityModel, investType } from "./../commonModel/KaifuActivityModel"
import { CongratulationObtainView } from "./../common/CongratulationObtainView"
import { BaseAlert } from "./../alert/BaseAlert"
import { TopVipModel } from "./../commonModel/TopVipModel"
import { VipModel } from "./../commonModel/VipModel"
import { BaseView1 } from "./../common/BaseView1"
import { FirstRechargeModel } from "./../commonModel/FirstRechargeModel"
import { RoleManager } from "./../commonModel/RoleManager"
import { OpenFun } from "./../common/OpenFun"
import { Util, GetQualifiedClassName } from "./../util/Util"
import { GameResPath } from "./../util/GameResPath"
import { EventName } from "./../common/EventName"
import { ResManager } from "./../common/ResManager"
import { BaseController } from "./../common/BaseController"
import { BaseWindowComponent } from "./../common/BaseWindowComponent"
import { PlatformManager } from "../PlatformManager"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { DragonBallModel } from "../commonModel/DragonBallModel"
export interface IBanner {
    id: string;
    weight: number;
    func_id: number;
    condition: string[];
    compName: string;
    offsetX: number;
    offsetY: number;
    scale: number[];
    hideInAlpha: boolean;
    specialCondition: any;
    localWeight:number
}
export class BannerController extends BaseController {
    private static _ins: BannerController;
    private cfg: {
        "Banner": {
            [id: string]: IBanner[]
        }
    };
    private conditionFunc: { [type: string]: (value: any) => boolean } = {
        role_create_day: this.FuncRoleCreateDay,
        role_lv: this.FuncRoleLv,
        vip_lv: this.FuncVipLv,
        first_charge: this.FuncFirstCharge,
        ac_vip_card: this.FuncACVipCard,
        ac_top_vip: this.FuncACTopVip,
        month_card: this.FuncMonthCard,
        lv_invest: this.FuncLvInvest,
        act_base_type:this.FuncActOpen,
        dragon_statue:this.FuncDragonStatue,
        dragon_ball_gift:this.FuncDragonBallGift
    }
    private viewSpecialCondition: { [type: string]: (value?: BaseView1, cfgs?: IBanner[]) => [boolean, IBanner[]] } = {
        AlertTypeOne: this.FuncAlert,
        AlertTypeTwo: this.FuncAlert,
        AlertTypeThree: this.FuncAlert,
        AlertTypeTreasure: this.FuncAlert,
        AlertTypeCheckBox: this.FuncAlert,
        AlertTypeCheckBox2: this.FuncAlert,
        CongratulationObtainView: this.FuncCongratulationObtainView
    }
    constructor() {
        super()
        this.initConfig()
        this.initEvent()
    }
    // /**使用 await BannerController.getInstance() BannerController */
    static getInstance() {
        if (!BannerController._ins) {
            BannerController._ins = new BannerController()
        }
        return BannerController._ins
    }
    initEvent() {
        let banner: Laya.Image;
        let btnImg: Laya.Image;
        let btnLbl: Laya.Label;
        this.Bind(EventName.BASEVIEW_OPEN_OR_CLOSE, (is_open, __, ___, ____, obj: BaseView1) => {
            Laya.timer.callLater(this, () => {
                let clsname: string = GetQualifiedClassName(obj)
                if (!clsname) {
                    return;
                }
                let cfgs = this.cfg?.Banner[clsname]
                if (!cfgs) return
                if (!is_open) {
                    banner?.removeChildren();
                    banner?.removeSelf();
                    banner = null
                    btnImg = null
                    btnLbl = null
                    return
                }
                if (this.viewSpecialCondition[clsname]) {
                    let [result, newcfgs] = this.viewSpecialCondition[clsname].call(this, obj, cfgs)
                    if (result) return
                    if (newcfgs) cfgs = newcfgs
                }
                let randomBannerList: IBanner[] = []
                let is_alpha = PlatformManager.GetInstance().is_alpha;
                for (const cfg of cfgs) {
                    if (is_alpha && cfg.hideInAlpha) continue;
                    let conditions = cfg.condition
                    let satisfy = true;
                    for (const condition of conditions) {
                        let [type, value] = condition.split('|')
                        if (!type) continue
                        if (!this.conditionFunc[type].call(this, value)) {
                            satisfy = false
                            break;
                        }
                    }
                    if (satisfy) {
                        randomBannerList.push(cfg)
                    }
                }
                banner?.removeChildren();
                banner?.removeSelf();
                banner = null
                btnImg = null
                btnLbl = null
                if (randomBannerList.length <= 0) {
                    return;
                }
                // 总权重
                let totalWeight = randomBannerList.reduce((p, c, i, l) => {
                    return l[i].weight + p
                }, 0)
                // 权重递增
                let weightStep = 0
                randomBannerList.forEach(b => { 
                    b.localWeight = b.weight / totalWeight + weightStep; 
                    weightStep = b.localWeight; 
                })
                let ran = Math.random() * weightStep
                // 算区间
                let bannerCfg = randomBannerList.find(b => b.localWeight >= ran)
                // 新建banner加到对应界面的组件下
                banner = new Laya.Image();
                banner.mouseThrough = false;
                btnImg = new Laya.Image();
                btnImg.mouseEnabled = true;
                btnImg.mouseThrough = true;
                btnLbl = new Laya.Label();
                btnLbl.mouseThrough = true;
                btnLbl.fontSize = 20;
                btnLbl.color = "#ffffff"
                btnLbl.stroke = 2;
                btnLbl.strokeColor = "#c97137"
                banner.addChild(btnImg)
                if(PlatformManager.IsEyouThPlatform()){
                    btnImg.pos(56, 140)
                }else{
                btnImg.pos(543, 90)
                }
                btnImg.addChild(btnLbl)
                btnLbl.pos(20, 12)
                ResManager.GetInstance().SetTexture(obj, banner, GameResPath.GetIconOtherPath("banner", `com_bq_bg${bannerCfg.id}`), null, obj, true)
                btnImg.skin = GameResPath.GetIcon("common", `ui_tb_20`);
                btnLbl.text = "立即前往"
                // banner.anchorX = 0.5;
                // banner.anchorY = 0.5;
                banner.scale(bannerCfg.scale?.[0] || 1, bannerCfg.scale?.[1] || 1)
                obj[bannerCfg.compName].addChild(banner)
                banner.x = bannerCfg.offsetX || 0
                banner.y = bannerCfg.offsetY || 0
                obj.display_obj && (obj.display_obj.hitTestPrior = false)
                obj.click_bg_toClose = false
                Util.AddClickEvent(btnImg, () => {}, btnImg, true)
                banner.on(Laya.Event.CLICK, this, () => {
                    obj.close_imme = true;
                    obj.Close()
                    Laya.timer.callLater(this, () => {
                        ViewPopLevelModel.IGNORE_BASEWINDOW_OPEN_STATE = true
                        OpenFun.OpenFunHandler(bannerCfg.func_id)
                        ViewPopLevelModel.IGNORE_BASEWINDOW_OPEN_STATE = false
                        // 无视ViewLevelPopModel弹窗
                    })
                });
            })
        })
    }
    initConfig() {
        ResManager.GetInstance().LoadGameConfig(this, "ConfigBanner", true, null, (cfg) => {
            this.cfg = cfg;
        })
    }

    FuncActOpen(value: string) {
        let [base_type, show_id] = value.split('@')
        let actInfo = CustomActivityModel.GetInstance().GetActInfoByShowID(Number(base_type), Number(show_id))
        return actInfo
    }
    FuncDragonStatue(value: string){
        let statue_state = DragonBallModel.GetInstance().GetStatueActiveState()
        if(value == "false"){
           if(statue_state){
                return false
           }
           else{
                return true
           }
        }else if(value == "true"){
            if(statue_state){
                return true
           }
           else{
                return false
           }
        }
    }
    FuncDragonBallGift(value: string){
        var statue_state = DragonBallModel.GetInstance().GetStatueActiveState()
        var gift_data = DragonBallModel.GetInstance().dragon_gift_data
        if(gift_data && statue_state && value == gift_data.id){
            return true
        }
        else{
            return false
        }
    }
    FuncRoleCreateDay(value: string) {
        let day = RoleManager.GetInstance().GetRoleCreateDay() + 1
        if (value.indexOf("[") == -1) {
            return day >= Number(value)
        } else {
            let [min, max] = value.replace(/[\[\]]/g, "").split(",").map(v => Number(v))
            return min <= day && day <= max
        }
    }
    FuncRoleLv(value: string) {
        let lv = RoleManager.GetInstance().GetMainRoleLevel()
        if (value.indexOf("[") == -1) {
            return lv >= Number(value)
        } else {
            let [min, max] = value.replace(/[\[\]]/g, "").split(",").map(v => Number(v))
            return min <= lv && lv <= max
        }
    }
    FuncVipLv(value: string) {
        if (!CommonManager.GetInstance().OpenFunCanJump(8)) {
            return false
        }
        let vip_lv = RoleManager.GetInstance().mainRoleInfo.vip_flag
        if (value.indexOf("[") == -1) {
            return vip_lv >= Number(value)
        } else {
            let [min, max] = value.replace(/[\[\]]/g, "").split(",").map(v => Number(v))
            return min <= vip_lv && vip_lv <= max
        }
    }
    FuncFirstCharge(value: string) {
        if (!CommonManager.GetInstance().OpenFunCanJump(70)) {
            return false
        }
        let b = value == "true"
        return !!FirstRechargeModel.GetInstance().IsDoneFirstRecharge() == b
    }
    FuncACVipCard(value: string) {
        if (!CommonManager.GetInstance().OpenFunCanJump(23)) {
            return false
        }
        let vip_lv = VipModel.GetInstance().nobel_card_lv
        if (value.indexOf("[") == -1) {
            return vip_lv >= Number(value)
        } else {
            let [min, max] = value.replace(/[\[\]]/g, "").split(",").map(v => Number(v))
            return min <= vip_lv && vip_lv <= max
        }
    }
    FuncACTopVip(value: string) {
        if (!CommonManager.GetInstance().OpenFunCanJump(451)) {
            return false
        }
        let b = value == "true"
        return (TopVipModel.GetInstance().my_top_vip_vo?.supvip_type > 0) == b
    }
    FuncMonthCard(value: string) {
        if (!CommonManager.GetInstance().OpenFunCanJump(61)) {
            return false
        }
        let b = value == "true"
        let data: any[] = KaifuActivityModel.GetInstance().open_data?.open_list || []
        return data.some(d => {
            if (d.type == investType.month) {
                return d.state > 0
            }
            return false
        }) == b
    }
    FuncLvInvest(value: string) {
        if (!CommonManager.GetInstance().OpenFunCanJump(62)) {
            return false
        }
        let b = value == "true"
        let data: any[] = KaifuActivityModel.GetInstance().open_data?.open_list || []
        return data.every(d => {
            let flag = true
            if (d.type == investType.level) {
                flag = d.state > 0 && flag
            }
            if (d.type == investType.top) {
                flag = d.state > 0 && flag && CommonManager.GetInstance().OpenFunCanJump(115)
            }
            if (d.type == investType.king) {
                flag = d.state > 0 && flag && CommonManager.GetInstance().OpenFunCanJump(184)
            }
            if (d.type == investType.extreme) {
                flag = d.state > 0 && flag && CommonManager.GetInstance().OpenFunCanJump(155)
            }
            if (d.type == investType.god) {
                flag = d.state > 0 && flag && CommonManager.GetInstance().OpenFunCanJump(185)
            }
            return flag
        }) == b
    }
    // 满足时不加
    FuncAlert(obj: BaseAlert, cfg) {
        let newCfg = cfg.filter(c => {
            let b = c.specialCondition == "true"
            return b == obj.is_charge
        })
        let result: [boolean, IBanner[]] = [newCfg.length <= 0, newCfg];
        return result
    }
    // 满足时不加
    FuncCongratulationObtainView(obj: CongratulationObtainView, cfg: IBanner[]) {
        let newCfg = cfg.filter(c => c.specialCondition == obj.banner_view_type)
        let result: [boolean, IBanner[]] = [newCfg.length <= 0, newCfg];
        return result
    }
}

window["BannerController"] = BannerController