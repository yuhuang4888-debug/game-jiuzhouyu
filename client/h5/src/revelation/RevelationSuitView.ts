import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { Vector2 } from "../util/Vector2"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { InstructionType } from "../common/InstructionType"
import { RoleManager } from "../commonModel/RoleManager"
import { RevelationModel, RevelationEvent } from "../commonModel/RevelationModel"
import { RevelationSuitNameItem } from "./RevelationSuitNameItem"
import { RevelationPropItem } from "./RevelationPropItem"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { GameResPath } from "../util/GameResPath"

export class RevelationSuitView extends BaseView1 {
	model
	res_mgr

	cur_data
	suit_cfg
	suit_items
	name_loop_mgr

	public constructor() {
		super()
		this.base_file = "revelation"
		this.layout_file = "RevelationSuitView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.destroy_imm = true
		this.show_open_movie = true
		this.preload_server_config = {
			"config_revelation_equip_figuire": false
		}

		this.res_mgr = ResManager.GetInstance()
		this.model = RevelationModel.GetInstance()

		this.cur_data = null
		this.suit_cfg = null
		this.suit_items = []
		this.name_loop_mgr = null

		this.load_callback = () => {
			this.LoadSucess()
		}

		this.open_callback = () => {
			this.InitView()
			/*
			if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				this.tipsLb.size = 18
				SetAnchoredPositionX(this._gp_up_cond, 0)
				this._Label1.size = 18
			}
			if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				this.tipsLb.size = 16
				this.tipsLb.color = ColorUtil.TryParseHtmlString("#000000")
			}
			*/
		}

		this.destroy_callback = () => {
			this.DesCallback()
		}
	}

	private LoadSucess() {
		this.gp_suit.hScrollBar.visible = false
		
		this.lb_tips.width = 552
		this.lb_tips.style.fontSize = 20
		this.lb_tips.style.color = "#ffffff"
		this.lb_tips.style.align = "center"
		this.lb_tips.style.valign = "middle"
		
		this.res_mgr.SetOutsideImageSprite(this, this.img_bg2, GameResPath.GetIcon("revelation", "ui_Apocalypse_02"))
		this.res_mgr.SetOutsideImageSprite(this, this.img_title3, GameResPath.GetIcon("equip", "xx_titleBg16"))

		this.InitEvent()
	}

	private DesCallback() {
		this.cur_data = null

		for (let _tmpi in this.suit_items) {
			var vo = this.suit_items[_tmpi]
			vo.DeleteMe()
		}
		this.suit_items = []

		if (this.name_loop_mgr) {
			this.name_loop_mgr.DeleteMe()
			this.name_loop_mgr = null
		}
	}

	private InitEvent() {
		Util.AddClickEvent(this.btn_close, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this.img_ins, () => {
			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.RevelationSuit)
		}, this, true)

		Util.AddClickEvent(this.gp_use, () => {
			if (this.cur_data && this.cur_data.figure != this.model.equipData.current_figure_id) {
				this.model.Fire(RevelationEvent.REQUEST_PROTO, 28607, "h", Number(this.cur_data.figure))
			} else {
				this.model.Fire(RevelationEvent.REQUEST_PROTO, 28607, "h", 0)
			}
		}, this, true)

		this.BindEvent(this.model, RevelationEvent.UPDATE_FIGURE_ID, (data?) => {
			if (data) {
				this.gp_use.visible = this.model.equipData.max_figure_id >= this.cur_data.figure
				this.img_use.visible = this.cur_data.figure == data.current_figure_id
			}
		})
		
