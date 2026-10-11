import { Alert } from "../alert/Alert";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { LungEvent, LungModel } from "../commonModel/LungModel";
import { ColorUtil } from "../util/ColorUtil";
import { AtlasUrl, Util } from "../util/Util";

export class LungResolveItem extends BaseItemRenderer {
	public WIDTH = 296
	public HEIGT = 124

	private item: EquipmentItem
	private model: LungModel
	public is_selected = false
	public constructor() {
		super();
		this.base_file = "lung"
		this.layout_file = "LungResolveItem"
		this.model = LungModel.GetInstance()
		this.Load()



	}

	public load_callback() {
		if (!this.item) {
			this.item = new EquipmentItem(this.goods_icon)
			this.item.Load()
			this.item.SetItemSize(70, 70)
		}

		Util.AddClickEvent(this.click_bg, () => {
			if (this.data) {
				this.data.is_selected = !this.data.is_selected
				this.SetSelected(this.data.is_selected)
			}
		}, this)
	}

	protected dataChanged(): void {
		if (super.dataChanged()) {
			let self = this
			self.item.SetData(self.data.type_id, null, null, null, null, null, null, null, null, self.data.level)
			self.item.SetClickCallBack(() => {
				if (self.data.type == LungModel.LungMaterialGoodsType) {
					UIToolTipMgr.GetInstance().AppendGoodsTips(self.data.type_id, null, null, self.data)
				} else {
					UIToolTipMgr.GetInstance().AppendLungTips(self.data.type_id, self.data)
				}
			});
			let str = (self.data.goods_name).trim()
			self.goods_name.color = ColorUtil.GetColorDark(self.data.color, false)
			self.goods_name.text = Util.StrToHTML(str)
			this.goods_style.skin = AtlasUrl("lung", `${this.model.GetLungStyleSource(self.data.subtype)}`)
			self.SetSelected(self.data.is_selected, true)

			this.level.width = 200
			this.level.style.fontSize = 20
			this.level.style.color = "##a0a0a"
			if (this.data.type == LungModel.LungGoodsType) {
				let [lv, star] = this.model.GetLungRealLvAndStar(self.data.level)
				this.level.innerHTML = `Lv.${lv}`
			} else if (this.data.type == LungModel.LungMaterialGoodsType) {
				let [can_compose, cost_num, id, is_recommend, target_type_id] = this.model.ChipCanComposeDot(self.data.type_id)
				let color_str = "'#0a953e'"
				if (!can_compose) {
					color_str = "'#ff4f50'"
				}
				let str = `拥有:<font color=${color_str}>${this.data.goods_num}</font>/${cost_num}`
				this.level.innerHTML = Util.StrToHTML(str)
			}
		}
	}

	public SetSelected(bool, not_fire_event?: boolean) {
		this.selectBg.visible = bool
		if (!not_fire_event) {
			this.model.Fire(LungEvent.CLICK_LUNG_RESOLVE_ITEM, this.data.goods_id, bool)
		}
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe();
		}
		super.DeleteMe();
	}
	
	bg: Laya.Image
	_Group1: Laya.HBox
	goods_name: Laya.Label
	goods_style: Laya.Image
	level: Laya.HTMLDivElement
	goods_icon: Laya.Box
	selectBg: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	click_bg: Laya.Box
	public GetComponents() {
		[
			this.bg,
			this._Group1,
			this.goods_name,
			this.goods_style,
			this.level,
			this.goods_icon,
			this.selectBg,
			this._Image1,
			this._Image2,
			this.click_bg,
		]
			= this.GetChildrenByNames([

				"bg",
				"_Group1",
				"goods_name",
				"goods_style",
				"level",
				"goods_icon",
				"selectBg",
				"_Image1",
				"_Image2",
				"click_bg",
			])
	}
}
window["LungResolveItem"] = LungResolveItem