import { Alert, Alert_Type } from "../alert/Alert";
import { BaseItem1 } from "../common/BaseItem1";
import { EquipmentItem } from "../common/EquipmentItem";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, NotEnougnDiamond, SetHtmlCenter, Util } from "../util/Util";
import { FtvInvestBtnView } from "./FtvInvestBtnView";
import { FtvInvestRewardView } from "./FtvInvestRewardView";

export class FtvInvestView extends BaseItem1 {
    _gp_bottom: Laya.Box
    _gp_effect: Laya.Box
    _gp_model: Laya.Box
    _img_model: Laya.Image
    _img_title: Laya.Image
    _lab_time: Laya.HTMLDivElement
    _tab_list: Laya.List
    _fight_box: Laya.Box
    fight_num: Laya.Label
    _lab_buy: Laya.Label
    _bottom_box: Laya.Box
    _img_icon1: Laya.Image
    _lab_present: Laya.Label
    _lab_original: Laya.Label
    _img_icon: Laya.Image
    invest_btn: Laya.Box
    labelDisplay: Laya.Label
    _rew_box: Laya.HBox
    _day_box: Laya.HBox

    _timer
    InitEvent
    UpdateViewInfo
    RefGradeCfg
    SetTabListInfo
    InitRewardItem
    RefBtn
    ShowModel
    ClearModel
    onTimer
    removeTimer
    UpdateDayList
    CustomMehod
    ShowAnimation
    ShowAnimation2
    public constructor(parent) {
        super(parent);
        let model = CustomActivityModel.GetInstance(),
            local_Util = Util,
            local_Message = Message,
            local_Number = Number,
            local_CustomActivityDefine = CustomActivityDefine,
            local_TimeUtil = TimeUtil,
            info_, //参数信息
            btn_loop_mgr,
            cond_,
            data_,
            act_etime,
            buy_etime,
            reward_list_,
            cur_show_reward,
            select_grade_ = 0,
            reward_red = [],
            reward_item_list_ = [],
            day_item_list_ = [],
            _type_id
        this._timer = null;
        this.base_file = 'ftvInvest';
        this.layout_file = 'FtvInvestView';
        this.load_callback = () => {
            LoadCallback();
            InitEvent();
        }
        let LoadCallback = () => {
            if (!info_) return
            act_etime = info_.etime //活动结束时间
            model.CloseACTRed(info_.base_type, info_.sub_type, undefined, info_.show_id)
            cond_ = model.GetActCondition(info_.base_type, info_.sub_type, "info") //购买时间
            if (model.act_key_dic[info_.base_type][info_.sub_type]["buy_time"]) {
                buy_etime = model.act_key_dic[info_.base_type][info_.sub_type]["buy_time"]
            }
            this._lab_time.style.fontSize = 20
            this._lab_time.style.wordWrap = false
            let data = model.GetActData(info_.base_type, info_.sub_type)
            if (!data) return
            data_ = data
            if (!this._timer) {
                this._timer = GlobalTimerQuest.AddPeriodQuest(() => {
                    this.onTimer();
                }, 1, -1);
            }
            ResManager.GetInstance().SetTexture(this, this._img_title, GameResPath.GetIcon("ftvInvest", "uijrtz_002"), undefined, undefined, true)
            this.onTimer()
            this.ClearUIEffect(this._gp_bottom)
            this.AddUIEffect(`ui_fazhen_03`, this._gp_bottom, undefined, 4)
            this.RefGradeCfg() //更新奖励信息
            this.SetTabListInfo()
            this.UpdateViewInfo()
            this.ShowModel()
        }

        let InitEvent = () => {
            //切换内容
            this.BindEvent(model, CustomActivityDefine.EVENT.FTV_INVEST_TAB_SELECT, (data: any, index: number) => {
                if (select_grade_ == index) return
                select_grade_ = index;
                btn_loop_mgr.SetSelectIndex(select_grade_);
                cur_show_reward = data
                this.ShowModel()
                this.UpdateViewInfo()
            });
            Util.AddClickEvent(this.invest_btn, () => {
                if (!cur_show_reward) return
                let b = data_.base_type
                let s = data_.sub_type
                if (!model.act_key_dic[b] || !model.act_key_dic[b][s]) return
                let num, name, have_num
                let mainRole = RoleManager.GetInstance().mainRoleInfo
                if (cur_show_reward.status == 0) {
                    for (let cost of cond_.invest_cost) {
                        if (select_grade_ == local_Number(cost[0]) - 1) {
                            num = local_Number(cost[1][0][2])
                            name = local_Number(cost[1][0][0]) == 1 ? "勾玉" : "绑玉"
                            have_num = local_Number(cost[1][0][0]) == 1 ? mainRole.jin : mainRole.jin + mainRole.jinLock
                        }
                    }
                    let ok_func = () => {
                        if (num > have_num) {
                            NotEnougnDiamond()
                        } else {
                            model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 33212, b, s, cur_show_reward.lv);
                        }
                    }
                    let str = `是否消耗<font color='#639c12'>${num}${name}</font>进行投资`
                    Alert.Show(Util.StrToHTML(str), Alert_Type.Two, ok_func)
                } else {
                    local_Message.show(`已投资`)
                }
            }, this, true)

            this.BindEvent(model, local_CustomActivityDefine.EVENT.UPDATE_VIEW, (...args) => {
                if (!info_) return
                let b = info_.base_type
                let s = info_.sub_type
                if (b == args[0] && s == args[1]) {
                    data_ = model.GetActData(b, s)
                    if (!data_) return
                    this.RefGradeCfg()
                    this.SetTabListInfo()
                    this.UpdateViewInfo()
                }
            })
        }

