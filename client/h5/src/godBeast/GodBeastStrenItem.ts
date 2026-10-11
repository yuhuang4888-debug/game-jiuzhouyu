import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { GodBeastEvent, GodBeastModel } from "../commonModel/GodBeastModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { ColorUtil } from "../util/ColorUtil";
import { Util } from "../util/Util";

export class GodBeastStrenItem extends BaseItemRenderer {
    public WIDTH = 150
	public HEIGT = 183

    private _model: GodBeastModel;
    private _select = false;
    private _event_id;
    // private lvLb: eui.Label
    public item: EquipmentItem

    public constructor() {
        super()
        this.base_file = "godBeast"
		this.layout_file = "GodBeastStrenItem"
        this._model = GodBeastModel.GetInstance()
        this.Load()
        
    }

    public load_callback(){
        this.InitEvent()
        
		this.item = new EquipmentItem(this.itemGp, undefined, undefined, false)
        this.item.Load()
        this.item.SetScale(0.7)
	}

    public DeleteMe() {
        if (this.item) {
            this.item.DeleteMe()
            this.item = null
        }
        super.DeleteMe()
    }

    public createChildren() {
        super.createChildren()
        
    }

    protected InitEvent() {
        Util.AddClickEvent(this, () => {
            this._select = !this._select
            this.SetSelect(this._select)
            this._model.Fire(GodBeastEvent.SELECT_STREN_ITEM, this.data, this._select)
        }, this)

        this._event_id = this._model.Bind(GodBeastEvent.SELECT_STREN_ITEM, (data, select) => {
            // this.item.SetSelect(this.data == data)
            this.SetSelect(this.data == data)
        })
    }

    protected dataChanged() {
        if (!super.dataChanged()) return
        let data = this.data
        // let cfg = this._model.GetEquipData(data.type_id)
        // this._item.SetStar(cfg.star)
        this.item.SetData(data.type_id)
        this.item.SetStrengthen(data.stren)
        let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.type_id)
        this._lb_name.color = ColorUtil.GetColorDark(basic.color, false)
        this._lb_name.text = basic.goods_name
        // this.lvLb.text = `强化等级+${data.stren}`

        this.SetSelect(this._model.now_select_stren_goods_id == data.goods_id)
    }

    public SetSelect(bool){
        if (this.is_loaded){
            this.selectImg.visible = bool
        }
    }
    
    _Image1: Laya.Image
    selectImg: Laya.Image
    _lb_name: Laya.Label
    itemGp: Laya.Box
    public GetComponents() {
        [
            this._Image1,
            this.selectImg,
            this._lb_name,
            this.itemGp,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "selectImg",
                "_lb_name",
                "itemGp",
            ])
    }
}
window["GodBeastStrenItem"] = GodBeastStrenItem