import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { UI_MODEL_TYPE } from "../common/UIModelClass3D";
import { WordManager } from "../common/WordManager";
import { DemonDefine } from "../commonModel/DemonDefine";
import { DemonEvent } from "../commonModel/DemonEvent";
import { DemonModel } from "../commonModel/DemonModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { SkillVo } from "../skill/SkillVo";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil, ColorType } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util, HtmlColorTxt, PlayBigEffect, SetHtmlStyle, SetHtmlCenter, RefBoxChildsLayout } from "../util/Util";
import { DemonMaterialItem } from "./DemonMaterialItem";
import { DemonSecondView } from "./DemonSecondView";
import { DemonSkillItem } from "./DemonSkillItem";
import { DemonTabItem } from "./DemonTabItem";
import { DemonTalentItem2 } from "./DemonTalentItem2";

import "./DemonSkillTipsView"
import "./DemonTalentSelectView"
import "./DemonFettersView"
import "./DemonRotaryView"
import { Vector2 } from "../util/Vector2";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { Vector3 } from "../util/Vector3";
import { PlatformManager } from "../PlatformManager";
import { SoundManager } from "../common/SoundManager";
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";

export class DemonMainView extends BaseItem1 {

	_list_tab_con
	can_up
	default_index
	demon_model: DemonModel
	is_preview
	material_item_list:Array<DemonMaterialItem>
	now_demon_id
	now_index
	now_live_skill_cfg
	progress_width
	role_mgr
	select_state
	show_model
	skill_item
	tab_list
	tab_loop_mgr
	talent_item_list
	res_mgr: ResManager
	array_tab
	voice
	channel
	fight_item
	public static SelectState = {
		LevelUp: 0,
		StarUp: 1
	}

	public constructor(parent?) {
		super(parent)

		this.base_file = "demon"
		this.layout_file = "DemonMainView"
		this.demon_model = DemonModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.progress_width = 182
		this.can_up = false
		this.material_item_list = null
		this.show_model = null
		this.select_state = null
		this.now_demon_id = null
		this.now_index = null
		this.default_index = 0
		this.channel=null
		this.preload_server_config = {
			"config_demons": false,
			"config_demons_level": false,
			"config_demons_star": false,
			"config_demons_skill": false,
			"config_demons_skill_map": false,
			"config_demons_value": false,
			"config_demons_skill_add": false
		}

		this.voice=["NPC_Voice25a","NPC_Voice33a","NPC_Voice23a","NPC_Voice26a","NPC_Voice15a","NPC_Voice06a","NPC_Voice20b","NPC_Voice06b","NPC_Voice02a","NPC_Voice26b","Pet_Voice15b","Pet_Voice13b","NPC_Voice09a","Pet_Voice11a","Pet_Voice18b"]
		this.load_callback = () => {
			
			
			this._Scroller2.scrollBar.visible=false
			this._pre_attr_scr.vScrollBar.visible=false
			this._Scroller1.vScrollBar.visible=false
			SetHtmlStyle(this._lb_name,{f:24,c:"#fffb98",ww:false,w:720})
			SetHtmlStyle(this._skill_desc,{f:20,c:"#663915",ww:false,w:250})
			SetHtmlStyle(this._skill_desc,{f:22,c:"#663915",ww:false,w:200})
			SetHtmlStyle(this._pre_attr1,{f:22,c:"#663915",li:5,ww:false,w:200})
			SetHtmlStyle(this._pre_attr2,{f:22,c:"#663915",li:5,ww:false,w:200})
			SetHtmlStyle(this._lb_attr0,{f:22,c:"#663915",li:5,ww:false,w:200})
			SetHtmlStyle(this._lb_attr1,{f:22,c:"#663915",li:5,ww:false,w:200})
			this.fight_item = new FightingShowSmallItem(this._gp_fight)
			this.fight_item.Load()
			this.fight_item.IsCenter(true, false)

			this.LoadSuccess()
			this.InitEvent()
		}

		// this.ReOpen_callback = () => {
		// 	let data = this.tab_list && this.tab_list[this.now_index]
		// 	if (data) {
		// 		this.ShowModel(this.demon_model.GetResource(this.now_demon_id), data.scale)
		// 	}
		// }
	}
	public LoadSuccess() {
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("demon", "uism_027"))
		ResManager.GetInstance().SetImageSpriteTrans(this, this._bg, GameResPath.GetIcon("demon", "uism_027b"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg3, GameResPath.GetIcon("demon", "uism_004"))
		ResManager.GetInstance().SetTexture(this,this._bg,GameResPath.GetIcon("demon","ui_servant_08"))
		// this.array_tab = new Laya.ArrayCollection()
		// this._list_tab_con.dataProvider = this.array_tab
		// this._list_tab_con.itemRenderer = DemonTabItem

		this.UpdateTab()
		// this._list_tab_con.selectedIndex = this.default_index
		this.SwitchTab(this.default_index)

		this.UpdateRotaryRedState()
		this.UpdatePaintingRedState()
		this.UpdateShopRedState()
	}



