import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"
import { AwardItemRenderer } from "../dungeon/AwardItemRenderer"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetAnchoredPositionY, SetSizeDeltaX, SetSizeDeltaY, Util } from "../util/Util"

export class FeastBossResultView extends BaseView1 {
    bg: Laya.Image
    _btn_right: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    _lb_left_time: Laya.Label
    _gp_victory: Laya.Box
    _gp_fly: Laya.Box
    _gp_reward_con: Laya.Box
    _img_reward_bg: Laya.Image
    _sc_reward_col: Laya.List
    Content: Laya.List
    _gp_tip_1: Laya.Box
    _Image11: Laya.Image
    _lb_tip_1: Laya.Label
    none_label: Laya.Label
    CancelTime
    InitEvent
    InitView
    Local_Open
    OnTime
    ShowNeedComponent
    StartTime
    UpdateView
    _cur_data
    _end_time
    data
    left_time
    model
    result
    result_type_cfg
    reward_arr
    reward_arr_col
    time_event_id

    public constructor() {
        super()

        this.left_time = 8
        this.result_type_cfg = { _gp_fly: { visible: true }, _gp_victory: { visible: true }, _gp_tip_1: { visible: true }, _gp_reward_con: { visible: true } }
        this.base_file = "feastBoss"
        this.layout_file = "FeastBossResultView"
        this.dependent_res = ["dungeonCommon"]
        this.layer_value = Enum_UILayer.Activity
        this.back_login_toClose = true
        this.use_background = true
        this.background_alpha = 0.75
        this.is_center = true
        this.destroy_imm = true
        this.model = BossModel.GetInstance()
        let local_TimeUtil = TimeUtil
        this.load_callback = () => {

            this.InitEvent()
        }

        this.open_callback = () => {
            this.InitView()
        }

        this.close_callback = () => {
            if (this.reward_arr) {
                this.reward_arr.DeleteMe()
                this.reward_arr = null
            }
            if (this.reward_arr_col) {
                this.reward_arr_col.DeleteMe()
                this.reward_arr_col = null
            }
            this.CancelTime()
        }

        this.InitEvent = () => {
            //this.grid_layout = this.GetChild("_gp_reward_con/_sc_reward/_dgp_reward/Content").GetComponent("UnityEngine.UI.GridLayoutGroup")
            Util.AddClickEvent(
                this._btn_right, () => {
                    this.Close()
                },
                this,
                true
            )
        }

        this.Local_Open = (parms?) => {
            this.data = parms
            super.Open()
        }

        this.InitView = () => {
            if (!this.data) {
                this.Close()
                return
            }
            this.result = this.data.code == 1
            let res = this.result ? "ui_copy_64" : "ui_copy_65"
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIconOtherPath("feastBoss", res), true)
            let show_cfg = this.result_type_cfg
            // for (let key in show_cfg) {

            //     // [ts2lua]show_cfg下标访问可能不正确
            //     let vo = show_cfg[key]
            //     if (vo) {
            //         for (let k in vo) {

            //             if (k == "visible") {
            //                 this[key].visible = vo[k]
            //             }
            //         }
            //     } else {
            //         this[key].visible = false
            //     }
            // }
            this.ShowNeedComponent()
            let reward_list = this.data.reward_list
            this.UpdateView(reward_list)
        }

        this.ShowNeedComponent = () => {
            let cfg = []
            //ResManager.GetInstance().SetOutsideImageSprite(this, this._img_reward_bg, GameResPath.GetIcon("common4", "uijs_038"))
            if (this.result) {
                // [ts2lua]cfg下标访问可能不正确
                //cfg["_lb_tip_1"] = { text: "防守成功" }
                // [ts2lua]cfg下标访问可能不正确
                cfg["labelDisplay"] = { label: "确认" }
                // [ts2lua]cfg下标访问可能不正确
                //cfg["text_lb_left_time"] = [y = -1200]
                //cfg["trans_btn_right"] = [y = -1100]
            } else {
                // [ts2lua]cfg下标访问可能不正确
                //cfg["_lb_tip_1"] = { text: "防守失败" }
                // [ts2lua]cfg下标访问可能不正确
                cfg["labelDisplay"] = { label: "确认" }
                // [ts2lua]cfg下标访问可能不正确
                //cfg["trans_lb_left_time"] = [y = -880]
                //cfg["trans_btn_right"] = [y = -830]
            }
            for (let key in cfg) {

                let vo = cfg[key]
                if (vo) {
                    for (let k in vo) {

                        if (k == "label") {
                            this[key].text = vo[k]
                        }
                        else if (k == "y") {
                            let new_key = key
                            SetAnchoredPositionY(this[new_key], vo[k])
                        } else {
                            this[key][k] = vo[k]
                        }
                    }
                } else {
                    // [ts2lua]this下标访问可能不正确
                    this[key].visible = false
                }
            }
            // [ts2lua]lua中0和空字符串也是true，此处this.result需要确认
            let effect_name = (this.result && ("UI_2104") || ("UI_2105"))
            // [ts2lua]lua中0和空字符串也是true，此处effect_name == "ui_defeated_glow"需要确认
            //let effect_scale = (effect_name == "UI_2105" && ( {x = 1.1, y = 1.1} ) || ( {x = 1.3, y = 1.3} ) )
            //if (this.result ) {
            //    this.AddUIEffect("ui_victory_glow1", this._gp_victory, null, {x = 1.3, y = 1.3}, true, false, false, false, false, true)
            //}
            //this.AddUIEffect(effect_name, this.layer_value, this._gp_fly, null, null, false, null, null, null, true)
        }

