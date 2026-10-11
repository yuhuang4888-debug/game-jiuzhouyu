import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { TaskModel, TaskTipType } from "../commonModel/TaskModel";
import { ColorUtil } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { SetHtmlCenter, Util } from "../util/Util";

export class RuneBagItem extends BaseItemRenderer {
	public WIDTH = 202
	public HEIGT = 326

	task_model: TaskModel
	model: RuneModel
	public constructor() {
		super()
		this.base_file = "rune"
		this.layout_file = "RuneBagItem"
		this.task_model = TaskModel.GetInstance()
		this.model = RuneModel.GetInstance()
		this.Load()
	}

	public load_callback() {

		let btn_fun = () => {
			if (this.data) {
				this.model.Fire(RuneEvent.RUNE_REQUEST_PROTO, 16701, "cl", this.data.pos_id, this.data.goods_vo.goods_id)
			}
		}
		Util.AddClickEvent(this.insertBtn, btn_fun, this, true)
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data) {
				let awake = false
				if (this.data.goods_vo) {
					if (this.model.guide_goods_id && this.task_model.IsCurrMainLineTaskTipType(TaskTipType.RuneNum) && !this.task_model.IsCurrMainTaskHasFinish()) {
						if (this.model.guide_goods_id == this.data.goods_vo.goods_id) {
							let setp_cfg = { "step": 2, "direction": 4, "text": "点击<font color='#0a9f42'>镶嵌</font>按钮，<br>属性嗖嗖的~", "effect_scaleX": 0.65, "effect_scaleY": 0.9, "front_parent":true }
							GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.insertBtn, "Activity", null, -10, null, null, setp_cfg)
							this.display_obj.parent.zOrder = 1
						} else {
							this.display_obj.parent.zOrder = 0
							GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.insertBtn)
						}
					}
					let color = (this.data.goods_vo.subtype == 26 || this.data.goods_vo.subtype == 27) &&  this.data.goods_vo.color == 5? 6:  this.data.goods_vo.color
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, "resource/game/runeCard/" + this.data.goods_vo.type_id + ".png")
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_kuang, "resource/game/runeCard/icon_kp_0" + color + ".png")
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_iconbg, "resource/game/runeCard/icon_kpbg_0" + color + ".png")
					ResManager.GetInstance().SetImageSprite(this, this._img_color, "rune", "color_" + color)
					let txtColor = color == 6? 7: color
					let color_str = ColorUtil.GetColorDark(txtColor, false)
					this.goods_name.text = this.data.goods_vo.goods_name;
					this.goods_lv.text = `Lv.${this.data.goods_vo.level}`;
					this.goods_name.strokeColor = this.goods_lv.strokeColor = color_str;
					let source = "rune_001"
					if (this.data.goods_vo.subtype == 22 || this.data.goods_vo.subtype == 23) {
						source = "uifu_009"
					}

					for (let _tmpi in this.data.goods_vo.awake_list) {
						var vo = this.data.goods_vo.awake_list[_tmpi]
						if (vo.awake_lv > 0) {
							awake = true
							break
						}
					}
				}

				this.pro.style.fontSize = 20
				this.pro.style.leading = 8
				this.pro.width = 190
				this.pro.height = 55
				this.pro.style.color = "#5a1c20"
				this.pro.style.align = "center"
				this.pro.innerHTML = this.model.GetProStr(this.data.pro_list, ColorUtil.GetColorLight(4))
				SetHtmlCenter(this.pro, { "x": 1, "w": 190 })
				this.pro.style.padding = [(this.pro.height - this.pro.contextHeight) / 2, 0, 0, 0];     //垂直居中
				this.awakeIcon.visible = awake
				if (this.data.can_use) {
					this.not_state.visible = false
					this.insertBtn.visible = true
					this.not_suit.visible = false
					if (this.data.type == 1) {
						this.labelDisplay.text = "镶嵌"
					} else {
						this.labelDisplay.text = "替换"
					}
				} else {
					this.insertBtn.visible = false
					if (this.data.pos_id == 9 || this.data.pos_id == 10 || this.data.goods_vo.subtype == RuneModel.IgnoreAttackSubType || this.data.goods_vo.subtype == RuneModel.IgnoreDefendSubType) {
						this.not_suit.visible = true
						this.not_state.visible = false
					} else {
						this.not_suit.visible = false
						this.not_state.visible = true
					}
				}
			}
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	bg: Laya.Image
	_img_iconbg: Laya.Image
	_img_icon: Laya.Image
	_img_kuang: Laya.Image
	goods_name: Laya.Label
	goods_lv: Laya.Label
	pro: Laya.HTMLDivElement
	insertBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	not_state: Laya.Image
	not_suit: Laya.Image
	awakeIcon: Laya.Image
	_img_color: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this._img_iconbg,
			this._img_icon,
			this._img_kuang,
			this.goods_name,
			this.goods_lv,
			this.pro,
			this.insertBtn,
			this._Image1,
			this.labelDisplay,
			this.not_state,
			this.not_suit,
			this.awakeIcon,
			this._img_color,
		]
			= this.GetChildrenByNames([

				"bg",
				"_img_iconbg",
				"_img_icon",
				"_img_kuang",
				"goods_name",
				"goods_lv",
				"pro",
				"insertBtn",
				"_Image1",
				"labelDisplay",
				"not_state",
				"not_suit",
				"awakeIcon",
				"_img_color",
			])
	}
}
window["RuneBagItem"] = RuneBagItem