		this.BindEvent(this.model, RevelationEvent.SELECT_SUIT_NAME, (item) => {
			this.SelectSuit(item)
		})
	}

	private InitView() {
		this.suit_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_revelation_equip_suit", false)
		let list = []
		if (this.suit_cfg) {
			for (let key in this.suit_cfg) {
				if (this.suit_cfg[key].num == 10) {
					table.insert(list, this.suit_cfg[key])
				}
			}
		}
		table.sort(list, (a?, b?) => {
			return a.star < b.star
		})
		if (!this.name_loop_mgr) {
			this.name_loop_mgr = new LoopScrowViewMgr()
			this.name_loop_mgr.SetData(this.gp_tabs, RevelationSuitNameItem, list, LoopScrCon.Horizontal, 1, () => {
			})
		}

		let showNameIndex = 0
		let showCountIndex = 1
		let suitData = this.model.equipData.suit
		if (suitData) {
			for (let _tmpi in suitData) {
				var vo = suitData[_tmpi]
				if (vo.star > showNameIndex) {
					showNameIndex = vo.star
					showCountIndex = vo.num
				} else if (vo.star == showNameIndex && vo.num > showCountIndex) {
					showCountIndex = vo.num
				}
			}
		}
		this.SelectSuit({ data: this.suit_cfg[showNameIndex + "@10"] })
		this.name_loop_mgr.SetSelectIndex(showNameIndex)
	}

	private SelectSuit(item?) {
		if (this.cur_data && this.cur_data == item.data) {
			return
		}
		this.cur_data = item.data
		if (!this.cur_data) {
			return
		}

		let list = [3, 5, 7, 10]
		let star = this.cur_data.star
		let suitData = this.model.equipData.suit
		let count = 0
		if (suitData) {
			for (let _tmpi in suitData) {
				let vo = suitData[_tmpi]
				if (vo.star >= star && vo.num > count) {
					count = vo.num
				}
			}
		}
		let ShowIndex = 0
		for (let i = 0; i < list.length; i++) {
			let item = this.suit_items[i]
			if (!item) {
				item = new RevelationPropItem(this.gp_suitCont)
				item.Load()
				this.suit_items[i] = item
			}
			if (count >= list[i]) {
				ShowIndex = ShowIndex + 1
			}
			item.SetData(this.suit_cfg[star + "@" + list[i]], count >= list[i])
		}

		if (ShowIndex > 3) {
			//this.suitScroller.viewport.scrollH = 166 * ShowIndex - this.suitScroller.width
		}

		let data = this.cur_data
		if (data) {
			this.lb_tips.innerHTML = Util.StrToHTML("穿戴整套<font color='#00fa64'>" + data.star + "星</font>天启套装可激活该形象")
			this.gp_use.visible = this.model.equipData.max_figure_id >= data.figure
			this.img_use.visible = this.model.equipData.current_figure_id == data.figure
			this.CreateModel(data.figure)
		}
	}

	private CreateModel(id?) {
		let role_vo = RoleManager.GetInstance().GetMainRoleVo()
		let weapon_model_id = role_vo.GetWeaponClotheId()
		let [role_res, texture_id] = Util.GetRevelationClothesRes(id, role_vo.sex)
		let [hairs, hairs_text_id] = Util.GetRevelationHairRes(id, role_vo.sex)
		let data = {
			clothe_res_id: role_res,
			texture_id: texture_id,
			type : UI_MODEL_TYPE.ROLE,
			can_rotate: true,
			layer_value: this.layer_value,
			weapon_res_id: weapon_model_id,
			//weapon_clothe_id: weapon_texture_id,
			head_wear_id: hairs,
			head_clothe_id: hairs_text_id,
			scale: 1.1,
			position: new Vector2(0, 0),
			fashion_model_id: role_res,
			sex: role_vo.sex,
			career: role_vo.career
		}
		ResManager.GetInstance().SetRoleModel(this, this.gp_model, data)
	}

	img_bg1: Laya.Image
	img_bg2: Laya.Image
	img_title: Laya.Image
	lb_title: Laya.Label
	btn_close: Laya.Image
	img_bg3: Laya.Image
	img_title2: Laya.Image
	img_title3: Laya.Image
	lb_tips: Laya.HTMLDivElement
	gp_use: Laya.Box
	lb_use: Laya.Label
	img_bg4: Laya.Image
	img_use: Laya.Image
	gp_tabs: Laya.List
	gp_suit: Laya.Panel
	gp_suitCont: Laya.HBox
	gp_model: Laya.Box
	img_ins: Laya.Image
	img_empty: Laya.Image
	public GetComponents() {
		[
			this.img_bg1,
			this.img_bg2,
			this.img_title,
			this.lb_title,
			this.btn_close,
			this.img_bg3,
			this.img_title2,
			this.img_title3,
			this.lb_tips,
			this.gp_use,
			this.lb_use,
			this.img_bg4,
			this.img_use,
			this.gp_tabs,
			this.gp_suit,
			this.gp_suitCont,
			this.gp_model,
			this.img_ins,
			this.img_empty,
		]
			= this.GetChildrenByNames([
				"img_bg1",
				"img_bg2",
				"img_title",
				"lb_title",
				"btn_close",
				"img_bg3",
				"img_title2",
				"img_title3",
				"lb_tips",
				"gp_use",
				"lb_use",
				"img_bg4",
				"img_use",
				"gp_tabs",
				"gp_suit",
				"gp_suitCont",
				"gp_model",
				"img_ins",
				"img_empty",
			])
	}
}
window["RevelationSuitView"] = RevelationSuitView