import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { FirstBloodEvent, FirstBloodModel } from "../commonModel/FirstBloodModel"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"

export class DungeonRuneFirstTab extends BaseItemRenderer {

    model

    WIDTH = 158
    HEIGT = 68
    
    public constructor(parent?) {
        super()
        this.base_file = "dungeonRune"
		this.layout_file = "DungeonRuneFirstTab"
        this.model = FirstBloodModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
    }

    public LoadSuccess(){
        this.InitEvent()
    }

    public InitEvent(){
        this.BindEvent(this.model, FirstBloodEvent.UPDATE_RUNE_DATA, (type?, subtype?, object_id?) => {
            if (this.data && this.data.type == type && this.data.sub_type == subtype && this.data.object_id == object_id) {
                let get = this.model.GetRuneFirstHave(this.data.object_id)
                this._img_reveived.visible = get
                let red = this.model.GetRuneFirstRed(this.data.object_id)
                this._img_red.visible = red
            }
        })

    }

     dataChanged(){
        if (super.dataChanged()) {
            let str = (this.data.desc).trim()
            this._lb_desc.text = str
            let red = this.model.GetRuneFirstRed(this.data.object_id)
            this._img_red.visible = red
            let get = this.model.GetRuneFirstHave(this.data.object_id)
            this._img_reveived.visible = get

            let selected = this.selected

            ResManager.GetInstance().SetImageSprite(this, this._img_bg, "dungeonRune", selected ? "ui_btn_achv_highlight" : "ui_btn_achv")
            this._lb_desc.color = selected ? "#a75d21" : "#ffffff"
        }
    }

    public DeleteMe() {
        super.DeleteMe()
    }

    _img_bg: Laya.Image
    _lb_desc: Laya.Label
    _img_reveived: Laya.Image
    _img_red: Laya.Image
    public GetComponents() {
        [
            this._img_bg,
            this._lb_desc,
            this._img_reveived,
            this._img_red,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_lb_desc",
                "_img_reveived",
                "_img_red",
            ])
    }
}

window["DungeonRuneFirstTab"] = DungeonRuneFirstTab