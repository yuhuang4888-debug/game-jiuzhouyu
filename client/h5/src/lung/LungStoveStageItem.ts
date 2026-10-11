import { BaseItem1 } from "../common/BaseItem1";
import { EquipmentItem } from "../common/EquipmentItem";
import { GoodsModel } from "../commonModel/GoodsModel";
import { LungEvent, LungModel } from "../commonModel/LungModel";
import { Util } from "../util/Util";

export class LungStoveStageItem extends BaseItem1 {

	private data
	private needRefresh
	private item: EquipmentItem
	private model: LungModel
	public constructor(parent) {
		super(parent);
		this.base_file = "lung";
		this.layout_file = "LungStoveStageItem";
		this.model = LungModel.GetInstance()
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvents()
		}
	}
	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		this.ClearUIEffect(this.front_effect)
		this.ClearUIEffect(this.under_effect)
		super.DeleteMe()
	}

	public LoadSuccess() {
		// this.front_effect.touchEnabled = this.front_effect.touchChildren = false
		// this.under_effect.touchEnabled = this.under_effect.touchChildren = false
	}

	public InitEvents() {
		let self = this
		Util.AddClickEvent(self.click_bg, () => {
			if (self.data && self.data[0]) {
				let state = self.model.GetStoveStageState(self.data[0])
				if (state == 1) {
					self.model.Fire(LungEvent.LUNG_REQUEST_PROTO, 18107, "i", self.data[0])
				}
			}
		}, self, true)

		if (self.needRefresh) {
			self.SetData(self.data)
		}
	}

	public SetData(data) {
		let self = this
		self.data = data
		if (self.is_loaded && self.data) {
			let goods = self.data[1][0]
			// if (self.item){
			// 	self.item.DeleteMe()
			// 	self.item = null
			// }
			self.num.text = `累计${self.data[0]}次`
			if (goods) {
				let [goods_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(goods[0], goods[1])
				if (!self.item) {
					self.item = new EquipmentItem(self.icon_group)
					self.item.Load()
					self.item.SetItemSize(60, 60)
				}
				self.item.SetData(goods_id, goods[2])
				let state = self.model.GetStoveStageState(self.data[0])
				self.click_bg.visible = state == 1
				self.got_tag.visible = state == 2

				this.selectImg.visible = state != 0;
				this.defImg.visible = state == 0;
				this.redImg.visible = state == 1;

				if (state == 1) {	//可领取
					// let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)
					// if (basic){
					// 	self.item.SetBoxEffect(basic.color)
					// }
					self.AddUIEffect("ui_giftglow_front", self.front_effect, null, null, true)
					self.AddUIEffect("ui_activity_glow", self.under_effect, null, null, true)

				} else if (state == 2 || state == 0) { //已领取
					self.item.ClearBoxEffect()
					this.ClearUIEffect(this.front_effect)
					this.ClearUIEffect(this.under_effect)
				}
			}


		} else {
			self.needRefresh = true
		}

	}


	selectImg: Laya.Image
	defImg: Laya.Image
	under_effect: Laya.Box
	icon_group: Laya.Box
	front_effect: Laya.Box
	got_tag: Laya.Image
	num: Laya.Label
	redImg: Laya.Image
	click_bg: Laya.Box
	public GetComponents() {
		[
			this.selectImg,
			this.defImg,
			this.under_effect,
			this.icon_group,
			this.front_effect,
			this.got_tag,
			this.num,
			this.redImg,
			this.click_bg,
		]
			= this.GetChildrenByNames([

				"selectImg",
				"defImg",
				"under_effect",
				"icon_group",
				"front_effect",
				"got_tag",
				"num",
				"redImg",
				"click_bg",
			])
	}
}
window["LungStoveStageItem"] = LungStoveStageItem