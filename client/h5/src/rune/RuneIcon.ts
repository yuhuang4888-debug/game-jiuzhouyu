import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1"
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { SetHtmlCenter, Util } from "../util/Util";
import { RuneBagView } from "./RuneBagView";

export class RuneIcon extends BaseItem1 {

	data
	is_delay_callback
	item
	model
	needRefresh
	select_cache
	use_local_view


	SetSelected
	GetLastNum
	SetData
	InitEvents
	LoadSuccess
	getNextUnLockId

	public constructor(parent?) {
		super(parent)
		this.base_file = "rune"
		this.layout_file = "RuneIcon"
		this.is_delay_callback = false
		this.model = RuneModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
		}

		this.DeleteMe = () => {
			if (this.item) {
				this.item.DeleteMe()
				this.item = null
			}
			this.ClearUIEffect(this.special_effect)
			this.ClearUIEffect(this.EffectGp)
			// this.ClearUIEffect(this.EffectGp1)
			super.DeleteMe()
		}

		this.LoadSuccess = () => {
			this.unlockLab.style.color = "#663915"
			this.unlockLab.style.fontSize = 20
			this.unlockLab.style.wordWrap = true
			this.unlockLab.style.align = "center"
			this.unlockLab.style.leading = 0.1
			this.unlockLab.width = 130
		}

		this.InitEvents = () => {
			let click_fun = () => {
				if (this.data) {
					if(this.data.pos_id == this.getNextUnLockId()) return;
					if (this.data.if_open > 0) {
						if (this.data.goods_id > 0) {

						} else {
							this.model.Fire(RuneEvent.OPEN_VIEW, "RuneBagView", 1, this.data.pos_id)
						}
					} else {
						// let config_rune_pos = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_pos", false)
						// let str = this.model.GetOpenCondition(this.data.pos_id, config_rune_pos)
						Message.show("通关御魂塔解锁更多孔位！")
					}
					this.SetSelected(true)
				}
			}
			Util.AddClickEvent(this._Group1, click_fun, this)

			let click_go_fun = () => {
				if (this.data) {
					OpenFun.OpenFunHandler(6)
				}
			}

			Util.AddClickEvent(this.goLab, click_go_fun, this)

			let rune_fun = (pos_id?) => {
				if (!this.data || this.data.pos_id != pos_id) {
					this.SetSelected(false)
				}
			}
			this.BindEvent(this.model, RuneEvent.CLICK_RUNE_ICON, rune_fun)

			if (this.needRefresh) {
				this.SetData(this.data)
			}
		}

