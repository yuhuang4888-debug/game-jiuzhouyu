import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { ResManager } from "../common/ResManager";
import { InsertState, LungEvent, LungModel } from "../commonModel/LungModel";
import { ColorUtil } from "../util/ColorUtil";
import { TimeUtil } from "../util/TimeUtil";
import { AtlasUrl, Util } from "../util/Util";

export class LungSelectItem extends BaseItemRenderer {
	public WIDTH = 534
	public HEIGT = 124

	private item: EquipmentItem
	private model: LungModel
	private needRefresh = false
	private init_pos
	last_click_time
	public constructor() {
		super();
		this.base_file = "lung"
		this.layout_file = "LungSelectItem"
		this.model = LungModel.GetInstance()
		this.Load()
	}

	public load_callback() {
		this.item = new EquipmentItem(this.goods_icon)
		this.item.SetItemSize(90, 90)
		this.item.Load()
		this.init_pos = this.up_tag.y
		let btn_fun = () => {
			if (this.data && this.data.goods_vo) {
				if (this.last_click_time && TimeUtil.getServerTime() - this.last_click_time <= 1) {
					return
				}
				this.model.Fire(LungEvent.LUNG_CLOSE_VIEW, "LungSelectView")
				this.last_click_time = TimeUtil.getServerTime()
				this.model.Fire(LungEvent.LUNG_REQUEST_PROTO, 18102, "lc", this.data.goods_vo.goods_id, this.data.pos_id)
			}
		}
		Util.AddClickEvent(this.replaceBtn, btn_fun, this, true)
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		this.last_click_time = null
		if (this.up_tag)
			Laya.Tween.clearAll(this.up_tag)
		super.DeleteMe()
	}

	protected dataChanged(): void {
		if (super.dataChanged()) {
			let self = this
			if (self.data.goods_vo) {
				self.item.SetData(self.data.goods_vo.type_id, null, null, null, null, null, null, null, null, self.data.goods_vo.level)
				let color_str = ColorUtil.GetColorDark(self.data.goods_vo.color, false)
				let goods_name = `${(self.data.goods_vo.goods_name).trim()}`
				self.goods_mame.color = color_str
				self.goods_mame.text = Util.StrToHTML(goods_name)
				let [lv, star] = this.model.GetLungRealLvAndStar(self.data.goods_vo.level)
				this.level.text = `Lv.${lv}`
				this.style.skin = AtlasUrl("lung", `${this.model.GetLungStyleSource(self.data.goods_vo.subtype)}`)
			}
			if (self.data.wear_state == InsertState.Insert) {
				self.replaceBtn.visible = true
				self.state.visible = false
				if (self.data.type == 1) {	//镶嵌
					self.replace_label.text = "镶嵌"
				} else {	//替换
					self.replace_label.text = "替换"
				}
			} else {
				self.replaceBtn.visible = false
				self.state.visible = true
				let source = "uidjtz_011"
				if (self.data.wear_state == InsertState.NotKind) {
					source = "uidjtz_012a"
				}
				this.state.skin = AtlasUrl("lung", source)
			}
			this.ShowUpTag()
		}
	}

	public ShowUpTag() {
		if (this.data && this.data.goods_vo && this.data.wear_state == InsertState.Insert) {
			let [show, same, high_color, same_kind, same_color] = this.model.IsBetterThanWear(this.data.goods_vo, this.data.pos_id)
			this.up_tag.visible = show && !same
			this.down_tag.visible = !show && !same
			let dragon_pos_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_dragon_pos", false)
			if (show || high_color) {
				this.red_dot.visible = (high_color || (show && (!same_kind || same_color)))
					&& !this.model.CanInsertInEmptyGrid(this.data.pos_id, this.data.goods_vo.subtype, this.data.goods_vo.type_id, dragon_pos_cfg)
			} else {
				this.red_dot.visible = false
			}
			if (show) {
				
			} else {
				Laya.Tween.clearAll(this.up_tag)
			}
		} else {
			this.red_dot.visible = false
		}
	}

	public ShowAnimation(){
		Laya.Tween.to(this.up_tag, { y: this.init_pos - 10 }, 500, undefined, Laya.Handler.create(this, ()=>{
			this.ShowAnimation2()
		}))
	}
	
	public ShowAnimation2(){
		Laya.Tween.to(this.up_tag, { y: this.init_pos }, 500, undefined, Laya.Handler.create(this, ()=>{
			this.ShowAnimation()
		}))
	}	
	

	_Image1: Laya.Image
	_Group1: Laya.HBox
	goods_mame: Laya.Label
	style: Laya.Image
	goods_icon: Laya.Box
	level: Laya.Label
	replaceBtn: Laya.Box
	_Image2: Laya.Image
	replace_label: Laya.Label
	red_dot: Laya.Image
	state: Laya.Image
	up_tag: Laya.Image
	down_tag: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._Group1,
			this.goods_mame,
			this.style,
			this.goods_icon,
			this.level,
			this.replaceBtn,
			this._Image2,
			this.replace_label,
			this.red_dot,
			this.state,
			this.up_tag,
			this.down_tag,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Group1",
				"goods_mame",
				"style",
				"goods_icon",
				"level",
				"replaceBtn",
				"_Image2",
				"replace_label",
				"red_dot",
				"state",
				"up_tag",
				"down_tag",
			])
	}
}
window["LungSelectItem"] = LungSelectItem