        this.UpdateView = (reward?) => {
            this.StartTime()
            if (reward && reward.length > 0) {
                this.none_label.visible = false
                let len = reward.length
                this.Content.visible = true
                // let index = Math.ceil(len / 4)
                // if (index > 3) {
                //     index = 3
                // }
                // if (index == 0) {
                //     index = 1
                // }
                // let layout = null
                // //if (index == 1 ) {
                // //layout = local_eui. new HorizontalLayout()
                // //layout.gap = 15
                // //layout.horizontalAlign = local_laya.HorizontalAlign.CENTER
                // //this._sc_reward.width = 108 * len + len - 1 * 15
                // //}else{
                // //layout = local_eui. new TileLayout()
                // //layout.verticalGap = 15
                // //layout.horizontalGap = 15
                // //layout.horizontalAlign = local_laya.HorizontalAlign.LEFT
                // //layout.verticalAlign = local_laya.VerticalAlign.TOP
                // //}
                // //this._dgp_reward.layout = layout
                // //this._gp_reward_con.height = index * 108 + index - 1 * 13 + 32 + 20
                // //this:validateNow()
                // //this._gp_fly.y = this._gp_reward_con.y - 80
                // //this._gp_victory.y = this._gp_reward_con.y - 80
                // //this._gp_tip_1.y = this._gp_reward_con.y - 30

                // if (index == 1) {
                //     this._sc_reward.visible = false
                //     this._sc_reward_col.visible = true

                //     if (!this.reward_arr_col) {
                //         this.reward_arr_col = new LoopScrowViewMgr()
                //         this.reward_arr_col.SetData(this._sc_reward_col, AwardItemRenderer, reward)
                //     } else {
                //         this.reward_arr_col.replaceAll(reward)
                //     }
                //     SetAnchoredPositionY(this._btn_right, -830)
                //     SetAnchoredPositionY(this._lb_left_time, -880)
                //     SetSizeDeltaY(this._img_reward_bg, 160)
                // } else {
                //     SetSizeDeltaY(this._img_reward_bg, 570)
                //     SetAnchoredPositionY(this._btn_right, -1100)
                //     SetAnchoredPositionY(this._lb_left_time, -1200)

                // this._sc_reward.visible = true
                // this._sc_reward_col.visible = false
                if (!this.reward_arr) {
                    this.reward_arr = new LoopScrowViewMgr()
                    this.reward_arr.SetData(this.Content, AwardItemRenderer, reward, LoopScrCon.Vertical)
                } else {
                    this.reward_arr.replaceAll(reward)
                }
                // this.grid_layout.enabled = reward.length < 4
                //}
            } else {
                this.none_label.visible = true
                this.Content.visible = false
            }
        }

        this.StartTime = () => {
            this.CancelTime()
            this._end_time = this.left_time + local_TimeUtil.getServerTime()
            this._cur_data = null
            this.time_event_id = GlobalTimerQuest.AddPeriodQuest(() => {
                this.OnTime()
            }, 1)
            this.OnTime()
        }

        this.OnTime = () => {
            let left_time = this._end_time - local_TimeUtil.getServerTime()
            if (left_time < 0) {
                this.Close()
                return
            }
            this._lb_left_time.text = left_time + "秒后自动关闭"
        }

        this.CancelTime = () => {
            if (this.time_event_id) {
                GlobalTimerQuest.CancelQuest(this.time_event_id)
                this.time_event_id = null
            }
        }
    }

    public Open(...new_args) {

        this.Local_Open(...new_args)
    }




    public GetComponents() {
        [
            this.bg,
            this._btn_right,
            this._Image1,
            this.labelDisplay,
            this._lb_left_time,
            this._gp_victory,
            this._gp_fly,
            this._gp_reward_con,
            this._img_reward_bg,
            this._sc_reward_col,
            this.Content,
            this._gp_tip_1,
            this._Image11,
            this._lb_tip_1,
            this.none_label,
        ]
            = this.GetChildrenByNames([

                "bg",
                "_btn_right",
                "_Image1",
                "labelDisplay",
                "_lb_left_time",
                "_gp_victory",
                "_gp_fly",
                "_gp_reward_con",
                "_img_reward_bg",
                "_sc_reward_col",
                "Content",
                "_gp_tip_1",
                "_Image11",
                "_lb_tip_1",
                "none_label",
            ])
    }
}
window["FeastBossResultView"] = FeastBossResultView