        this.UpdateViewInfo = () => {
            if (!cur_show_reward) return
            let rewards = model.GetActReward(info_.base_type, info_.sub_type, cur_show_reward.form_type, cur_show_reward.reward)
            for (let i in rewards) {
                let item: EquipmentItem = reward_item_list_[i]
                if (!item) {
                    item = new EquipmentItem(this._rew_box)
                    item.Load()
                    item.SetItemSize(95, 95)
                    reward_item_list_.push(item)
                }
                item.ExcuteCallback(() => {
                    let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(rewards[i][0], rewards[i][1])
                    item.SetData(type_id, rewards[i][2])
                })
            }
            for (let cost of cond_.invest_cost) { //价格显示
                if (select_grade_ == local_Number(cost[0]) - 1) {
                    this._lab_original.text = `原价:${cost[2][0][2]}`
                    this._lab_present.text = `现价:${cost[1][0][2]}`
                    let url = local_Number(cost[2][0][0]) == 1 ? "com_diamond" : "com_bind_diamond"
                    let url1 = local_Number(cost[1][0][0]) == 1 ? "com_diamond" : "com_bind_diamond"
                    ResManager.GetInstance().SetImageSprite(this, this._img_icon, "common_asset", url)
                    ResManager.GetInstance().SetImageSprite(this, this._img_icon1, "common_asset", url1)
                }
            }
            this.labelDisplay.text = cur_show_reward.status == 0 ? buy_etime > local_TimeUtil.getServerTime() ? "立即投资" : "已过期" : "已投资"


            this.UpdateDayList()
        }

        this.UpdateDayList = () => {
            if (!reward_list_ || reward_list_.length == 0) return
            let day_list = []
            for (let item of reward_list_) {
                let rew_cond = model.GetActCondition(info_.base_type, info_.sub_type, "data", item.grade)
                if (rew_cond.login_days && item.lv == select_grade_ + 1) {
                    day_list.push(item)
                }

            }
            table.sort(day_list, (a, b) => {
                return a.grade < b.grade
            })
            for (let i = 0, l = day_list.length; i < l; i++) {
                let item: FtvInvestRewardView = day_item_list_[i]
                if (!item) {
                    item = new FtvInvestRewardView(this._day_box)
                    item.Load()
                    day_item_list_.push(item)
                }
                item.ExcuteCallback(() => {
                    item.SetData(day_list[i])
                })
            }

        }

        this.RefGradeCfg = () => {
            let reward_list = []
            let redInfo = [0, 0]
            if (data_.reward_list) {
                for (let i in data_.reward_list) {
                    let item = data_.reward_list[i]
                    let rew_cond = model.GetActCondition(info_.base_type, info_.sub_type, "data", item.grade)
                    item.b = info_.base_type //大类
                    item.s = info_.sub_type //子类
                    item.lv = local_Number(rew_cond.investment_lv) //类型
                    reward_list.push(item)
                    if (item.status == 1 && !redInfo[item.lv - 1]) {
                        redInfo[item.lv - 1] = 1
                    }
                }
            }
            if (reward_list.length == 0) return
            reward_red = redInfo
            reward_list_ = reward_list
        }

        /**列表按钮信息 */
        this.SetTabListInfo = () => {
            if (!reward_list_ || reward_list_.length == 0) return
            let tabList = []
            for (let item of reward_list_) {
                let cond = model.GetActCondition(info_.base_type, info_.sub_type, "data", item.grade)
                if (cond.buy_reward && cond.buy_reward == 1) {
                    item.bool = reward_red[local_Number(cond.investment_lv) - 1] == 1//红点
                    tabList.push(item)
                }
            }
            table.sort(tabList, (a, b) => {
                return a.grade < b.grade
            })
            if (!btn_loop_mgr) {
                btn_loop_mgr = new LoopScrowViewMgr()
                btn_loop_mgr.SetData(this._tab_list, FtvInvestBtnView, tabList, LoopScrCon.Horizontal, 1)
            } else {
                btn_loop_mgr.replaceAll(tabList)
            }
            btn_loop_mgr.SetSelectIndex(select_grade_)
            cur_show_reward = tabList[select_grade_]
        }

