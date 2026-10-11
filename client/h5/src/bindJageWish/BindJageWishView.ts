import { Alert, Alert_Type } from "../alert/Alert";
import { BaseItem1 } from "../common/BaseItem1";
import { CongratulationObtainView } from "../common/CongratulationObtainView";
import { EventName } from "../common/EventName";
import { Enum_UILayer, LayerManager } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, HtmlColorTxt, SetHtmlCenter, Util } from "../util/Util";
import { BindJageRecordItem } from "./BindJageRecordItem";

export class BindJageWishView extends BaseItem1 {
    _img_title: Laya.Image
    _img_preview: Laya.Image
    _lab_tips: Laya.Text
    _lab_time: Laya.HTMLDivElement
    _lab_desc: Laya.HTMLDivElement
    _gp_sign: Laya.Box
    _gp_sign_4: Laya.Box
    _img_sign_4: Laya.Image
    _lab_multiple_4: Laya.Label
    _gp_sign_5: Laya.Box
    _img_sign_5: Laya.Image
    _lab_multiple_5: Laya.Label
    _gp_sign_1: Laya.Box
    _img_sign_1: Laya.Image
    _lab_multiple_1: Laya.Label
    _gp_sign_3: Laya.Box
    _img_sign_3: Laya.Image
    _lab_multiple_3: Laya.Label
    _gp_sign_2: Laya.Box
    _img_sign_2: Laya.Image
    _lab_multiple_2: Laya.Label
    _lab_base: Laya.Label
    _lab_max: Laya.Label
    _btn_daily: Laya.Box
    _img_daily_red: Laya.Image
    _btn_wish: Laya.Box
    _lab_btn: Laya.Label
    _lab_cost: Laya.Label
    _img_jage: Laya.Image
    _wish_red: Laya.Image
    _gp_record: Laya.List
    autoGp: Laya.Box
    _Label1: Laya.Label
    _Image14: Laya.Image
    autoImg: Laya.Image


