import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { TopPkDefine, TopPkModel } from "../commonModel/TopPkModel"
import { SceneManager } from "../scene/SceneManager"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"

export class TopPkResultView extends BaseView1 {
    _gp_glow: Laya.Box
    _gp_fly: Laya.Box
    _Group2: Laya.Box
    _img_bg: Laya.Image
    _Group1: Laya.Box
    _gp_left: Laya.Box
    _img_left_level: Laya.Image
    _lb_left_level: Laya.Label
    _img_arrow: Laya.Image
    _gp_right: Laya.Box
    _img_right_level: Laya.Image
    _lb_right_level: Laya.Label
    _Image1: Laya.Image
    _img_progress: Laya.Image
    _lb_progress_desc: Laya.Label
    _Label1: Laya.Label
    _lb_point: Laya.Label
    _Label2: Laya.Label
    _img_icon: Laya.Image
    _lb_money: Laya.Label
    _lb_tips: Laya.Label
    _img_bg1: Laya.Image
    result_img: Laya.Image
    right_level_img: Laya.Image
    left_level_img: Laya.Image
    CancelCountDown
    InitEvent
    InitView
    LoadSuccess
    Local_Open
    Remove
    StartCountDown
    StartUpdate
    StopUpdate
    Update
    UpdateQuitCountTime

    public static PROGRESS_WIDTH = 444;
    public static Move_Times = 20;
    public constructor() {
        super()


        this.base_file = "topPk"
        this.layout_file = "TopPkResultView"
        this.layer_value = Enum_UILayer.Activity
        let model = TopPkModel.GetInstance()
        let local_TopPkModel = TopPkModel

        let local_TopPkResultView = TopPkResultView
        let runner = Runner.GetInstance()
        let local_Math = Math
        let data_ = null
        let update_state_ = false
        let update_id_ = null
        let time_id_ = null
        let time_func_ = null
        let frame_index_ = 0
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.change_scene_close = true
        let voice
        this.load_callback = () => {

            this.LoadSuccess()
        }

        this.close_callback = () => {
            this.Remove()
        }
        this.open_callback = () => {
            let data = data_
            let effect_name = null
            if (data.res == 1) {
                effect_name = "UI_2104"

                //this:AddUIEffect("ui_victory_glow1", this._gp_glow, null, {x=1.4, y=1.4}, true, false, false, false, false, true)
            } else {
                effect_name = "UI_2105"
            }
            // [ts2lua]lua中0和空字符串也是true，此处effect_name == "ui_defeated_glow2"需要确认
            //let effect_scale = effect_name == "UI_2105" && {x=1, y=} || {x=1, y=1}
            //this.AddUIEffect(effect_name, this.layer_value, this._gp_fly, null, null, false)
        }

        this.Remove = () => {
            if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}


            this.CancelCountDown()
            this.StopUpdate()
            if (SceneManager.GetInstance().IsTopPkScene()) {
                model.Fire(local_TopPkModel.REQUEST_SCMD, 28116)
            }
            this.ClearUIEffect(this._gp_fly)
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("topPk", "com_up_bg1"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, GameResPath.GetIcon("topPk", "com_up_bg2"))
            //ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("topPk", "uidfjj_027"))
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._img_progress, GameResPath.GetIcon("topPk", "uidfjj_028"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(TopPkDefine.MONEY_ICON_ID))
            this.InitView()
            this.InitEvent()
        }

        this.InitEvent = () => {
            this.BindVar(model, "quit_scene_time", (event_name?, value?) => {
                this.UpdateQuitCountTime()
            }
            )
        }

