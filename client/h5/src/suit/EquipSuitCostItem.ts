import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { EquipModel } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ColorUtil, Enum_ColorUtil_Light, Enum_ColorUtil_NEW } from "../util/ColorUtil"
import { Util } from "../util/Util"


export class EquipSuitCostItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_group_item: Laya.Box
	lockImg: Laya.Image
	num_text: Laya.HTMLDivElement
	_awarditem: EquipmentItem
	model

	public WIDTH = 100;
	public HEIGT = 100;

	public constructor() {
		super()

		this.model = EquipModel.GetInstance()
		this.base_file = "suit"
		this.layout_file = "EquipSuitCostItem"
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load();
	}

	public DeleteMe() {

		if (this._awarditem) {
			this._awarditem.DeleteMe()
			this._awarditem = null
		}
		super.DeleteMe()
	}

	public LoadSuccess() {
		// this.display_obj.scale(0.9,0.9)
		if (!this._awarditem) {
			this._awarditem = new EquipmentItem(this._group_item)
			this._awarditem.SetItemSize(85, 85);
			this._awarditem.Load();
		}
	}


	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data;
			if (!this._awarditem) {
				this._awarditem = new EquipmentItem(this._group_item);
				this._awarditem.SetItemSize(85, 85);
				this._awarditem.Load();
			}
			let num: number = Number(data[2]);
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1]);
			let own: number = GoodsModel.GetInstance().GetTypeGoodsNum(type_id); // 自己拥有数量
			let color = own >= num && ColorUtil.TransHtmlColor(Enum_ColorUtil_NEW.LIGHT_GREEN) || Enum_ColorUtil_Light.RED
			this._awarditem.SetData(type_id);
			this.SetNumberInFlow(Util.StrToHTML(`<font color=${color}>${own}/${num}</font>`))
		}
	}


	/* public SetLockStatus(unlock?) {

		if (this._awarditem) {
			this._img_bg.visible = !unlock
			this.lockImg.visible = !unlock
			this._awarditem.SetVisible(unlock)
			this.num_text.visible = false
		}
	} */

	private SetNumberInFlow(str?) {


		if (this._awarditem) {
			this.num_text.visible = true
			// this._awarditem.ForceSetNumberInFlow(str)
			this.num_text.width = 100
			this.num_text.innerHTML = str
		}


	}


	public GetComponents() {
		[
			this._img_bg,
			this._group_item,
			this.num_text,
			this.lockImg,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_group_item",
				"num_text",
				"lockImg",
			])
		this.num_text.style.fontSize = 18;
		this.num_text.style.stroke = 2;
		this.num_text.style.color = "#FFFFFF";
		this.num_text.width = 100;
	}
}
window["EquipSuitCostItem"] = EquipSuitCostItem