    _act_info
    _model
    _timer
    UpdateViewInfo
    PlayTweenSign
    PlayTurnTween
    PlayResultTween
    PlayTweenEnd
    ShowRewardPop
    InitViewInfo
    onTimer
    removeTimer
    CustomMehod
    public constructor(parent) {
        super(parent);
        this.base_file = 'bindJageWish';
        this.layout_file = 'BindJageWishView';
        this.layer_value = Enum_UILayer.UI;
        let local_Event = CustomActivityDefine.EVENT,
            goods_model = GoodsModel.GetInstance(),
            local_roleMgr = RoleManager.GetInstance(),
            _record_list: LoopScrowViewMgr,
            is_play = false, //播放动画
            is_skip = false,//是否跳过动画
            act_etime,
            _cond,
            _max_multiple, //最大倍数
            reward_list,
            turn,
            times,
            max_times,
            daily_gain,
            free_times,
            is_recharge,
            cur_turn_info,
            next_turn_info,
            show_reward,
            show_cond,
            down_x = [0, 15, 0, -15, 15, -15]
        this._model = CustomActivityModel.GetInstance()
        this._timer = null
        this.load_callback = () => {
            if (!this._act_info) return
            this._lab_time.style.fontSize =  this._lab_desc.style.fontSize = 18
            this._lab_desc.style.color = "#663915"
            this._lab_time.style.bold = this._lab_desc.style.bold = true
            this._lab_time.style.wordWrap = this._lab_desc.style.wordWrap = false
            let Mask_: Laya.Sprite;
            Mask_ = new Laya.Sprite();
            Mask_.graphics.drawRect(0, 0, 250, 505, "#ffffff");
            Mask_.pos(0, 0);
            this._gp_sign.mask = Mask_
            ResManager.GetInstance().SetTexture(this, this._img_title, GameResPath.GetIcon("bindJageWish", "ui_byqy_bt"), undefined, undefined, true)
            LoadCallback()
            InitEvent()
        }
        let LoadCallback = () => {
            act_etime = this._act_info.etime
            _max_multiple = 0
            if (!this._timer) {
                this._timer = GlobalTimerQuest.AddPeriodQuest(() => {
                    this.onTimer();
                }, 1, -1);
            }
            this.onTimer()
            _cond = this._model.GetActCondition(this._act_info.base_type, this._act_info.sub_type, "info")
            if (_cond) { //倍数显示
                if(_cond.times_show){}
                for (let item of _cond.times_show) {
                    if (_max_multiple < Number(item[1])) {
                        _max_multiple = Number(item[1])
                    }
                    this[`_lab_multiple_${item[0]}`].text = `x${item[1]}`
                }
            }
            this.autoImg.visible = is_skip
            this._Image14.visible = !is_skip
            this.InitViewInfo(this._act_info)
            this._model.Fire(local_Event.SCMD_REQUEST, 33260, this._act_info.base_type, this._act_info.sub_type)
            this._model.Fire(local_Event.SCMD_REQUEST, 33197, this._act_info.base_type, this._act_info.sub_type)
        }
        let InitEvent = () => {
            //抽奖记录
            this.BindEvent(this._model, local_Event.UP_LOG_LIST, (data?) => {
                if (data && data.base_type && data.base_type == this._act_info.base_type) {
                    let list = []
                    if (data.self_list && data.self_list.length > 0) {
                        list = list.concat(data.self_list)
                        if (!_record_list) {
                            _record_list = new LoopScrowViewMgr();
                            _record_list.SetData(this._gp_record, BindJageRecordItem, list, LoopScrCon.Vertical, 1)
                        } else {
                            _record_list.replaceAll(list);
                        }
                    }
                }
            })
            this.BindEvent(this._model, local_Event.UPDATE_VIEW, (data?) => {
                if (data && data.type && data.type == this._act_info.base_type) {
                    is_recharge = data.is_first_recharge == 1 //是否充值
                    free_times = data.free_times || 0 //免费次数
                    daily_gain = data.free_gift_status == 1 //每日奖励
                    turn = data.turn //轮次
                    times = data.times //抽奖次数
                    this.UpdateViewInfo()
                }
            })
            /**每日奖励返回 */
            this.BindEvent(this._model, local_Event.BIND_JAGE_WISH_DAILY, (data?) => {
                if (data && data.type && data.type == this._act_info.base_type) {
                    daily_gain = this._btn_daily.visible = this._img_daily_red.visible = false
                    let view = new CongratulationObtainView(_cond.gift, 10)
                    view.Open()
                }
            })
            /**单次抽奖返回 */
            this.BindEvent(this._model, local_Event.BIND_JAGE_WISH_REWARD, (data?) => {
                if (data && data.type && data.type == this._act_info.base_type) {
                    let reward = reward_list[`${turn}`]
                    turn = data.turn
                    times = data.times
                    if (free_times > 0) free_times -= 1
                    show_reward = []
                    if (reward) {
                        for (let item of reward) {
                            if (item.grade == data.grade) {
                                show_cond = this._model.GetActCondition(data.type, data.subtype, "data", item.grade)
                                let cur_reward = this._model.GetActReward(data.type, data.subtype, item.form_type, item.reward)
                                if (show_cond && reward) {
                                    for (let i = 0; i < Number(show_cond.times); i++) {
                                        show_reward.push(cur_reward[0])
                                    }
                                    break
                                }
                            }
                        }
                    }
                    if (!is_skip) { //不跳过动画
                        is_play = true //是否在动画中
                        this.PlayTweenSign()
                    } else {
                        this._model.Fire(local_Event.SCMD_REQUEST, 33261, 33262)
                        this.ShowRewardPop()
                    }
                }
            })
            Util.AddClickEvent(this.autoImg, () => {
                is_skip = !is_skip
                this.autoImg.visible = is_skip
                this._Image14.visible = !is_skip
            }, this, true)
            Util.AddClickEvent(this._Image14, () => {
                is_skip = !is_skip
                this.autoImg.visible = is_skip
                this._Image14.visible = !is_skip
            }, this, true)
            Util.AddClickEvent(this._img_preview, () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BindJageWishRewardView", reward_list)
            }, this, true)
            Util.AddClickEvent(this._btn_daily, () => {
                if (daily_gain) {
                    this._model.Fire(local_Event.SCMD_REQUEST, 33263, this._act_info.base_type, this._act_info.sub_type)
                }
            }, this, true)

            Util.AddClickEvent(this._btn_wish, () => {
                if (is_play) return
                if (!cur_turn_info) {
                    Message.show("暂无下一轮次")
                    return
                }
                let cost = _cond.price[Number(turn) - 1][1][0][2]
                let cur_have = local_roleMgr.mainRoleInfo.jin
                let ok_func = () => {
                    this._model.Fire(local_Event.SCMD_REQUEST, 33262, this._act_info.base_type, this._act_info.sub_type)
                }
                let check_func = (bool: boolean) => {
                    this._model.act_key_dic[this._act_info.base_type][this._act_info.sub_type]["alert"] = bool
                }
                if (free_times > 0) {
                    ok_func()
                    return
                }
                if (cur_have >= cost) {
                    if (!this._model.act_key_dic[this._act_info.base_type][this._act_info.sub_type]["alert"]) {
                        let str = `是否消耗<font color='#639c12'>${cost}勾玉</font>进行祈愿？`
                        let content = Util.StrToHTML(str)
                        Alert.Show(content, Alert_Type.AlertTypeCheckBox, ok_func, undefined, "确定", "取消", undefined, false, check_func, "本次登录不再提示")
                    } else {
                        ok_func()
                    }
                } else {
                    let charge_fun = () => {
                        OpenFun.OpenFunHandler(21)
                    }
                    let str = `您的勾玉不足${cost}，是否前往充值`
                    Alert.Show(str, Alert_Type.One, charge_fun, undefined, "确定")
                }
            }, this, true)
        }