        this.InitView = () => {
            let data = data_

            //音效
            let state=data_.res ==1?2:1
            voice=CommonManager.GetInstance().PlayFightingVoice(state)
           
            //this:AddUIEffect(effect_name, this._gp_fly, null, effect_scale, false, null, null, null, true)
            this._lb_money.text = String(data.honor)
            let top_pk_rank_reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_top_pk_rank_reward", false)

            this._gp_right.visible = false
            this._gp_left.x = 110
            this._img_arrow.visible = false
            this._img_bg.visible = (data_.flag == 1)
            this._img_bg1.visible = (data_.flag != 1)
            let url = data_.res == 1 ? "ui_copy_64" : "ui_copy_67"
            ResManager.GetInstance().SetOutsideImageSprite(this, this.result_img, GameResPath.GetIcon("topPk", url), true)
            if (data_.flag == 1) {
                this._lb_point.text = "+" + data.point
                let old_level_cfg = model.GetLevelCfg(data.old_rank_lv, top_pk_rank_reward_cfg)
                if (old_level_cfg) {
                    this._lb_left_level.text = old_level_cfg.rank_name
                    model.SetLevelIcon(this, this.left_level_img, old_level_cfg.big_rank, old_level_cfg.rank_lv,true)
                    ResManager.GetInstance().SetOutsideImageSprite(this, this._img_left_level,GameResPath.GetIcon("topPk",old_level_cfg.big_rank))
                    this._lb_progress_desc.text = data.old_point + "/" + old_level_cfg.point
                    let value = local_Math.min(1, data.old_point / old_level_cfg.point)
                    this._img_progress.width = value * 356
                }
                if (data.old_rank_lv != data.now_rank_lv) {
                    this._gp_right.visible = true
                    this._gp_left.x = 0
                    this._img_arrow.visible = true
                    let now_level_cfg = model.GetLevelCfg(data.now_rank_lv, top_pk_rank_reward_cfg)
                    if (now_level_cfg) {
                        model.SetLevelIcon(this, this.right_level_img, now_level_cfg.big_rank, now_level_cfg.rank_lv,true)
                        this._lb_right_level.text = now_level_cfg.rank_name
                        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_right_level,GameResPath.GetIcon("topPk", now_level_cfg.big_rank))
                    }
                }
                update_state_ = true
                frame_index_ = 0
                this.StartUpdate()
            } else {
                this._lb_point.text = "-" + data.point
                let now_level_cfg = model.GetLevelCfg(data.now_rank_lv, top_pk_rank_reward_cfg)
                if (now_level_cfg) {
                    this._lb_left_level.text = now_level_cfg.rank_name
                    model.SetLevelIcon(this, this.left_level_img, now_level_cfg.big_rank, now_level_cfg.rank_lv,true)
                    ResManager.GetInstance().SetOutsideImageSprite(this, this._img_left_level, GameResPath.GetIcon("topPk", now_level_cfg.big_rank))
                    this._lb_progress_desc.text = data.now_point + "/" + now_level_cfg.point
                    let value = local_Math.min(1, data.now_point / now_level_cfg.point)
                    this._img_progress.width = value * 356
                }
            }
            this.left_level_img.scaleX = 0.8
            this.left_level_img.scaleY = 0.8
            this.right_level_img.scaleX = 0.8
            this.right_level_img.scaleY = 0.8
            this.UpdateQuitCountTime()
            // LayoutRebuilder(this._Group1)
        }

        this.UpdateQuitCountTime = () => {
            let end_time = model.quit_scene_time
            if (end_time) {
                this.StartCountDown(() => {
                    if (this.use_delete_method) {
                        return
                    }
                    let left_time = end_time - TimeUtil.getServerTime()
                    if (left_time < 0) {
                        this.CancelCountDown()
                        this.Close()
                        return
                    }
                    this._lb_tips.text = "点击任意位置继续(" + left_time + "s)"
                }
                )
            }
        }

        this.CancelCountDown = () => {

            if (time_id_) {
                GlobalTimerQuest.CancelQuest(time_id_)
                time_id_ = null
                time_func_ = null
            }
        }

        this.StartCountDown = (func?) => {
            this.CancelCountDown()
            time_func_ = func

            time_id_ = GlobalTimerQuest.AddPeriodQuest(func, 1)
            func()
        }

        this.StartUpdate = () => {
            if (!update_id_) {
                frame_index_ = 0
                update_id_ = runner.AddRunObj(this, 1)
            }
        }

        this.StopUpdate = () => {
            if (update_id_) {
                runner.RemoveRunObj(update_id_)
                update_id_ = null
            }
        }

        this.Update = (now_time?, elapse_time?) => {
            if (update_state_) {
                frame_index_ = frame_index_ + 1
                let scale = frame_index_ / local_TopPkResultView.Move_Times
                if (scale > 1) {
                    scale = 1
                }
                let top_pk_rank_reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_top_pk_rank_reward", false)
                let now_point = data_ && data_.old_point
                let now_rank_lv = data_ && data_.old_rank_lv
                if (now_point || now_point == 0) {
                    now_point = now_point + scale * data_.point
                }
                if ((now_point || now_point == 0) && now_rank_lv) {
                    let cfg = model.GetLevelCfg(now_rank_lv, top_pk_rank_reward_cfg)
                    if (cfg) {
                        if (cfg.point <= now_point) {
                            now_point = now_point - cfg.point
                            now_rank_lv = now_rank_lv + 1
                        }
                    }
                    let now_cfg = model.GetLevelCfg(now_rank_lv, top_pk_rank_reward_cfg)
                    if (now_cfg) {
                        this._lb_progress_desc.text = local_Math.floor(now_point) + "/" + now_cfg.point
                        let value = local_Math.min(1, now_point / now_cfg.point)
                        this._img_progress.width = value * 356
                    }
                    if (scale == 1) {
                        update_state_ = false
                        this.StopUpdate()
                    }
                }

            }
        }

        this.Local_Open = (data?) => {
            data_ = data[0]

        }


    }

    public Open(...new_args) {

        let data = new_args
        this.Local_Open(data)
        super.Open()
    }



    public GetComponents() {
        [
            this._gp_glow,
            this._gp_fly,
            this._Group2,
            this._img_bg,
            this._Group1,
            this._gp_left,
            this._img_left_level,
            this._lb_left_level,
            this._img_arrow,
            this._gp_right,
            this._img_right_level,
            this._lb_right_level,
            this._Image1,
            this._img_progress,
            this._lb_progress_desc,
            this._Label1,
            this._lb_point,
            this._Label2,
            this._img_icon,
            this._lb_money,
            this._lb_tips,
            this._img_bg1,
            this.result_img,
            this.left_level_img,
            this.right_level_img
        ]
            = this.GetChildrenByNames([

                "_gp_glow",
                "_gp_fly",
                "_Group2",
                "_img_bg",
                "_Group1",
                "_gp_left",
                "_img_left_level",
                "_lb_left_level",
                "_img_arrow",
                "_gp_right",
                "_img_right_level",
                "_lb_right_level",
                "_Image1",
                "_img_progress",
                "_lb_progress_desc",
                "_Label1",
                "_lb_point",
                "_Label2",
                "_img_icon",
                "_lb_money",
                "_lb_tips",
                "_img_bg1",
                "result_img",
                "left_level_img",
                "right_level_img"
            ])
    }
}
window["TopPkResultView"] = TopPkResultView