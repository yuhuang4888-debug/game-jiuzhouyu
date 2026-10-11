import { BaseView1 } from "../common/BaseView1";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { InstructionType } from "../common/InstructionType";
import { Enum_UILayer } from "../common/LayerManager";
import { RedDotManager } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { DemonEvent } from "../commonModel/DemonEvent";
import { DemonModel } from "../commonModel/DemonModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MarriageTagShowItem } from "../marriage/MarriageTagShowItem";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { Mathf } from "../util/Mathf";
import { Runner } from "../util/Runner";
import { Util, SetAnchoredPosition } from "../util/Util";
import { DemonRotaryItem } from "./DemonRotaryItem";

import "./DemonRotaryPreView"
import "./DemonRotaryUpView"

export class DemonRotaryView extends BaseView1 {
	add_goods
	add_rew_item
	cache_order
	custom_model
	degree
	demon_model: DemonModel
	fragment_list
	goods_model
	init_effect_order
	is_add
	last_bless
	one_btn_item
	pool_goods
	radius
	red_dot_mgr
	reward_list
	show_bless
	show_good
	show_num
	ten_btn_item
	type
	type_id_array
	update_id
	res_mgr: ResManager


	public constructor() {
		super()

		this.base_file = "demon"
		this.layout_file = "DemonRotaryView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true

		this.type = null
		this.demon_model = DemonModel.GetInstance()
		this.last_bless = 0
		this.pool_goods = []
		this.show_num = 10
		this.reward_list = []
		this.add_rew_item = null
		this.show_bless = true
		this.show_good = null
		this.is_add = false
		this.add_goods = null
		this.degree = 0
		this.radius = 200
		this.type_id_array = []
		this.one_btn_item = null
		this.ten_btn_item = null
		this.fragment_list = []
		this.update_id = null

		this.res_mgr = ResManager.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.custom_model = CustomActivityModel.GetInstance()
		this.red_dot_mgr = RedDotManager.GetInstance()

		this.preload_server_config = {
			"config_spirit_rotary_kv": false,
			"config_spirit_rotary": false
		}

		this.load_callback = () => {
			ResManager.GetInstance().LoadFont(this,"fighting_font",this.target_bless,undefined,false)
			this.LoadSuccess()
		}

		this.open_callback = () => {
			// if (!this.init_effect_order) {
			// 	this.init_effect_order = true
			// 	this.cache_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// 	this.AddCurrLayerSortingOrder(this.layer_value)
			// }
			this.RefType()
		}

		this.close_callback = () => {
			this.init_effect_order = false

		}

		this.destroy_callback = () => {
			this.DesCallback()
		}

	}

	public InitEvnet() {
		this.BindVar(this.demon_model, "bless_value", (value?) => {
			this.RefBlessValue(value)
		})

		this.BindEvent(GlobalEventSystem, EventName.MATERIAL_VIEW_CLOSE, () => {
			this.Close()
		})


		this.BindEvent(this.demon_model, DemonEvent.GETREWARD, (scmd?) => {
			this.demon_model.bless_value = scmd.bless_value
			this.RefBlessValue(scmd.bless_value)
			this.InitReward()
			Util.ShowCongratulationView(scmd.reward_list)
		})

		Util.AddClickEvent(this._proview, () => {
			if (this.show_bless) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DemonRotaryPreView", this.type)
			} else {
				let [cfg] = this.GetCfg(this.demon_model.bless_value)
				if (cfg) {
					let pool = this.type == 1 && cfg.reward_pool || cfg.high_reward_pool
					if (pool) {
						pool = JSON.parse(pool)
						let list = []
						for (let i in pool) {
							let v = pool[i]
							let [type, lock] = this.goods_model.GetMappingTypeId(v[0], v[1])
							let vo = [type, v[2], lock]
							list.push(vo)
						}
						if (list.length > 0) {
							this.custom_model.Fire(CustomActivityDefine.EVENT.OPEN_CUSTOM_VIEW, "CommonActRewardPreview", "customActivity", list, true)
						}
					}
				}
			}
		}, this, true)