        this.PlayTweenSign = () => {
            for (let i = 1; i < 6; i++) {
                Laya.Tween.clearAll(this[`_gp_sign_${i}`])
                this[`_gp_sign_${i}`].scaleX = this[`_gp_sign_${i}`].scaleY = 1
                Laya.Tween.to(this[`_gp_sign_${i}`], { y: this[`_gp_sign_${i}`].y + 100, x: this[`_gp_sign_${i}`].x + down_x[i] }, 300, undefined, Laya.Handler.create(this, () => {
                    if (i == 5) { //最后一只签结束
                        this.PlayTurnTween()
                    }
                }))
            }
        }

        this.PlayTurnTween = () => {
            for (let i = 1; i < 6; i++) {
                Laya.Tween.to(this[`_gp_sign_${i}`], { scaleX: -1 }, 200, undefined, Laya.Handler.create(this, () => {
                    this[`_lab_multiple_${i}`].text = ``
                    this[`_img_sign_${i}`].skin = GameResPath.GetIcon("bindJageWish", "byqy_cq_03")
                    if (i == 5) {
                        setTimeout(() => {
                            this.PlayResultTween()
                        }, 500);
                    }
                }))
            }
        }

        this.PlayResultTween = () => {
            // let sign_num = 1
            // for (let item of _cond.times_show) {
            //     if (Number(item[1]) == Number(show_cond.times)) {
            //         sign_num = Number(item[0])
            //         break
            //     }
            // }
            let item = this[`_gp_sign_2`]
            Laya.Tween.to(item, { y: item.y - 100, x: item.x - down_x[2] }, 150, undefined, Laya.Handler.create(this, () => {
                Laya.Tween.to(item, { scaleX: 1 }, 150, undefined, Laya.Handler.create(this, () => {
                    this[`_img_sign_2`].skin = GameResPath.GetIcon("bindJageWish", "byqy_cq_01")
                    this[`_lab_multiple_2`].text = `x${Number(show_cond.times)}`
                    setTimeout(() => {
                        this.PlayTweenEnd(2)
                    }, 1000);
                }))
            }))
        }

        this.PlayTweenEnd = (num) => {
            is_play = false
            for (let item of _cond.times_show) {
                let sign = this[`_gp_sign_${item[0]}`]
                if (num != Number(item[0])) {
                    Laya.Tween.to(sign, { y: sign.y - 100, x: sign.x - down_x[Number(item[0])] }, 150, undefined, Laya.Handler.create(this, () => {
                        Laya.Tween.to(sign, { scaleX: 1 }, 150, undefined, Laya.Handler.create(this, () => {
                            this[`_img_sign_${item[0]}`].skin = GameResPath.GetIcon("bindJageWish", "byqy_cq_01")
                            this[`_lab_multiple_${item[0]}`].text = `x${item[1]}`
                          
                        }))
                    }))
                }else{
                    this[`_lab_multiple_${item[0]}`].text = `x${item[1]}`
                }
            }
            this._model.Fire(local_Event.SCMD_REQUEST, 33261, 33262)
            this.ShowRewardPop()

        }

