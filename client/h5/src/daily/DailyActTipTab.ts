import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { DailyModel } from "../commonModel/DailyModel"
import { ColorUtil } from "../util/ColorUtil"
import { DailyActTipView } from "./DailyActTipView"
import { DailyEvent } from "./DailyEvent"

export class DailyActTipTab extends BaseItemRenderer {
    WIDTH = 84
    HEIGT = 84


    model: DailyModel = DailyModel.GetInstance();
    is_first = true
    public constructor(parent) {
        super()


        this.base_file = "daily"
        this.layout_file = "DailyActTipTab"
        this.load_callback = () => {
            this.LoadSuccess()
        }
        this.Load()
    }

    public LoadSuccess(){
       
    }

    public InitEvent(){
        this.BindEvent(this.model, DailyEvent.DAILY_ORDER_SUCCESS, (module, module_sub, ac_sub, sign_state) => {
            let data = this.data
            if (data && data.module == module && data.module_sub == module_sub && data.ac_sub == ac_sub) {
                this.red.visible = sign_state == 0
            }
        })
    }


    public dataChanged() {
        if (super.dataChanged()) {
            if(this.is_first){
                this.is_first = false
                Laya.Tween.clearAll(this.display_obj)
                this.display_obj.x = DailyActTipView.OpenTweenData.TabInStartPos
                this.display_obj.alpha = DailyActTipView.OpenTweenData.TabInStartAlpha
                let delay_time = (this.index - 1) * DailyActTipView.OpenTweenData.TabInTimeInterval + DailyActTipView.OpenTweenData.ViewInTime
                setTimeout(() => {
                    if(this.use_delete_method) return
                    this.InitEvent()
                    Laya.Tween.to(this.display_obj, { x: 0, alpha: 1 }, DailyActTipView.OpenTweenData.TabInTimeInterval, Laya.Ease.linearNone)
                }, delay_time);
            }
            if (this.data) {
                let data = this.data
                this._Label1.text = data.ac_name
                this.select.visible = this.selected
                this._Label1.stroke = 2
                if (this.selected) {
                    this._Label1.color = ColorUtil.TryParseHtmlString("#323457")
                    this._Label1.strokeColor = ColorUtil.TryParseHtmlString("#ffffff")
                } else {
                    this._Label1.color = ColorUtil.TryParseHtmlString("#d7d9ed")
                    this._Label1.strokeColor = ColorUtil.TryParseHtmlString("#323457")
                }
                let module = data && data.module
                let sign_state = data.sign_state
                let reservation = this.model.GetResStatus(module, data.module_sub, data.ac_sub)
                this.red.visible = sign_state == 0 && reservation != null && data.state != 1
            }
        }
    }




    select: Laya.Image
    _Label1: Laya.Label
    red:Laya.Image
    public GetComponents() {
        [
            this.select,
            this._Label1,
            this.red
        ]
            = this.GetChildrenByNames([

                "select",
                "_Label1",
                "red"
            ])
    }
}
window["DailyActTipTab"] = DailyActTipTab