import { BaseView1 } from "../common/BaseView1";
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { Message } from "../sysInfo/SysInfoController";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, SetAnchoredPositionY, SetHtmlCenter, SetLocalPositionX, Util } from "../util/Util";
import { Config } from "../common/Config"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { RareSurfaceListItem } from "./RareSurfaceListItem";
import { table } from "../common/table";
import { EquipmentItem } from "../common/EquipmentItem";
import { GoodsModel } from "../commonModel/GoodsModel";
import { SYTweenLite } from "../util/SYTweenLite";
import { SYTweenFunc } from "../util/SYTweenFunc";
import { VipModel } from "../commonModel/VipModel";
import { PlatformManager } from "../PlatformManager";
import { RareSurfaceSkillItem } from "./RareSurfaceSkillItem";
import { CongratulationObtainView } from "../common/CongratulationObtainView";
import { RoleManager } from "../commonModel/RoleManager";
import { Alert, Alert_Type } from "../alert/Alert";
import { OpenFun } from "../common/OpenFun";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { Vector2 } from "../util/Vector2";
export class RareSurfaceView extends BaseView1 {
    _img_bg: Laya.Image
    _img_adorn: Laya.Image
    _img_title: Laya.Image
    _img_gift: Laya.Image
    _gp_time: Laya.Box
    _lab_time: Laya.HTMLDivElement
    _img_model: Laya.Image
    _gp_effect: Laya.Box
    _gp_model: Laya.Box
    _img_close: Laya.Image
    _gp_list: Laya.List
    _gp_skill: Laya.Box
    _gp_bottom: Laya.VBox
    _gp_fight: Laya.Box
    _gp_reward: Laya.HBox
    _gp_tips: Laya.Box
    _img_tips: Laya.Image
    _gp_tips_h: Laya.HBox
    _lab_back: Laya.Label
    _img_icon: Laya.Image
    _lab_add: Laya.Label
    _btn_buy: Laya.Box
    _lab_buy: Laya.Label
    _img_buy_icon: Laya.Image
    _gp_banner: Laya.Box
    _img_banner: Laya.Image
    _btn_pack: Laya.Box
    _lab_pack: Laya.Label

    _fight_item
    _timer
    _tween_id