        this.ShowRewardPop = () => {
            let layer_mgr: LayerManager = LayerManager.GetInstance()
            let point = { x: layer_mgr.stageWidth / 2, y: layer_mgr.stageHeight / 2 };
            GlobalEventSystem.Fire(EventName.REWARD_FLY, show_reward, point, undefined, undefined, 0, 0)
            let view = new CongratulationObtainView(show_reward)
            view.Open()
            this.UpdateViewInfo()
        }

        this.InitViewInfo = (info?) => {
            reward_list = {}
            let act_data = this._model.GetActData(info.base_type, info.sub_type)
            if (act_data && act_data.reward_list && act_data.reward_list.length > 0) {
                for (let item of act_data.reward_list) {
                    let cond = this._model.GetActCondition(info.base_type, info.sub_type, "data", item.grade)
                    if (!reward_list[cond.turn]) reward_list[cond.turn] = []
                    reward_list[cond.turn].push(item)
                }
            }
            if (reward_list) { //排序
                for (let turn in reward_list) {
                    table.sort(reward_list[turn], (a, b) => {
                        return a.grade < b.grade
                    })
                }
            }
        }

        this.UpdateViewInfo = () => {
            let b = this._act_info.base_type
            let s = this._act_info.sub_type
            let cur_cond, next_cond
            cur_turn_info = reward_list[`${turn}`] ? reward_list[turn][0] : null
            next_turn_info = reward_list[`${turn + 1}`] ? reward_list[`${turn + 1}`][0] : null
            if(_cond && _cond.turn_frequency){
                for(let item of _cond.turn_frequency){
                    if(Number(item[0]) == turn){
                        max_times = Number(item[1])
                        break
                    }
                }
            }
            if (cur_turn_info) {
                cur_cond = this._model.GetActReward(b, s, cur_turn_info.form_type, cur_turn_info.reward)
                let [type_id, lock] = goods_model.GetMappingTypeId(cur_cond[0][0], cur_cond[0][1])
                let cur_goods = goods_model.GetGoodsBasicByTypeId(type_id)
                let max_jage = `${(Number(cur_cond[0][2]) * _max_multiple) + cur_goods.goods_name}`
                this._lab_max.text = max_jage
                this._lab_base.text = `${Number(cur_cond[0][2])}`
                if (!next_turn_info) {
                    this._lab_desc.innerHTML = Util.StrToHTML(`已达到最高轮次`)
                } else {
                    next_cond = this._model.GetActReward(b, s, next_turn_info.form_type, next_turn_info.reward)
                    let [type_id, lock] = goods_model.GetMappingTypeId(next_cond[0][0], next_cond[0][1])
                    let next_goods = goods_model.GetGoodsBasicByTypeId(type_id)
                    let max_jage = `${(Number(next_cond[0][2]) * _max_multiple) + next_goods.goods_name}`
                    let need_wish = max_times - times
                    this._lab_desc.innerHTML = Util.StrToHTML(`抽<font color = '#00b22a'>${need_wish}次</font>
                    进入下一轮最高<font color = '#00b22a'>${max_jage}</font>`)
                }
            } else { // 无
                let max_turn_info = reward_list[`${Number(turn) - 1}`] ? reward_list[Number(turn) - 1][0] : null
                cur_cond = this._model.GetActReward(b, s, max_turn_info.form_type, max_turn_info.reward)
                let [type_id, lock] = goods_model.GetMappingTypeId(cur_cond[0][0], cur_cond[0][1])
                let cur_goods = goods_model.GetGoodsBasicByTypeId(type_id)
                let max_jage = `${(Number(cur_cond[0][2]) * _max_multiple) + cur_goods.goods_name}`
                this._lab_max.text = max_jage
                this._lab_base.text = `${Number(cur_cond[0][2])}`
                this._lab_desc.innerHTML = Util.StrToHTML(`暂无下一轮次`)
            }

            if (free_times > 0 && Number(_cond.free_open)!= 0) {
                this._lab_btn.text = "免费祈愿"
                this._lab_btn.centerY = -2
                this._img_jage.visible = this._lab_cost.visible = false
                this._wish_red.visible = true
            } else {
                let cost = '0'
                if (!cur_turn_info) {
                    cost = _cond.price[Number(turn) - 2][1][0][2]
                } else {
                    cost = _cond.price[Number(turn) - 1][1][0][2]
                }
                this._lab_btn.text = "祈愿抽取"
                this._lab_btn.centerY = -16
                this._lab_cost.text = cost
                this._img_jage.visible = this._lab_cost.visible = true
                this._wish_red.visible = false

            }
            SetHtmlCenter(this._lab_desc,{x:-42,w:240})
            this._btn_daily.visible = this._img_daily_red.visible = daily_gain
            this._lab_tips.visible = !is_recharge && cur_turn_info && Number(_cond.free_open)!= 0
        }

