import { BaseView1 } from "../common/BaseView1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { CookieWrapper } from "../common/CookieWrapper"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { FunctionOpenEvent, FunctionOpenModel } from "../commonModel/FunctionOpenModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"
import { SuperGiftItem } from "./SuperGiftItem"
export class SuperGiftView extends BaseView1 {
    bg: Laya.Image
    free: Laya.Image
    close: Laya.Image
    tip: Laya.Box
    check: Laya.Image
    toggle: Laya.Image
    time_gp: Laya.HBox
    reward_gp: Laya.List
    tips: Laya.Box
    red: Laya.Image
    tip_lb: Laya.Label
    _root_gp: Laya.Box
    model
    info
    set_index
    base_type
    sub_type
    data
    _timer = null
    loop_mgr
    free_data
    tween_list
    static FREE_TYPE = 10
    public constructor() {
        super()

        this.base_file = "superGift"
        this.layout_file = "SuperGiftView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.model = CustomActivityModel.GetInstance()
        this.destroy_imm = true
        this.tween_list = []

        this.load_callback = () => {
            this.model.CloseACTRed(this.info.base_type, this.info.sub_type)
            this.InitEvent()
            this.LoadCallback()
        }
        this.open_callback = () => {
            this._root_gp.alpha = 0.5
			this._root_gp.y = 200
			this.tween_list.push(SYTweenLite.to(this, this._root_gp, SYTweenLite.UiAnimationType.ALPHA, 1, 0.15))
			this.tween_list.push(SYTweenLite.to(this, this._root_gp, SYTweenLite.UiAnimationType.ANCHORED_POSY, 0, 0.15))
        }
        this.destroy_callback = () => {
            this.DestroyCallback()
        }
    }

