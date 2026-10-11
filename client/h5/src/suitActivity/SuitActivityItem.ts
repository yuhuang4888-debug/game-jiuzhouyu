import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { ErlangParser } from "../util/ErlangParser"
import { WordManager } from "../common/WordManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { SuitActivityModel } from "../commonModel/SuitActivityModel"
import { RefBoxChildsLayout } from "../util/Util"
import { PlatformManager } from "../PlatformManager"

export class SuitActivityItem extends BaseItem1 {
	stage
	count
	needRefresh
	suit_id
	cfg_suit_proc

	public constructor(parent) {
		super(parent)
		this.base_file = "suitActivity"
		this.layout_file = "SuitActivityItem"

		this.load_callback = () => {
			this.cfg_suit_proc = Config.PRELOAD_SERVER_CONFIG.config_suit_clt_process
			ResManager.GetInstance().SetOutsideImageSprite(this, this.img_bg, GameResPath.GetIcon("suitActivity", "ui_sstz_004"))
			if (this.needRefresh) {
				this.SetData(this.count, this.stage, this.suit_id)
			}
		}
	}

	public SetData(count?, stage?, suit_id?) {
		if (this.is_loaded) {
			let is_single = SuitActivityModel.GetInstance().IsSuitSingle(suit_id)
			this._gp_normal.visible = !is_single
			this._gp_single.visible = is_single
			if (is_single) {
				this.UpdateSingle(count, stage, suit_id)
			} else {
				this.UpdateView(count, stage, suit_id)
			}
		} else {
			this.count = count
			this.stage = stage
			this.suit_id = suit_id
			this.needRefresh = true
		}
	}

	// 单个激活类型
	public UpdateSingle(count?, stage?, suit_id?) {
		let left_id = count - 1
		let left_cfg = this.cfg_suit_proc[suit_id + "@" + left_id]
		if (left_cfg) {
			let prop = ErlangParser.GetInstance().Parse(left_cfg.attr)
			let actived = left_id <= stage
			let color = actived && "#0a953e" || "#a2a2a2"
			this.count1.text = "【" + left_id + "件】"
			this.count1.color = color
			this.prop1.text = WordManager.GetProperties(prop[0][0])
			this.prop1.color = color
			this.num1.text = WordManager.ConvertToPercentValue(prop[0][0], prop[0][1])
			this.num1.color = color
			this.active_1.visible = actived
			// this.img_1.visible = !actived
		}

		let right_id = count
		let right_cfg = this.cfg_suit_proc[suit_id + "@" + right_id]
		if (right_cfg) {
			let prop = ErlangParser.GetInstance().Parse(right_cfg.attr)
			let actived = right_id <= stage
			let color = actived && "#0a953e" || "#a2a2a2"
			this.count2.text = "【" + right_id + "件】"
			this.count2.color = color
			this.prop2.text = WordManager.GetProperties(prop[0][0])
			this.prop2.color = color
			this.num2.text = WordManager.ConvertToPercentValue(prop[0][0], prop[0][1])
			this.num2.color = color
			this.active_2.visible = actived
			// this.img_2.visible = !actived
		}

		if (PlatformManager.IsEyouPlatform()) {
			this.RefBox(this._gp1, 36)
			this.RefBox(this._gp2, 36)
		}
	}
	private RefBox(box: Laya.Box,start) {
		let cont_w = start
		for (let i = 0; i < box.numChildren; i++) {
			if (i <= 1) continue
			let cell: any = box.getChildAt(i)
			if (cell) {
				let wid = 0
				wid = cell.contextWidth ? cell.contextWidth : cell.width
				cell.x = cont_w
				cont_w += (5 + wid)
			}
		}
	}

	public UpdateView(count?, stage?, suit_id?) {
		let prop_cfg = this.cfg_suit_proc[suit_id + "@" + count]
		if (prop_cfg) {
			let prop = ErlangParser.GetInstance().Parse(prop_cfg.attr)
			let actived = count <= stage
			let color = actived && "#663915" || "#a2a2a2"
			this.countText.text = count + "件"
			this.countText.color = color
			this.propText.text = WordManager.GetProperties(prop[0][0])
			this.propText.color = color
			this.numText.text = "+ " + WordManager.ConvertToPercentValue(prop[0][0], prop[0][1])
			this.numText.color = actived && "#0a953e" || "#a2a2a2"
			this.Image2.visible = actived
		}
		if (PlatformManager.IsEyouPlatform()) {
			this.RefBox(this._gp_normal, 179)
		}
	}

	public ShowEffect() {
		if (!this.use_delete_method) {
			//this.AddUIEffect("UI_1156", "UI", this.form, Vector2(175, -18))
		}
	}

	img_bg: Laya.Image
	_gp_normal: Laya.Box
	Image: Laya.Image
	Image2: Laya.Image
	countText: Laya.Label
	propText: Laya.Label
	numText: Laya.Label
	_gp_single: Laya.Box
	_gp1: Laya.Box
	img_1: Laya.Image
	active_1: Laya.Image
	count1: Laya.Label
	prop1: Laya.Label
	num1: Laya.Label
	_gp2: Laya.Box
	img_2: Laya.Image
	active_2: Laya.Image
	count2: Laya.Label
	prop2: Laya.Label
	num2: Laya.Label
	public GetComponents() {
		[
			this.img_bg,
			this._gp_normal,
			this.Image,
			this.Image2,
			this.countText,
			this.propText,
			this.numText,
			this._gp_single,
			this._gp1,
			this.img_1,
			this.active_1,
			this.count1,
			this.prop1,
			this.num1,
			this._gp2,
			this.img_2,
			this.active_2,
			this.count2,
			this.prop2,
			this.num2,
		]
			= this.GetChildrenByNames([
				"img_bg",
				"_gp_normal",
				"Image",
				"Image2",
				"countText",
				"propText",
				"numText",
				"_gp_single",
				"_gp1",
				"img_1",
				"active_1",
				"count1",
				"prop1",
				"num1",
				"_gp2",
				"img_2",
				"active_2",
				"count2",
				"prop2",
				"num2",
			])
	}
}
window["SuitActivityItem"] = SuitActivityItem