        this.CustomMehod = (index?, info?) => {
            this._act_info = info
        }

        this.onTimer = () => {
            if (act_etime >= TimeUtil.getServerTime()) { //活动时间
                let time = act_etime - TimeUtil.getServerTime()
                this._lab_time.innerHTML = `<font color = '#ffffff'>活动剩余时间:</font>
                ${HtmlColorTxt(TimeUtil.timeConvert(time, 'hh-mm-ss'), "'#71f563'")}`
            } else {
                this._lab_time.innerHTML = Util.StrToHTML(`<font color = '#ffffff'>活动已结束</font>`)
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

        this.DeleteMe = () => {
            if(is_play){
                this._model.Fire(local_Event.SCMD_REQUEST, 33261, 33262) 
            }
            this.removeTimer()
            super.DeleteMe()
        }
    }

    public GetComponents() {
        [
            this._img_title,
            this._img_preview,
            this._lab_tips,
            this._lab_time,
            this._lab_desc,
            this._gp_sign,
            this._gp_sign_4,
            this._img_sign_4,
            this._lab_multiple_4,
            this._gp_sign_5,
            this._img_sign_5,
            this._lab_multiple_5,
            this._gp_sign_1,
            this._img_sign_1,
            this._lab_multiple_1,
            this._gp_sign_3,
            this._img_sign_3,
            this._lab_multiple_3,
            this._gp_sign_2,
            this._img_sign_2,
            this._lab_multiple_2,
            this._lab_base,
            this._lab_max,
            this._btn_daily,
            this._img_daily_red,
            this._btn_wish,
            this._lab_btn,
            this._lab_cost,
            this._img_jage,
            this._wish_red,
            this._gp_record,
            this.autoGp,
            this._Label1,
            this._Image14,
            this.autoImg,
        ]
            = this.GetChildrenByNames([

                "_img_title",
                "_img_preview",
                "_lab_tips",
                "_lab_time",
                "_lab_desc",
                "_gp_sign",
                "_gp_sign_4",
                "_img_sign_4",
                "_lab_multiple_4",
                "_gp_sign_5",
                "_img_sign_5",
                "_lab_multiple_5",
                "_gp_sign_1",
                "_img_sign_1",
                "_lab_multiple_1",
                "_gp_sign_3",
                "_img_sign_3",
                "_lab_multiple_3",
                "_gp_sign_2",
                "_img_sign_2",
                "_lab_multiple_2",
                "_lab_base",
                "_lab_max",
                "_btn_daily",
                "_img_daily_red",
                "_btn_wish",
                "_lab_btn",
                "_lab_cost",
                "_img_jage",
                "_wish_red",
                "_gp_record",
                "autoGp",
                "_Label1",
                "_Image14",
                "autoImg",
            ])
        for (let i = 1; i < 6; i++) {
            ResManager.GetInstance().LoadFont(this, "bind_jage_multiple", this[`_lab_multiple_${i}`], null, false);
        }
        ResManager.GetInstance().LoadFont(this, "bind_jade_wish", this._lab_base, null, false);
    }
}
window["BindJageWishView"] = BindJageWishView