		this.SetData = (data?) => {
			this.data = data
			if (this.is_loaded) {
				this.ClearUIEffect(this.special_effect)
				this.ClearUIEffect(this.EffectGp)
				// this.ClearUIEffect(this.EffectGp1)
				let sp = this.data.pos_id == 9 || this.data.pos_id == 10;
				this.special_grid.visible = sp
				this.bg.visible = this.data.pos_id != 9 && this.data.pos_id != 10
				let effect = this.data.pos_id == 9 && "ui_yuhun_wushiyiji" || "ui_yuhun_jueduifangyu"
				let awakeLv = 0;
				let isLockid:boolean = this.data.pos_id == this.getNextUnLockId();
				this.unlockBox.visible = !this.data.if_open;
				this._img_kuang.skin = "";
				this._img_icon.skin = "";
				this._img_iconbg.skin = "";
				this._Image_add.visible = false;
				this._Image2.visible = this.special_label.visible = true;
				if (this.data.if_open > 0) {
					this.gray_bg.visible = false
					if (this.data.goods_type_id > 0) {
						this._Image2.visible = this.special_label.visible = false
						// if (!this.item) {
						// 	this.item = new BaseAwardItem(this.icon_wnd)
						// 	this.item.Load()
						// 	this.item.SetItemSize(95, 95)
						// }
						// this.item.SetData(this.data.goods_type_id, 1, null, null, null, true)
						// this.item.SetShowTips(false)
						// this.item.SetItembgVisible(false)
						let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.goods_type_id)
						let color = sp && this.data.color == 5? 6: this.data.color
						ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, "resource/game/runeCard/" + this.data.goods_type_id + ".png")
						ResManager.GetInstance().SetOutsideImageSprite(this, this._img_kuang, "resource/game/runeCard/icon_kp_0" + color + ".png")
						ResManager.GetInstance().SetOutsideImageSprite(this, this._img_iconbg, "resource/game/runeCard/icon_kpbg_0" + color + ".png")
						ResManager.GetInstance().SetImageSprite(this, this._img_lv_bg, "rune", "rune_lv_bg_00" + color)
						// let sub_type_name = ""
						if (basic) {
							this.lv.text = `Lv.${this.data.lv}`
							this._lb_name.text = basic.goods_name
							let txtColor
							let showColor = sp && this.data.color == 5 ? 7 : this.data.color
							if (color == 1) {
								txtColor = ColorUtil.GetColorLight(showColor, false)
							} else {
								txtColor = ColorUtil.GetColorDark(showColor, false)
							}
							this._lb_name.strokeColor = this.lv.strokeColor = txtColor
							ResManager.GetInstance().SetImageSprite(this, this._img_color, "rune", "color_" + color)
						}
						// this.lv_bg.visible = true
						// this.name_bg.visible = true
						this._img_color.visible = true
						effect = (this.data.pos_id == 9 && ("ui_yuhun_wushiyiji_1") || ("ui_yuhun_jueduifangyu_1"))
						for (let _tmpi in this.data.attr_list) {
							var vo = this.data.attr_list[_tmpi]
							if (vo.awake_lv > awakeLv) {
								awakeLv = vo.awake_lv
							}
						}
					} else {
						this._img_color.visible = false
						this._Image_add.visible = true;
						// this.lv_bg.visible = false
						// this.name_bg.visible = false
						this.lv.text = ""
						this._lb_name.text = ""
					}
					this.red_dot.visible = this.model.CanInsert(this.data.pos_id) || this.model.CanUpgrade(this.data.pos_id)
				} else { // 未解锁
					let config_rune_pos = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_pos", false)
					let num: number = this.model.GetOpenConditionNum(this.data.pos_id, config_rune_pos)
					let curNum = BaseDungeonModel.GetInstance().GetRuneCurFloor()
					this.goLab.visible = isLockid;

					this.gray_bg.visible = true
					this._img_color.visible = false
					// this.lv_bg.visible = false
					// this.name_bg.visible = false
					this.lv.text = ""
					this._lb_name.text = ""
					let color = Enum_ColorUtil_Dark.GREEN
					if (curNum < num) {
						color = Enum_ColorUtil_Dark.RED
					}
					let str = "<font color=" + color + ">" + curNum + "</font><font color='#ffffff'>/" + num + "层解锁</font>"
					this.unlockLab.innerHTML = str;
					this.unlockLab.width = 130
					SetHtmlCenter(this.unlockLab, { x: -14, w: 130, y: -2, h: 35 })
				}
				if (this.special_grid.visible) {
					let source = this.data.pos_id == 9 && "ui_rare_27" || "ui_rare_28"
					ResManager.GetInstance().SetImageSprite(this, this.special_label, "rune_asset", source)
					this.AddUIEffect(effect, this.special_effect, null, 5.7, true)
					// let curr_sorting_order = this.AddCurrLayerSortingOrder("UI")
					// this.CoverMode(this.special_label, "UI", curr_sorting_order)
					// this.CoverMode(this.icon_wnd, "UI", curr_sorting_order)

				}
				this.awakeImg.visible = awakeLv > 0
				if (awakeLv > 0 && data.color >= 4) {
					let name = null
					if (this.data.pos_id != 9 && this.data.pos_id != 10) {
						// name = "ui_Runewakefulness_" + ColorUtil.GetColorEffectStr(data.color)
						// name = name + this.GetLastNum(data.color, awakeLv)
						//觉醒特效注释
						// this.AddUIEffect("UI_1601_0" + (data.color == 4 && ("3") || ("4")), this.EffectGp1, null, 2, true)
					} else {
						// name = "ui_gathericon_" + ColorUtil.GetColorEffectStr(data.color)
						// name = name + this.GetLastNum(data.color, awakeLv)
					}
					// this.AddUIEffect(name, this.EffectGp, null, null, true)
					// let curr_sorting_order = this.AddCurrLayerSortingOrder("UI")
					// this.CoverMode(this.EffectGp, "UI", curr_sorting_order)
					// this.CoverMode(this.icon_wnd, "UI", curr_sorting_order)
					// this.CoverMode(this.selectBg, "UI", curr_sorting_order)
					// curr_sorting_order = this.AddCurrLayerSortingOrder("UI")
					// this.CoverMode(this.lv_bg, "UI", curr_sorting_order)
					// this.CoverMode(this.lv, "UI", curr_sorting_order)
					// this.CoverMode(this.awakeImg, "UI", curr_sorting_order)
					// this.CoverMode(this.red_dot, "UI", curr_sorting_order)
				} else {
					this.ClearUIEffect(this.EffectGp)
					//觉醒特效注释
					// this.ClearUIEffect(this.EffectGp1)
				}
				if (this.select_cache != null) {
					this.SetSelected(this.select_cache)
					this.select_cache = null
				}
			} else {
				this.needRefresh = true
			}
		}

		this.getNextUnLockId = () => {
			let _data = this.model.rune_info
			if (!_data || !_data.rune_list) return 0
			for (let i = 0; i < _data.rune_list.length; i++) {
				let vo = _data.rune_list[i];
				if(vo.pos_id == 8 || vo.pos_id == 9) continue;
				if(vo.if_open == 0){
					return vo.pos_id
				}
			}
			return 0
		}

		this.SetSelected = (bool?) => {
			if (this.is_loaded) {
				this.selectBg.visible = bool
				if (bool && this.data) {
					// if (this.data.pos_id == 9 || this.data.pos_id == 10) {
					// 	ResManager.GetInstance().SetImageSprite(this, this.selectBg, "rune_asset", "uifu_003c", true)
					// } else {
					// 	ResManager.GetInstance().SetImageSprite(this, this.selectBg, "rune_asset", "rune_003", true)
					// }
					this.model.Fire(RuneEvent.CLICK_RUNE_ICON, this.data.pos_id)
				}
			} else {
				this.select_cache = bool
			}
		}

		this.GetLastNum = (color?, lv?) => {
			if (color == 4) {
				return (lv <= 3 && (1) || (3))
			} else {
				return Math.ceil(lv / 5)
			}
		}
	}

	_Group1: Laya.Box
	bg: Laya.Image
	_img_icon: Laya.Image
	_img_iconbg: Laya.Image
	_img_kuang: Laya.Image
	EffectGp1: Laya.Box
	special_grid: Laya.Box
	special_effect: Laya.Box
	_Image2: Laya.Image
	special_label: Laya.Image
	icon_wnd: Laya.Box
	EffectGp: Laya.Box
	gray_bg: Laya.Image
	selectBg: Laya.Image
	awakeImg: Laya.Image
	_Image_add: Laya.Image
	_img_color: Laya.Image
	lv: Laya.Label
	_lb_name: Laya.Label
	red_dot: Laya.Image
	unlockBox: Laya.Box
	unlockLab: Laya.HTMLDivElement
	goLab: Laya.Label
	_img_lv_bg: Laya.Image

	public GetComponents() {
		[
			this._Group1,
			this.bg,
			this._img_icon,
			this._img_kuang,
			this.EffectGp1,
			this.special_grid,
			this.special_effect,
			this._Image2,
			this.special_label,
			this.icon_wnd,
			this.EffectGp,
			this.gray_bg,
			this.selectBg,
			this.awakeImg,
			this._img_color,
			this.lv,
			this._lb_name,
			this.red_dot,
			this.unlockBox,
			this.unlockLab,
			this.goLab,
			this._img_iconbg,
			this._Image_add,
			this._img_lv_bg
		]
			= this.GetChildrenByNames([

				"_Group1",
				"bg",
				"_img_icon",
				"_img_kuang",
				"EffectGp1",
				"special_grid",
				"special_effect",
				"_Image2",
				"special_label",
				"icon_wnd",
				"EffectGp",
				"gray_bg",
				"selectBg",
				"awakeImg",
				"_img_color",
				"lv",
				"_lb_name",
				"red_dot",
				"unlockBox",
				"unlockLab",
				"goLab",
				"_img_iconbg",
				"_Image_add",
				"_img_lv_bg"
			])
	}
}
window["RuneIcon"] = RuneIcon