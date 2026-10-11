import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { SceneEventType } from "../common/EventName"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DressModel, DressEvent, DressType } from "../commonModel/DressModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { PoseState } from "../util/StateMachineManager"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { GetLocalPositionX, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { DressItem } from "./DressItem"
import { DressProItem } from "./DressProItem"
import { DressSkillItem } from "./DressSkillItem"

export class DressSubView extends BaseItem1 {
	FormatList
	GetFirstSelectId
	GetFirstSelectIdByTypeId
	InitContent
	InitEvents
	InitSelect
	LoadSuccess
	PlayRole
	RefreshCostNum
	Scr_Scroller1
	Scr_Scroller2
	Scrscroll
	SetContentView
	SetCostAndBtnState
	SetData
	SetProContent
	SetSkill
	ShowFootEffect
	ShowModel
	arrayCollection_
	updatePowerShow
	cost_item_
	outlineactivite_btn_label
	pro_item_list_
	skill_item_list_
	tween_id_
	font_name: string = "fighting_font"
	bitmapFont
	_dress_item_data

	fight_item:FightingShowSmallItem
	public constructor(parent?) {
		super(parent)


		this.base_file = "dress"
		this.layout_file = "DressSubView"
		let model = DressModel.GetInstance()
		let UI_scene = null //UIScene:GetInstance()
		let local_DressEvent = DressEvent
		let goods_model = GoodsModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_SceneEventType = SceneEventType
		let local_Erlang = ErlangParser.GetInstance()
		let dress_list_cfg_ = null
		let dress_type_ = 1
		let needRefresh_ = false
		this.arrayCollection_ = null
		this.pro_item_list_ = []
		let use_btn_pos_ = null
		this.cost_item_ = null
		this.skill_item_list_ = []
		let cost_type_id_ = null
		let need_cost_num_ = null
		this.tween_id_ = null
		let is_top_level_ = false
		let roleCon_pos_ = null
		this.preload_server_config = {
			"config_dress_up_cfg": false
		}
		this.load_callback = () => {
			this.mat_num.style.fontSize = 20
			this.mat_num.style.color = "#ffffff"
			this.mat_num.style.strokeColor = "#000000"
			this.mat_num.style.stroke = 2
			this._Scroller1.vScrollBar.visible = false
			this.LoadSuccess()
			this.InitEvents()
		}
		// this.bitmapFont = new Laya.BitmapFont();


		this.LoadSuccess = () => {
			if(PlatformManager.IsEyouThPlatform()){
				this.dress_name.fontSize = 20
			}
			this.fight_item = new FightingShowSmallItem(this._gp_fight)
			this.fight_item.Load()
			this.fight_item.IsCenter(true, false)
			use_btn_pos_ = GetLocalPositionX(this.use_btn)
			roleCon_pos_ = GetLocalPositionX(this.roleCon)
			this.Content1.space = 28
		}

		this.InitEvents = () => {
			let click_call = (id?) => {
				model.now_select_id = id
				this.SetContentView(id)
			}

			this.BindEvent(model, local_DressEvent.DRESS_CLICK_DRESS_ITEM, click_call)
			let active_fun = () => {
				if (model.now_select_id && dress_type_) {
					model.Fire(local_DressEvent.DRESS_REQUEST_PROTO, 11201, "ci", dress_type_, model.now_select_id)
				}
			}

			Util.AddClickEvent(this.activite_btn, active_fun, this, true)
			let use_btn_fun = () => {
				if (model.now_select_id && dress_type_) {
					if (model.my_dress_data[dress_type_] && model.my_dress_data[dress_type_].use_dress_id == model.now_select_id) {
						model.Fire(local_DressEvent.DRESS_REQUEST_PROTO, 11203, "ci", dress_type_, model.now_select_id)
					} else {
						model.Fire(local_DressEvent.DRESS_REQUEST_PROTO, 11202, "ci", dress_type_, model.now_select_id)
					}
				}
			}

			Util.AddClickEvent(this.use_btn, use_btn_fun, this, true)
			let update_fun = (id?) => {
				if (dress_type_) {
					this.SetData(dress_type_)
				}
			}

			this.BindEvent(model, local_DressEvent.DRESS_UPDATE_DRESS_DATA, update_fun)

			this.BindEvent(model, local_DressEvent.DRESS_ACTIVE_POWER_DATA, ()=>{
				this.updatePowerShow()
			})
			this.BindEvent(goods_model, GoodsModel.CHANGE_BAG_LIST, () => {
				if (this.use_delete_method) {
					return
				}
				if ((model.now_select_id && cost_type_id_) && need_cost_num_) {
					this.RefreshCostNum(cost_type_id_, need_cost_num_)
				}
			}
			)
			let success_fun = () => {
				//this:ClearUIEffect(this.upgrade_effect)
				// this.AddUIEffect2("ui_visualupgrade_front", this.upgrade_effect, null, 1)
				//this:AddUIEffect2("ui_visualupgrade_behind", this.upgrade_effect1, null, 1)
				if (model.now_select_id && dress_type_) {
					let can_up_grade = model.DressCanUplevel(dress_type_, model.now_select_id)
					if (!can_up_grade) {
						model.now_select_id = null
						this.SetData(dress_type_)
					}
				}
			}

			this.BindEvent(model, local_DressEvent.DRESS_ACTIVE_SUCCESS, success_fun)
			//let role_fun = (role?, role_id?) => {
			//this:PlayRole(role)
			//}

			//this:BindEvent(local_GlobalEventSystem, local_SceneEventType.UIROLE_VO_ADD_SUCCESS, role_fun)
			if (needRefresh_) {
				this.SetData(dress_type_)
				needRefresh_ = false
			}
		}

		this.SetData = (dress_type?, select_id?) => {
			dress_type_ = dress_type
			if (this.is_loaded) {
				model.config_dress_up_cfg = this.preload_server_config["config_dress_up_cfg"]
				dress_list_cfg_ = model.GetDressAllCfgByType(dress_type_) || {}
				let data = Util.DeepCopy(dress_list_cfg_)
				data = this.FormatList(data)
				if (select_id) {
					model.now_select_id = this.GetFirstSelectIdByTypeId(select_id)
				} else {
					model.now_select_id = this.GetFirstSelectId()
				}
				this.InitContent(data)
				this.InitSelect()
			} else {
				needRefresh_ = true
			}
		}

		this.FormatList = (data?) => {
			if (data) {
				let max = 6
				if (data.length < max) {
					let num = max - data.length
					let i = 0
					do {
						let obj = null
						obj = []
						obj.type = dress_type_
						obj.id = 0
						obj.name = "敬请期待"
						obj.level = 0
						obj.cost = ""
						obj.attr = ""
						obj.skill = 0
						table.insert(data, obj)
						i = i + 1
					} while ((i < num)
					)
				}
			}
			return data
		}

		this.InitContent = (data?) => {
			if (!this.arrayCollection_) {
				if (data && !Util.IsTableEmpty(data)) {
					this.arrayCollection_ = new LoopScrowViewMgr()
					this.arrayCollection_.SetData(this.scroll, DressItem, data, LoopScrCon.Vertical, 3)
					this.arrayCollection_.SetSelectIndex(model.now_select_id)
					// this.Content.addEventListener(Laya.ItemTapEvent.ITEM_TAP)
				}
			} else {
				this.arrayCollection_.replaceAll(data)
			}
		}

		this.GetFirstSelectId = () => {
			let select_id = model.now_select_id
			if (!select_id) {
				let can_up_or_active = false
				if (dress_list_cfg_) {
					for (let _tmpi in dress_list_cfg_) {
						var vo = dress_list_cfg_[_tmpi]
						can_up_or_active = model.DressCanActive(dress_type_, vo.id) || model.DressCanUplevel(dress_type_, vo.id)
						if (can_up_or_active) {
							select_id = vo.id
							break
						}
					}
				}
				if (!select_id) {
					select_id = model.GetNowUseId(dress_type_)
				}
				if (select_id == 0 && dress_list_cfg_[0]) {
					select_id = dress_list_cfg_[0].id
				}
			}
			return select_id
		}

		this.GetFirstSelectIdByTypeId = (type_id?) => {
			let select_id = model.now_select_id
			if (dress_list_cfg_ && type_id) {
				for (let _tmpi in dress_list_cfg_) {
					var vo = dress_list_cfg_[_tmpi]
					let cost = vo.cost && local_Erlang.Parse(vo.cost)
					if (cost && cost[1] && cost[1][2] && type_id == Number(cost[1][2])) {
						select_id = vo.id
						break
					}
				}
			}
			return select_id || 1
		}

		this.InitSelect = () => {
			if (model.now_select_id) {
				let count = null
				let vo = null
				let i = 0
				if (i < dress_list_cfg_.length) {
					do {
						vo = dress_list_cfg_[i]
						if (vo.id == model.now_select_id) {
							count = i
							break
						}
						i = i + 1
					} while ((i < dress_list_cfg_.length)
					)
				}
				if (count != null) {
					let height = 200
					let line = Math.floor(count / 3)
					//let scroll_to = line * height
					//this.arrayCollection_.LastOnChild(line)
					//if (scroll_to > this.scroll_group.height - this.scroll.height ) {
					//scroll_to = this.scroll_group.height - this.scroll.height
					//}
					//this.scroll_group.validateNow()
					//this.scroll_group.scrollV = scroll_to
					model.Fire(local_DressEvent.DRESS_CLICK_DRESS_ITEM, model.now_select_id)
				}
			}
		}

		this.SetContentView = (id?) => {
			let dress_data = model.GetMyDressDataByTypeAndId(dress_type_, id)
			this.pro_title.text = (dress_data && ("升级增加属性") || ("激活增加属性"))
			this.active_title.text = (dress_data && ("升级条件") || ("激活条件"))
			if (!dress_data) {
				dress_data = model.getUnActDressData(dress_type_, id)
				if(dress_data.next_power == 0){
					model.Fire(local_DressEvent.DRESS_REQUEST_PROTO, 11205, "ci", dress_type_, model.now_select_id)
				}
			}
			let lv = (dress_data.dress_lv != 0 && (dress_data.dress_lv) || (1))
			this.active_desc.text = "";
			let cfg = model.GetDressCfgByTypeAndIdAndLv(dress_type_, id, lv)
			if (cfg) {
				let condition = JSON.parse(cfg.condition);
				this.dress_name.text = condition.length > 0? cfg.name : "Lv." + dress_data.dress_lv + " " + cfg.name
				if(dress_type_ == DressType.Head && condition.length > 0 && dress_data.dress_lv == 0){
					this.active_desc.text = `${condition[0][1]}转可激活`
				}
				// this.fighting.font=this.font_name
				this.SetProContent(dress_type_, id, dress_data.dress_lv)
				this.ShowModel(cfg)
				this.SetSkill(dress_type_, id, dress_data.dress_lv)
				let next_cfg = model.GetDressCfgByTypeAndIdAndLv(dress_type_, id, dress_data.dress_lv + 1)
				this.SetCostAndBtnState(id, next_cfg)
			}
			this.updatePowerShow()
		}

		this.SetProContent = (dress_type?, id?, lv?) => {
			let [now_pro, next_pro] = model.GetProList(dress_type, id, lv)
			if (now_pro && next_pro) {
				let len = Math.max(now_pro.length, next_pro.length)
				for (let _tmpi in this.pro_item_list_) {
					var item = this.pro_item_list_[_tmpi]
					item.SetVisible(false)
				}

				let i = 0
				do {
					let item = this.pro_item_list_[i]
					if (!item) {
						item = new DressProItem(this.Content11)
						this.pro_item_list_[i] = item
						item.Load()
					}
					let now = now_pro[i]
					let next = next_pro[i]
					item.ExcuteCallback(() => {
						item.SetVisible(true)
						item.SetData(now, next)
					})
					i = i + 1
				} while ((i < len)
				)
				this.top_level.visible = false;//next_pro.length <= 0
			}
		}

		this.ShowModel = (cfg?) => {
			if (cfg) {
				let cost_list = JSON.parse(cfg.cost);
				if (cfg.type == 5) {
					let headStr: string = DressModel.GetInstance().getHeadICon(cfg.id)
					ResManager.GetInstance().SetImageSpriteTrans(this, this.model_img, "resource/game/head/texture/" + headStr + ".png", true);
					this.model_img.scale(1, 1, true);
					if (!this.tween_id_) {
						let end_value = this.img_con.y + 50
						this.tween_id_ = SYTweenLite.to(this, this.img_con, SYTweenLite.UiAnimationType.POSY, end_value, 3, null, SYTweenFunc.PINGPONG, true)
					}
				}else if (cost_list && cost_list[0]) {
					//UI_scene:ClearUIScene()
					let [goods_id, lock] = goods_model.GetMappingTypeId(cost_list[0][0], cost_list[0][1])
					let goods_basic = goods_model.GetGoodsBasicByTypeId(goods_id)
					if (goods_basic) {
						if (cfg.type == 1) {
							ResManager.GetInstance().SetImageSpriteTrans(this, this.model_img, "resource/game/chat/texture/1_" + cfg.id + "_0.png", true);
							this.model_img.scale(1, 1, true);
						} else if (cfg.type == 2) {
							ResManager.GetInstance().SetImageSpriteTrans(this, this.model_img, "resource/game/head/texture/2_" + cfg.id + ".png", true)
							this.model_img.scale(1.5, 1.5, true);
						} else if (cfg.type == 3) {
							//this:ShowFootEffect(cfg.id)
						}
						this.model_img.visible = cfg.type == 1 || cfg.type == 2
						this.roleCon.visible = cfg.type == 3
						if (!this.tween_id_) {
							let end_value = this.img_con.y + 50
							this.tween_id_ = SYTweenLite.to(this, this.img_con, SYTweenLite.UiAnimationType.POSY, end_value, 3, null, SYTweenFunc.PINGPONG, true)
						}
					}
				}
			}
			//this:ClearUIEffect(this.picture_effect1)
			//this:ClearUIEffect(this.picture_effect2)
			//this:AddUIEffect2("ui_arrayglow_behind", this.picture_effect1, null, 1, true)
			//this:AddUIEffect2("ui_arrayglow_front", this.picture_effect2, null, 1, true)
		}

		this.SetSkill = (dress_type?, id?, lv?) => {
			let skill_cfg = model.GetDressSkillCfg(dress_type, id)
			this.skill_group.visible = skill_cfg && skill_cfg.length
			if (skill_cfg && skill_cfg.length) {
				let item = null
				let i = 0
				do {
					item = this.skill_item_list_[i]
					if (!item) {
						item = new DressSkillItem(this.Content1)
						item.Load()
						table.insert(this.skill_item_list_, item)
					}
					item.SetData(skill_cfg[i], lv)
					i = i + 1
				} while ((i < skill_cfg.length)
				)
			}
		}

		this.SetCostAndBtnState = (id?, next_cfg?) => {
			let dress_data = model.GetMyDressDataByTypeAndId(dress_type_, id)
			this.use_btn.visible = dress_data != null
			if (dress_data) {
				let is_in_dress = model.my_dress_data[dress_type_] && model.my_dress_data[dress_type_].use_dress_id == id
				this.use_btn_label.text = (is_in_dress && ("卸下") || ("使用"))
			}
			is_top_level_ = next_cfg == null
			Util.SetImageGray(this.active_btn_img, next_cfg == null)
			if (next_cfg == null) {
				this.activite_btn_label.stroke = 0
			}
			else {
				this.activite_btn_label.stroke = 2
			}

			// this.outlineactivite_btn_label.effectColor = next_cfg == null && "#Ox9c9c9c" || "#0xf33d4c" //Color(156/255,156/255,156/255,156/255) || Color(243/255,61/255,76/255,255/255)
			this.activite_btn_label.text = (next_cfg == null || Number(next_cfg.level) > 1) && "升级" || "激活"
			if(next_cfg && next_cfg.condition && next_cfg.condition != "[]" && this.activite_btn_label.text == "激活"){
				this.activite_btn.set_visible(false)
			}else{
				this.activite_btn.set_visible(true)
			}
			let cost_list = null
			if (next_cfg) {
				cost_list = JSON.parse(next_cfg.cost)
			} else if (dress_data) {
				let now_cfg = model.GetDressCfgByTypeAndIdAndLv(dress_type_, id, dress_data.dress_lv)
				if (now_cfg) {
					cost_list = JSON.parse(now_cfg.cost)
				}
			}
			if (cost_list && cost_list[0]) {
				let [goods_id, lock] = goods_model.GetMappingTypeId(cost_list[0][0], cost_list[0][1])
				this.RefreshCostNum(goods_id, Number(cost_list[0][2]))
				this.cost_con.visible  = true
			}else{
				this.cost_con.visible  = false
				this.mat_num.innerHTML = ""
			}
		}

		this.RefreshCostNum = (goods_id?, need_num?) => {
			cost_type_id_ = goods_id
			need_cost_num_ = need_num
			this.mat_num.width = 80
			let goods_basic = goods_model.GetGoodsBasicByTypeId(goods_id)
			if (goods_basic) {
				if (!this.cost_item_) {
					this.cost_item_ = new BaseAwardItem(this.cost_con)
					this.cost_item_.Load()
					this.cost_item_.SetItemSize(85, 85)
				}
				let my_have = goods_model.GetTypeGoodsNum(goods_id)
				this.cost_item_.ChangeCountVisible(false)
				this.cost_item_.SetData(goods_id, my_have)
				if (!is_top_level_) {
					let color_str = (my_have < need_num && ("#ff4f50") || ("#19ae4a"))
					let str = "<font color='" + color_str + "'>" + my_have + "</font>/" + need_num
					this.mat_num.innerHTML = Util.StrToHTML(str)
				} else {
					this.mat_num.innerHTML = ""
				}
				this.upgrade_dot.visible = !is_top_level_ && my_have >= need_num
			}
		}

		this.ShowFootEffect = (model_id?) => {
			let fun = (list?) => {
				if (list) {
					let tmp = null
					let i = 0
					let length = list.length
					do {
						tmp = list[i]
						if (tmp.figure_type == FigureProtoVo.FigureType.Wing) {
							list.splice(i, 1)
							break
						}
						i = i + 1
					} while ((i < length)
					)
				}
				return list
			}

			let get_main = Scene.GetInstance().GetMainRole()
			if (!get_main) {
				return
			}
			let main_role = get_main.vo
			let role_vo = SceneManager.GetInstance().CreateRoleVo()
			role_vo.role_id = main_role.role_id
			role_vo.sex = main_role.sex
			role_vo.career = main_role.career
			role_vo.fashion_model_list = Util.DeepCopy(main_role.fashion_model_list)
			role_vo.level_model_list = Util.DeepCopy(main_role.level_model_list)
			role_vo.figure_list = fun(Util.DeepCopy(main_role.figure_list))
			role_vo.revelation_suit = main_role.revelation_suit
			role_vo.pos_x = -100
			role_vo.pos_y = 80
			role_vo.force_show_foot_effect = true
			role_vo.foot_effect_scale = new Vector2(1.5, 1.5)
			role_vo.dress_list = [{ dress_type: DressType.Foot, dress_id: model_id }]
			//local_GlobalEventSystem:Fire(local_SceneEventType.UIROLE_VO_ADD, role_vo, this.roleCon, this.roleCon)
		}

		this.PlayRole = (role?) => {
			if (role) {
				role.SetDirectionByNum(1)
				role.ChangeState(PoseState.MOVE)
			}
		}


		this.updatePowerShow = () => {
			let dress_data = model.GetMyDressDataByTypeAndId(dress_type_, model.now_select_id)
			if(!dress_data){
				dress_data = model.getUnActDressData(dress_type_, model.now_select_id)
			}
			let cur_power = dress_data.cur_power;
			let next_power = dress_data.next_power;
			if(cur_power == 0){
				this.fight_item.Updatefighting(next_power);
				this.fight_item.UpdatefightingUp(0);
			}else{
				this.fight_item.Updatefighting(cur_power);
				if(next_power > 0){
					this.fight_item.UpdatefightingUp(next_power - cur_power);
				}else{
					this.fight_item.UpdatefightingUp(0);
				}
			}
		}
	}

