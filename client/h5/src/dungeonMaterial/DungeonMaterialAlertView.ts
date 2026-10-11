import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { NotEnougnDiamond, Util } from "../util/Util"
import { LuaSoundManager } from "../common/SoundManager"
import { Config } from "../common/Config"
import { ErlangParser } from "../util/ErlangParser"
import { ColorUtil } from "../util/ColorUtil"
import { ColorType } from "../util/ColorUtil"
import { BaseAwardItem } from "../common/BaseAwardItem"


export class DungeonMaterialAlertView extends BaseView1 {
	_Group4: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Group1: Laya.HBox
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Box
	image: Laya.Image
	_img_close: Laya.Image
	_btn_enter: Laya.Box
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	_btn_cancel: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_Group2: Laya.Box
	_gp_award: Laya.Box
	_Image7: Laya.Image
	_lb_num: Laya.HTMLDivElement
	_lb_name: Laya.HTMLDivElement
	_lb_tips: Laya.HTMLDivElement
	_Group3: Laya.Box
	_img_gx: Laya.Image
	_Label1: Laya.Label
	InitEvent
	InitView
	LoadSuccess
	Local_Open
	UpdateGxState
	_awarditem
	change_scene_close
	destroy_callback
	destroy_imm
	is_center
	preload_server_config
	show_open_movie
	use_background