    public LoadCallback() {
        if (this._timer) {
            this._timer.DeleteMe()
            this._timer = null
        }
        this._timer = this.model.LoadActTimer(this.time_gp, this.info.etime, 20, "#00fa64", "hh-mm-ss2", "#ffffff", "活动剩余时间：")
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIconOtherPath("superGift", "ui_czfl_01"), false)
        if (!this.info) { return }
        this.base_type = this.info.base_type
        this.sub_type = this.info.sub_type
        let data = this.model.GetActData(this.info.base_type, this.info.sub_type)
        if (!data) { return }
        this.data = data
        let cookie = CookieWrapper.Instance.GetCookie(CookieWrapper.SUPER_GIFT_CHECK)
        this.toggle.visible = !((cookie && Number(cookie) == 0) || !cookie) ? true : false
        this.SetHeight()
        this.InitRewardList()
        this.CheckFreeRed()
    }

    public Close() {
        this.tween_list.push(SYTweenLite.to(this, this._root_gp, SYTweenLite.UiAnimationType.ALPHA, 0.5, 0.15))
        this.tween_list.push(SYTweenLite.to(this, this._root_gp, SYTweenLite.UiAnimationType.ANCHORED_POSY, 200, 0.15, ()=>{
            super.Close()
        }))
    }

    public InitEvent() {
        Util.AddClickEvent(this.check, () => {
            this.toggle.visible = !this.toggle.visible
            let state = this.toggle.visible ? 1 : 0
            CookieWrapper.GetInstance().SaveCookie(CookieWrapper.SUPER_GIFT_CHECK, state)
        }, this, true)

        Util.AddClickEvent(this.close, () => {
            this.Close()
        }, this, true)

        Util.AddClickEvent(this.free, () => {
            if (this.free_data) {
                CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, this.info.base_type, this.info.sub_type, this.free_data.grade)
            }
            else
                Message.show("当前无免费奖励领取~")
        }, this, true)
        this.BindEvent(this.model, CustomActivityDefine.EVENT.ANSWER_TARGET, (base_type?, sub_type?, result_data?, reward_data?) => {
            if (!this.info) {
                return
            }
            if (this.info.base_type == base_type && this.info.sub_type == sub_type) {

                let rewards = this.model.GetActReward(reward_data.base_type, reward_data.sub_type, reward_data.form_type, reward_data.reward)
                new CongratulationObtainView(rewards, 10).Open()

                let moneys = [];
                let ids: number[] = [31, 34, 35];
                for (const iterator of rewards) {
                    let [type_id_, lock_] = GoodsModel.GetInstance().GetMappingTypeId(iterator[0], iterator[1])
                    if (ids.indexOf(type_id_) != -1) {
                        moneys.push(iterator);
                    }
                }

                if (moneys && moneys.length > 0) {
                    if (result_data.grade == 10) { // 10是免费的
                        let point = this.free.localToGlobal(new Laya.Point(this.free.width / 2, 0))
                        GlobalEventSystem.Fire(EventName.REWARD_FLY, moneys, point, undefined, undefined, 0, 0);
                    } else {
                        FunctionOpenModel.GetInstance().Fire(FunctionOpenEvent.FUNCTIONOPEN_GET_REWARD_SUCCESS, result_data.grade, moneys)
                    }

                    // for (const iterator of moneys) {
                    //     let [type_id_, lock_] = GoodsModel.GetInstance().GetMappingTypeId(iterator[0], iterator[1])
                    //     GoodsModel.GetInstance().Fire(GoodsModel.REQUEST_CCMD_EVENT, 15050, "li", type_id_, iterator[2]);
                    // }
                }

            }
            this.InitRewardList()
            this.CheckFreeRed()
        }
        )
    }

    public SetHeight() {
        if (this.info) {
            // let reward_list = this.data.reward_list
            // let free_count = 0
            // let is_have_rmb = false
            // if (reward_list && Util.TableSize(reward_list) > 0) {
            //     for (let key in reward_list) {
            //         let vo = reward_list[key]
            //         let condition = ErlangParser.GetInstance().parse(vo.condition)
            //         for (let k in condition) {
            //             if (condition[k][0] == "is_free" && Number(condition[k][1]) == 1)
            //                 free_count++
            //             if (condition[k][0] == "is_rmb" && Number(condition[k][1]) == 1)
            //                 is_have_rmb = true
            //         }
            //     }
            // }
            // let a = free_count
            let condition = ErlangParser.GetInstance().parse(this.info.condition)
            let have_tip = false
            let tip_type
            let show_pop = false
            for (let key in condition) {
                let vo = condition[key]
                if (vo[0] == "show_tip") {
                    have_tip = true
                    tip_type = vo[1]

                }
                if (vo[0] == "is_popup") {
                    show_pop = Number(vo[1]) == 1 ? true : false

                }
            }
            let str = ""
            if (have_tip)
                str = Number(tip_type) == 1 ? "本活动计入充值活动额度" : "本活动不计入充值活动额度"
            let data = this.model.GetActData(this.info.base_type, this.info.sub_type)
            if (data) {
                let reward_list = Util.DeepCopy(data.reward_list)
                if (reward_list && Util.TableSize(reward_list) > 0) {
                    for (let key in reward_list) {
                        let vo = reward_list[key]
                        let condition = ErlangParser.GetInstance().parse(vo.condition)
                        for (let k in condition) {
                            if (condition[k][0] == "is_free" && Number(condition[k][1]) == 1) {
                                this.free_data = vo
                                table.remove(reward_list, Number(key))
                                break
                            }
                        }
                    }
                }
                if(Util.TableSize(reward_list) > 3 ){
                    this.bg.height = have_tip ? 1167 : 1147
                    this.reward_gp.height = 815
                } else{
                    this.bg.height = have_tip ? 1110 : 1090
                    this.reward_gp.height = 740
                }
            }
            this.tips.visible = have_tip ? true : false
            this.tip_lb.text = str
            this.tip.visible = show_pop
        }
    }


    public CheckFreeRed() {
        if (this.free_data) {
            this.free.visible = this.free_data.status == 1
        }
    }

    public InitRewardList() {
        let data = this.model.GetActData(this.info.base_type, this.info.sub_type)
        if (data) {
            let reward_list = Util.DeepCopy(data.reward_list)
            if (reward_list && Util.TableSize(reward_list) > 0) {
                for (let key in reward_list) {
                    let vo = reward_list[key]
                    let condition = ErlangParser.GetInstance().parse(vo.condition)
                    for (let k in condition) {
                        if (condition[k][0] == "is_free" && Number(condition[k][1]) == 1) {
                            this.free_data = vo
                            table.remove(reward_list, Number(key))
                            break
                        }
                    }
                }
            }

            for (let k in reward_list) {
                let v = reward_list[k]
                v.base_type = this.info.base_type
                v.sub_type = this.info.sub_type
            }
            table.sort(reward_list, (a, b) => {
                return a.grade < b.grade
            })

            table.sort(reward_list, (a, b) => {
                return a.receive_times < b.receive_times
            })
            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this.reward_gp, SuperGiftItem, reward_list, LoopScrCon.Vertical)
            }
            else {
                this.loop_mgr.replaceAll(reward_list)
            }
            // let default_index = reward_list.length
            // this.loop_mgr.LastOnChild(default_index)
        }
    }

    public DestroyCallback() {
        if (this._timer) {
            this._timer.DeleteMe()
            this._timer = null
        }
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe()
            this.loop_mgr = null
        }
        if (this.tween_list) {
            for(let id of this.tween_list){
                SYTweenLite.Stop(id)
            }
            this.tween_list.length = 0
        }
    }

    public SetActInfo(info?, parm?) {

        this.info = info
        this.set_index = parm[0] ? parm[0] : 0

    }


    public GetComponents() {
        [
            this.bg,
            this.free,
            this.close,
            this.tip,
            this.check,
            this.toggle,
            this.time_gp,
            this.reward_gp,
            this.tips,
            this.red,
            this.tip_lb,
            this._root_gp,
        ]
            = this.GetChildrenByNames([

                "bg",
                "free",
                "close",
                "tip",
                "check",
                "toggle",
                "time_gp",
                "reward_gp",
                "tips",
                "red",
                "tip_lb",
                "_root_gp"
            ])
    }
}
window["SuperGiftView"] = SuperGiftView