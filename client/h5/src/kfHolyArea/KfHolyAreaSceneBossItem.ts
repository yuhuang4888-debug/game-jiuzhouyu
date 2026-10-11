
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { BossModel } from "../commonModel/BossModel"
import { TimeUtil } from "../util/TimeUtil"
import { ColorUtil, Enum_ColorUtil_Light, Enum_ColorUtil_NEW } from "../util/ColorUtil"
import { Config } from "../common/Config"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { ColorType } from "../util/ColorUtil"
import { GlobalTimerQuest } from "../util/Util"
export class KfHolyAreaSceneBossItem extends BaseItemRenderer {
    _Image1: Laya.Image
    _lb_boss_name: Laya.Label
    _lb_boss_tips: Laya.Label
    _Image2: Laya.Image
    _img_peace: Laya.Image
    time_id
    WIDTH = 220
    HEIGT = 40


    public static width = 220

    public static height = 40

    public constructor(parent) {
        super()


        this.base_file = "kfHolyArea"

        this.layout_file = "KfHolyAreaSceneBossItem"
        this.Load()

    }



    public load_callback() {






        this.BindEvent(BossModel.GetInstance(), BossModel.UPDATE_BOSS_HP, () => {

            this.UpdateBossHp()

        }

        )

    }



    public dataChanged() {


        if (super.dataChanged()) {

            this._Image2.visible = this.selected

            let data = this.data

            if (data) {

                this.ClearTimer()

                if (data.reborn_time > 0) {



                    let loop_func = () => {

                        if (this.data && this.data.reborn_time - TimeUtil.getServerTime() > 0) {

                            this._lb_boss_tips.color = ColorUtil.GetReplaceChar(Enum_ColorUtil_Light.RED)

                            this._lb_boss_tips.text = TimeUtil.convertTimeColor(this.data.reborn_time - TimeUtil.getServerTime())

                        } else {
                            this.ClearTimer()

                            this.UpdateBossHp()

                        }

                    }

                    this.time_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)

                    loop_func()

                } else {
                    this.UpdateBossHp()

                }

                this._img_peace.visible = KfHolyAreaModel.GetInstance().IsPeaceBoss(data.bossid)

                let boss_info = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, data.bossid, false)

                this._lb_boss_name.text = boss_info.name

            }


        }


    }



    public ClearTimer() {


        if (this.time_id) {

            GlobalTimerQuest.CancelQuest(this.time_id)

            this.time_id = null

        }

    }



    public DeleteMe() {


        this.ClearTimer()
        super.DeleteMe()
    }



    public UpdateBossHp() {
        if (!this.data) return
        if (this.data.reborn_time && TimeUtil.getServerTime() < this.data.reborn_time){

        }
        else  {

            this._lb_boss_tips.color = Enum_ColorUtil_NEW.LIGHT_GREEN

            let data = BossModel.GetInstance().GetBossHpData(this.data.bossid)

            if (data) {

                this._lb_boss_tips.text = Math.floor(data.hp / data.hp_max * 100) + "%"

            } else {
                if (BossModel.GetInstance().HasBossHpCfg(this.data.bossid)) {

                    this._lb_boss_tips.text = "100%"

                } else {
                    this._lb_boss_tips.text = "已复活"

                }

            }

        }

    }




    public GetComponents() {
        [
            this._Image1,
            this._lb_boss_name,
            this._lb_boss_tips,
            this._Image2,
            this._img_peace,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_lb_boss_name",
                "_lb_boss_tips",
                "_Image2",
                "_img_peace",
            ])
    }
}
window["KfHolyAreaSceneBossItem"] = KfHolyAreaSceneBossItem