		Util.AddClickEvent(this._close, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this._btn_tab1, () => {
			this.type = 1
			this._tab1.skin="resource/game/demon/texture/uijlzp_005.png"
			this._select1.visible=true
			this.labelDisplay.strokeColor="#cb292b"
			this._tab2.skin="resource/game/demon/texture/uijlzp_004.png"
			this._select2.visible=false
			this.labelDisplay1.strokeColor="#217dac"
			this.RefType()
		}, this, true)

		Util.AddClickEvent(this._btn_tab2, () => {
			this.type = 2
			this._tab2.skin="resource/game/demon/texture/uijlzp_005.png"
			this._select2.visible=true
			this.labelDisplay1.strokeColor="#cb292b"
			this._tab1.skin="resource/game/demon/texture/uijlzp_004.png"
			this._select1.visible=false
			this.labelDisplay.strokeColor="#217dac"
			this.RefType()
		}, this, true)

		Util.AddClickEvent(this._instruction, () => {
			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.SPRITE_ROTARY)
		}, this, true)

		Util.AddClickEvent(this._img_add, () => {
			let v = this.show_good
			if (v) {
				let [type, lock] = this.goods_model.GetMappingTypeId(v[0], v[1])
				UIToolTipMgr.GetInstance().DefaultAppendTips(type, 0)
			}
		}, this, true)
		this.BindEvent(GlobalEventSystem, EventName.CONGRATULATION_VIEW_CLOSE, () => {
			if (this.is_add && this.add_goods) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DemonRotaryUpView", this.add_goods)
				this.is_add = false
				this.add_goods = null
			}
		})

		this.BindEvent(this.demon_model, DemonEvent.REFRESH_RED_FLAG, (flag?, key?) => {
			if (flag == DemonModel.RedFlag.Rotary) {
				this.RefRed()
			}
		})

	}

	public LoadSuccess() {
		this.res_mgr.SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("demon", "uijlzp_002"))
		this.res_mgr.SetOutsideImageSprite(this, this._bg2, GameResPath.GetIconOtherPath("demon","uijlzp_014"))
		this.res_mgr.SetTexture(this,this._bg3,GameResPath.GetIcon("demon","uijlzp_006"))
		this.res_mgr.SetOutsideImageSprite(this,this.top_bg_3,GameResPath.GetIconOtherPath("demon","ui_gift_02"))
		Util.SetCircleMask(this._img_add, undefined, undefined, 45)
		this.RefRed()
		this.update_id = Runner.GetInstance().AddRunObj(this, 1)
		this.InitEvnet()
	}

	public RefRed() {
		this.red1.visible = this.demon_model.GetRedFlagState(DemonModel.RedFlag.Rotary, 0)
		this.red2.visible = this.demon_model.GetRedFlagState(DemonModel.RedFlag.Rotary, 1)
	}

	public RefType() {
		// this._select1.visible = this.type == 1
		// this._select2.visible = this.type == 2
		// this._tab1.skin = GameResPath.GetIcon("demon", `${this.type == 1 ? "uijlzp_005" : "uijlzp_004"}`) //`demon_json.${this.type == 1 ? "uijlzp_005" : "uijlzp_004"}_png`
		// this._tab2.skin = GameResPath.GetIcon("demon", `${this.type == 2 ? "uijlzp_005" : "uijlzp_004"}`) //`demon_json.${this.type == 2 ? "uijlzp_005" : "uijlzp_004"}_png`
		this.RefView()
	}

	public RefView() {
		this.last_bless = 0
		this.degree = 0
		this.SelectType()
		this.RefBlessValue(this.demon_model.bless_value)
		this.InitReward()
		this.InitBtn()
	}

	public SelectType() {
		this.CheckShowBless()
		let bool = this.show_bless
		this._gp_bless.visible = bool
		bool = this.type == 1
		this._desc.text = bool &&
			"每次转动转盘均可增加1点祝福值\n祝福值越高,产出高级妖灵碎片越大" ||
			"每次转动转盘均有机会获得珍稀大奖\n高级转盘消耗道具可通过初级转盘获得"

		let name = bool ? "ui_servant_13" : "ui_servant_19"
		this.res_mgr.SetTexture(this, this._bg1, "resource/game/demon/texture/" + name + ".png")	

		// name=bool ? "ui_servant_14":"uijlzp_002a1"
		// this.res_mgr.SetTexture(this,this._bg_5,"resource/game/demon/texture/" + name + ".png")

		name = bool ? "ui_servant_14" : "uijlzp_002a1"
		this.res_mgr.SetTexture(this, this._bg4, "resource/game/demon/texture/" + name + ".png")

		// name = bool ? "uijlzp_006a" : "uijlzp_006"
		// this.res_mgr.SetTexture(this, this._bg3, "resource/game/demon/texture/" + name + ".png")

		name= bool 	? "ui_servant_15" : "ui_servant_21"
		this.res_mgr.SetImageSprite(this,this.Image,"demon" , name)
	}

	public CheckShowBless() {
		let cfg = this.res_mgr.GetGameConfigFromCache(this, "config_spirit_rotary_kv", false)
		if (!cfg) {
			return
		}
		let key = this.type == 1 && 5 || 6
		let value = cfg[key] && cfg[key].value
		this.show_bless = Number(value) > 0
	}

	public InitBtn() {
		let cfg = this.res_mgr.GetGameConfigFromCache(this, "config_spirit_rotary_kv", false)
		// let cfg = Config.Spiritrotarykv
		if (cfg) {
			let bool = this.type == 1
			let one_cfg = bool && (cfg[1] && cfg[1].value) || (cfg[2] && cfg[2].value)
			let ten_cfg = bool && (cfg[3] && cfg[3].value) || (cfg[4] && cfg[4].value)
			if (one_cfg) {
				one_cfg = JSON.parse(one_cfg)[0]
			}
			if (ten_cfg) {
				ten_cfg = JSON.parse(ten_cfg)[0]
			}
			let data = { model_id: 509, type: this.type }
			let btn_dic = {}
			btn_dic["text"] = ""
			//btn_dic["t_size"] = 28
			//btn_dic["strokeColor"] = bool && "#617ab4" || "#9661b4"
			let source = GameResPath.GetIcon("demon","ui_servant_btn1")//bool && GameResPath.GetIcon("demon","uijlzp_009a") ||GameResPath.GetIcon("demon","uijlzp_009b") //"demon_json.uijlzp_009a_png" || "demon_json.uijlzp_009b_png"
			this.one_btn_item = this.custom_model.LoadActBtn(this._btn1, this.one_btn_item, data, one_cfg, btn_dic, 1, source, null, null, false)
			if (this.one_btn_item) {
				this.one_btn_item.SetRedPos(-80)
				this.one_btn_item.ExcuteCallback(()=>{
					this.one_btn_item._name_0.text="转动1次"
					this.one_btn_item._name_0.fontSize=24
					this.one_btn_item._name_0.stroke=2
					this.one_btn_item._name_0.strokeColor="#903ee2"
					this.one_btn_item._name_0.x=54
					this.one_btn_item._name_0.y=20
					this.one_btn_item._gp_cost_0.x=60
				})
			}
			btn_dic = {}
			btn_dic["text"] = ""
			//btn_dic["t_size"] = 28
			//btn_dic["strokeColor"] = "#be8931"
			source =GameResPath.GetIcon("demon","uijlzp_008") //"demon_json.uijlzp_008_png"
			this.ten_btn_item = this.custom_model.LoadActBtn(this._btn2, this.ten_btn_item, data, ten_cfg, btn_dic, 10, source, null, null, false)
			if (this.ten_btn_item) {
				this.ten_btn_item.SetRedPos(-80)
				this.ten_btn_item.ExcuteCallback(()=>{
					this.ten_btn_item._name_0.text="转动10次"
					this.ten_btn_item._name_0.fontSize=24
					this.ten_btn_item._name_0.stroke=2
					this.ten_btn_item._name_0.strokeColor="#c95b37"
					this.ten_btn_item._name_0.x=54
					this.ten_btn_item._name_0.y=20
					this.ten_btn_item._gp_cost_0.x=72
				})
			}
		}
	}

	public GetCfg(bless?) {
		let cfg = this.res_mgr.GetGameConfigFromCache(this, "config_spirit_rotary", false)
		if (cfg && bless != undefined) {
			for (let key in cfg) {
				let vo = cfg[key]
				let v_1 = vo.bless_value_1
				let v_2 = vo.bless_value_2
				if (v_1 <= bless && v_2 >= bless) {
					return [vo, v_1, v_2]
				}
			}
		}
		return [null, null, null]
	}

	public InitReward() {
		let bless = this.demon_model.bless_value
		let [_cfg, min, max] = this.GetCfg(bless)
		let [old_cfg] = this.GetCfg(this.last_bless)
		let last_bless = this.last_bless
		this.last_bless = bless
		if (_cfg == old_cfg) {
			return
		}
		let [last_cfg] = this.GetCfg(min - 1)
		let [next_cfg] = this.GetCfg(max + 1)
		this._gp_bless.visible = next_cfg != null
		if (this.type == 1) {
			let bool = next_cfg && this.show_bless
			if (bool) {
				this.target_bless.text = max + 1
			}
			this._add_desc.skin = GameResPath.GetIcon("demon",`${bool && "uijlzp_010a" || "uijlzp_010b"}`)  //`demon_json.${bool && "uijlzp_010a" || "uijlzp_010b"}_png`
			// this._add_desc.y = bool && 235 || 230
			this._bless_desc1.visible = bool
			this._bless_desc.visible = !this.show_bless
			this._bless_full.visible = !next_cfg && this.show_bless
		} else {
			this._add_desc.skin = GameResPath.GetIcon("demon", "uijlzp_010b") //`demon_json.uijlzp_010b_png`
			// this._add_desc.y = 230
			this._bless_desc1.visible = false
			this._bless_desc.visible = true
			this._bless_full.visible = false
		}
		if (_cfg) {
			let pool = this.type == 1 && _cfg.reward_pool || _cfg.high_reward_pool
			if (pool) {
				pool = JSON.parse(pool)
			}
			this.InitRewardItem(pool, _cfg.shows_2)
			let shows = _cfg.shows
			if (!next_cfg && last_cfg) {
				shows = last_cfg.shows
			}
			if (shows) {
				shows = JSON.parse(shows)
				shows = shows[this.type - 1]
				if (shows && shows[1]) {
					this.RefAddReward(shows[1])
					if (last_bless && last_bless > 0 && last_cfg) {
						this.is_add = true
						let _shows = last_cfg.shows
						if (_shows && _shows != []) {
							_shows = JSON.parse(_shows)
							_shows = _shows[this.type - 1]
							if (_shows && _shows[1]) {
								this.add_goods = _shows[1]
							}
						}
					}
				}
			}
		}
	}

	public RefAddReward(rew?) {
		if (!rew) {
			return
		}
		// Util.SetGoodsIcon(this._img_add, rew[0], rew[1], this)
		let [id, _] = GoodsModel.GetInstance().GetMappingTypeId(rew[0], rew[1])
		let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(id)
		if (goods_vo) {
			let icon_url = this.demon_model.GetCirItemIcon(goods_vo)
			ResManager.GetInstance().SetTexture(this, this._img_add, icon_url)
		}
		this.show_good = rew
	}

	public InitRewardItem(pool?, shows?) {
		this.pool_goods = []
		if (pool && pool.length > 0) {
			for (let _tmpi in pool) {
				let v = pool[_tmpi]
				let is_new = true
				let [type, lock] = this.goods_model.GetMappingTypeId(v[0], v[1])
				for (let i in this.pool_goods) {
					if (this.pool_goods[i] == type) {
						is_new = false
						break
					}
				}
				if (is_new) {
					this.pool_goods.push(type)
				}
			}
			let scale = [
				0.8, 0.7, 0.7, 0.7, 0.7, 0.8, 0.9, 1, 1, 0.9
			]
			this.show_num = this.pool_goods.length > 10 && 10 || this.pool_goods.length
			if (this.reward_list.length > 0) {
				for (let _tmpi in this.reward_list) {
					let item = this.reward_list[_tmpi]
					item.DeleteMe()
				}
				this.reward_list = []
			}

			let index = 0

			let load_call_back = () => {
				index = index + 1
				if (index >= this.show_num) {
					this.UpdateEffect()
				}
			}

			for (let i = 0; i < this.show_num; i++) {
				let item = this.reward_list[i]
				if (!item) {
					item = new DemonRotaryItem(this._reward)
					item.Load()
					// item.anchorOffsetX = item.width / 2
					// item.anchorOffsetY = item.height / 2

					this.reward_list.push(item)
					this.fragment_list[i] = i / this.show_num * 360
				}
				item.ExcuteCallback(() => {
					item.display_obj.visible = false
					item.display_obj.scaleX = item.display_obj.scaleY = scale[i]
					item.display_obj.anchorX=0.5
					item.display_obj.anchorY=0.5
					item.SetData(this.pool_goods[i], this.type, shows)
					load_call_back()
				})

			}

			this.type_id_array = []
			if (this.show_num < this.pool_goods.length) {
				for (let i = this.show_num; i < this.pool_goods.length; i++) {
					this.type_id_array.push(this.pool_goods[i])
				}
			}
		}
	}

	public UpdateEffect() {


	}

	public Update(now_time?, elapse_time?) {
		let pt ={x:null,y:null}
		if (this.reward_list.length > 0) {
			for (let i = 0; i < this.pool_goods.length; i++) {
				// pt = Laya.Point.polar(this.radius, (this.fragment_list[i] + this.degree) * Math.PI / 180);
				pt.x=this.radius*Mathf.Cos((this.fragment_list[i] + this.degree) * Math.PI / 180)
				pt.y=this.radius*Mathf.Sin((this.fragment_list[i] + this.degree) * Math.PI / 180)
				if(!this.reward_list[i] || !this.reward_list[i].display_obj)  break
				let item_obj = this.reward_list[i].display_obj
				let item=this.reward_list[i]
				if (item_obj) {
					if (!item_obj.visible)
						item_obj.visible = true
					item_obj.x = pt.x;
					item_obj.y = pt.y;
					if (item_obj.x > 80 && item_obj.y > -190 && item_obj.y < 200 && item_obj.scaleX > 0.7) {
						item_obj.scaleX = item_obj.scaleY -= 0.0008
					} else if (item_obj.x < -30 && item_obj.y > -200 && item_obj.y < 100 && item_obj.scaleX < 1) {
						item_obj.scaleX = item_obj.scaleY += 0.001
					}
					if (!item_obj.changed && item_obj.x <= 10 && item_obj.x >= -10 && item_obj.y > 100) {
						this.type_id_array.push(item_obj.type_id)
						item.SetData(this.type_id_array.shift(), this.type)
						item_obj.changed = true
					} else if (item_obj.changed && item_obj.x > this.radius - 10) {
						item_obj.changed = false
					}
				}
			}

			// let i = 0
			// let r
			// let scale
			// let cos_v, sin_v
			// do {
			// 	let item = this.reward_list[i]
			// 	if (item && item.is_loaded) {
			// 		r = (this.fragment_list[i] + this.degree) * Mathf.PI / 180

			// 		pt = [x = this.radius * Mathf.Cos(r), y = this.radius * Mathf.Sin(r)]

			// 		if (!item.visible) {
			// 			item.SetVisible(true)
			// 		}

			// 		//console.log("Update@pt",i+1,pt.x,pt.y)
			// 		item.SetAnchoredPosition(pt.x, -pt.y)

			// 		scale = item.transform.localScale.x
			// 		if (pt.x > 80 && pt.y > -190 && pt.y < 200 && scale > 0.8) {
			// 			item.SetScale(scale - 0.0008)
			// 		} else if (pt.x < -30 && pt.y > -200 && pt.y < 100 && scale < 1) {
			// 			item.SetScale(scale + 0.0008)
			// 		}

			// 		if (!item.changed && pt.x <= 10 && pt.x >= -10 && pt.y > 100) {
			// 			table.insert(this.type_id_array, item.type_id)
			// 			item.SetData(table.remove(this.type_id_array, 1), this.type)
			// 			//this:UpdateEffect()
			// 			item.changed = true
			// 		} else if (item.changed && pt.x > this.radius - 10) {
			// 			item.changed = false
			// 		}
			// 	}
			// 	i = i + 1
			// } while ((i < this.show_num))
		}
		this.degree = this.degree + 0.26
	}

	public RefBlessValue(value?) {
		if (this.show_bless) {
			this._bless_value.text = value
		}
	}

	public DesCallback() {
		Runner.GetInstance().RemoveRunObj(this.update_id)
		if (this.reward_list.length > 0) {
			for (let _tmpi in this.reward_list) {
				let item = this.reward_list[_tmpi]
				item.DeleteMe()
			}
			this.reward_list = []
		}
		if (this.one_btn_item) {
			this.one_btn_item.DeleteMe()
			this.one_btn_item = null
		}
		if (this.ten_btn_item) {
			this.ten_btn_item.DeleteMe()
			this.ten_btn_item = null
		}
		if (this.add_rew_item) {
			this.add_rew_item.DeleteMe()
		}
	}

	public Open(...parms) {
		this.type = parms[0] || 1
		if (this.HasOpen()) {
			this.RefType()
		} else {
			super.Open()
		}
	}