	public InitEvent() {
		Util.AddClickEvent(this._img_group, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DemonFettersView", this.now_demon_id)
		}, this, true)

		Util.AddClickEvent(this._img_gx, () => {
			if (this.now_demon_id != this.role_mgr.GetMainRoleVo().demon_id) {
				this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18306, this.now_demon_id)
			} else {
				Message.show("当前妖灵已出战")
			}
		}, this, true)

		Util.AddClickEvent(this._img_picture, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DemonSecondView", DemonSecondView.Index.Picture)
		}, this, true)

		Util.AddClickEvent(this._img_shop, () => {
			if(PlatformManager.GetInstance().is_alpha) return
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DemonSecondView", DemonSecondView.Index.Shop)
		}, this, true)

		Util.AddClickEvent(this._img_rotary, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DemonRotaryView")
		}, this, true)

		Util.AddClickEvent(this._gp_up, () => {
			if (this.is_preview) {
				this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18304, this.now_demon_id)
			} else {
				if (!this.can_up) {
					if (this.select_state == DemonMainView.SelectState.LevelUp) {
						Message.show("当前妖灵已满级")
					} else {
						Message.show("当前妖灵已满星")
					}
					return
				}
				if (this.select_state == DemonMainView.SelectState.LevelUp) {
					this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18305, this.now_demon_id)
				} else {
					this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18304, this.now_demon_id)
				}
			}
		}, this, true)

		Util.AddClickEvent(this._img_level_up, () => {
			this.SelectLevelUp()
		}, this, false)

		Util.AddClickEvent(this._img_star_up, () => {
			this.SelectStarUp()
		}, this, false)

		Util.AddClickEvent(this._live_skill_icon, () => {
			if (this.now_live_skill_cfg) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DemonSkillTipsView", this.now_demon_id, this.now_live_skill_cfg.skill_id)
			}
		}, this, true)

		// this._list_tab_con.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.SwitchTab, this)

		this.BindEvent(this.demon_model, DemonEvent.UPDATE_DEMONS_LIST, () => {
			this.UpdateTab()
		})

		this.BindEvent(this.demon_model, DemonEvent.UPDATE_DEMON_DATA, (demons_id?) => {
			if (this.now_demon_id == demons_id) {
				this.UpdateView()
				this.UpdateTalent()
			}
		})

		this.BindEvent(this.demon_model, DemonEvent.ACTIVE_DEMON, (demons_id?) => {
			if (this.now_demon_id == demons_id) {
				//PlayBigEffect("ui_ZiTi_Jihuo")
				//this.AddUIEffect("ui_ZiTi_Jihuo", this._gp_effect,{x:0,y:0},2,false)//激活成功
			}
		})

		this.BindEvent(this.demon_model, DemonEvent.UPDATE_DEMONS_POWER, (demon_id?) => {
			if (this.now_demon_id == demon_id) {
				this.UpdatePower()
			}
		})

		this.BindVar(this.role_mgr.GetMainRoleVo(), "demon_id", () => {
			this.UpdateFollowState()
		})

		this.BindEvent(this.demon_model, DemonEvent.LEVEL_UP_SUCCESS, () => {
			PlayBigEffect("ui_shengjitexiao")
			// this.AddUIEffect("ui_shengjichenggong_glow", this._gp_effect,{x:0,y:0},2,false)
		})

		this.BindEvent(this.demon_model, DemonEvent.REFRESH_RED_FLAG, (flag?, key?) => {
			if ((flag == DemonModel.RedFlag.Level || flag == DemonModel.RedFlag.Star) && key == this.now_demon_id) {
				let level_red_state = this.demon_model.GetRedFlagState(DemonModel.RedFlag.Level, this.now_demon_id)
				this._img_level_up_red.visible = level_red_state
				let star_red_state = this.demon_model.GetRedFlagState(DemonModel.RedFlag.Star, this.now_demon_id)
				this._img_star_up_red.visible = star_red_state

				if (this.select_state == DemonMainView.SelectState.LevelUp) {
					this._img_up_red.visible = level_red_state
				} else {
					this._img_up_red.visible = star_red_state
				}
			} else if (flag == DemonModel.RedFlag.Rotary) {
				this.UpdateRotaryRedState()
			} else if (flag == DemonModel.RedFlag.Painting) {
				this.UpdatePaintingRedState()
			} else if (flag == DemonModel.RedFlag.Shop) {
				this.UpdateShopRedState()
			}
		})

		this.BindEvent(this.demon_model, DemonEvent.TALENT_UP_RETURN, (demons_id?, slot?) => {
			if (this.now_demon_id == demons_id) {
				this.UpdateTalent()
			}
		})

		this.BindEvent(GoodsModel.GetInstance(),GoodsModel.CHANGE_BAG_LIST,()=>{
			this.UpdateView()
		})
	}
	public UpdateView() {
		
		let cfgs_demons = this.res_mgr.GetGameConfigFromCache(this, "config_demons", false)
		let demon_cfg = cfgs_demons[this.now_demon_id]
		if (demon_cfg) {
			let name_str = demon_cfg.demons_name
			name_str = name_str + "[" + HtmlColorTxt(DemonDefine.Realm2Name[demon_cfg.realm], ColorUtil.GetColorDark(demon_cfg.color)) + "]"
			this._lb_name.innerHTML = name_str
			SetHtmlCenter(this._lb_name,{x:0,w:720})
		}

		if (this.demon_model.IsActive(this.now_demon_id)) {
			this.is_preview = false
			this._activation.visible = true
			this._inactivated.visible = false
			this._gp_stars.visible = true
			let domon_data = this.demon_model.GetDemonData(this.now_demon_id)
			if (domon_data) {
				DemonModel.SetStars(this._gp_stars, domon_data.star, 26, 6)
			}
			this.UpdateFollowState()
			this.UpdateSelectState()
			this.UpdateActivation()
			
		} else {
			this.is_preview = true
			this._gp_stars.visible = false
			this._activation.visible = false
			this._inactivated.visible = true
			this.UpdateInactivated()
		}
		let power = this.demon_model.GetDemonPower(this.now_demon_id)
		if (!power) {
			this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18302, this.now_demon_id)
		} else {
			this.UpdatePower()
		}
	}

	public UpdatePower() {
		let power = this.demon_model.GetDemonPower(this.now_demon_id)
		if (power) {
			this.fight_item.Updatefighting(power)
		}
	}

	public ShowModel(mon_res?, scale?) {
		let data = {
			clothe_res_id: mon_res,
			type: UI_MODEL_TYPE.DEMON,
			layer_value: this.layer_value,
			action_name_list: ["idle"],
			position: new Vector3(0, 0,0),
			scale: 1.2,
			can_rotate: true,
		}
		ResManager.GetInstance().SetRoleModel(this, this._gp_model, data)
	}

	/**
	 * 
	 * @param is_switch 是否是切页操作
	 * @returns 
	 */
	public UpdateActivation(is_switch?) {
		let demon_data = this.demon_model.GetDemonData(this.now_demon_id)
		let exp_desc
		let progress_width = this.progress_width
		let list = []
		let btn_state
		if (!demon_data) {
			return
		}
		this._img_star_up_red.visible = this.demon_model.GetRedFlagState(DemonModel.RedFlag.Star, this.now_demon_id)
		this._img_level_up_red.visible = this.demon_model.GetRedFlagState(DemonModel.RedFlag.Level, this.now_demon_id)

		if (this.select_state == DemonMainView.SelectState.LevelUp) {
			exp_desc = demon_data.exp
			let material_list = this.demon_model.GetLevelUpMaterial(demon_data.realm)
			for (let _tmpi in material_list) {
				let vo = material_list[_tmpi]
				list.push({
					"0": 0,
					"1": vo[0],
					"2": 1,
				})
			}
			let level_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_level", false)

			if (level_cfgs) {
				let now_cfg = level_cfgs[demon_data.realm + "@" + demon_data.level]
				this._lb_level0.text = "Lv." + demon_data.level
				if (now_cfg) {
					this.SetProValue(this._lb_attr0, now_cfg.attr, "'#d15e00'")
				}
				let next_cfg = level_cfgs[demon_data.realm + "@" + (demon_data.level + 1)]
				if (next_cfg) {
					this.can_up = true
					this._lb_level1.visible = true
					this._img_bg2.visible = true
					this._img_full.visible = false
					this._gp_up.visible=true
					this._lb_level1.text = "Lv." + (demon_data.level + 1)
					exp_desc = exp_desc + "/" + next_cfg.exp
					progress_width = Math.floor(demon_data.exp / next_cfg.exp * this.progress_width)
					this.SetProValue(this._lb_attr1, next_cfg.attr, "'#0a953e'")
					btn_state = true
				} else {
					this.can_up = false
					this._lb_level1.visible = false
					this._img_bg2.visible = false
					this._img_full.skin =GameResPath.GetIcon("demon","uiwg_042") //"demon_json.uiwg_042_png"
					this._img_full.visible = true
					exp_desc = "已满级"
					this._gp_up.visible=false
					this._lb_attr1.innerHTML = ""
					btn_state = false
				}
			}
			this._img_up_red.visible = this._img_level_up_red.visible
		} else {
			let stars_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_star", false)
			if (stars_cfgs) {
				let now_cfg = stars_cfgs[this.now_demon_id + "@" + demon_data.star]
				if (now_cfg) {
					DemonModel.SetStars(this._gp_stars0, demon_data.star, 26)
					this.SetProValue(this._lb_attr0, now_cfg.attr, "'#d15e00'")
				}
				let next_cfg = stars_cfgs[this.now_demon_id + "@" + (demon_data.star + 1)]
				if (next_cfg) {
					this.can_up = true
					this._gp_stars1.visible = true
					this._img_full.visible = false
					this._gp_up.visible=true
					list = JSON.parse(next_cfg.cost)
					let cost = list[0]
					if (cost) {
						let goods_count = GoodsModel.GetInstance().GetTypeGoodsNum(cost[1])
						exp_desc = goods_count + "/" + cost[2]
						progress_width = Math.min(this.progress_width, goods_count / cost[2] * this.progress_width)
					}
					DemonModel.SetStars(this._gp_stars1, demon_data.star + 1, 26)
					this._lb_attr1.width=200
					this.SetProValue(this._lb_attr1, next_cfg.attr, "'#0a953e'")
					btn_state = true
				} else {
					this.can_up = false
					let need_show_cfg = stars_cfgs[this.now_demon_id + "@" + demon_data.star]
					list = JSON.parse(need_show_cfg.cost)
					this._img_full.skin =GameResPath.GetIcon("demon","uism_067") //"demon_json.uism_067_png"
					exp_desc = "已满星"
					this._lb_attr1.innerHTML = ""
					this._gp_stars1.visible = false
					this._img_full.visible = true
					this._gp_up.visible=false
					btn_state = false
				}
			}
			this._img_up_red.visible = this._img_star_up_red.visible
		}

		// Util.SetImageGray(this._gp_up, ! btn_state)
		if(exp_desc!=undefined){
			this._lb_material_value.text = exp_desc
		}else{
			this._lb_material_value.text =""
		}
		this._img_progress.width = progress_width

		if (!this.material_item_list) {
			this.material_item_list = []
		}
		for (let i = list.length; i < this.material_item_list.length; i++) {
			this.material_item_list[i].SetVisible(false)
		}
		let item: DemonMaterialItem
		for (let key in list) {
			item = this.material_item_list[key]
			if (!item) {
				item = new DemonMaterialItem(this._gp_material)
				item.Load()
				this.material_item_list[key] = item
			}
			item.SetData(list[key][1])
			item.SetVisible(true)

			item.ExcuteCallback(()=>{
				RefBoxChildsLayout(this._gp_material,6,61,true,"center")
			})
		}
		RefBoxChildsLayout(this._gp_material,6,61,true,"center")

		if(is_switch&&this._Scroller1&&this._Scroller1.vScrollBar){
			this._gp_attrs.height = Math.max(this._lb_attr0.contextHeight,this._lb_attr1.contextHeight)
			this._Scroller1.vScrollBar.stopScroll()
			this._Scroller1.vScrollBar.value = 0
		}
	}
	public SetProValue(attr_con, list, value_color, has_parse = false) {
		let attrs
		let attr_desc = ""
		if (has_parse) {
			attrs = list
		} else {
			attrs = JSON.parse(list)
		}
		attrs.sort((a, b) => {
			if (DemonDefine.BestAttr.indexOf(Number(a[0])) != -1 && DemonDefine.BestAttr.indexOf(Number(b[0])) != -1) {
				return a[0] - b[0]
			} else if (DemonDefine.BestAttr.indexOf(Number(a[0])) != -1) {
				return -1
			} else if (DemonDefine.BestAttr.indexOf(Number(b[0])) != -1) {
				return 1
			}
		})
		let len = Util.TableSize(attrs)
		let index = 1
		for (let _tmpi in attrs) {
			let vo = attrs[_tmpi]
			let name = WordManager.GetProperties(vo[0]) + ":"
			let value = WordManager.ConvertToPercentValue(vo[0], vo[1])
			if (len != index) {
				value = value 
			}

			if (DemonDefine.BestAttr.indexOf(Number(vo[0])) != -1) {
				name = HtmlColorTxt(name, ColorUtil.GetColorDark(ColorType.RED))
				value = HtmlColorTxt(value, ColorUtil.GetColorDark(ColorType.RED))
			} else {
				value = HtmlColorTxt(value, value_color)
			}
			attr_desc = attr_desc + name
			attr_desc = attr_desc + value
			attr_desc=attr_desc+"<br/>"
			index = index + 1
		}
		attr_con.innerHTML = Util.StrToHTML(attr_desc)

	}
	public UpdateSkill() {
		let skill_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_skill", false)
		let skills_list = []
		if (skill_cfgs) {
			let cfg
			let item
			for (let key in skill_cfgs) {
				let value = skill_cfgs[key]
				if (value && value.demons_id == this.now_demon_id && value.sk_type == 1) {
					cfg = value
					break
				}
			}

			if (cfg) {
				this.now_live_skill_cfg = cfg
				if (!this.skill_item) {
					this.skill_item = new DemonSkillItem(this._gp_skills)
					this.skill_item.Load()
					// this.skill_item.x = 49

					this.skill_item.y = 37
				}
				this.skill_item.SetData(cfg)
			}
		}
	}
	public UpdateTab() {
		let demons_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons", false)
		let list = []
		let demons_data = this.demon_model.GetDemonsList()
		let data
		let cfg
		for (let key in demons_cfgs) {
			cfg = demons_cfgs[key]
			data = this.demon_model.GetDemonData(cfg.demons_id) || cfg
			data.demon_id = cfg.demons_id
			list.push(data)
		}

		list.sort((a, b) => {
			if (a.color == b.color) {
				return a.demon_id - b.demon_id
			} else {
				return a.color - b.color
			}
		})
		this.tab_list = list

		// this.array_tab.source = list
		// this.array_tab.refresh()
		if (!this._list_tab_con) {
			this._list_tab_con = new LoopScrowViewMgr()
			this._list_tab_con.SetData(this._Scroller2,DemonTabItem,list,LoopScrCon.Horizontal,null,(index?)=>{
				if(this.channel){
					SoundManager.GetInstance().StopSoundEffect(this.channel)
				}
				this.channel=SoundManager.GetInstance().PlaySoundEffect(this.voice[index],true,null,"npc")
				this.SwitchTab(index)
			})
		}else{
			this._list_tab_con.replaceAll(list)
		}

		// if (this.tab_loop_mgr) {
		// 	this.tab_loop_mgr.replaceAll(list)
		// } else {
		// 	this.tab_loop_mgr = new LoopScrowViewMgr()
		// 	this.tab_loop_mgr.SetData(this.Content11, DemonTabItem, list, this._Scroller2, 1, (item?) => {
		// 		this.SwitchTab(item.real_index)
		// 	})
		// 	this.tab_loop_mgr.SetSelectIndex(1)
		// }
	}
	public SwitchTab(e?) {
		let index = e
		if (this.now_index == index) {
			return
		}
		let data = this.tab_list && this.tab_list[index]
		if (data) {
			this.now_demon_id = data.demon_id
			this.ShowModel(this.demon_model.GetResource(this.now_demon_id), data.scale)
			this.select_state = DemonMainView.SelectState.StarUp
			this.UpdateView()
			this.UpdateTalent()
			this.UpdateSkill()
			this.now_index = index
		}
	}
	public SelectLevelUp() {
		if (this.select_state == DemonMainView.SelectState.LevelUp) {
			return
		}
		this.select_state = DemonMainView.SelectState.LevelUp
		this.UpdateSelectState()
		this.UpdateActivation(true)
	}
	public SelectStarUp() {
		if (this.select_state == DemonMainView.SelectState.StarUp) {
			return
		}
		this.select_state = DemonMainView.SelectState.StarUp
		this.UpdateSelectState()
		this.UpdateActivation(true)
	}
	public UpdateSelectState() {
		this._pre_attr_scr.vScrollBar.value = 0

		let bool = this.select_state == DemonMainView.SelectState.LevelUp
		this._lb_level1.visible = bool
		this._lb_level0.visible = bool
		this._img_bg2.visible = bool
		this._img_bg1.visible = bool
		this._lb_up_desc.text = bool ? "升级" : "升星"
		this._lb_material_tips.text = bool ? "经验:" : "碎片:"

		bool = this.select_state == DemonMainView.SelectState.StarUp
		this._gp_stars1.visible = bool
		this._gp_stars0.visible = bool


		//btn样式
		this.SwitchBtnStyle(this.select_state)

	}


	public SwitchBtnStyle(index){

		let tab_1_skin = index==0?"uism_005a":"uism_005b"
		ResManager.GetInstance().SetImageSprite(this,this._img_level_up,"demon",tab_1_skin)
		this._lb_level_up.color = index==0? "#9b572f" : "#ffffff"
		this._lb_level_up.stroke=index==0? 2: 0


		let tab_2_skin = index==1?"uism_005a":"uism_005b"
		ResManager.GetInstance().SetImageSprite(this,this._img_star_up,"demon",tab_2_skin)
		this._lb_star_up.color = index==1? "#9b572f" : "#ffffff"
		this._lb_star_up.stroke=index==1? 2: 0
	}


	public UpdateFollowState() {
		if (this.demon_model.IsActive(this.now_demon_id)) {
			this._img_gx1.visible = this.role_mgr.GetMainRoleVo().demon_id == this.now_demon_id
			this._img_gx.visible = true
		} else {
			this._img_gx.visible = false
		}
	}

	public UpdateRotaryRedState() {
		this._img_rotary_red.visible = this.demon_model.HasRedFlag(DemonModel.RedFlag.Rotary)
	}

	public UpdateInactivated() {
		let demon_star_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_demons_star", false)
		let pre_demons_star_cfg = demon_star_cfg[this.now_demon_id + "@0"]
		let exp_desc = ""
		let progress_width = 0
		let red_state = false
		if (pre_demons_star_cfg) {
			let material_list = JSON.parse(pre_demons_star_cfg.cost)
			let cost = material_list[0]
			if (cost) {
				let goods_count = GoodsModel.GetInstance().GetTypeGoodsNum(cost[1])
				exp_desc = goods_count + "/" + cost[2]
				progress_width = Math.min(this.progress_width, goods_count / cost[2] * this.progress_width)
				red_state = goods_count >= Number(cost[2])
			}

			if (!this.material_item_list) {
				this.material_item_list = []
			}

			for (let i = material_list.length; i < this.material_item_list.length; i++) {
				this.material_item_list[i].SetVisible(false)
			}

			let item
			for (let index in material_list) {
				let vo = material_list[index]
				item = this.material_item_list[index]
				if (!item) {
					item = new DemonMaterialItem(this._gp_material)
					item.Load()
					this.material_item_list[index] = item
				}

				item.ExcuteCallback(()=>{
					RefBoxChildsLayout(this._gp_material,6,61,true,"center")
				})
				item.SetData(vo[1])
				item.SetVisible(true)
			}
			RefBoxChildsLayout(this._gp_material,6,61,true,"center")
			let now_attr_list = JSON.parse(pre_demons_star_cfg.attr)
			let attr1_list = []
			let attr2_list = []
			for (let index in now_attr_list) {
				let vo = now_attr_list[index]
				if (Number(index) % 2 == 0) {
					attr1_list.push(vo)
				} else {
					attr2_list.push(vo)
				}
			}
			this._pre_attr1.width=200
			this._pre_attr2.width=200
			this.SetProValue(this._pre_attr1, attr1_list, "'#d15e00'", true)
			this.SetProValue(this._pre_attr2, attr2_list, "'#0a953e'", true)


			// setTimeout(() => {
			// 	if (this.use_delete_method) { return }
			// 	LayoutRebuilder(this.Content)
			// 	let height = this._pre_attr1.sizeDelta.y
			// 	SetSizeDeltaY(this.Content, height)
			// }, 0.2)
		}
		if(exp_desc!=undefined){
			this._lb_material_value.text = exp_desc
			this._gp_up.visible=true
		}else{
			this._lb_material_value.text=""
			this._gp_up.visible=false
		}

		this._img_progress.width = progress_width
		this._img_up_red.visible = red_state

		let demons_skill_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_skill", false)
		let cfg
		for (let key in demons_skill_cfgs) {
			let value = demons_skill_cfgs[key]
			if (value && value.demons_id == this.now_demon_id && value.sk_type == 1) {
				cfg = value
				break
			}
		}

		if (cfg) {
			let demons_skill_map_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_skill_map", false)
			let real_skill_cfg = demons_skill_map_cfgs[cfg.skill_id]
			let real_skill_id = real_skill_cfg && real_skill_cfg.skill_unfollow
			if (real_skill_id) {
				this._skill_desc.width=250
				let skill_vo = new SkillVo(real_skill_id)

				ResManager.GetInstance().SetTexture(this, this._live_skill_icon, GameResPath.GetSkillIconPath(skill_vo.GetIcon()))

				this._skill_name.text = skill_vo.getName()
				let skill_d: string = skill_vo.getDesc()
				skill_d = skill_d.replace("@", "<br/>")
				this._skill_desc.innerHTML = Util.StrToHTML(skill_d)
			} else {

			}
		}

		this._lb_up_desc.text = "激活"
		this._lb_material_tips.text = "碎片:"
		this._img_material_tips.skin =GameResPath.GetIcon("demon","uism_00911")// "demon_json.uism_00911_png"
	}

	public UpdatePaintingRedState() {
		this._img_painting_red.visible = this.demon_model.HasRedFlag(DemonModel.RedFlag.Painting)
	}

	public UpdateShopRedState() {
		this._img_shop_red.visible = this.demon_model.HasRedFlag(DemonModel.RedFlag.Shop)
	}

	/**技能书 学习得来的天赋 */
	public UpdateTalent() {
		let demons_value_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_value", false)
		let demon_data = this.demon_model.GetDemonData(this.now_demon_id)
		let slot_count = demons_value_cfgs[11].value
		if (!this.talent_item_list) {
			this.talent_item_list = []
		}
		for (let i = 0; i < slot_count; i++) {
			let item = this.talent_item_list[i]
			if (!item) {
				item = new DemonTalentItem2(this._gp_talent)
				item.Load()
				// item.x = 49
				item.ExcuteCallback(()=>{
					item.display_obj.y = 113 + 106 * i
				})
				this.talent_item_list.push(item)
			}
			item.SetData(i, this.now_demon_id)
		}
	}
	public DeleteMe() {
		// this._list_tab_con.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.SwitchTab, this)

		if(this.fight_item){
			this.fight_item.DeleteMe()
			this.fight_item = null
		}
		//技能
		if (this.skill_item) {
			this.skill_item.DeleteMe()
			this.skill_item = null
		}

		//进阶材料
		if (this.material_item_list) {
			for (let _tmpi in this.material_item_list) {
				let obj = this.material_item_list[_tmpi]
				if (obj) {
					obj.DeleteMe()
				}
			}
			this.material_item_list = null
		}

		//天赋技能
		if (this.talent_item_list) {
			for (let _ in this.talent_item_list) {
				let item = this.talent_item_list[_]
				item.DeleteMe()
			}
			this.talent_item_list = false
		}

		if(this.channel){
			SoundManager.GetInstance().StopSoundEffect(this.channel)
			this.channel=null
		}

		this.now_index = null
		this.ClearUIEffect( this._gp_effect)
		super.DeleteMe()
	}