    SetActInfo
    InitInfo
    UpdateSelectItem
    UpdateBannerInfo
    UpdateListInfo
    UpdateModelInfo
    UpdateSkillInfo
    SwitchTab
    onTimer
    removeTimer
    windows_cfg
    key
    public constructor() {
        super();
        this.base_file = 'rareSurface';
        this.layout_file = 'RareSurfaceView';
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;
        let cfg_custom_activity = Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity
        this.windows_cfg = null
        this.key = null
        let model = CustomActivityModel.GetInstance(),
            res_mgr = ResManager.GetInstance(),
            local_Util = Util,
            local_Message = Message,
            local_Number = Number,
            local_CustomActivityDefine = CustomActivityDefine,
            local_TimeUtil = TimeUtil,
            _info,
            _cond,
            act_etime,
            _data,
            select_item,
            suf_loop_mgr = null,
            reward_item_list_ = [],
            skill_item_list_ = [],
            location,
            location1,
            cache_effect,
            cache_model,
            cache_model_type,
            skill_pos_x = [30,0,30],
            skill_pos_y = [0,100,200]


        this.load_callback = () => {
            LoadCallback()
            InitEvent()
        }
        let LoadCallback = () => {
            this._lab_time.style.fontSize = 20
            this._lab_time.style.color = "#ffffff"
            this._lab_time.style.wordWrap = false
            this._lab_time.style.bold = true
            this._fight_item = new FightingShowSmallItem(this._gp_fight)
            this._fight_item.Load()
            this._fight_item.IsCenter(true, false)
            this._fight_item.SetScale(1.3)
            location = this._img_model.y
            location1 = this._gp_effect.y
            let bg_name = "ui_wgzg_01"
            if(this.windows_cfg){
                bg_name = this.windows_cfg.bg
                res_mgr.SetOutsideImageSprite(this, this._img_close, GameResPath.GetIcon("rareSurface", this.windows_cfg.close_btn_bg))
                res_mgr.SetOutsideImageSprite(this, this._img_adorn, GameResPath.GetIcon("rareSurface", this.windows_cfg.btn_line))
                SetLocalPositionX(this._gp_list, 660)
                SetLocalPositionX(this._img_adorn, 677)
            }
            else{
                res_mgr.SetImageSprite(this, this._img_close, "rareSurface", "uihfqrhl_0091")
                res_mgr.SetImageSprite(this, this._img_adorn,"rareSurface", "ui_wgzg_06")
            }
            res_mgr.SetTexture(this, this._img_bg, GameResPath.GetIcon("rareSurface", bg_name), undefined, undefined, true)
            res_mgr.SetTexture(this, this._img_banner, GameResPath.GetIcon("rareSurface", "ui_wgzg_09"))
            res_mgr.SetTexture(this, this._img_tips, GameResPath.GetIcon("rareSurface", "ui_wgzg_03"))
            if (!_info) return
            act_etime = _info.etime
            model.CloseACTRed(_info.base_type, _info.sub_type)
            _cond = model.GetActCondition(_info.base_type, _info.sub_type, "info")
            if (!this._timer) {
                this._timer = GlobalTimerQuest.AddPeriodQuest(() => {
                    this.onTimer();
                }, 1, -1);
            }
            this.InitInfo()
        }

        let InitEvent = () => {
            let down_pos = new Vector2()
            let good_tips = ()=>{
                let rewards = model.GetActReward(_info.base_type, _info.sub_type, select_item.form_type, select_item.reward)
                if(rewards){
                    let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(rewards[0][0], rewards[0][1])
                    UIToolTipMgr.GetInstance().DefaultAppendTips(type_id,rewards[0][2])
                }
            }

            let touchModelOperate = (target: Laya.Event) =>{
                if(!target) return;
                if(target.type == "mousedown"){
                    down_pos.x = target.stageX
                    down_pos.y = target.stageY
                }else if(target.type == "mouseup"){
                    if(down_pos.x != target.stageX || down_pos.y != target.stageY) return
                    good_tips()
                }
            }
            Util.AddClickEvent(this._btn_buy, () => {
                if (select_item.status != 2) {
                    let check_func = (bool: boolean) => {
                        model.setKeyDicValue(_info.base_type, _info.sub_type,"is_show_alert",bool) 
                    }
                    let ok_func = () => {
                        model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33265, _info.base_type, _info.sub_type, select_item.grade)
                    }
                    let cur_cond = model.GetActCondition(_info.base_type, _info.sub_type, "data", select_item.grade)
                    if (cur_cond) {
                        if (cur_cond.recharge_id) {
                            let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
                            let cfg = Config.PRELOAD_SERVER_CONFIG.config_recharge_product
                            let product_info = cfg[Number(cur_cond.recharge_id)]
                            if (hasNum >= product_info.money) {
                                VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO, 15804, 'i', product_info.product_id)
                            } else {
                                if (product_info) {
                                    PlatformManager.GetInstance().PayRequest(product_info.money, { id: product_info.product_id, pay_title: product_info.product_name })
                                }
                            }
                        } else if (cur_cond.cost) {
                            let money_enough = false
                            let money_name = "勾玉"
                            if(Number(cur_cond.cost[0][0]) == 1){
                             money_enough = RoleManager.GetInstance().mainRoleInfo.jin >= Number(cur_cond.price[1])
                            }else{
                                money_name = "绑玉"
                                money_enough = RoleManager.GetInstance().mainRoleInfo.jinLock >= Number(cur_cond.price[1]) 
                            }
                             
                            if (money_enough) {
                                if (!model.getKeyDicValue(_info.base_type, _info.sub_type,"is_show_alert")) {
                                    let str = `是否消耗<font color='#639c12'>${cur_cond.price[1] + money_name}</font>进行抢购？`
                                    let content = Util.StrToHTML(str)
                                    Alert.Show(content, Alert_Type.AlertTypeCheckBox, ok_func, undefined, "确定", "取消", undefined, false, check_func, "本次登录不再提示")
                                } else {
                                    ok_func()
                                }
                            } else {
                                let charge_fun = () => {
                                    OpenFun.OpenFunHandler(21)
                                }
                                let str = `您的勾玉不足${cur_cond.price[1]}，是否前往充值`
                                Alert.Show(str, Alert_Type.One, charge_fun, undefined, "确定")
                            }
                        }
                    }
                }
            }, this, true)
            Util.AddClickEvent(this._btn_pack, () => {
                let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
                let cfg = Config.PRELOAD_SERVER_CONFIG.config_recharge_product
                let product_info = cfg[Number(_cond.one_package[1])]
                if (hasNum >= product_info.money) {
                    VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO, 15804, 'i', product_info.product_id)
                } else {
                    if (product_info) {
                        PlatformManager.GetInstance().PayRequest(product_info.money, { id: product_info.product_id, pay_title: product_info.product_name })
                    }
                }
            }, this, true)
            Util.AddClickEvent(this._img_close, () => {
                this.Close()
            }, this, true)
            Util.AddClickEvent(this._img_model, ()=>{
                good_tips()
            },this)
            Util.AddClickEvent(this._gp_effect, ()=>{
                good_tips()
            },this)
            this._gp_model.on(Laya.Event.MOUSE_DOWN,this,touchModelOperate)
            this._gp_model.on(Laya.Event.MOUSE_UP,this,touchModelOperate)
            // Util.AddClickEvent(this._gp_model, ()=>{
            //     good_tips()
            // },this)
            this.BindEvent(model, local_CustomActivityDefine.EVENT.UPDATE_VIEW, (...args) => {
                if (!_info) return
                let b = _info.base_type
                let s = _info.sub_type
                if(args[2] &&select_item.grade == args[2] && !!suf_loop_mgr){
                    model.ChangeVar("update_rare_surface",args[2])
                }
                if (b == args[0] && s == args[1]) {
                    if (select_item.status != 2) select_item.status = 2
                    if (this._gp_banner.visible) {
                        this.UpdateBannerInfo()
                    }
                    this.InitInfo()
                }
            })
        }

        this.InitInfo = () => {
            _data = model.GetActData(_info.base_type, _info.sub_type)
            this._gp_banner.visible = _cond && _cond.one_package
            this._img_adorn.visible = this._gp_list.visible = _data && _data.reward_list && _data.reward_list.length > 1
            if (this._gp_banner.visible) {
                this.UpdateBannerInfo()
            }
            if (this._gp_list.visible) {
                this.UpdateListInfo()
            } else {
                select_item = _data.reward_list[0]
                this.UpdateSelectItem()
            }
        }
        this.UpdateListInfo = () => {
            let list = _data.reward_list.concat()
            this._img_adorn.height = (list.length + 1) * 110
            table.sort(list, (a, b) => {
                return a.grade < b.grade
            })

            let index = select_item ? select_item.grade - 1 :0
            if (!suf_loop_mgr) {
                suf_loop_mgr = new LoopScrowViewMgr()
                suf_loop_mgr.SetData(this._gp_list, RareSurfaceListItem, list, LoopScrCon.Vertical, 1, () => {
                    this.SwitchTab()
                }, null, null, null, false)
            } else {
                suf_loop_mgr.replaceAll(list)
            }
            this._gp_list.selectedIndex = index
            select_item = select_item? select_item : list[index]
            this.UpdateSelectItem()
        }

        this.SwitchTab = () => {
            select_item = this._gp_list.selectedItem
            this.UpdateSelectItem()
        }
        /**下方banner图判断*/
        this.UpdateBannerInfo = () => {
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_recharge_product
            let pack_price = 0
            let surplus_price = 0
            if (cfg && cfg[Number(_cond.one_package[1])]) {
                let product_info = cfg[Number(_cond.one_package[1])]
                pack_price = product_info.money || 0
                for (let item of _data.reward_list) {
                    if (item.status != 2) {
                        let rew_cond = model.GetActCondition(_info.base_type, _info.sub_type, "data", item.grade)
                        let surplus_info = cfg[Number(rew_cond.recharge_id)]
                        surplus_price += surplus_info.money || 0
                    }
                }
                this._lab_pack.text = `${pack_price}元`
                this._gp_banner.visible = surplus_price >= pack_price
            }
        }
        this.UpdateSelectItem = () => {
            if (!_info || !select_item) return
            let cur_cond = model.GetActCondition(_info.base_type, _info.sub_type, "data", select_item.grade)
            this._img_title.visible = cur_cond && cur_cond.title
            this._img_gift.visible = cur_cond && cur_cond.gift
            this._gp_skill.visible = cur_cond && cur_cond.skill
            this._gp_reward.visible = cur_cond && cur_cond.is_show_reward == 1
            this._gp_tips.visible = cur_cond && cur_cond.rebate 
            this._img_buy_icon.visible = cur_cond && cur_cond.cost && select_item.status != 2
            this._gp_fight.visible = cur_cond && cur_cond.fight
            this._gp_time.y = this._img_gift.visible ? 274 : 226
            this._lab_buy.text = select_item.status == 2 ? "已购买" : ""
            if (this._img_title.visible) {
                res_mgr.SetTexture(this, this._img_title, GameResPath.GetIcon("rareSurface", `${cur_cond.title}`), undefined, undefined, true)
            }
            if (this._img_gift.visible) {
                res_mgr.SetTexture(this, this._img_gift, GameResPath.GetIcon("rareSurface", `${cur_cond.gift}`), undefined, undefined, true)
            }
            if (this._gp_fight.visible) {
                this._fight_item.Updatefighting(cur_cond.fight || 0)
            }
            if (this._gp_reward.visible) {
                let rewards = model.GetActReward(_info.base_type, _info.sub_type, select_item.form_type, select_item.reward)
                for (let i in rewards) {
                    let item: EquipmentItem = reward_item_list_[i]
                    if (!item) {
                        item = new EquipmentItem(this._gp_reward)
                        item.Load()
                        item.SetItemSize(90, 90)
                        reward_item_list_.push(item)
                    }
                    item.ExcuteCallback(() => {
                        let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(rewards[i][0], rewards[i][1])
                        item.SetData(type_id, rewards[i][2])
                    })
                }
            } else {
                if (reward_item_list_.length > 0) {
                    for (let item of reward_item_list_) {
                        item.DeleteMe()
                    }
                    reward_item_list_.length = 0
                }
            }
            if (this._gp_tips.visible) {
                if(!Number(cur_cond.rebate[1])&&!Number(cur_cond.rebate[2]) &&!Number(cur_cond.rebate[3])){
                    this._gp_tips.visible = false
                }else{ //只计入充值
                    this._img_icon.visible = this._lab_back.visible = Number(cur_cond.rebate[1]) != 0
                    this._lab_add.visible = Number(cur_cond.rebate[3]) !=0
                    if(this._lab_back.visible){
                        let url = Number(cur_cond.rebate[2]) == 1 ? "com_diamond" : "com_bind_diamond"
                        res_mgr.SetImageSprite(this, this._img_icon, "common", url)
                        this._lab_back.text = `即刻抢购可立返${cur_cond.rebate[1]}`
                    }else{
                        this._lab_back.text = ""
                        this._img_icon.width = 0
                    }   
                    this._gp_tips_h.refresh()
                }
            }
            if (this._gp_skill.visible) {
                if (skill_item_list_.length > cur_cond.skill.length) {
                    for (let item of skill_item_list_) {
                        item.DeleteMe()
                    }
                    skill_item_list_.length = 0
                }
                this.UpdateSkillInfo(cur_cond.skill)
            }
            if (cur_cond && select_item.status != 2) {
                if (cur_cond.recharge_id) {
                    this._lab_buy.text = `${cur_cond.price[1]}元`
                } else if (cur_cond.cost) {
                    let url = Number(cur_cond.cost[0][0]) == 1 ? "com_diamond" : "com_bind_diamond"
                    res_mgr.SetImageSprite(this, this._img_buy_icon, "common", url)
                    this._lab_buy.text = `购买${cur_cond.price[1]}`
                }
            }
            this.UpdateModelInfo(cur_cond)
            this._gp_bottom.refresh()
        }

        this.UpdateSkillInfo = (skills) => {
            if (skills.length == 1) {
                skill_pos_x = [-50]
                skill_pos_y = [130]
            } else if (skills.length == 2) {
                skill_pos_x = [-10, -10]
                skill_pos_y = [50, 210]
            } else if (skills.length == 3) {
                skill_pos_x = [-10, -50, -10]
                skill_pos_y = [10, 130, 250]
            } else if (skills.length == 4) {
                skill_pos_x = [0, -40, -40, 15,]
                skill_pos_y = [-30, 90, 210, 330]
            }
            for (let i = 0, l = skills.length; i < l; i++) {
                let item: RareSurfaceSkillItem = skill_item_list_[i]
                if (!item) {
                    item = new RareSurfaceSkillItem(this._gp_skill)
                    item.Load()
                    skill_item_list_.push(item)
                }
                item.ExcuteCallback(() => {
                    item.SetData(skills[i])
                    item.SetPosition(skill_pos_x[i], skill_pos_y[i])
                })
            }
        }
        this.UpdateModelInfo = (cur_cond) => {
            this._img_model.visible = cur_cond.icon
            if (cur_cond.icon) {
                this._gp_effect.visible = this._gp_model.visible = false
                this.ClearTween()
                ResManager.GetInstance().SetTexture(this, this._img_model, GameResPath.GetIcon("ftvInvest", `${cur_cond.icon[0][1]}`), null, this, true)
                if (!this._tween_id) {
                    SetAnchoredPositionY(this._img_model, location)
                    this._tween_id = SYTweenLite.to(this, this._img_model, SYTweenLite.UiAnimationType.POSY, location - 25, 2, null, SYTweenFunc.PINGPONG, true)
                }
            }
            if (cur_cond.effect && cur_cond.effect[0]) {
                if (!cache_effect || cache_effect != cur_cond.effect[0][1]) {
                    cache_model = null
                    cache_model_type = null
                    cache_effect = cur_cond.effect[0][1]
                    this.ClearUIEffect(this._gp_effect)
                    this._gp_effect.visible = true
                    this._gp_model.visible = false
                    this.AddUIEffect(cur_cond.effect[0][1], this._gp_effect, undefined, 1)
                    this.ClearTween()
                    if (!this._tween_id) {
                        SetAnchoredPositionY(this._gp_effect, location1)
                    }
                }
            }
            if (cur_cond.model && cur_cond.model[0]) {
                if (!cache_model || (cache_model != cur_cond.model[0][1] || cache_model_type != cur_cond.model[0][0])) {
                    cache_effect = null
                    cache_model = cur_cond.model[0][1]
                    cache_model_type = cur_cond.model[0][0]
                    this.ClearTween()
                    this._gp_effect.visible = false
                    this._gp_model.visible = true
                    let model_id = cur_cond.model[0]
                    model.ShowViewModel(this, "RareSurfaceView", model_id, this._gp_model, null, true, null, null, null, true)
                }
            }
        }
        this.onTimer = () => {
            if (act_etime >= TimeUtil.getServerTime()) { //活动时间
                this._lab_time.innerHTML = Util.StrToHTML(`倒计时：<font color='#90fa14'>
                ${TimeUtil.timeConvert(act_etime - TimeUtil.getServerTime(), 'hh-mm-ss')}</font>`)
            } else {
                this._lab_time.innerHTML = Util.StrToHTML(`<font color = '#ffffff'>活动已结束</font>`)
                this._lab_buy.text = `已结束`
                this.removeTimer();
            }
            SetHtmlCenter(this._lab_time, { x: 0, w: 334 })
        }

        this.removeTimer = () => {
            if (this._timer) {
                GlobalTimerQuest.CancelQuest(this._timer)
                this._timer = null
                act_etime = 0
            }
        }
        this.destroy_callback = () => {
            this.ClearUIEffect(this._gp_effect)
            cache_effect = null
            cache_model = null
            if (reward_item_list_.length > 0) {
                for (let item of reward_item_list_) {
                    item.DeleteMe()
                }
                reward_item_list_.length = 0
            }
            if (skill_item_list_.length > 0) {
                for (let item of skill_item_list_) {
                    item.DeleteMe()
                }
                skill_item_list_.length = 0
            }
            if (suf_loop_mgr) {
                suf_loop_mgr.DeleteMe()
                suf_loop_mgr = null
            }
            if (this._fight_item) {
                this._fight_item.DeleteMe()
                this._fight_item = null
            }
            if (select_item) select_item = null
            this.removeTimer()
        }

        this.DeleteMe = () => {
            super.DeleteMe()
        }

        this.SetActInfo = (info, parm) => {
            if (!info) return
            _info = info
            this.key = `331@${info.base_type}@${info.show_id}`
            let cfg = cfg_custom_activity["CAN_CHANGE_RESSORCE_FESTIVAL"]
            if(cfg[this.key]){
                this.windows_cfg = cfg[this.key]
            }
        }
    }

    public ClearTween() {

        if (this._tween_id) {
            SYTweenLite.Stop(this._tween_id)
            this._tween_id = null
        }
    }



    public GetComponents() {
        [
            this._img_bg,
            this._img_adorn,
            this._img_title,
            this._img_gift,
            this._gp_time,
            this._lab_time,
            this._img_model,
            this._gp_effect,
            this._gp_model,
            this._img_close,
            this._gp_list,
            this._gp_skill,
            this._gp_bottom,
            this._gp_fight,
            this._gp_reward,
            this._gp_tips,
            this._img_tips,
            this._gp_tips_h,
            this._lab_back,
            this._img_icon,
            this._lab_add,
            this._btn_buy,
            this._lab_buy,
            this._img_buy_icon,
            this._gp_banner,
            this._img_banner,
            this._btn_pack,
            this._lab_pack,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_adorn",
                "_img_title",
                "_img_gift",
                "_gp_time",
                "_lab_time",
                "_img_model",
                "_gp_effect",
                "_gp_model",
                "_img_close",
                "_gp_list",
                "_gp_skill",
                "_gp_bottom",
                "_gp_fight",
                "_gp_reward",
                "_gp_tips",
                "_img_tips",
                "_gp_tips_h",
                "_lab_back",
                "_img_icon",
                "_lab_add",
                "_btn_buy",
                "_lab_buy",
                "_img_buy_icon",
                "_gp_banner",
                "_img_banner",
                "_btn_pack",
                "_lab_pack",
            ])
    }
}
window["RareSurfaceView"] = RareSurfaceView