_bg:Laya.Image
_bg1:Laya.Image
_bg_5:Laya.Image
top_bg_3:Laya.Image
_bg2:Laya.Image
_close:Laya.Image
_instruction:Laya.Image
_gp_bless:Laya.Box
_img_bless:Laya.Image
_gp_bless1:Laya.HBox
_lb_value:Laya.Label
_bless_value:Laya.Label
_desc:Laya.Label
_reward:Laya.Box
_bg4:Laya.Image
con:Laya.Box
_bg3:Laya.Image
_eff_bigglow:Laya.Box
Image:Laya.Image
_add_reward:Laya.Box
_add_desc:Laya.Image
_bless_full:Laya.Image
_bless_desc:Laya.Image
_bless_desc1:Laya.Box
_Image7:Laya.Image
gp:Laya.HBox
_Image8:Laya.Image
target_bless:Laya.Label
_Image9:Laya.Image
_proview:Laya.Image
_img_add:Laya.Image
_btn1:Laya.Box
_btn2:Laya.Box
_btn_tab1:Laya.Box
_tab1:Laya.Image
labelDisplay:Laya.Label
_select1:Laya.Image
_btn_tab2:Laya.Box
_tab2:Laya.Image
labelDisplay1:Laya.Label
_select2:Laya.Image
red1:Laya.Image
red2:Laya.Image
public GetComponents() {
[
this._bg,
this._bg1,
this._bg_5,
this.top_bg_3,
this._bg2,
this._close,
this._instruction,
this._gp_bless,
this._img_bless,
this._gp_bless1,
this._lb_value,
this._bless_value,
this._desc,
this._reward,
this._bg4,
this.con,
this._bg3,
this._eff_bigglow,
this.Image,
this._add_reward,
this._add_desc,
this._bless_full,
this._bless_desc,
this._bless_desc1,
this._Image7,
this.gp,
this._Image8,
this.target_bless,
this._Image9,
this._proview,
this._img_add,
this._btn1,
this._btn2,
this._btn_tab1,
this._tab1,
this.labelDisplay,
this._select1,
this._btn_tab2,
this._tab2,
this.labelDisplay1,
this._select2,
this.red1,
this.red2,
]
 = this.GetChildrenByNames([

"_bg",
"_bg1",
"_bg_5",
"top_bg_3",
"_bg2",
"_close",
"_instruction",
"_gp_bless",
"_img_bless",
"_gp_bless1",
"_lb_value",
"_bless_value",
"_desc",
"_reward",
"_bg4",
"con",
"_bg3",
"_eff_bigglow",
"Image",
"_add_reward",
"_add_desc",
"_bless_full",
"_bless_desc",
"_bless_desc1",
"_Image7",
"gp",
"_Image8",
"target_bless",
"_Image9",
"_proview",
"_img_add",
"_btn1",
"_btn2",
"_btn_tab1",
"_tab1",
"labelDisplay",
"_select1",
"_btn_tab2",
"_tab2",
"labelDisplay1",
"_select2",
"red1",
"red2",
])
}
}
 window["DemonRotaryView"]= DemonRotaryView