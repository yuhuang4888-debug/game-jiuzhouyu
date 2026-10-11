import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BossModel } from "../commonModel/BossModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { DressModel, DressType } from "../commonModel/DressModel"
import { FirstBloodModel, FirstBloodEvent } from "../commonModel/FirstBloodModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ModelPartName, SceneBaseType } from "../scene/SceneConfig"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SetSizeDeltaX, SetAnchoredPositionX, SetAnchoredPositionY, SetSizeDeltaY, SetSizeDelta, SetAnchoredPosition, Util, Trim, GlobalTimerQuest } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { FirstBloodItem } from "./FirstBloodItem"
import { Config } from "../common/Config"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"


export class FirstBloodMainView extends BaseItem1 {
	_img_title_info: Laya.Image
	Content
	InitEvent
	LoadSuccess
	ReOpen_callback
	ScrollView
	ScrollView1
	Viewport1
	_gp_model_con
	_model
	_playerHead
	all_red_img
	all_reward
	all_reward_img
	boss_id
	boss_link
	data
	data_list
	detail_text
	go_btn
	go_img
	go_text
	head
	image
	image1
	image11
	image111
	img
	img_text
	item_content
	all_reward_item_list
	self_reward_item_list
	kill_name_text
	killed_img
	light_img
	line
	loop_mgr
	name_bg
	name_gp
	name_text
	none
	own_reward
	pos_text
	receive_stage
	red_img
	select_index
	single_red_img
	single_reward_img
	sub_type
	title_bg
	ConfigBoss
	_Image1: Laya.Image
	_Label1: Laya.Label
	all_reward_effect: Laya.Box
	img_reward_gp: Laya.Image
	img_reward_title:Laya.Image
	whole_first_blood_reward
	shared_reward
	no_name_img
	shared_status

	all_reward_get
	single_reward_get

