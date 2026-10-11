import { BaseView1 } from "../common/BaseView1"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DailyModel } from "../commonModel/DailyModel"
import { EffectResType } from "../scene/SceneConfig"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Status } from "../util/Status"
import { Util, SetAnchoredPosition } from "../util/Util"
import { DailyEvent } from "./DailyEvent"
import { DailyLivenessMsgProItem } from "./DailyLivenessMsgProItem"
import { RoleManager } from "../commonModel/RoleManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"

export class DailyLivenessMsgView extends BaseView1 {
	GetNextOrUpperCfg
	InitEvents
	LoadSuccess
	SetData
	SetHuanHuaState
	SetProgress
	SetPropertyView
	ShowModel
	CreateModel

	progress_bar
	fight_num
	progress_width
	last_click_time
	last_visible_cache
	mainVo
	public constructor() {
		super()

		this.base_file = "daily"
		this.layout_file = "DailyLivenessMsgView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		//this.use_local_view = true
		this.progress_bar = null
		let model = DailyModel.GetInstance()
		let local_DailyEvent = DailyEvent
		let local_Util = Util
		let local_Message = Message
		let local_Erlang = ErlangParser.GetInstance()
		let _data = null
		let _config_liveness_active = null
		let _config_liveness_lv = null
		let _now_show_cfg = null
		let _show_animation = false
		let _last_data_cache = null
		// let _state_x = null
		// let _state_y = null
		let pro_item_list = []
		this.preload_server_config = {
			"config_liveness_active": false,
			"config_liveness_lv": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
		}

		this.open_callback = () => {
			this.SetData()
		}

		this.destroy_callback = () => {
			_config_liveness_lv = null
			_config_liveness_active = _config_liveness_lv
			_now_show_cfg = null
			if (pro_item_list) {
				for (let i = 0; i < pro_item_list.length; i++) {
					var item = pro_item_list[i]
					item.DeleteMe()
				}
				pro_item_list = []
			}
			if (this.roleCon) {
				this.ClearUIEffect(this.roleCon)
			}
			if (this.progress_bar) {
				this.progress_bar.DeleteMe()
				this.progress_bar = null
			}
			if (this.fight_num) {
				this.fight_num.DeleteMe()
				this.fight_num = null
			}
			_last_data_cache = null
		}

		this.LoadSuccess = () => {

			this.left_arrow.visible = this.right_arrow.visible = false
			this.liveness_name.visible = this.title_bg.visible = false
			this.condition.visible = false

			
			this._Scroller1.vScrollBar.visible = false
			_config_liveness_active = ResManager.GetInstance().GetGameConfigFromCache(this, "config_liveness_active", false);
			_config_liveness_lv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_liveness_lv", false);

			// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("daily", "uimmr_001"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.circle_bg, GameResPath.GetIcon("daily","uimmr_001"))  

			model.Fire(local_DailyEvent.DAILY_REQUEST_PROTO, 15709)
			// _state_x = this.state.x
			// _state_y = this.state.y
			this.fight_num = new FightingShowSmallItem(this.fight_con)
			this.fight_num.Load()
			this.fight_num.ExcuteCallback(() => {
				// SetAnchoredPosition(this.fight_num.transform, 0.5, 0.5)
				// this.CoverMode(this.fight_num.transform)
			})

			this.progress_width = 340
			var expMask_: Laya.Sprite;
			expMask_ = new Laya.Sprite();
			expMask_.graphics.drawRect(0, 0, 0, 43, "#ffffff");
			expMask_.pos(0, 0);
			// this.progress_font.mask = expMask_


			this.CreateModel()
		}

		this.InitEvents = () => {
			let update_fun = () => {
				this.SetData()
			}
			this.BindEvent(model, local_DailyEvent.UPDATE_LIVENESS_IMAGE_DATA, update_fun)

			
			// Util.AddClickEvent(this.left_arrow, () => {
			// 	if (_now_show_cfg) {
			// 		let upper_cfg = this.GetNextOrUpperCfg(_now_show_cfg.id, false)
			// 		if (upper_cfg) {
			// 			_now_show_cfg = upper_cfg
			// 			this.ShowModel(_now_show_cfg)
			// 		} else {
			// 			local_Message.show("前面没有了")
			// 		}
			// 	}
			// }, this, true)

			// Util.AddClickEvent(this.right_arrow, () => {
			// 	if (_now_show_cfg) {
			// 		let next_cfg = this.GetNextOrUpperCfg(_now_show_cfg.id, true)
			// 		if (next_cfg) {
			// 			_now_show_cfg = next_cfg
			// 			this.ShowModel(_now_show_cfg)
			// 		} else {
			// 			local_Message.show("后面没有了")
			// 		}
			// 	}
			// }, this, true)
			// let use_fun = () => {
			// 	if (_data && _now_show_cfg) {
			// 		model.Fire(local_DailyEvent.DAILY_REQUEST_PROTO, 15711, "i", _now_show_cfg.id)
			// 	}
			// }
			// Util.AddClickEvent(this.huanhuaBtn, use_fun, this, true)
			//AddClickEvent(this.usedBtn, use_fun, this, true)
			Util.AddClickEvent(this.upgradeBtn, () => {
				if (!this.last_click_time || Status.NowTime - this.last_click_time >= 0.5) {
					this.last_click_time = Status.NowTime
					if (_data) {
						_show_animation = true
						model.Fire(local_DailyEvent.DAILY_REQUEST_PROTO, 15710)
					}
				}else{

				}
			}, this, true)
			this.BindEvent(model, local_DailyEvent.LIVENESS_UPGRDE_SUCCESS, () => {
				Message.show("升级成功")
				// this.AddUIEffect("UI_1102_shengjichenggong", this.effect_group, null, 1)
			})
			//AddClickEvent(this.checkBtn,() => {
			//if (_data && _now_show_cfg ) {
			//if (_data.id == _now_show_cfg.id ) {
			//local_Message:show("已幻化该形象")
			//}else{
			//model:Fire(local_DailyEvent.DAILY_REQUEST_PROTO, 15711, "i", _now_show_cfg.id)
			//}
			//}
			//}
			//, this)

			// Util.AddClickEvent(this.huanhuaBtn, () => {
			// 	if (_data && _now_show_cfg) {
			// 		if (_data.id == _now_show_cfg.id) {
			// 			local_Message.show("已幻化该形象")
			// 		} else {
			// 			model.Fire(local_DailyEvent.DAILY_REQUEST_PROTO, 15711, "i", _now_show_cfg.id)
			// 		}
			// 	}
			// }, this)
		}

		this.SetData = () => {
			_data = model.liveness_image_data
			if (!_data || !_config_liveness_active) {
				return
			}
			if (_data.id > 0 && (!_last_data_cache || _last_data_cache.id != _data.id)) {
				_now_show_cfg = _config_liveness_active[_data.id]
			}
			_last_data_cache = _data
			if (!_now_show_cfg) {
				_now_show_cfg = _config_liveness_active[1]
			}
			if (_now_show_cfg) {
				this.ShowModel(_now_show_cfg)
			}
			let lv_cfg = _config_liveness_lv[_data.lv]
			if (lv_cfg) {
				let attr = JSON.parse(lv_cfg.attr)
				if (attr) {
					//this.fight.text = "z" + String(CalAttrPower(attr))
					this.fight_num.Updatefighting(String(Util.CalAttrPower(attr, false)))
				}

				let next_lv_cfg = _config_liveness_lv[_data.lv + 1]
				this.SetPropertyView(lv_cfg, next_lv_cfg)
				//if (next_lv_cfg ) {
				//this.upgradeBtn.enabled = true
				//}else{
				//this.upgradeBtn.enabled = false
				//}
				if (next_lv_cfg) {
					Util.SetImageGray(this._Image1, false)
				} else {
					Util.SetImageGray(this._Image1, true)
				}
				this.SetProgress(_data.liveness, lv_cfg.liveness, next_lv_cfg)
			}
			this.upgrade_dot.visible = model.LivenessCanUpgrade()
		}

		this.ShowModel = (cfg?) => {
			if (cfg) {
				this.liveness_name.text = cfg.name
				// let res = "other_effect_guangqiu_" + cfg.figure_id
				// this.ClearUIEffect(this.roleCon)
				// this.AddUIEffect(res, this.roleCon, null, 1.5, true, null, null, null, null, null, null, null, true, EffectResType.Other)
				// this.CreateModel(cfg)

				// if (_data && _data.lv >= cfg.lv) {
				// 	this.condition.text = ""
				// } else {
				// 	this.condition.text = "Lv." + cfg.lv + "解锁"
				// }
				// this.SetHuanHuaState(cfg.id, cfg.lv)
				// let upper_cfg = this.GetNextOrUpperCfg(cfg.id, false)
				// let next_cfg = this.GetNextOrUpperCfg(cfg.id, true)
				// this.left_arrow.visible = upper_cfg && true || false
				// this.right_arrow.visible = next_cfg && true || false
			}
		}
		
		this.CreateModel = ()=> {
			this.mainVo = RoleManager.GetInstance().GetMainRoleVo()
			let [model_id, texture_id] = this.mainVo.GetRoleClotheTextureId()
			let [head_model_id, head_texture_id] = this.mainVo.GetRoleHeadId()

			let data = {
				career: this.mainVo.career,
				sex: this.mainVo.sex,
				clothe_res_id: this.mainVo.GetRoleClotheId(),
				type: UI_MODEL_TYPE.MAINROLE,
				scale: 1,
				position: { x: 0, y: -1 },
				fashion_model_id: model_id,
				texture_id: texture_id,
				wing_id: Util.GetWingClotheId(this.mainVo),
				head_wear_id: head_model_id,
				head_clothe_id: head_texture_id,
				hair_id: 0,
				// image_id: cfg.figure_id,
				action_name_list: ["meditation"],
				layout_file:"DailyLivenessMsgView",
				back_ornament_id: Util.GetBackOrnamentId(this.mainVo)
			}
			ResManager.GetInstance().SetRoleModel(this, this.roleCon, data)
		}

		this.SetPropertyView = (now_cfg?, next_cfg?) => {
			if (now_cfg) {
				let now = JSON.parse(now_cfg.attr)
				let next = []
				if (next_cfg) {
					next = JSON.parse(next_cfg.attr)
				}

				let pro_list = []
				let obj
				for (let i = 0; i < now.length; i++) {
					obj = []
					obj[0] = now[i]
					obj[1] = next[i]
					pro_list.push(obj)
				}
				let item
				for (let i = 0; i < pro_list.length; i++) {
					var v = pro_list[i]
					item = pro_item_list[i]
					if (!item) {
						item = new DailyLivenessMsgProItem(this.Content)
						item.Load()
						pro_item_list[i] = item
					}
					item.SetVisible(true)
					item.SetData(v)
				}
				if (pro_list.length < pro_item_list.length) {
					for (let i = pro_list.length + 1; i <= pro_item_list.length; i++) {
						pro_item_list[i].SetVisible(false)
					}
				}
			}
		}

		this.SetHuanHuaState = (id?, lv?) => {
			if (_data) {
				if (_data.lv >= lv) {
					//this.checkBtn.visible = true 
					// this.huanhuaBtn.visible = _data.id != id
					// this.state.visible = _data.id == id
					//if (_data.id == id ) {
					//lua_resM:SetImageSprite(this, this.check_img, "common_asset", "com_ui_gx1")
					//}else{
					//lua_resM:SetImageSprite(this, this.check_img, "common_asset", "com_ui_gx")
					//}
				} else {
					//this.checkBtn.visible = false 
					// this.state.visible = false
					// this.huanhuaBtn.visible = false
				}
				// if (this.last_visible_cache == undefined || this.last_visible_cache != this.huanhuaBtn.visible){
				// 	this.last_visible_cache = this.huanhuaBtn.visible
				// 	this.upgradeBtn.x = this.huanhuaBtn.visible == true ? 278 : 173
				// }
				
			}
		}

		this.SetProgress = (now_value?, max?, next_lv_cfg?) => {
			//if (! this.progress_bar ) { 
			//this.progress_bar = ProgressBarComponent.New(this.progressBar, 100, 0, this.progressBar.sizeDelta.x, this.progressBar.sizeDelta.y + 4,
			//null, "uirw_031", "uirw_030", {x = 0, y = 0.8}, null)			
			//}

			//this.progress_bar.SetValue(now_value, max)
			// this.progress_font.mask.graphics.clear()
			if (next_lv_cfg) {
				this.progress_text.text = now_value + "/" + max
				// this.progress_font.fillAmount = Number(now_value) / Number(max)
				let p = Math.min(1, Number(now_value) / Number(max))
				this.progress_font.width = p*this.progress_width
				// this.progress_font.mask.graphics.drawRect(0, 0, p * this.progress_width, 22, "#ffffff");
			} else {
				this.progress_text.text = "已满级"
				// this.progress_font.fillAmount = 1
				this.progress_font.width = this.progress_width
				// this.progress_font.mask.graphics.drawRect(0, 0, this.progress_width, 22, "#ffffff");
			}
			this.lv_label.text = "活跃度\nLv." + _data.lv

			//this.progressBar.minimum = 0
			//this.progressBar.maximum = max
			//this.progressBar.slideDuration = 0
			//if (_show_animation ) {
			//this.progressBar.value = 0
			//_show_animation = false
			//this.progressBar.slideDuration = 200
			//}
			//this.progressBar.value = now_value
			//this.progressBar.labelDisplay.size = 24
			//this.progressBar.labelDisplay.visible = false
			//this.progress_text.text = now_value + "/" + max
			//this.lv_label.text = "活跃度\nLv." + _data.lv
			//let _url = GameResPath.GetIcon("daily","uirw_031")
			//lua_resM:SetOutsideImageSprite(this, this.progressBar.getChildAt(0), _url)
			//_url = GameResPath.GetIcon("daily","uirw_030")
			//lua_resM:SetOutsideImageSprite(this, this.progressBar.getChildAt(1), _url)
		}

		this.GetNextOrUpperCfg = (id?, is_next?) => {
			let cfg = null
			if (is_next) {
				cfg = _config_liveness_active[id + 1]
			} else {
				cfg = _config_liveness_active[id - 1]
			}
			return cfg
		}
	}

