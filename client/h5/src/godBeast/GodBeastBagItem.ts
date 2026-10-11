import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { GodBeastModel } from "../commonModel/GodBeastModel";

export class GodBeastBagItem extends BaseItemRenderer {
    public WIDTH = 85
	public HEIGT = 85

    private _model: GodBeastModel;
    public _item: EquipmentItem
    public constructor() {
        super()
        this.base_file = "godBeast"
		this.layout_file = "GodBeastBagItem"
        this._model = GodBeastModel.GetInstance()
		this.Load()
    }

    public load_callback() {


    }

    public DeleteMe() {
		if (this._item) {
            this._item.DeleteMe()
            this._item = null
        }
		super.DeleteMe()
	}

    protected Clear() {
        
    }

    public createChildren() {
        super.createChildren()
        // this._item.is_loaded = true
        // this._item.load_callback()
    }

    protected dataChanged() {
        if (!super.dataChanged()) return
        let data = this.data
        // let cfg = this._model.GetEquipData(data.type_id)
        // this._item.SetStar(cfg.star)
        if (!this._item) {
            this._item = new EquipmentItem(this.con)
            this._item.Load()
            this._item.SetItemSize(85, 85)
        }
        this._item.SetData(data.type_id, data.goods_num)
        this._item.SetClickCallBack(this.ClickCallBack)
        // this._item.ExcuteCallback(() => {
            this._item.SetStrengthen(data.stren)
        // })
        let wear = this._model.GetWearEquipInfo(data.goods_id)
        this._img_tips.visible = !!wear
    }

    private ClickCallBack = () => {
        if (this.data.type == 39) {
            UIToolTipMgr.GetInstance().AppendGodBeastTips(this.data.type_id, undefined, undefined, this.data)
        } else {
            UIToolTipMgr.GetInstance().AppendGoodsTips(this.data.type_id, undefined, undefined, undefined, this.data.goods_num)
        }
    }
    con: Laya.Box
    _img_tips: Laya.Image
    _img_down: Laya.Image
    _img_up: Laya.Image
    _group_select: Laya.Box
    _Image1: Laya.Image
    _Image2: Laya.Image
    public GetComponents() {
        [
            this.con,
            this._img_tips,
            this._img_down,
            this._img_up,
            this._group_select,
            this._Image1,
            this._Image2,
        ]
            = this.GetChildrenByNames([

                "con",
                "_img_tips",
                "_img_down",
                "_img_up",
                "_group_select",
                "_Image1",
                "_Image2",
            ])
    }
}
window["GodBeastBagItem"] = GodBeastBagItem