	public DeleteMe() {
		if(this.fight_item){
			this.fight_item.DeleteMe()
			this.fight_item = null
		}
		//this:ClearUIEffect(this.picture_effect1)
		//this:ClearUIEffect(this.picture_effect2)
		if (this.tween_id_) {
			SYTweenLite.Stop(this.tween_id_)
			this.tween_id_ = null
		}
		if (this.arrayCollection_) {
			this.arrayCollection_.DeleteMe()
			this.arrayCollection_ = null
		}
		if (this.pro_item_list_) {
			for (let _tmpi in this.pro_item_list_) {
				var item = this.pro_item_list_[_tmpi]
				item.DeleteMe()
				item = null
			}
			this.pro_item_list_ = []
		}
		if (this.cost_item_) {
			this.cost_item_.DeleteMe()
			this.cost_item_ = null
		}
		for (let _tmpi in this.skill_item_list_) {
			var item = this.skill_item_list_[_tmpi]
			item.DeleteMe()
			item = null
		}
		this.skill_item_list_ = []
		super.DeleteMe()
		//UI_scene:ClearUIScene()
	}



_Image1:Laya.Image
_Image2:Laya.Image
name_bg:Laya.Image
scroll:Laya.List
picture_effect1:Laya.Box
img_con:Laya.Box
model_img:Laya.Image
picture_effect2:Laya.Box
upgrade_effect:Laya.Box
upgrade_effect1:Laya.Box
dress_name:Laya.Label
_gp_fight:Laya.Box
roleCon:Laya.Box
pro_group:Laya.Box
_Image3:Laya.Image
pro_title:Laya.Label
_Scroller1:Laya.Panel
Content11:Laya.VBox
top_level:Laya.Box
_Image4:Laya.Image
_Image5:Laya.Image
skill_group:Laya.Box
_Scroller2:Laya.Panel
Content1:Laya.HBox
activite_group:Laya.Box
_Image7:Laya.Image
active_desc:Laya.Label
active_title:Laya.Label
cost_con:Laya.Box
mat_num:Laya.HTMLDivElement
activite_btn:Laya.Box
active_btn_img:Laya.Image
upgrade_dot:Laya.Image
activite_btn_label:Laya.Label
use_btn:Laya.Box
_Image8:Laya.Image
use_btn_label:Laya.Label
public GetComponents() {
[
this._Image1,
this._Image2,
this.name_bg,
this.scroll,
this.picture_effect1,
this.img_con,
this.model_img,
this.picture_effect2,
this.upgrade_effect,
this.upgrade_effect1,
this.dress_name,
this._gp_fight,
this.roleCon,
this.pro_group,
this._Image3,
this.pro_title,
this._Scroller1,
this.Content11,
this.top_level,
this._Image4,
this._Image5,
this.skill_group,
this._Scroller2,
this.Content1,
this.activite_group,
this._Image7,
this.active_desc,
this.active_title,
this.cost_con,
this.mat_num,
this.activite_btn,
this.active_btn_img,
this.upgrade_dot,
this.activite_btn_label,
this.use_btn,
this._Image8,
this.use_btn_label,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image2",
"name_bg",
"scroll",
"picture_effect1",
"img_con",
"model_img",
"picture_effect2",
"upgrade_effect",
"upgrade_effect1",
"dress_name",
"_gp_fight",
"roleCon",
"pro_group",
"_Image3",
"pro_title",
"_Scroller1",
"Content11",
"top_level",
"_Image4",
"_Image5",
"skill_group",
"_Scroller2",
"Content1",
"activite_group",
"_Image7",
"active_desc",
"active_title",
"cost_con",
"mat_num",
"activite_btn",
"active_btn_img",
"upgrade_dot",
"activite_btn_label",
"use_btn",
"_Image8",
"use_btn_label",
])
}
}
 window["DressSubView"]= DressSubView