	public constructor(goos_type?, num?, need_num?, hite?, dun_id?, tiket_name?, enter_type?, enter_callback?) {
		super()

		this.base_file = "dungeonMaterial"
		this.layout_file = "DungeonMaterialAlertView"
		this.use_background = true
		this.show_open_movie = true
		this.is_center = true
		this.change_scene_close = true
		this.destroy_imm = true
		this.layer_value = Enum_UILayer.Activity
		let model = BaseDungeonModel.GetInstance()
		let local_BaseDungeonModel = BaseDungeonModel
		let role_mgr = RoleManager.GetInstance()
		let local_Config = Config
		let goods_model = GoodsModel.GetInstance()
		let dun_id_ = null
		let dun_type_ = null
		let price_cfg_ = null
		let diamond_count_ = null
		let bind_diamond_count_ = null
		let gx_state_ = false
		let enter_callback_ = null
		let sweep_num
		this.preload_server_config = {
			"config_quick_buy_price": false,
			"config_dungeon": false
		}
		this.load_callback = () => {

			// 		if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 			this._lb_name.size  = 18
			// 			this._lb_tips.size  = 18
			// 			this._Label1.size  = 18
			// 			SetAnchoredPositionY(this._Group3,-220)

			// 			let csf = this.labelDisplay.GetComponent("ContentSizeFitter")
			// 			csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 			csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 			SetSizeDelta(this.labelDisplay,168,62)
			// 			SetAnchoredPosition(this.labelDisplay,3,1)
			// 			this.labelDisplay.lineSpacing = 0.8
			// 			this.labelDisplay.verticalAlign = "middle"
			// this.labelDisplay.textAlign = "center"
			// 		}
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			if (this._awarditem) {
				this._awarditem.DeleteMe()
				this._awarditem = null
			}
			model.material_auto_buy_state = gx_state_
			gx_state_ = false
		}

		// this.preload_server_config = [config_dungeon=false]
		this.Local_Open = (parm?) => {
			if (parm) {
				dun_type_ = parm[0]
				dun_id_ = parm[1]
				sweep_num = parm[2] ? parm[2] : 1
			}
			super.Open()
		}

		this.LoadSuccess = () => {
			price_cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_quick_buy_price", false)
			if (this.use_delete_method) {
				// ResManager.GetInstance().DestroyAllReferenceRes(this.hashCode)
				return
			}
			diamond_count_ = 0
			bind_diamond_count_ = diamond_count_
			this.BindEvent(model, local_BaseDungeonModel.UPDATE_DUNGEON_TYPE_VIEW, (type?) => {
				if (type == dun_type_) {
					let [left_times, total_times] = model.GetDunLeftTime(dun_type_, dun_id_)
					if (left_times == 0) {
						this.Close()
					}
				}
			}
			)
			this.InitView()
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_cancel, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this._btn_enter, () => {
				if (dun_id_) {
					let check_bind_diamond = () => {
						return bind_diamond_count_ <= role_mgr.GetMainRoleVo().jinLock
					}

					let check_diamond = () => {
						if (diamond_count_) {
							if (role_mgr.GetMainRoleVo().jin < diamond_count_) {
								NotEnougnDiamond()
								return false
							}
							return true
						}
					}

					if (check_bind_diamond() || check_diamond()) {
						if (enter_callback_) {
							enter_callback_()
						} else {
							model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61022, dun_id_, sweep_num)
						}
					}
					this.Close()
				}
			}
				, this, true)
			Util.AddClickEvent(this._img_gx, () => {
				gx_state_ = !gx_state_
				this.UpdateGxState()
			}
				, true)
		}

		this.InitView = () => {
			// let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon", false)
			let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon", false)
			let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_dungeon.name, dun_id_, false, cfgs)
			if (cfg) {
				let sweep_cost = ErlangParser.GetInstance().Parse(cfg.sweep_cost)
				sweep_cost = sweep_cost[0]
				let type_id = Number(sweep_cost[1])
				let need_count = Number(sweep_cost[2]) * sweep_num
				if (!this._awarditem) {
					this._awarditem = new BaseAwardItem(this._gp_award)
					this._awarditem.SetItemSize(100, 100)
					this._awarditem.Load()
				}
				this._awarditem.SetData(type_id, null, false)
				let my_count = goods_model.GetTypeGoodsNum(Number(sweep_cost[1]))
				let need_buy_count = need_count - my_count
				this._lb_num.style.fontSize = 24
				this._lb_num.style.valign = "center"
				this._lb_num.style.color = "#4a3a32"
				this._lb_num.width = 300
				this._lb_num.innerHTML = Util.StrToHTML(Util.HtmlColorTxt(my_count, ColorUtil.GetColorDark(ColorType.RED)) + "/" + need_count)
				// [ts2lua]price_cfg_下标访问可能不正确
				let quick_buy_cfg = price_cfg_[type_id]
				if (quick_buy_cfg) {
					let bind_diamond_count = quick_buy_cfg.bgold_price
					let diamond_count = quick_buy_cfg.gold_price
					diamond_count_ = diamond_count
					bind_diamond_count_ = bind_diamond_count
					let tips_desc = null
					if (bind_diamond_count == diamond_count) {
						tips_desc = "可消耗" + Util.HtmlColorTxt(bind_diamond_count * need_buy_count, "'#0a953e'") + "绑玉或者勾玉扫荡<font color='#0a953e'>(优先消耗绑玉)</font>"
					} else {
						tips_desc = "可消耗" + Util.HtmlColorTxt(bind_diamond_count * need_buy_count, "'#0a953e'") + "绑玉或者" + Util.HtmlColorTxt(diamond_count * need_buy_count, ColorUtil.GetColorDark(ColorType.GREEN)) + "勾玉进入<font color='#0a953e'>(优先消耗绑玉)</font>"
					}
					this._lb_tips.style.fontSize = 20
					this._lb_tips.style.valign = "center"
					this._lb_tips.style.color = "#663915"
					this._lb_tips.style.wordWrap = false
					this._lb_tips.width = 300
					this._lb_tips.innerHTML = Util.StrToHTML(tips_desc)
				}
				let good_basic = goods_model.GetGoodsBasicByTypeId(type_id)
				if (good_basic) {
					let name_desc = "还缺少:"
					name_desc = name_desc + Util.HtmlColorTxt(good_basic.goods_name, ColorUtil.GetColorDark(good_basic.color))
					name_desc = name_desc + "x" + need_buy_count
					this._lb_name.style.fontSize = 22
					this._lb_name.style.valign = "center"
					this._lb_name.style.color = "#663915"
					this._lb_name.width = 300
					this._lb_name.innerHTML = Util.StrToHTML(name_desc)
				}
			}
		}

		this.UpdateGxState = () => {
			// [ts2lua]lua中0和空字符串也是true，此处gx_state_需要确认
			let img = (gx_state_ ? ("com_ui_gx1") : ("com_ui_gx"))
			ResManager.GetInstance().SetImageSprite(this, this._img_gx, "common_asset", img)
		}


	}

	public Open(...new_args) {

		let parm = new_args
		this.Local_Open(parm)
	}



	public GetComponents() {
		[
			this._Group4,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Group1,
			this._Image4,
			this._Image5,
			this._Image6,
			this.image,
			this._img_close,
			this._btn_enter,
			this._Image111,
			this.labelDisplay1,
			this._btn_cancel,
			this._Image11,
			this.labelDisplay,
			this._Group2,
			this._gp_award,
			this._Image7,
			this._lb_num,
			this._lb_name,
			this._lb_tips,
			this._Group3,
			this._img_gx,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"_Group4",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Group1",
				"_Image4",
				"_Image5",
				"_Image6",
				"image",
				"_img_close",
				"_btn_enter",
				"_Image111",
				"labelDisplay1",
				"_btn_cancel",
				"_Image11",
				"labelDisplay",
				"_Group2",
				"_gp_award",
				"_Image7",
				"_lb_num",
				"_lb_name",
				"_lb_tips",
				"_Group3",
				"_img_gx",
				"_Label1",
			])
	}
}
window["DungeonMaterialAlertView"] = DungeonMaterialAlertView
