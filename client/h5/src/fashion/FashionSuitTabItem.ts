import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { FashionModel } from "../commonModel/FashionModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"


let local_FashionModel = FashionModel
export class FashionSuitTabItem extends BaseItem1 {


    model: FashionModel = local_FashionModel.GetInstance()

    index
    data
    need_refresh_data
    cache_select
    public constructor(parent?) {
        super(parent)
        this.base_file = "fashion"
        this.layout_file = "FashionSuitTabItem"
        this.load_callback = () => {
            this.LoadSuccess()
        }
    }

    public LoadSuccess() {
        this.InitEvent()
        if (this.cache_select != null) {
            this.SetSelect(this.cache_select)
        }
        if (this.need_refresh_data) {
            this.UpdateItem()
        }
    }

    public InitEvent() {
        Util.AddClickEvent(this._img_bg, () => {
            if (this.index == null) return
            this.model.Fire(FashionModel.SELECT_SUIT, this.index)
        }, this, false)

        this.BindEvent(this.model, FashionModel.SUIT_REFRESH_ACTIVE_RED_FLAG, (suit_id)=>{
            if(this.data && this.data.id == suit_id){
                this.UpdateRed()
            }
        })

        this.BindEvent(this.model, FashionModel.SUIT_REFRESH_UPSTAGE_RED_FLAG, (suit_id)=>{
            if(this.data && this.data.id == suit_id){
                this.UpdateRed()
            }
        })
    }

    public SetData(index, data) {
        this.index = index
        this.data = data
        if (this.is_loaded) {
            this.UpdateItem()
        }
        else {
            this.need_refresh_data = true
        }
    }

    public UpdateItem() {
        this._img_icon.skin = GameResPath.GetIcon("fashion", `tab_icon_${this.data.id}`)
        this._lb_name.text = this.data.name
        this.UpdateRed()
    }

    public SetSelect(bool) {
        if (this.is_loaded) {
            this._img_select.visible = bool
        }
        else {
            this.cache_select = bool
        }
    }

    public UpdateRed(){
        this._img_red.visible = (this.model.fashion_suit_upstage_red_dic && this.model.fashion_suit_upstage_red_dic[this.data.id])
            || (this.model.fashion_suit_active_red_dic && this.model.fashion_suit_active_red_dic[this.data.id])
    }

    public DeleteMe() {
        this.cache_select = undefined
        this.need_refresh_data = undefined
        this.data = undefined
        this.index = undefined


        super.DeleteMe()
    }

    _img_bg: Laya.Image
    _img_icon: Laya.Image
    _img_select: Laya.Image
    _lb_name: Laya.Label
    _img_red: Laya.Image
    public GetComponents() {
        [
            this._img_bg,
            this._img_icon,
            this._img_select,
            this._lb_name,
            this._img_red,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_icon",
                "_img_select",
                "_lb_name",
                "_img_red",
            ])
    }
}
window["FashionSuitTabItem"] = FashionSuitTabItem