        this.ShowModel = () => {

            let rew_cond = model.GetActCondition(info_.base_type, info_.sub_type, "data", cur_show_reward.grade)
            this._img_model.visible = rew_cond.show_img
            this._fight_box.visible = rew_cond.fight
            this._img_model.y = 250
            if (rew_cond.show_img) {
                this._gp_effect.visible = this._gp_model.visible = false
                Laya.Tween.clearAll(this._img_model)
                this.ShowAnimation()
                ResManager.GetInstance().SetTexture(this, this._img_model, GameResPath.GetIcon("ftvInvest", `${rew_cond.show_img}`), null, this, true)
            }
            if (rew_cond.show_effect && rew_cond.show_effect[0]) {
                this.ClearUIEffect(this._gp_effect)
                this._gp_effect.visible = true
                this._gp_model.visible = false
                this._gp_effect.width = 720
                this._gp_effect.height = 1280
                this.AddUIEffect(rew_cond.show_effect[0][1], this._gp_model, undefined, 1)
            }
            if (rew_cond.show_model && rew_cond.show_model[0]) {
                this._gp_effect.visible = false
                this._gp_model.visible = true
                let model_id = rew_cond.show_model[0]

                model.ShowViewModel(this, "FtvInvestView", model_id, this._gp_model, null, true, null, null, null, true)
            }
            if (rew_cond.fight) {
                this.fight_num.text = `${rew_cond.fight}`
            }
        }
        this.ShowAnimation = () => {
            Laya.Tween.to(this._img_model, { y: this._img_model.y - 10 }, 700, undefined, Laya.Handler.create(this, () => {
                this.ShowAnimation2()
            }))
        }

        this.ShowAnimation2 = () => {
            Laya.Tween.to(this._img_model, { y: this._img_model.y + 10 }, 700, undefined, Laya.Handler.create(this, () => {
                this.ShowAnimation()
            }))
        }

        this.onTimer = () => {
            if (act_etime >= TimeUtil.getServerTime()) { //活动时间
                this._lab_time.innerHTML = Util.StrToHTML(`<font color = '#ffffff'>活动倒计时:</font><font color='#90fa14'>
                ${TimeUtil.timeConvert(act_etime - TimeUtil.getServerTime(), 'hh-mm-ss')}</font>`)
                if (cur_show_reward) {
                    if (buy_etime >= TimeUtil.getServerTime() && cur_show_reward.status != 2) {
                        this._lab_buy.text = `${TimeUtil.timeConvert(buy_etime - TimeUtil.getServerTime(), 'hh-mm-ss')}后结束购买`
                    } else {
                        this._lab_buy.text = `${TimeUtil.timeConvert(act_etime - TimeUtil.getServerTime(), 'hh-mm-ss')}后活动结束`
                    }
                }
            } else {
                this._lab_time.innerHTML = Util.StrToHTML(`<font color = '#ffffff'>活动已结束</font>`)
                this._lab_buy.text = `活动已结束`
                this.removeTimer();
            }
        }

        this.removeTimer = () => {
            if (this._timer) {
                GlobalTimerQuest.CancelQuest(this._timer)
                this._timer = null
                act_etime = 0
            }
        }

        this.CustomMehod = (index, arg) => {
            if (arg) {
                info_ = arg[0]
            }
        }

        this.DeleteMe = () => {
            if (btn_loop_mgr) {
                btn_loop_mgr.DeleteMe();
                btn_loop_mgr = null;
            }

            if (reward_item_list_.length > 0) {
                for (let item of reward_item_list_) {
                    item.DeleteMe()
                }
                reward_item_list_.length = 0
            }
            if (day_item_list_.length > 0) {
                for (let item of day_item_list_) {
                    item.DeleteMe()
                }
                day_item_list_.length = 0
            }
            Laya.Tween.clearAll(this._img_model)
            this.ClearUIEffect(this._gp_effect)
            this.ClearUIEffect(this._gp_model)
            this.ClearUIEffect(this._gp_bottom)
            this.removeTimer()
            super.DeleteMe();
        }
    }

    public GetComponents() {
        [
            this._gp_bottom,
            this._gp_effect,
            this._gp_model,
            this._img_model,
            this._img_title,
            this._lab_time,
            this._tab_list,
            this._fight_box,
            this.fight_num,
            this._lab_buy,
            this._bottom_box,
            this._img_icon1,
            this._lab_present,
            this._lab_original,
            this._img_icon,
            this.invest_btn,
            this.labelDisplay,
            this._rew_box,
            this._day_box,
        ]
            = this.GetChildrenByNames([

                "_gp_bottom",
                "_gp_effect",
                "_gp_model",
                "_img_model",
                "_img_title",
                "_lab_time",
                "_tab_list",
                "_fight_box",
                "fight_num",
                "_lab_buy",
                "_bottom_box",
                "_img_icon1",
                "_lab_present",
                "_lab_original",
                "_img_icon",
                "invest_btn",
                "labelDisplay",
                "_rew_box",
                "_day_box",
            ])
        ResManager.GetInstance().LoadFont(this, "fighting_font", this.fight_num, null, false);
    }
}
window["FtvInvestView"] = FtvInvestView