import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Mathf } from "../util/Mathf"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"

export class GuildFightReliveView extends BaseView1 {
    CancelTimer
    InitView
    ReliveTimer
    back_login_toClose
    change_scene_close
    destroy_callback
    destroy_imm
    is_center
    not_close_by_android_back_key
    open_callback
    percentHeight
    percentWidth
    use_background

    public constructor() {
        super()

        this.base_file = "guildFight"
        this.layout_file = "GuildFightReliveView"
        this.destroy_imm = true
        this.layer_value = Enum_UILayer.Top
        this.change_scene_close = true
        this.is_center = true
        this.back_login_toClose = true
        this.use_background = true
        this.percentWidth = 100
        this.percentHeight = 100
        this.not_close_by_android_back_key = true
        let local_timeutil = TimeUtil
        let left_time_ = null
        let timer_id_ = null
        this.open_callback = () => {

            this.InitView()
        }

        this.destroy_callback = () => {
            this.CancelTimer()
        }

        this.InitView = () => {
            left_time_ = local_timeutil.getClientTime() + 5
            timer_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
                this.ReliveTimer()
            }, 1)
            this.ReliveTimer()
        }

        this.ReliveTimer = () => {
            if (left_time_ - local_timeutil.getClientTime() < 0) {
                if (timer_id_) {
                    GlobalTimerQuest.CancelQuest(timer_id_)
                    timer_id_ = null
                }
                GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 14)
                this.Close()
                return
            }
            if (this.reborn_num) {
                this.reborn_num.text = Mathf.Ceil(left_time_ - local_timeutil.getClientTime())+""
            }
        }

        this.CancelTimer = () => {
            if (timer_id_) {
                GlobalTimerQuest.CancelQuest(timer_id_)
                timer_id_ = null
            }
        }
    }

    reborn_group: Laya.Box
    _Image1: Laya.Image
    reborn_num: Laya.Label
    public GetComponents() {
        [
            this.reborn_group,
            this._Image1,
            this.reborn_num,
        ]
            = this.GetChildrenByNames([

                "reborn_group",
                "_Image1",
                "reborn_num",
            ])
    }
}
window["GuildFightReliveView"] = GuildFightReliveView