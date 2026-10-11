import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { StoryModel } from "../commonModel/StoryModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { SetAnchoredPosition, Util } from "../util/Util"
import { DungeonExpFightSceneItem } from "./DungeonExpFightSceneItem"
import { DungeonExpUseExpView } from "./DungeonExpUseExpView"

export class DungeonExpInspriteView extends BaseView1 {

	model: BaseDungeonModel
	story_model: StoryModel
	scene_mgr: SceneManager
	role_mgr: RoleManager
	res_mgr: ResManager

	now_index = null
	info = null
	cost_cfg = null
	guide_state = null
	com = null
	gold_count = null
	coin_count = null
	price_coin = null
	price_diamond = null
	curr_dun_id = 0
	request = false
	diamond_select = false
	coin_select = false

	public constructor() {
		super()
		this.base_file = "dungeonExp"
		this.layout_file = "DungeonExpInspriteView"
		this.layer_value = Enum_UILayer.UI

		this.use_background = true
		this.click_bg_toClose = true
		this.background_alpha = 0.0
		this.is_center = true
		this.change_scene_close = true
		this.not_show_main_msg = true
		this.destroy_imm = true
		this.show_open_movie = true
		// this.back_login_close = true

		this.model = BaseDungeonModel.GetInstance()
		this.story_model = StoryModel.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.preload_server_config = {
			"config_dungeon_special_cfg": false
		}

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.SelectInspriteType(1, true)
			this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61026)
		}

		this.close_callback = () => {
			//this:ClearCheckBoxEvent()
			this.ReDisplayExpFinger()
			this.Remove()
		}
	}
	private ReDisplayExpFinger(){
		let info = this.model.GetInspireInfo()
		if (info) {
			let now_count = info.gold_count + info.coin_count
			if(now_count<=0&&this.guide_state ==DungeonExpFightSceneItem.GUIDE_STATE.INSPRITE){
				this.model.Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, DungeonExpFightSceneItem.GUIDE_STATE.INSPRITE)
			}
		}
	}

	Remove() {
		this.request = false
		GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_ok)
		if (this.guide_state == DungeonExpFightSceneItem.GUIDE_STATE.INSPRITE_DONE) {
			this.guide_state = false
			let bool = true
			let goods_buff_list = GoodsModel.GetInstance().goods_buff_list
			for (let _tmpi in goods_buff_list) {
				var vo = goods_buff_list[_tmpi]
				for (let _tmpi in DungeonExpUseExpView.goods_list) {
					var goods_id = DungeonExpUseExpView.goods_list[_tmpi]
					if (vo.goods_id == goods_id) {
						bool = false
						break
					}
				}
			}
			if (bool) {
				this.model.Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, DungeonExpFightSceneItem.GUIDE_STATE.USE_EXP)
			} else {
				this.model.Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, DungeonExpFightSceneItem.GUIDE_STATE.DONE)
			}
		}
	}

	LoadSuccess() {

		let str = ''
		this.curr_dun_id = this.scene_mgr.GetCurrDunId()
		str = this.curr_dun_id + "@encourage_data"
		this._lb_desc.text = "每次鼓舞可增加人物10%伤害（上限100%）"
		if (this.curr_dun_id == BaseDungeonModel.GUILD_EXP_ID) {

			this._lb_desc.text = "每次鼓舞可增加人物5%伤害（上限50%）"
		}
		let special_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_dungeon_special_cfg", false)
		let cfg_spe = special_cfg && special_cfg[str]
		if (cfg_spe) {
			this.cost_cfg = JSON.parse(cfg_spe.value)
		}

		if (this.cost_cfg) {
			this.gold_count = this.cost_cfg[1]
			this.coin_count = this.cost_cfg[2]
			this.price_coin = this.cost_cfg[4][2]
			this.price_diamond = this.cost_cfg[3][2]
		}
		if (this.guide_state == DungeonExpFightSceneItem.GUIDE_STATE.INSPRITE) {
			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_ok, this.layer_value, false, false, false, true, { text: "点击鼓舞吧!", direction: 8, "effect_scaleX": 0.65, "effect_scaleY": 0.9 }, true)
		}


		this._img_select.x = 22
		// this._img_select.x = 290

		this.InitEvent()
	}

	InitEvent() {
		this.BindEvent(this.model, BaseDungeonModel.UPDATE_INSPRITE_INFO, (show_effect?) => {
			if (show_effect) {
				this.ShowEffect();
			}
			this.UpdateInsprite()
			if (!this.request) {
				this.request = true
				this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61062, this.curr_dun_id)
			}
		}, true)

		Util.AddClickEvent(this._box_coin, () => {
			this.SelectInspriteType(1)
		}, this)

		Util.AddClickEvent(this._box_diamond, () => {
			this.SelectInspriteType(2)
		}, this)

		Util.AddClickEvent(this._box_ok, () => {
			if (this.guide_state == DungeonExpFightSceneItem.GUIDE_STATE.INSPRITE) {
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_ok)
				this.guide_state = DungeonExpFightSceneItem.GUIDE_STATE.INSPRITE_DONE
				this.model.Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, this.guide_state)
			}
			if (!this.info) {
				return
			}
			if (this.info.coin_count == this.cost_cfg[2] && this.now_index == 1) {
				Message.show("铜币鼓舞次数已达上限")
				return
			} else if (this.info.gold_count == this.cost_cfg[1] && this.now_index == 2) {
				Message.show("勾玉鼓舞次数已达上限")
				return
			}
			this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61025, this.now_index)
		}, this, true)

		Util.AddClickEvent(this._box_cancel, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

		Util.AddClickEvent(this._box_coin_check, () => {
			this.SelectInspriteType(1)
			if (!this.coin_select) {
				let str = "勾选后,本次副本或后续进入将自动鼓舞至上限.\n是否确认勾选?"
				let content = Util.StrToHTML(str)
				Alert.Show(content, Alert_Type.Two, () => {
					GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_ok)
					this.guide_state = DungeonExpFightSceneItem.GUIDE_STATE.INSPRITE_DONE
					this.model.Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, this.guide_state)
					this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61063, this.curr_dun_id, 4, 0, 1, 0)
				}
				)
			} else {
				this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61063, this.curr_dun_id, 4, 0, 0, 0)
				this.res_mgr.SetImageSprite(this, this._img_bg3, "common", "com_ui_gx")
			}
		}, this)

		Util.AddClickEvent(this._box_diamond_check, () => {
			this.SelectInspriteType(2)
			if (!this.diamond_select) {
				let str = "勾选后,本次副本或后续进入将自动鼓舞至上限.\n是否确认勾选?"
				let content = Util.StrToHTML(str)
				Alert.Show(content, Alert_Type.Two, () => {
					GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_ok)
					this.guide_state = DungeonExpFightSceneItem.GUIDE_STATE.INSPRITE_DONE
					this.model.Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, this.guide_state)
					this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61063, this.curr_dun_id, 2, 0, 1, 0)
				}
				)
			} else {
				this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61063, this.curr_dun_id, 2, 0, 0, 0)
				this.res_mgr.SetImageSprite(this, this._img_bg4, "common_asset", "com_ui_gx")
			}
		}, this)

		this.BindEvent(this.model, BaseDungeonModel.UPDATE_COIN_INSPRITE_STAGE, (bool?, dun_id?) => {
			if (dun_id != this.curr_dun_id) {
				return
			}
			let info = this.model.GetInspireInfo()
			if (!this.coin_select && bool && info.coin_count < Number(this.coin_count)) {
				let max = this.coin_count - info.coin_count
				let coin_insprite_count = null
				this.coin_select = bool
				this.res_mgr.SetImageSprite(this, this._img_bg3, "common", "com_ui_gx1")
				let have_coin = this.role_mgr.mainRoleInfo.tong
				coin_insprite_count = ((Math.floor(have_coin / this.price_coin)) >= max) && max || Math.floor(have_coin / this.price_coin)
				if (coin_insprite_count > 0) {
					let i = 0
					do {
						let time = 200 * i
						setTimeout(() => {
							this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61025, 1)
						}
							, time)
						i = i + 1
					} while ((i < coin_insprite_count))
				}
				if (coin_insprite_count < 5) {
					Message.show("铜币不足")
				}
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_ok)
			} else {
				this.coin_select = bool
				let res = bool && "com_ui_gx1" || "com_ui_gx"
				this.res_mgr.SetImageSprite(this, this._img_bg3, "common", res)
			}
		}
		)

		this.BindEvent(this.model, BaseDungeonModel.UPDATE_DIAMOND_INSPRITE_STAGE, (bool?, dun_id?) => {
			if (dun_id != this.curr_dun_id) {
				return
			}
			let info = this.model.GetInspireInfo()
			if (!this.diamond_select && bool && info.gold_count < Number(this.gold_count)) {
				let max = this.gold_count - info.gold_count
				let diamond_inspritre_count = null
				this.diamond_select = bool
				this.res_mgr.SetImageSprite(this, this._img_bg4, "common", "com_ui_gx1")
				let have_diamond = this.role_mgr.mainRoleInfo.jin
				have_diamond = have_diamond + this.role_mgr.mainRoleInfo.jinLock
				diamond_inspritre_count = (Math.floor(have_diamond / this.price_diamond) >= max) && max || (Math.floor(have_diamond / this.price_diamond))
				if (diamond_inspritre_count > 0) {
					let i = 0
					do {
						let time = 200 * i
						setTimeout(() => {
							this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61025, 2)
						}
							, time)
						i = i + 1
					} while ((i < diamond_inspritre_count))
				}
				if (diamond_inspritre_count < 5) {
					Message.show("铜币不足")
				}
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_ok)
			} else {
				this.diamond_select = bool
				let res = bool && "com_ui_gx1" || "com_ui_gx"
				this.res_mgr.SetImageSprite(this, this._img_bg4, "common", res)
			}
		}
		)
	}

	UpdateInsprite() {
		let info = this.model.GetInspireInfo()
		if (info && this.cost_cfg) {
			this.info = info
			let now_count = info.gold_count + info.coin_count
			this._lb_diamond_left_count.text = "（" + info.gold_count + "/" + this.gold_count + "）"
			this._lb_coin_left_count.text = "（" + info.coin_count + "/" + this.coin_count + "）"
			Util.SetImageGray(this._img_diamond_icon, info.gold_count == Number(this.gold_count))
			Util.SetImageGray(this._img_coin_icon, info.coin_count == Number(this.coin_count))
			this._lb_now_insprite.text = "已鼓舞次数：" + now_count + "/" + (this.gold_count + this.coin_count)
			this._lb_coin_count.text = this.price_coin * this.com + "/次"
			this._lb_diamond_count.text = this.price_diamond * this.com + "/次"
			this.UpdateInsptireType()
		}
	}

	SelectInspriteType(index?, bool?) {
		if (this.now_index == index) {
			return
		}
		this.now_index = index
		if (!this._img_select.visible) {
			this._img_select.visible = true
		}

		let x = index == 1 && 22 || 290
		this._img_select.x = x
	}

	UpdateInsptireType() {
		if (this.info.coin_count == Number(this.cost_cfg[2]) && this.now_index == 1) {
			if (this.info.gold_count != Number(this.cost_cfg[1])) {
				this.SelectInspriteType(2)
			}
		} else if (this.info.gold_count == Number(this.cost_cfg[1]) && this.now_index == 2) {
			if (this.info.coin_count != Number(this.cost_cfg[2])) {
				this.SelectInspriteType(1)
			}
			return
		}
	}

	ShowEffect() {
		if (this.now_index == 1) {
			this.ClearUIEffect(this._box_coin_effect);
			this.AddUIEffect("ui_dungeon_inspire", this._box_coin_effect, { x: 0, y: 0 }, 5, false, 0.5, null, null, null, null, null, null, false)
		} else {
			this.ClearUIEffect(this._box_diamond_effect);
			this.AddUIEffect("ui_dungeon_inspire", this._box_diamond_effect, { x: 0, y: 0 }, 5, false, 0.5, null, null, null, null, null, null, false)
		}
	}

	public Open(...new_args) {
		let parms = new_args
		this.guide_state = parms[0]
		this.com = parms[1] ? parms[1] : 1
		super.Open()
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_lb_title: Laya.Label
	_lb_desc: Laya.Label
	_lb_now_insprite: Laya.Label
	_img_bg6: Laya.Image
	_box_coin: Laya.Box
	_img_bg7: Laya.Image
	_img_bg5: Laya.Image
	_img_coin_icon: Laya.Image
	_box_gold_cost: Laya.HBox
	_img_coin_icon2: Laya.Image
	_lb_coin_count: Laya.Label
	_lb_coin_left_count: Laya.Label
	_lb_desc5: Laya.Label
	_box_diamond: Laya.Box
	_img_bg8: Laya.Image
	_img_bg9: Laya.Image
	_lb_desc4: Laya.Label
	_img_diamond_icon: Laya.Image
	_box_diamond_cost: Laya.HBox
	_img_diamond_icon2: Laya.Image
	_lb_diamond_count: Laya.Label
	_lb_diamond_left_count: Laya.Label
	_lb_desc6: Laya.Label
	_img_select: Laya.Image
	_box_cancel: Laya.Box
	_img_cancel: Laya.Image
	_lb_cancel: Laya.Label
	_box_ok: Laya.Box
	_img_ok: Laya.Image
	_lb_ok: Laya.Label
	_img_close: Laya.Image
	_box_coin_effect: Laya.Box
	_box_diamond_effect: Laya.Box
	_box_coin_check: Laya.Box
	_img_bg3: Laya.Image
	_lb_desc2: Laya.Label
	_box_diamond_check: Laya.Box
	_img_bg4: Laya.Image
	_lb_desc3: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._lb_title,
			this._lb_desc,
			this._lb_now_insprite,
			this._img_bg6,
			this._box_coin,
			this._img_bg7,
			this._img_bg5,
			this._img_coin_icon,
			this._box_gold_cost,
			this._img_coin_icon2,
			this._lb_coin_count,
			this._lb_coin_left_count,
			this._lb_desc5,
			this._box_diamond,
			this._img_bg8,
			this._img_bg9,
			this._lb_desc4,
			this._img_diamond_icon,
			this._box_diamond_cost,
			this._img_diamond_icon2,
			this._lb_diamond_count,
			this._lb_diamond_left_count,
			this._lb_desc6,
			this._img_select,
			this._box_cancel,
			this._img_cancel,
			this._lb_cancel,
			this._box_ok,
			this._img_ok,
			this._lb_ok,
			this._img_close,
			this._box_coin_effect,
			this._box_diamond_effect,
			this._box_coin_check,
			this._img_bg3,
			this._lb_desc2,
			this._box_diamond_check,
			this._img_bg4,
			this._lb_desc3,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_lb_title",
				"_lb_desc",
				"_lb_now_insprite",
				"_img_bg6",
				"_box_coin",
				"_img_bg7",
				"_img_bg5",
				"_img_coin_icon",
				"_box_gold_cost",
				"_img_coin_icon2",
				"_lb_coin_count",
				"_lb_coin_left_count",
				"_lb_desc5",
				"_box_diamond",
				"_img_bg8",
				"_img_bg9",
				"_lb_desc4",
				"_img_diamond_icon",
				"_box_diamond_cost",
				"_img_diamond_icon2",
				"_lb_diamond_count",
				"_lb_diamond_left_count",
				"_lb_desc6",
				"_img_select",
				"_box_cancel",
				"_img_cancel",
				"_lb_cancel",
				"_box_ok",
				"_img_ok",
				"_lb_ok",
				"_img_close",
				"_box_coin_effect",
				"_box_diamond_effect",
				"_box_coin_check",
				"_img_bg3",
				"_lb_desc2",
				"_box_diamond_check",
				"_img_bg4",
				"_lb_desc3",
			])
	}
}
window["DungeonExpInspriteView"] = DungeonExpInspriteView
