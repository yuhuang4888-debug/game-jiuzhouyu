import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

export class SentientActTipView extends BaseView1 {
    LoadSuccess
    InitEvent
    public constructor() {
        super()

        this.base_file = "sentientAct"
        this.layout_file = "SentientActTipView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true
        this.is_delay_callback = false
        this.change_scene_close = true
        this.load_callback = () => {
            this.InitEvent()
            this.LoadSuccess()
        }

        this.open_callback = () => {
        }

        this.close_callback = () => {

        }

        this.destroy_callback = () => {

        }



        this.LoadSuccess = () => {
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this.close, () => {
                this.Close()
            }, true)

            Util.AddClickEvent(this.know, () => {
                this.Close()
            }, true)

            Util.AddClickEvent(this.team, () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'SentientActTeamView');
                this.Close()
            }, true)

        }





    }







    close: Laya.Image
    team: Laya.Box
    know: Laya.Box
    public GetComponents() {
        [
            this.close,
            this.team,
            this.know,
        ]
            = this.GetChildrenByNames([

                "close",
                "team",
                "know",
            ])
    }
}
window["SentientActTipView"] = SentientActTipView