_gp_fight:Laya.Box
_img_bg:Laya.Image
_img_group:Laya.Image
_img_picture:Laya.Image
_img_shop:Laya.Image
_img_rotary:Laya.Image
_img_painting_red:Laya.Image
_img_shop_red:Laya.Image
_img_rotary_red:Laya.Image
_img_name_bg:Laya.Image
_lb_name:Laya.HTMLDivElement
_scroll_bg:Laya.Image
_gp_stars:Laya.HBox
_gp_talent:Laya.Box
_gp_skills:Laya.VBox
_gp_model:Laya.Box
_gp_effect0:Laya.Box
_gp_effect:Laya.Box
_inactivated:Laya.Box
_bg:Laya.Image
Image:Laya.Image
_live_skill_icon:Laya.Image
_skill_name:Laya.Label
_skill_desc:Laya.HTMLDivElement
_pre_attr_scr:Laya.Panel
_pre_attr:Laya.Box
_pre_attr1:Laya.HTMLDivElement
_pre_attr2:Laya.HTMLDivElement
_activation:Laya.Box
_img_bg1:Laya.Image
_lb_level0:Laya.Label
_img_bg2:Laya.Image
_lb_level1:Laya.Label
_img_level_up:Laya.Image
_img_star_up:Laya.Image
_lb_level_up:Laya.Label
_lb_star_up:Laya.Label
_img_level_up_red:Laya.Image
_img_star_up_red:Laya.Image
_Image2:Laya.Image
_gp_stars0:Laya.HBox
_gp_stars1:Laya.HBox
_Scroller1:Laya.Panel
_gp_attrs:Laya.Box
_lb_attr0:Laya.HTMLDivElement
_lb_attr1:Laya.HTMLDivElement
_img_full:Laya.Image
gp_img_gx:Laya.Box
_img_gx:Laya.Image
_img_gx1:Laya.Image
_Label1:Laya.Label
_Scroller2:Laya.List
_img_material_tips:Laya.Image
_Image3:Laya.Image
_Image4:Laya.Image
_gp_material:Laya.Box
_Image5:Laya.Image
_img_progress:Laya.Image
_lb_material_title:Laya.Label
_lb_material_tips:Laya.Label
_lb_material_value:Laya.Label
_gp_up:Laya.Box
_Image6:Laya.Image
_lb_up_desc:Laya.Label
_img_up_red:Laya.Image
public GetComponents() {
[
this._gp_fight,
this._img_bg,
this._img_group,
this._img_picture,
this._img_shop,
this._img_rotary,
this._img_painting_red,
this._img_shop_red,
this._img_rotary_red,
this._img_name_bg,
this._lb_name,
this._scroll_bg,
this._gp_stars,
this._gp_talent,
this._gp_skills,
this._gp_model,
this._gp_effect0,
this._gp_effect,
this._inactivated,
this._bg,
this.Image,
this._live_skill_icon,
this._skill_name,
this._skill_desc,
this._pre_attr_scr,
this._pre_attr,
this._pre_attr1,
this._pre_attr2,
this._activation,
this._img_bg1,
this._lb_level0,
this._img_bg2,
this._lb_level1,
this._img_level_up,
this._img_star_up,
this._lb_level_up,
this._lb_star_up,
this._img_level_up_red,
this._img_star_up_red,
this._Image2,
this._gp_stars0,
this._gp_stars1,
this._Scroller1,
this._gp_attrs,
this._lb_attr0,
this._lb_attr1,
this._img_full,
this.gp_img_gx,
this._img_gx,
this._img_gx1,
this._Label1,
this._Scroller2,
this._img_material_tips,
this._Image3,
this._Image4,
this._gp_material,
this._Image5,
this._img_progress,
this._lb_material_title,
this._lb_material_tips,
this._lb_material_value,
this._gp_up,
this._Image6,
this._lb_up_desc,
this._img_up_red,
]
 = this.GetChildrenByNames([

"_gp_fight",
"_img_bg",
"_img_group",
"_img_picture",
"_img_shop",
"_img_rotary",
"_img_painting_red",
"_img_shop_red",
"_img_rotary_red",
"_img_name_bg",
"_lb_name",
"_scroll_bg",
"_gp_stars",
"_gp_talent",
"_gp_skills",
"_gp_model",
"_gp_effect0",
"_gp_effect",
"_inactivated",
"_bg",
"Image",
"_live_skill_icon",
"_skill_name",
"_skill_desc",
"_pre_attr_scr",
"_pre_attr",
"_pre_attr1",
"_pre_attr2",
"_activation",
"_img_bg1",
"_lb_level0",
"_img_bg2",
"_lb_level1",
"_img_level_up",
"_img_star_up",
"_lb_level_up",
"_lb_star_up",
"_img_level_up_red",
"_img_star_up_red",
"_Image2",
"_gp_stars0",
"_gp_stars1",
"_Scroller1",
"_gp_attrs",
"_lb_attr0",
"_lb_attr1",
"_img_full",
"gp_img_gx",
"_img_gx",
"_img_gx1",
"_Label1",
"_Scroller2",
"_img_material_tips",
"_Image3",
"_Image4",
"_gp_material",
"_Image5",
"_img_progress",
"_lb_material_title",
"_lb_material_tips",
"_lb_material_value",
"_gp_up",
"_Image6",
"_lb_up_desc",
"_img_up_red",
])
}
}
 window["DemonMainView"]= DemonMainView