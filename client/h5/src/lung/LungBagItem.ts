import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { LungModel } from "../commonModel/LungModel";
import { ColorUtil } from "../util/ColorUtil";
import { AtlasUrl, Util } from "../util/Util";

export class LungBagItem extends BaseItemRenderer {
	public WIDTH = 296
	public HEIGT = 124

	private item: EquipmentItem
	private model: LungModel
	private is_recommend = false
	public constructor() {
		super();
		this.base_file = "lung"
		this.layout_file = "LungBagItem"
		this.Load()

	}

	public load_callback() {
		this.model = LungModel.GetInstance()
		this.item = new EquipmentItem(this.icon_con)
		this.item.SetItemSize(70, 70)
		this.item.Load()
		this.item.SetShowTips(false)

		let btn_fun = () => {
			let self = this
			if (this.data) {
				if (self.data.type == LungModel.LungMaterialGoodsType) {
					UIToolTipMgr.GetInstance().AppendLungStoneTips(self.data.type_id, self.data)
				} else {
					UIToolTipMgr.GetInstance().AppendLungTips(self.data.type_id, self.data.level)
				}
			}
		}
		Util.AddClickEvent(this.click_group, btn_fun, this)
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		this.is_recommend = false
		super.DeleteMe()
	}

	protected dataChanged(): void {
		if (super.dataChanged()) {
			let self = this
			self.item.SetData(self.data.type_id, null, null, null, null, null, null, null, null, self.data.level)
			// self.item.SetClickCallBack(()=>{

			// });
			let color_str = ColorUtil.GetColorDark(self.data.color, false)
			let goods_name = `${(self.data.goods_name).trim()}`
			self.goods_name.color = color_str
			self.goods_name.text = Util.StrToHTML(goods_name)

			this.style.skin = AtlasUrl("lung", `${this.model.GetLungStyleSource(this.data.subtype)}`)
			this.is_recommend = false

			this.level.style.fontSize = 20
			this.level.width = 150
			this.level.style.color = "#4a3a32"
			if (this.data.type == LungModel.LungGoodsType) {
				let [lv, star] = this.model.GetLungRealLvAndStar(self.data.level)
				this.level.innerHTML = `Lv.${lv}`
			} else if (this.data.type == LungModel.LungMaterialGoodsType) {
				let [can_compose, cost_num, id, is_recommend, target_type_id] = this.model.ChipCanComposeDot(self.data.type_id)
				this.is_recommend = is_recommend
				let color_str = "'#0a953e'"
				if (!can_compose) {
					color_str = "'#ff4f50'"
				}
				let str = `拥有:<font color=${color_str}>${this.data.goods_num}</font>/${cost_num}`
			
				this.level.innerHTML = Util.StrToHTML(str)
			}
			this.ShowExchangeDot()
		}
	}

	public ShowExchangeDot() {
		if (this.data && this.data.type == LungModel.LungMaterialGoodsType) {
			this.exchange_dot.visible = this.is_recommend
		} else {
			this.exchange_dot.visible = false
		}
	}
	

	click_group: Laya.Box
	_Image1: Laya.Image
	icon_con: Laya.Box
	_Group1: Laya.HBox
	goods_name: Laya.Label
	style: Laya.Image
	level: Laya.HTMLDivElement
	exchange_dot: Laya.Image
	public GetComponents() {
		[
			this.click_group,
			this._Image1,
			this.icon_con,
			this._Group1,
			this.goods_name,
			this.style,
			this.level,
			this.exchange_dot,
		]
			= this.GetChildrenByNames([

				"click_group",
				"_Image1",
				"icon_con",
				"_Group1",
				"goods_name",
				"style",
				"level",
				"exchange_dot",
			])
	}
}
window["LungBagItem"] = LungBagItem