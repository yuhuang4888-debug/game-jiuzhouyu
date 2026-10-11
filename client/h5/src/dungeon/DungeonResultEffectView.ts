import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"

export class DungeonResultEffectView extends BaseView1 {

    effect_gp: Laya.Box

    StartTime
    CancelTime
    public constructor() {
        super()

        this.base_file = "dungeonCommon"
        this.layout_file = "DungeonResultEffectView"
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.background_alpha = 0.7
        this.not_show_main_msg = true
        this.is_center = true
        this.destroy_imm = true
        let end_time_
        let left_time_ = 10
        let time_id_
        this.load_callback = () => {
            let info = BaseDungeonModel.GetInstance().GetDungeonResultInfo()
            //let a = 1 // 
            let effect_name = info.result == 1 ? "ui_zhandoushengli" : "ui_zhandoushibai"
            this.effect_gp.width = 720
            this.effect_gp.height = 1280
            this.ClearUIEffect(this.effect_gp)
            this.AddUIEffect(effect_name, this.effect_gp, null, null, null, 1, () => {
                this.Close()
            })
            end_time_ = TimeUtil.getServerTime() + left_time_
            let time_func = () => {
                let left_time = end_time_ - TimeUtil.getServerTime()
                if (left_time < 0) {

                    this.Close()
                    return
                }
            }
            //this.StartTime(time_func)
        }

        this.open_callback = () => {

        }
        this.StartTime = (time_func?) => {
            this.CancelTime()
            time_id_ = GlobalTimerQuest.AddPeriodQuest(time_func, 1)
            time_func()
        }
        this.CancelTime = () => {
            if (time_id_) {
                GlobalTimerQuest.CancelQuest(time_id_)
                time_id_ = null
            }
        }
        this.close_callback = () => {
            this.ClearUIEffect(this.effect_gp)
            this.CancelTime()
        }
    }

    public GetComponents() {
        [
            this.effect_gp,
        ]
            = this.GetChildrenByNames([

                "effect_gp",
            ])
    }
}
window["DungeonResultEffectView"] = DungeonResultEffectView