import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { SceneEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TopPkModel } from "../commonModel/TopPkModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GetSizeDeltaX, GlobalTimerQuest, SetAnchoredPositionX, SetAnchoredPositionY } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { CommonManager } from "../common/CommonManager"
import { SoundManager } from "../common/SoundManager"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"

export class TopPkMatchSuccessView extends BaseView1 {
    FadeIn
    FadeOut
    InitEvent
    InitView
    LoadSuccess
    Remove
    UpdateMatchData
    UpdateRoleVo
    UpdateView
    anim_list
    percentHeight
    percentWidth
    fight_item_0
    fight_item_1

    public constructor() {
        super()


        this.base_file = "topPk"
        this.layout_file = "TopPkMatchSuccessView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.is_center = true
        this.use_background = true
        this.background_alpha = 0
        this.percentWidth = 100
        this.percentHeight = 100
        this.change_scene_close = true
        this.anim_list = []
        let model = TopPkModel.GetInstance()

        let local_TimeUtil = TimeUtil
        let auto_fight_mgr = AutoFightManager.GetInstance()
        let layer_mgr = LayerManager.GetInstance()
        let local_Math = Math
        let timer_out_ = null
        let center_x_ = null
        let center_y_ = null
        let enemy_pos_ = null
        let end_time_ = null
        let close_time = undefined
        let voice
        let time_fun = null
        this.preload_server_config = {
            "config_top_pk_rank_reward": false
        }
        this.load_callback = () => {
            this.fight_item_0 = new FightingShowSmallItem(this._gp_fight_0)
            this.fight_item_0.Load()
            this.fight_item_0.IsCenter(true, false)
            this.fight_item_1 = new FightingShowSmallItem(this._gp_fight_1)
            this.fight_item_1.Load()
            this.fight_item_1.IsCenter(true, false)

            this.LoadSuccess()
        }
        this.open_callback = () => {
            close_time = GlobalTimerQuest.AddDelayQuest(() => {
                this.Close()
                auto_fight_mgr.SetAutoFight(true)
            }
                , 4)
        }


        this.destroy_callback = () => {
            this.Remove()
        }

        this.Remove = () => {
            if (voice) {
                SoundManager.GetInstance().StopSoundEffect(voice)
                voice = null
            }
            if (timer_out_) {
                GlobalTimerQuest.CancelQuest(timer_out_)
            }
            if (close_time) {
                GlobalTimerQuest.CancelQuest(close_time)
            }
            if(time_fun){
                GlobalTimerQuest.CancelQuest(time_fun)
            }
            if (this.anim_list && this.anim_list.length > 0) {
                for (let i = 0; i < this.anim_list.length; i++) {
                    var v = this.anim_list[i]
                    SYTweenLite.Stop(v)
                }
                this.anim_list = []
            }
            enemy_pos_ = null

            for (let i = 0; i <= 1; i++) {
                if (this["head" + i]) {
                    this["head" + i].DeleteMe()
                    this["head" + i] = null
                }
            }
            if(this.fight_item_0){
                this.fight_item_0.DeleteMe()
                this.fight_item_0 = null
            }
            if(this.fight_item_1){
                this.fight_item_1.DeleteMe()
                this.fight_item_1 = null
            }
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_left_bg, GameResPath.GetIcon("topPk", "uikf1vn_023"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_right_bg, GameResPath.GetIcon("topPk", "uikf1vn_024"), true)
            center_x_ = this._gp_center.x
            center_y_ = this._gp_center.y
            this.InitView()
            this.InitEvent()

            voice = CommonManager.GetInstance().PlayFightingVoice(3)
        }

        this.InitView = () => {
            let role_vo = SceneManager.GetInstance().GetOneRoleVo()
            if (role_vo) {
                this.UpdateRoleVo(role_vo)
            }
            this.UpdateView()
        }

        this.UpdateRoleVo = (role_vo?) => {
            if (role_vo && this.isPop) {
                let main_vo = RoleManager.GetInstance().GetMainRoleVo()
                let bool = main_vo.pos_x > role_vo.pos_x
                // [ts2lua]lua中0和空字符串也是true，此处bool需要确认
                enemy_pos_ = !bool && 1 || 0
                // [ts2lua]lua中0和空字符串也是true，此处bool需要确认
                let list = bool && [role_vo, main_vo] || [main_vo, role_vo]
                for (let k in list) {

                    let key = Number(k)
                    let vo = list[k]
                    // [ts2lua]this下标访问可能不正确
                    let a = this["_lb_name" + key]
                    if (this["_lb_name" + key]) {
                        // [ts2lua]this下标访问可能不正确
                        let b = this["_lb_name" + key]
                        this["_lb_name" + key].text = "S" + vo.server_id + "." + vo.name
                    }
                    // [ts2lua]this下标访问可能不正确
                    if (this["_head" + key]) {
                        if (this["head" + key] == null) {
                            this["head" + key] = new CustomHeadItem(this["_head" + key])
                            this["head" + key].Load()
                        }
                        this["head" + key].SetRoleVoData(vo)
                    }
                    if (!vo.is_fake_role) {
                        // [ts2lua]this下标访问可能不正确
                        if (this["fight_item_" + key]) {
                            // [ts2lua]this下标访问可能不正确
                            this["fight_item_" + key].Updatefighting(vo.fighting)
                        }
                    }
                }
            }
            this.UpdateMatchData()
        }

        this.InitEvent = () => {
            this.BindEvent(GlobalEventSystem, SceneEventType.ROLE_VO_ADD, (role_id?, role_vo?) => {
                this.UpdateRoleVo(role_vo)
            }
            )
            this.BindVar(model, "fight_start_time", () => {
                this.UpdateView()
            }
            )
            this.BindVar(model, "match_data", () => {
                this.UpdateMatchData()
            }
            )
        }

        this.UpdateMatchData = () => {
            let match_data = model.match_data
            let top_pk_rank_reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_top_pk_rank_reward", false)
            if (match_data && enemy_pos_ != null) {
                let my_level_cfg = model.GetLevelCfg(match_data.my_rank_lv, top_pk_rank_reward_cfg)
                if (my_level_cfg) {
                    // [ts2lua]lua中0和空字符串也是true，此处enemy_pos_ == 0需要确认
                    let obj = enemy_pos_ == 0 && this._lb_right_level || this._lb_left_level
                    obj.text = my_level_cfg.rank_name
                }
                let enemy_level_cfg = model.GetLevelCfg(match_data.enemy_rank_lv, top_pk_rank_reward_cfg)
                if (enemy_level_cfg) {
                    // [ts2lua]lua中0和空字符串也是true，此处enemy_pos_ == 0需要确认
                    let obj = enemy_pos_ == 0 && this._lb_left_level || this._lb_right_level
                    obj.text = enemy_level_cfg.rank_name
                }
                if (match_data.fake_man_power) {
                    // [ts2lua]this下标访问可能不正确
                    if (this["fight_item_" + enemy_pos_]) {
                        // [ts2lua]this下标访问可能不正确
                        this["fight_item_" + enemy_pos_].Updatefighting(match_data.fake_man_power)
                    }
                }
            }
        }

        this.UpdateView = () => {
            if (this.use_delete_method) {
                return
            }
            let end_time = model.fight_start_time
            if (end_time) {
                end_time_ = end_time
                let leftTime = end_time - local_TimeUtil.getServerTime()
                if (leftTime >= 4) {
                    leftTime = 4
                }
                if (leftTime < 1) {
                    this.Close()
                    let OnTime = () => { }
                    if (leftTime < 0) {

                        auto_fight_mgr.SetAutoFight(true)
                        this.Close()
                    }

                    else {
                        time_fun = GlobalTimerQuest.AddDelayQuest(() => {
                            if (!this.use_delete_method) {
                                auto_fight_mgr.SetAutoFight(true)
                            }
                        }
                            , leftTime)

                    }
                    return false

                }
                if (leftTime > 2) {
                    this.FadeIn()
                } else if (leftTime > 1) {
                    let screenWidth = layer_mgr.stageWidth
                    SetAnchoredPositionX(this._gp_left, 0)
                    SetAnchoredPositionX(this._gp_right, 326)

                    this._gp_center.alpha = 1
                    timer_out_ = GlobalTimerQuest.AddDelayQuest(() => {
                        if (!this.use_delete_method) {
                            this.FadeOut()
                        }
                    }
                        , leftTime - 1)
                } else {
                    this.FadeOut()
                }
            }
            return true
        }

        this.FadeIn = () => {
            if (this.use_delete_method) {
                return
            }
            let screenWidth = layer_mgr.stageWidth
            SetAnchoredPositionX(this._gp_left, -GetSizeDeltaX(this._gp_left))
            SetAnchoredPositionX(this._gp_right, screenWidth)
            this._img_vs.visible = false
            //SetLocalScale(this._gp_center,5)
            SetAnchoredPositionX(this._gp_center, this._gp_center.x + 200)
            SetAnchoredPositionY(this._gp_center, this._gp_center.y - 50)
            SYTweenLite.Stop(this.anim_list["center1"])
            SYTweenLite.Stop(this.anim_list["center2"])
            this.anim_list["center1"] =
                SYTweenLite.to(this,
                    this._gp_center,
                    SYTweenLite.UiAnimationType.ANCHORED_POS,
                    new Vector2(center_x_, center_y_),
                    0.3,
                    null,
                    SYTweenFunc.EASE_IN,
                    false)
            this.anim_list["center2"] =
                SYTweenLite.to(this,
                    this._gp_center,
                    SYTweenLite.UiAnimationType.SCALE,
                    new Vector3(1, 1, 1),
                    0.3,
                    null,
                    SYTweenFunc.EASE_IN,
                    false)
            timer_out_ = GlobalTimerQuest.AddDelayQuest(() => {
                if (this.use_delete_method) {
                    return
                }

                SYTweenLite.Stop(this.anim_list["left"])
                this.anim_list["left"] =
                    SYTweenLite.to(this,
                        this._gp_left,
                        SYTweenLite.UiAnimationType.ANCHORED_POSX,
                        0,
                        0.25, () => {
                            let delayTime = end_time_ - local_TimeUtil.getServerTime()
                            if (delayTime >= 3) {
                                delayTime = 3
                            }
                            if (delayTime > 0) {
                                timer_out_ = GlobalTimerQuest.AddDelayQuest(() => {
                                    if (!this.use_delete_method) {
                                        this.FadeOut()
                                    }
                                }
                                    , (delayTime - 1) + 0.85)
                            } else {
                                this.FadeOut()
                            }
                        },
                        SYTweenFunc.EASE_IN,
                        false)

                SYTweenLite.Stop(this.anim_list["right"])
                this.anim_list["right"] =
                    SYTweenLite.to(this,
                        this._gp_right,
                        SYTweenLite.UiAnimationType.ANCHORED_POSX,
                        326,
                        0.25,
                        null,
                        SYTweenFunc.EASE_IN,
                        false)
                this._img_vs.visible = true
            }
                , 0.2)
        }

        this.FadeOut = () => {

            table.insert(this.anim_list, SYTweenLite.to(this,
                this._gp_center,
                SYTweenLite.UiAnimationType.ALPHA,
                0,
                0.7,
                null,
                SYTweenFunc.EASE_IN,
                false))
            table.insert(this.anim_list, SYTweenLite.to(this,
                this._img_vs,
                SYTweenLite.UiAnimationType.ALPHA,
                0,
                0.7,
                null,
                SYTweenFunc.EASE_IN,
                false))

            let len = 100
            let angle = 60 * local_Math.PI / 180
            let target_x = -(this._gp_left.x + len * local_Math.cos(angle))
            let target_y = this._gp_left.y - len * local_Math.sin(angle)
            let target_x2 = this._gp_right.x - len * local_Math.cos(angle)
            let target_y2 = this._gp_right.y + len * local_Math.sin(angle)
            SYTweenLite.Stop(this.anim_list["left"])
            table.insert(this.anim_list, SYTweenLite.to(this,
                this._gp_left,
                SYTweenLite.UiAnimationType.ANCHORED_POS,
                new Vector2(target_x, target_y),
                0.7,
                null,
                SYTweenFunc.EASE_OUT,
                false))
            table.insert(this.anim_list, SYTweenLite.to(this,
                this._gp_left,
                SYTweenLite.UiAnimationType.ALPHA,
                0,
                0.7, () => {
                    auto_fight_mgr.SetAutoFight(true)
                    this.Close()
                },
                SYTweenFunc.EASE_OUT,
                false))
            SYTweenLite.Stop(this.anim_list["right"])
            table.insert(this.anim_list, SYTweenLite.to(this,
                this._gp_right,
                SYTweenLite.UiAnimationType.ANCHORED_POS,
                new Vector2(target_x2, target_y2),
                0.7,
                null,
                SYTweenFunc.EASE_OUT,
                false))
            table.insert(this.anim_list, SYTweenLite.to(this,
                this._gp_right,
                SYTweenLite.UiAnimationType.ALPHA,
                0,
                0.7,
                null,
                SYTweenFunc.EASE_OUT,
                false))
        }


    }



_gp_left:Laya.Box
_img_left_bg:Laya.Image
_lb_left_level:Laya.Label
_head0:Laya.Box
_lb_name0:Laya.Label
_gp_fight_0:Laya.Box
_gp_right:Laya.Box
_img_right_bg:Laya.Image
_lb_right_level:Laya.Label
_head1:Laya.Box
_lb_name1:Laya.Label
_gp_fight_1:Laya.Box
_gp_center:Laya.Box
_Image1:Laya.Image
_img_vs:Laya.Image
    public GetComponents() {
        [
            this._gp_left,
            this._img_left_bg,
            this._lb_left_level,
            this._head0,
this._lb_name0,
this._gp_fight_0,
            this._gp_right,
            this._img_right_bg,
            this._lb_right_level,
            this._head1,
this._lb_name1,
this._gp_fight_1,
            this._gp_center,
            this._Image1,
            this._img_vs,
        ]
            = this.GetChildrenByNames([

                "_gp_left",
                "_img_left_bg",
                "_lb_left_level",
                "_head0",
"_lb_name0",
"_gp_fight_0",
                "_gp_right",
                "_img_right_bg",
                "_lb_right_level",
                "_head1",
"_lb_name1",
"_gp_fight_1",
                "_gp_center",
                "_Image1",
                "_img_vs",
            ])
    }
}
window["TopPkMatchSuccessView"] = TopPkMatchSuccessView