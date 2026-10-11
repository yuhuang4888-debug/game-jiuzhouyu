import { BaseItem1 } from "../common/BaseItem1"
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel"
import { Util } from "../util/Util"

export class MarriageDunLuckBtn extends BaseItem1 {

    needRefresh
    data
    index = 0
    select_cache
    model
    dot_cache
    public constructor(parent) {
        super(parent)
        this.base_file = "marriage"
        this.layout_file = "MarriageDunLuckBtn"
        this.model = MarriageModel.GetInstance()
        this.load_callback = () => {
            this.LoadSuccess()
            this.InitEvents()
        }
    }

    public DeleteMe() {

        super.DeleteMe()
    }

    public LoadSuccess() {

        if (this.needRefresh) {
            this.SetData(this.data, this.index)
            this.needRefresh = null
        }

    }

    public InitEvents() {
        Util.AddClickEvent(this.con, () => {
            this.model.Fire(MarriageEvent.DUN_TAB_BTN_CLICK, this.index)
        }, this, true)

        let click_fun = (index) => {
            if (this.index != undefined) {
                this.SetSelect(this.index == index)
            }
        }
        this.BindEvent(this.model, MarriageEvent.DUN_TAB_BTN_CLICK, click_fun)
    }


    public SetData(data, index) {
        this.data = data
        this.index = index
        if (this.is_loaded) {
            this._lb_content.text = String(data)
        } else {
            this.needRefresh = true
        }
    }

    public SetSelect(bool, force?) {
        if (this.is_loaded) {
            this._img_select.visible = bool
        } else {
            this.select_cache = bool
        }
    }
    con: Laya.Box
    _Image1: Laya.Image
    _img_select: Laya.Image
    _lb_content: Laya.Label
    public GetComponents() {
        [
            this.con,
            this._Image1,
            this._img_select,
            this._lb_content,
        ]
            = this.GetChildrenByNames([

                "con",
                "_Image1",
                "_img_select",
                "_lb_content",
            ])
    }
}
window["MarriageDunLuckBtn"] = MarriageDunLuckBtn