	my_first_blood
	other_first_blood
	select_time = 0
	all_reward_gp
	self_reward_gp
	timer_id
	public constructor(parent?) {
		super(parent)


		this.base_file = "firstBlood"
		this.layout_file = "FirstBloodMainView"
		this.receive_stage = 2
		this.data = null
		this.sub_type = 1
		this.all_reward_item_list = []
		this.self_reward_item_list = []
		this.data_list = []
		this.select_index = 0
		this.preload_server_config = { "config_boss_first_blood_plus_boss": false }
		this.my_first_blood = false
		this.other_first_blood = false
		this.load_callback = () => {
			ResManager.GetInstance().LoadGameConfig(this, "ConfigBoss", true, undefined, (cfgs) => {
				this.ConfigBoss = cfgs
			})
			// this.RegisterMask(this.Viewport1)
			this._model = FirstBloodModel.GetInstance()
			CustomActivityModel.GetInstance().SetActRedDot(96, this.sub_type)
			CustomActivityModel.GetInstance().RefreshIconRed(96, this.sub_type)
			this.LoadSuccess()
			this.InitEvent()

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	SetSizeDeltaX(this.img,80)
			// 	SetAnchoredPositionX(this.img,220)
			// 	SetSizeDeltaX(this.img_text,80)
			// 	SetAnchoredPositionX(this.img_text,220)
			// }
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this.detail_text.size  = 17
			// 	this.detail_text.lineSpacing = 0.8
			// 	SetAnchoredPositionY(this.detail_text,-189)
			// 	SetSizeDeltaY(this.detail_text, 67)
			// 	SetSizeDelta(this.img, 46.64, 77.39)
			// 	SetAnchoredPosition(this.img, 235.18, -904.7)
			// 	this._text.size  = 12
			// 	SetSizeDelta(this.img_text, 70.1, 36.3)
			// 	SetAnchoredPosition(this.img_text, 222.9, -926.2)
			// }
		}
		this.ReOpen_callback = () => {
			this.ShowModel()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.all_reward_img, () => {
				if (this.shared_status == 0) {//领取全服归属奖励
					this._model.Fire(FirstBloodEvent.REQUEST_PROTO, 18807, "cci", 96, this.sub_type, this.boss_id)
				}
				//刷新特定boss的全服归属奖励领取状态
				for (let key in this._model.shared_reward_state_list) {
					let v2 = this._model.shared_reward_state_list[key]
					if (v2.boss_id == this.boss_id) {
						this._model.shared_reward_state_list[key].shared_status = 1
					}
				}
			}
				, this, true)
			// Util.AddClickEvent(this.single_reward_img, () => {
			// 	this._model.Fire(FirstBloodEvent.OPEN_View, "FirstBloodRewardView", "个人奖励", this.own_reward)
			// }
			// 	, this, true)
			Util.AddClickEvent(this.go_btn, () => {
				if (this.go_text.text == "领取") {
					this._model.Fire(FirstBloodEvent.REQUEST_PROTO, 18802, "cci", 96, this.sub_type, this.boss_id)
					// if (this.shared_status == 0 && this.my_first_blood) {//领取全服归属奖励
						// this._model.Fire(FirstBloodEvent.REQUEST_PROTO, 18801, "cc", 96, this.sub_type)//更新击杀列表信息 以及归属列表领取奖励信息
						// this._model.Fire(FirstBloodEvent.REQUEST_PROTO, 18807, "cci", 96, this.sub_type, this.boss_id)
					// }
					//刷新特定boss的全服归属奖励领取状态
					// for (let key in this._model.shared_reward_state_list) {
					// 	let v2 = this._model.shared_reward_state_list[key]
					// 	if (v2.boss_id == this.boss_id) {
					// 		this._model.shared_reward_state_list[key].shared_status = 1
					// 	}
					// }
				} else if (this.go_text.text == "前往击杀") {
					let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.boss_id, false)
					if (mon_cfg.mon_sys == 7) {
						OpenFun.OpenFunHandler(28, this.boss_link)
					} else {
						OpenFun.OpenFunHandler(26, this.boss_link)
					}
				}
			}
				, this, true)
			this.BindEvent(this._model, FirstBloodEvent.UPDATE_VIEW, () => {
				if (this.data) {
					this.SetSelect()
					//this:SelectMonster(this.data)
				}
			}
			)
			this.BindEvent(this._model, FirstBloodEvent.UPDATE_KILL_RED, () => {
				if (!this.use_delete_method) {
					this.SelectMonster(this.data)
					this.ShowReward()
				}
			})
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.title_bg, GameResPath.GetIconJpg("firstBlood", "ui_activity_bg4"))
			ResManager.GetInstance().SetImageSprite(this, this.light_img, "firstBlood", "uiss_015")
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.name_bg, GameResPath.GetIcon("firstBlood", "uiss_008"))
			ResManager.GetInstance().SetImageSprite(this, this.line, "firstBlood", "uiss_003")
			// ResManager.GetInstance().SetOutsideImageSprite(this,this._img_title_info,GameResPath.GetIcon("firstBlood","ui_info"))
			ResManager.GetInstance().SetTexture(this,this.img_reward_gp,GameResPath.GetIcon("firstBlood","ui_activity_37"))
			this.AddUIEffect("UI_1601_03",this.all_reward_effect,null,4,true)
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_first_blood_plus_boss", false);
			let list = []
			let i = 0
			for (let _ in cfg) {
				var v = cfg[_]
				if (v.type == 96 && v.sub_type == this.sub_type) {
					list[i] = v
					i = i + 1
				}

			}
			table.sort(list, (a?, b?) => {
				return a.client_pos < b.client_pos
			})

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, FirstBloodItem, list, LoopScrCon.Vertical, 1, (item?) => {
					this.select_time = this.select_time + 1
					if (this.select_time <= 2) {
						if (item > 5) {
							this.loop_mgr.FirstOnChild(11)
						}
					}
					let data = this.loop_mgr.data_list[item]
					this.select_index = item
					this.data = data
					this.SelectMonster(data)
					this.ShowReward()
				})
			} else {
				this.loop_mgr.replaceAll(list)
			}

			let bool = this.sub_type == 1 && true || false
			this.all_reward_img.visible = bool
			// this.all_reward_effect.visible = bool
			// this.single_reward_img.visible = bool
			this.ScrollView1.visible = !bool
			let text = bool && "全服首次击败指定大妖获得掉落归属的个人，可以领取全服归属奖励；每位玩家首次击败指定大妖，可领取个人奖励。" || "全服首次击败指定大妖获得掉落归属的个人，可以领取全服首杀奖励，并赠予全服玩家一份全服奖励。"
			this.detail_text.style.fontSize = 20
			this.detail_text.style.color = "#FFFFFF"
			// this.detail_text.innerHTML = text
			this.detail_text.width = 587
			this.data_list = list
			this.SetSelect()
		}

	}

	public SetSelect() {

		let index = -1
		let kill_info = FirstBloodModel.GetInstance().GetKillInfo(96, this.sub_type)
		let info = null
		let info1 = null
		let hasreward = false
		for (let _ in this.data_list) {
			index = Number(_)
			var v0 = this.data_list[_]

			if (kill_info && kill_info.first_blood_list) {
				for (let k in kill_info.first_blood_list) {
					var v = kill_info.first_blood_list[k]
					if (v0.object_id == v.boss_id) {
						info = v
						break
					}
				}
			}

			for (let key in this._model.shared_reward_state_list) {
				let v2 = this._model.shared_reward_state_list[key]
				if (v2.boss_id == v0.object_id) {
					info1 = v2
					break
				}
			}

			if (info && info.reward_state == 0) {
				hasreward = true
				break
			}

			if (info1 && info1.shared_status == 0) {
				hasreward = true
				break
			}
		}
		if (index == 11 && !hasreward) {
			index = this.Content.selectedIndex
		}

		this.loop_mgr.SetSelectIndex(index)

	}

	public SelectMonster(data?) {
		this.all_reward_get.visible = false
		// this.single_reward_get.visible = false
		let kill_info = this._model.GetKillInfo(96, this.sub_type)
		let info = null
		let info1 = null
		let info2 = null
		this.boss_id = data.object_id
		if (kill_info && kill_info.first_blood_list) {
			for (let k in kill_info.first_blood_list) {
				var v = kill_info.first_blood_list[k]
				if (this.boss_id == v.boss_id) {
					info1 = v
				}
				if (Trim(v.first_blood_role_name) != "" && this.boss_id == v.boss_id) {
					info = v
					break
				}
			}
		}

		for (let key in this._model.shared_reward_state_list) {
			let v2 = this._model.shared_reward_state_list[key]
			if (v2.boss_id == this.boss_id) {
				info2 = v2
			}
		}


		let bool = info && true || false
		this.none.visible = !bool
		this.kill_name_text.visible = bool
		this.no_name_img.visible = !bool

		this.pos_text.text = Trim(data.boss_scene_name)
		let monster = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.boss_id, false)
		let name = String(monster.name)
		let lv = String(monster.lv)
		this.name_text.style.fontSize = 20
		this.name_text.style.color = "#FFFFFF"
		this.name_text.innerHTML = Util.StrToHTML(Trim(name) + "&nbsp;&nbsp;<font color='#ffea60'>Lv" + lv + "</font>"
		)
		this.name_text.width = 500
		this.go_text.text = "前往击杀"
		this.go_text.color = ColorUtil.TryParseHtmlString("#ffffff")
		Util.SetImageGray(this.go_img, false)
		this.whole_first_blood_reward = ErlangParser.GetInstance().Parse(data.whole_first_blood_reward)//全服首杀奖励
		for (let key in this.whole_first_blood_reward) {
			this.whole_first_blood_reward[key][4] = 0
		}
		this.shared_reward = ErlangParser.GetInstance().Parse(data.shared_reward)//全服归属奖励
		for (let key in this.shared_reward) {
			this.shared_reward[key][4] = 1
		}
		this.own_reward = ErlangParser.GetInstance().Parse(data.own_reward)//个人挑战奖励
		this.boss_link = data.boss_link
		this.red_img.visible = false
		this.all_reward_img.visible = false
		this.all_reward_effect.visible = false
		this.all_red_img.visible = false
		// this.single_red_img.visible = false
		this.killed_img.visible = false

		let single_red = false
		let first_blood_red = false
		let shared_red = false

		//info1 boss相关数据 info boss已经被首杀的时候有数据 info2存储全服归属奖励状态
		if (info1) {//先判断个人挑战红点
			let show_name = info1 && info1.show_first_blood == 1 && true || false
			this.name_gp.visible = show_name
			this.receive_stage = info1.reward_state
			this.killed_img.visible = info1.reward_state == 0 || info1.reward_state == 1
			if (this.receive_stage == 0) {
				// this.single_red_img.visible = true
				single_red = true
			} else if (this.receive_stage == 1) {
				single_red = false
			}


			//再判断全服首杀是否有
			if (info) {
				this.other_first_blood = true
				this.kill_name_text.text = String(info.first_blood_role_name)
				if (this.kill_name_text.width > 150) {
					SetSizeDeltaX(this.kill_name_text, this.kill_name_text.width)
				} else {
					SetSizeDeltaX(this.kill_name_text, 150)
				}
				// this.go_btn.GetComponent("EmptyRaycast").raycastTarget = true
				this.killed_img.visible = info.first_blood_role_name && Trim(info.first_blood_role_name != "")
				if (this.receive_stage == 0) {
					let main_role_name = RoleManager.GetInstance().GetMainRoleVo().name
					if (main_role_name == Trim(info.first_blood_role_name)) {
						this.all_reward_img.visible = false
						this.all_reward_effect.visible = false
						this.all_red_img.visible = false
						first_blood_red = true
						this.my_first_blood = true
						this.other_first_blood =false
					} else {
						first_blood_red = false
						this.all_reward_img.visible = false
						this.all_reward_effect.visible = false
						this.all_red_img.visible = false
						this.my_first_blood = false
						this.other_first_blood = true
					}
				}
				if (this.receive_stage == 1) {
					let main_role_name = RoleManager.GetInstance().GetMainRoleVo().name
					if (main_role_name == Trim(info.first_blood_role_name)) {
						this.my_first_blood = true
						this.other_first_blood =false
					} else {
						this.my_first_blood = false
						this.other_first_blood = true
					}
				}
				if (this.receive_stage == 2) {
					let main_role_name = RoleManager.GetInstance().GetMainRoleVo().name
					if (main_role_name == Trim(info.first_blood_role_name)) {
						this.my_first_blood = true
						this.other_first_blood =false
					} else {
						this.my_first_blood = false
						this.other_first_blood = true
					}
				}
				if (this._playerHead == null) {
					this._playerHead = new CustomHeadItem(this.head)
					this._playerHead.Load()
					this._playerHead.ExcuteCallback(() => {
						this._playerHead.display_obj.scaleX = 1.13
						this._playerHead.display_obj.scaleY = 1.13
					})
				}
				let frame_id = DressModel.GetInstance().GetDressByType(info.dress_list, DressType.Photo)
				this._playerHead.SetRoleVoData(info)
				this._playerHead.SetActiveBg(false)
				this._playerHead.SetVisible(true)
			} else {
				if (this._playerHead) {
					this._playerHead.SetVisible(false)
				}
				this.other_first_blood = false
				this.my_first_blood = false
			}
		}

		if (info2) {//再判断全服归属奖励
			if (info2.shared_status == 0 ) {
				shared_red = true
				this.all_reward_img.visible = true
				this.all_reward_effect.visible = true
				this.all_red_img.visible = true
			} else {
				shared_red = false
				this.all_reward_img.visible = this.all_reward_img.visible
				this.all_reward_effect.visible = false
				this.all_red_img.visible = false
			}
			this.shared_status = info2.shared_status
		}

		////最后更新按钮状态
		//更新按钮红点
		let btn_red = single_red || first_blood_red 
		this.red_img.visible = btn_red
		//更新按钮字体
		if (this.receive_stage == 0 ) {
			this.go_text.text = "领取"
			this.red_img.visible = true
		} else if (this.receive_stage == 1) {
			this.go_text.text = "已领取"
			Util.SetImageGray(this.go_img, true)
			// SetTextGray(this.go_text)
		} else {
			this.go_text.text = "前往击杀"
		}

		//更新两个按钮是否领取的状态
		if (this.shared_status == 1 && info) {//全服归属已领取
			this.all_reward_get.visible = true
			this.all_reward_effect.visible = false
			this.all_red_img.visible = false
			this.all_reward_img.visible = true
			// SetTextGray(this.go_text)	
		} else if (info){
			this.all_reward_get.visible = false
			this.all_reward_effect.visible = true
			this.all_red_img.visible = true
			this.all_reward_img.visible = true
		}

		//////

		if (this.receive_stage == 1) {
			// this.single_reward_get.visible = true
			// SetTextGray(this.go_text)
		} else {
			// this.single_reward_get.visible = false
		}

		//判断自己的全服奖励有哪些
		if (this.my_first_blood && this.shared_status == 0) {
			this.all_reward = this.whole_first_blood_reward
			this.all_reward_img.visible = true
			this.all_reward_effect.visible = true
			this.all_red_img.visible = true
			
		} else if(this.my_first_blood){
			this.all_reward = this.whole_first_blood_reward
		}else{
			// this.all_reward = this.shared_reward
		}
		//
		if (!info) {
			this.all_reward = this.whole_first_blood_reward.concat(this.shared_reward)
		}


		if (this.sub_type == 1) {
			let show = this._model.GetRed(1)
			if (!show || show == 0) {
				this._model.Fire(FirstBloodEvent.ADD_FIRST_BLOOD_ICON, false)
			}
		}

		
		if(this.all_reward_img.visible && (this.shared_status != 1)){
			if(this.timer_id){
				this.all_reward_img.rotation = 0
				Laya.Tween.clearAll(this.all_reward_img)
				GlobalTimerQuest.CancelQuest(this.timer_id)
				this.timer_id = null
				this.timer_id = GlobalTimerQuest.AddPeriodQuest(()=>{
					this.ShowAnimation()
				},2,-1)
				this.ShowAnimation()
			}else{
				this.timer_id = GlobalTimerQuest.AddPeriodQuest(()=>{
					this.ShowAnimation()
				},2,-1)
				this.ShowAnimation()
			}
		}else{
			this.all_reward_img.rotation = 0
			Laya.Tween.clearAll(this.all_reward_img)
			if(this.timer_id){
				GlobalTimerQuest.CancelQuest(this.timer_id)
				this.timer_id = null
			}
		}

		this.ShowModel()//data.boss_model
	}

	public ShowReward() {
		let i = 0
		if (this.all_reward_item_list && this.all_reward_item_list.length > 0) {
			for (let i in this.all_reward_item_list) {
				var v = this.all_reward_item_list[i]
				v.DeleteMe()
				v = null
			}
			this.all_reward_item_list = []
		}
		if(this.my_first_blood ||(!this.other_first_blood && !this.my_first_blood)){
			this.img_reward_gp.visible = true
			this.img_reward_title.visible = true
			for (let _ in this.all_reward) {
				var v = this.all_reward[_]
				let item = this.all_reward_item_list[i] && this.all_reward_item_list[i] || new EquipmentItem(this.all_reward_gp)
				this.all_reward_item_list[i] = item
				item.SetItemSize(78,78)
				item.Load()
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(v[0], v[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, v[2], lock)
				}
				let src
				if (v[4] != null) {
					if (v[4] == 0) {
						src = "uiss_003a"
					} else {
						src = "uiss_003b"
					}
				}
				let image = new Laya.Image()
				image.skin = "resource/game/firstBlood/texture/" + src + ".png"
				image.width = 55
				image.height = 55
				image.left = 10
				image.top = 10
				let _img_get
				if(this.receive_stage==1 ){
					_img_get = new Laya.Image()
					_img_get.skin = "resource/game/common4/texture/com_received.png"
					_img_get.centerX = 0
					_img_get.centerY = 0
					_img_get.width = 100
					_img_get.height = 78
				}
				item.ExcuteCallback(() => {
					item.display_obj.visible = true
					if(_img_get){
						item.display_obj.addChild(_img_get)
					}
					item.display_obj.addChild(image)
					this.all_reward_gp.refresh()
				})
				i = i + 1
			}
		}else{
			if(this.all_reward_item_list.length > 0){
				for(let key  in this.all_reward_item_list){
					let item = this.all_reward_item_list[key]
					if(item && item.display_obj){
						item.display_obj.visible = false
					}
				}
			}
			this.img_reward_gp.visible = false
			this.img_reward_title.visible = false
		}
		i = 0
		if (this.self_reward_item_list && this.self_reward_item_list.length > 0) {
			for (let i in this.self_reward_item_list) {
				var v = this.self_reward_item_list[i]
				v.DeleteMe()
				v = null
			}
			this.self_reward_item_list = []
		}
		for (let key in this.own_reward) {
			let v = this.own_reward[key]
			let item = this.self_reward_item_list[i] ? this.self_reward_item_list[i] : new EquipmentItem(this.self_reward_gp)
			this.self_reward_item_list[i] = item
			item.SetItemSize(78,78)
			item.Load()
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(v[0], v[1])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (goods_vo) {
				item.SetData(goods_vo.type_id, v[2], lock)
			}
			let _img_get
			if(this.receive_stage==1 ){
				_img_get = new Laya.Image()
				_img_get.skin = "resource/game/common4/texture/com_received.png"
				_img_get.centerX = 0
				_img_get.centerY = 0
				_img_get.width = 100
				_img_get.height = 78
			}
			item.ExcuteCallback(() => {
				item.display_obj.visible = true
				if(_img_get){
					item.display_obj.addChild(_img_get)
				}
				this.all_reward_gp.refresh()
			})
			i = i + 1
		}
	}

	public ShowModel() {

		let res = this.data.boss_model//2000020//
		let cfg = BossModel.GetShowModelCfg(BossModel.BossType.field, res, this.ConfigBoss)
		let scale = 1
		let offset = new Vector3(0, 0, 0)
		if (cfg) {
			scale = cfg.scale
		}
		// let curr_sorting_order = this.AddCurrLayerSortingOrder("UI")
		let callBack = () => {


		}
		let data = {
			clothe_res_id: res,
			type: UI_MODEL_TYPE.MONSTER,
			scale: 0.8,
			can_rotate: true,
			show_gray: false,
			layout_file: "FirstBloodMainView"
		}
		ResManager.GetInstance().SetRoleModel(this, this._gp_model_con, data)

		// this.CoverMode(this.killed_img,"UI",curr_sorting_order)
	}

	public ShowAnimation(){
		Laya.Tween.to(this.all_reward_img,{rotation:-20},250,null,Laya.Handler.create(this,()=>{
			Laya.Tween.clearAll(this.all_reward_img)
			Tween_2()
		}))
		let Tween_2=()=>{
			Laya.Tween.to(this.all_reward_img,{rotation:20},500,null,Laya.Handler.create(this,()=>{
				Laya.Tween.clearAll(this.all_reward_img)
				Laya.Tween.to(this.all_reward_img,{rotation: 0},250,null,Laya.Handler.create(this,()=>{
					Laya.Tween.clearAll(this.all_reward_img)
				}))
			}))
		}
	}
	public DeleteMe() {
		this.select_time = 0
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		if (this._playerHead) {
			this._playerHead.DeleteMe()
			this._playerHead = null
		}
		if (this.all_reward_item_list && this.all_reward_item_list.length > 0) {
			for (let i in this.all_reward_item_list) {
				var v = this.all_reward_item_list[i]
				v.DeleteMe()
				v = null
			}
			this.all_reward_item_list = []
		}
		if (this.self_reward_item_list && this.self_reward_item_list.length > 0) {
			for (let i in this.self_reward_item_list) {
				var v = this.self_reward_item_list[i]
				v.DeleteMe()
				v = null
			}
			this.self_reward_item_list = []
		}
		if(this.timer_id ){
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
		super.DeleteMe()

	}

	public GetComponents() {
		[
			this.title_bg,
			this.detail_text,
			this.ScrollView,
			this.Content,
			this.name_gp,
			this.image11,
			this.none,
			this.head,
			this.kill_name_text,
			this.image1,
			this.light_img,
			this.killed_img,
			this.name_bg,
			this.pos_text,
			this.name_text,
			this.line,
			this._Image1,
			this._Label1,
			this.all_reward_img,
			this.all_red_img,
			this.single_reward_img,
			this.single_red_img,
			this.go_btn,
			this.go_img,
			this.go_text,
			this.red_img,
			this._gp_model_con,
			this.ScrollView1,
			this.item_content,
			this.no_name_img,
			this.all_reward_get,
			this.single_reward_get,
			this._img_title_info,
			this.all_reward_gp,
			this.self_reward_gp,
			this.all_reward_effect,
			this.img_reward_gp,
			this.img_reward_title
		]
			= this.GetChildrenByNames([

				"title_bg",
				"detail_text",
				"ScrollView",
				"Content",
				"name_gp",
				"image11",
				"none",
				"head",
				"kill_name_text",
				"image1",
				"light_img",
				"killed_img",
				"name_bg",
				"pos_text",
				"name_text",
				"line",
				"_Image1",
				"_Label1",
				"all_reward_img",
				"all_red_img",
				"single_reward_img",
				"single_red_img",
				"go_btn",
				"go_img",
				"go_text",
				"red_img",
				"_gp_model_con",
				"ScrollView1",
				"item_content",
				"no_name_img",
				"all_reward_get",
				"single_reward_get",
				"_img_title_info",
				"all_reward_gp",
				"self_reward_gp",
				"all_reward_effect",
				"img_reward_gp",
				"img_reward_title"
			])
	}

}
window["FirstBloodMainView"] = FirstBloodMainView