	bg: Laya.Image
	circle_bg: Laya.Image
	roleCon: Laya.Box
	title_bg: Laya.Image
	liveness_name: Laya.Label
	condition: Laya.Label
	left_arrow: Laya.Box
	img1: Laya.Image
	right_arrow: Laya.Image
	_Image2: Laya.Image
	fight_con: Laya.Box
	fight: Laya.Label
	huanhuaBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay11: Laya.Label
	upgradeBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	upgrade_dot: Laya.Image
	usedBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.VBox
	progress_conta: Laya.Box
	lv_label: Laya.Label
	image: Laya.Image
	progress_font: Laya.Image
	progress_text: Laya.Label
	effect_group: Laya.Box
	state: Laya.Image
	checkBtn: Laya.Box
	check_img: Laya.Image
	check_label: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this.circle_bg,
			this.roleCon,
			this.title_bg,
			this.liveness_name,
			this.condition,
			this.left_arrow,
			this.img1,
			this.right_arrow,
			this._Image2,
			this.fight_con,
			this.fight,
			this.huanhuaBtn,
			this._Image11,
			this.labelDisplay11,
			this.upgradeBtn,
			this._Image1,
			this.labelDisplay1,
			this.upgrade_dot,
			this.usedBtn,
			this._Image111,
			this.labelDisplay,
			this._Scroller1,
			this.Content,
			this.progress_conta,
			this.lv_label,
			this.image,
			this.progress_font,
			this.progress_text,
			this.effect_group,
			this.state,
			this.checkBtn,
			this.check_img,
			this.check_label,
		]
			= this.GetChildrenByNames([

				"bg",
				"circle_bg",
				"roleCon",
				"title_bg",
				"liveness_name",
				"condition",
				"left_arrow",
				"img1",
				"right_arrow",
				"_Image2",
				"fight_con",
				"fight",
				"huanhuaBtn",
				"_Image11",
				"labelDisplay11",
				"upgradeBtn",
				"_Image1",
				"labelDisplay1",
				"upgrade_dot",
				"usedBtn",
				"_Image111",
				"labelDisplay",
				"_Scroller1",
				"Content",
				"progress_conta",
				"lv_label",
				"image",
				"progress_font",
				"progress_text",
				"effect_group",
				"state",
				"checkBtn",
				"check_img",
				"check_label",
			])
	}
}
window["DailyLivenessMsgView"] = DailyLivenessMsgView