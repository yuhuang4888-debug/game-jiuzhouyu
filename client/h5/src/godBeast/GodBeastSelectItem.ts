import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { GodBeastModel } from "../commonModel/GodBeastModel";

export class GodBeastSelectItem extends BaseItemRenderer {
    public WIDTH = 127
	public HEIGT = 127


    _model: GodBeastModel
    _item: EquipmentItem
    public constructor() {
        super()
        this.base_file = "godBeast"
		this.layout_file = "GodBeastSelectItem"
        this._model = GodBeastModel.GetInstance()
		this.Load()
    }

    public load_callback() {
        if (!this._item) {
            this._item = new EquipmentItem(this._item_con)
            this._item.Load()
        }
	}

    protected Clear() {
        if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}
    }

    public DeleteMe() {
		this.Clear()
		super.DeleteMe()
	}

    public createChildren() {
        super.createChildren()
    }

    protected dataChanged() {
        if (!super.dataChanged()) return
        let data = this.data
        // let cfg = this._model.GetEquipData(data.type_id)
        // this._item.SetStar(cfg.star)
        this._item.SetData(data.type_id)
        this._item.SetClickCallBack(this.ClickCallBack)
        this._item.SetStrengthen(data.stren)
        let wear = this._model.GetWearEquipInfo(data.goods_id)
        let id = this._model._select_beast_id
        let equip = this._model.GetWearEquipByIdAndPos(id, data.equip_type)
        this._img_tips.visible = !!wear
        let up = !equip || data.rating > equip.rating
        let is_same_power = !equip || data.rating == equip.rating
        let self = !equip || data.goods_id == equip.goods_id
        this._img_up.visible = !equip || (up && !self)
        this._img_down.visible = !up && !self && !is_same_power
    }

    private ClickCallBack = () => {
        if (this.data.type == 39) {
            let wear = GodBeastModel.GetInstance().GetWearEquipInfo(this.data.goods_id)
            let show_btn_list = wear ? [0, 1] : [0, 2]
            UIToolTipMgr.GetInstance().AppendGodBeastTips(this.data.type_id, undefined, undefined, this.data, undefined, show_btn_list)
        } else {
            UIToolTipMgr.GetInstance().AppendGoodsTips(this.data.type_id, undefined, undefined, undefined, this.data.goods_num)
        }
    }
    _item_con: Laya.Box
    _img_tips: Laya.Image
    _img_down: Laya.Image
    _img_up: Laya.Image
    _group_select: Laya.Box
    _Image1: Laya.Image
    _Image2: Laya.Image
    public GetComponents() {
        [
            this._item_con,
            this._img_tips,
            this._img_down,
            this._img_up,
            this._group_select,
            this._Image1,
            this._Image2,
        ]
            = this.GetChildrenByNames([

                "_item_con",
                "_img_tips",
                "_img_down",
                "_img_up",
                "_group_select",
                "_Image1",
                "_Image2",
            ])
    }
}
window["GodBeastSelectItem"] = GodBeastSelectItem