import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SceneEventType } from "../common/EventName"
import { RoleManager } from "../commonModel/RoleManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Scene } from "../scene/Scene"
import { EventName } from "../common/EventName"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util, Color, SetLocalScale, SetAlpha, SetSizeDeltaX } from "../util/Util"
import { LuaSoundManager } from "../common/SoundManager"
import { VipModel } from "../commonModel/VipModel"
import { WordManager } from "../common/WordManager"
import { ErlangParser } from "../util/ErlangParser"
import { EquipmentItem } from "../common/EquipmentItem"
import { ColorType } from "../util/ColorUtil"
// import { PlayerHead } from "../common/PlayerHead"
import { table } from "../common/table"
import { Vector2 } from "../util/Vector2"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"
import { FashionPartPos } from "../scene/SceneConfig"
import { Vector3 } from "../util/Vector3"
import { UIModelClass3D, UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { PlatformManager } from "../PlatformManager"

export class FirstRechargeView extends BaseView1 {
	_img_bg: Laya.Image
	view_ui: Laya.Box
	bg1: Laya.Image
	bg2: Laya.Image
	bg3: Laya.Image
	_gp_reward: Laya.HBox
	_gp_show: Laya.Box
	_title: Laya.Image
	_head: Laya.HTMLDivElement
	_img_l: Laya.Image
	_img_r: Laya.Image
	_desc_left: Laya.Image
	_desc_right: Laya.Image
	_gp_behindL: Laya.Box
	_left: Laya.Box
	_gp_behindR: Laya.Box
	_right: Laya.Box
	_gp_recharge: Laya.Box
	_Image1: Laya.Image
	_lb_recharge: Laya.Label
	_img_recharge_red: Laya.Image
	_img_close: Laya.Image
	Btn1: Laya.Box
	_Image2: Laya.Image
	select1: Laya.Image
	_Text1: Laya.Label
	red1: Laya.Image
	Btn2: Laya.Box
	_Image4: Laya.Image
	select2: Laya.Image
	_Text2: Laya.Label
	red2: Laya.Image
	Btn3: Laya.Box
	_Image6: Laya.Image
	select3: Laya.Image
	_Text3: Laya.Label
	red3: Laya.Image
	_mleft: Laya.Box
	_mright: Laya.Box
	_time: Laya.Label
	head_gp: Laya.HBox
	_lb_name_r: Laya.Label
	_lb_name_l: Laya.Label
	_img_1: Laya.Image
	_img_2: Laya.Image
	_img_3: Laya.Image
	_bg_effect: Laya.Box
	ClearModel
	ClearOld
	InitEvent
	LoadCfg
	LoadSuccess
	Out_Text1
	Out_Text2
	Out_Text3
	SetButtonRed
	ShowEffect
	ShowModel
	UpdateView
	_Viewport1
	_down
	background_alpha
	change_scene_close
	click_bg_toClose
	cur_sorting_order
	destroy_callback
	destroy_imm
	etime
	head
	is_center
	mainVo
	not_show_main_msg
	open_callback
	show_open_movie
	time_style
	timer
	use_background
	init_model_dic
	tween_pos
	public constructor() {
		super()


		this.base_file = "recharge"
		this.layout_file = "FirstRechargeView"
		this.layer_value = Enum_UILayer.Activity
		this.change_scene_close = true
		this.use_background = true
		this.is_center = true
		this.background_alpha = 1
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.show_open_movie = true
		this.not_show_main_msg = true
		this.append_to_ctl_queue = true;

		this.time_style = false	//倒计时关闭模式
		let model = FirstRechargeModel.GetInstance()

		let local_FirstRechargeModel = FirstRechargeModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_SceneEventType = SceneEventType
		let role_mgr = RoleManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let scene = Scene.GetInstance()
		let reward_list_ = null
		let cfg_ = null
		let client_cfg_ = null
		let state_ = 0
		let model_list_ = null
		let selectIndex_ = 1
		let floatList_ = []
		let effectList_ = []
		let model_head=[1103,1203,1103,1203]
		this.preload_client_config = {
			"ConfigFirstRecharge": false
		}
		this.preload_server_config = {
			"config_recharge_first": false
		}
		this.load_callback = () => {

			if(PlatformManager.IsEyouEnPlatform()){
				this._lb_name_l.x = 132
				this._lb_name_l.y = 399
				this._lb_name_l.width= 180
				this._lb_name_l.height = 46
				this._lb_name_l.rotation = -90

				this._lb_name_r.x = 668
				this._lb_name_r.y = 399
				this._lb_name_r.width= 180
				this._lb_name_r.height = 46
				this._lb_name_r.rotation = -90
			}
			this.LoadSuccess()
			this.InitEvent()
			model.loginfirst = false
			local_GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 159)
		}

		this.open_callback = () => {
			//this.RegisterMask(this._Viewport1)
			//this.cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)

			// let main_role = RoleManager.GetInstance().GetMainRoleVo()
			// let bg_data = {
			// 	type=1,
			// 	res_id = 410426,
			// 	layer_value = this.layer_value,
			// 	layout_file = "FirstRechargeView",
			// 	rotate = co.TableXYZ(20, 140, -13.5),
			// 	scale = 150,
			// 	position = Vector3(0,-74,0),
			// 	can_rotate = false,
			// 	custom_sorting_order = this.cur_sorting_order
			// }
			// ResManager.GetInstance().SetPartModel(this,this._img_bg,bg_data)
			// this.CoverMode(this.view_ui, "Activity", this.cur_sorting_order)

			this.LoadCfg()

		}

		this.destroy_callback = () => {
			//奖励item销毁
			if (reward_list_) {
				for (let _tmpi in reward_list_) {
					var vo = reward_list_[_tmpi]
					if (vo) {
						vo.DeleteMe()
					}
				}
			}
			reward_list_ = []

			//图片 动画取消
			for (let _tmpi in floatList_) {
				var obj = floatList_[_tmpi]
				if (obj) {
					SYTweenLite.Stop(obj)
				}
			}
			floatList_ = []

			if (this.head) {
				this.head.DeleteMe()
			}
			this.head = null

			this.time_style = false
			this.CancelTimer()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("recharge", "uiscsr_007"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg2, GameResPath.GetIcon("recharge", "uiscsr_022"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg3, GameResPath.GetIcon("recharge", "uiscsr_021"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("recharge", "ui_First_01"), true)
			this.AddUIEffect("ui_shouchong_01", this._bg_effect,undefined,10,true)
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this["text_head"].size  = 19
			// 	this._lb_recharge.size  = 26
			// 	SetLocalScale(this._desc_left,0.8,0.8,0.8)
			// }
			this.init_model_dic = {}
			this.tween_pos=this._left.y
		}

		this.LoadCfg = () => {
			client_cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigFirstRecharge", true)
			cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_recharge_first", false)

			let data = model.first_recharge_info
			if (data) {
				for (let _tmpi in data.reward_list) {
					var vo = data.reward_list[_tmpi]
					if (vo.open == 1 || vo.open == 2) {
						selectIndex_ = vo.index
						break
					}
				}
			}
			this.UpdateView()
			this.ShowEffect()
			this.SetButtonRed()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this._gp_recharge, () => {
				this.ClickView()
				if (state_ > 0) {
					model.Fire(local_FirstRechargeModel.SCMD_REQUEST, 15906, selectIndex_)
				} else if (state_ == 0) {
					VipModel.GetInstance().Fire(VipModel.OPEN_VIEW, "RechargeView")
				}
			}
				, this, true)
			this.BindEvent(model, local_FirstRechargeModel.UPDATE_FIRST_RECHARGE_VIEW, () => {
				this.UpdateView()
				if (cfg_) {
					//this:ShowEffect()
					this.SetButtonRed()
				}
			}
			)
			Util.AddClickEvent(this.Btn1, () => {
				this.ClickView()
				if (selectIndex_ != 1) {
					selectIndex_ = 1
					this.UpdateView()
					this.ShowEffect()
				}
			}
				, this, true)
			Util.AddClickEvent(this.Btn2, () => {
				this.ClickView()
				if (selectIndex_ != 2) {
					selectIndex_ = 2
					this.UpdateView()
					this.ShowEffect()
				}
			}
				, this, true)
			Util.AddClickEvent(this.Btn3, () => {
				this.ClickView()
				if (selectIndex_ != 3) {
					selectIndex_ = 3
					this.UpdateView()
					this.ShowEffect()
				}
			}
				, this, true)
			this.BindEvent(model, local_FirstRechargeModel.RECEVIED_SUCCESS, (index?) => {
				if (index) {
					selectIndex_ = index == 3 && 3 || index + 1
					this.UpdateView()
					this.ShowEffect()
				}
			}
			)

			if (this.time_style) {
				Util.AddClickEvent(this.view_ui, () => {
					this.ClickView()
				}, this, false)

				Util.AddClickEvent(this._Viewport1, () => {
					this.ClickView()
				}, this, false)

				this.StartTimer()
			}

			model.Fire(local_FirstRechargeModel.SCMD_REQUEST, 15905)
		}

		this.SetButtonRed = () => {
			let data = model.first_recharge_info
			if (!data) {
				return
			}
			for (let _tmpi in data.reward_list) {
				var vo = data.reward_list[_tmpi]
				let bool = vo.open == 1
				this["red" + vo.index].visible = bool
			}
		}

		this.UpdateView = () => {
			let data = model.first_recharge_info
			if (!data) {
				return
			}
			for (let _tmpi in data.reward_list) {
				var vo = data.reward_list[_tmpi]
				if (vo.index == selectIndex_) {
					state_ = vo.open
					this._img_recharge_red.visible = state_ == 1
					if (state_ == 0) {
						this._lb_recharge.text = "前往充值"
					} else if (state_ == 1) {
						this._lb_recharge.text = "领取"
					} else if (state_ == 4) {
						this._lb_recharge.text = "已领取"
					} else if (state_ == 2) {
						let nextDay = false
						for (let _tmpj in data.reward_list) {
							var vo1 = data.reward_list[_tmpj]
							if (vo1.index == selectIndex_ - 1 && vo1.open == 4) {
								nextDay = true
								break
							}
						}
						if (nextDay) {
							this._lb_recharge.text = "明天可领"
						} else {
							this._lb_recharge.text = "第" + WordManager.NumConvertStage(selectIndex_) + "天可领"
						}
					}else if(state_ == 5 ){
						this._lb_recharge.text = "第" + WordManager.NumConvertStage(selectIndex_) + "天可领"
						let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
						if(open_day == 2 && selectIndex_ == 3) {
							this._lb_recharge.text="明日可领"
						}
					}
					break
				}
			}
			if (!cfg_) {
				return
			}
			let sex = role_mgr.mainRoleInfo.sex
			let str = data.product_id + "@" + sex + "@" + selectIndex_
			let cfg_data = cfg_[str]
			if (!cfg_data) {
				return
			}
			let career_reward = JSON.parse(cfg_data.reward)
			let reward = []
			for (let _i = 0; _i < career_reward.length; _i++) {
				var _v = career_reward[_i]
				if (role_mgr.mainRoleInfo.career == Number(_v[0])) {
					reward = _v[1]
				}
			}
			let len = reward.length
			if (!reward_list_) {
				reward_list_ = []
			}
			let index = 0
			if (len > 0) {
				for (let key in reward) {

					let vo = reward[key]
					let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						let item = reward_list_[index]
						if (!item) {
							item = new EquipmentItem(this._gp_reward, null, "Activity")
							reward_list_[index] = item
							item.SetScale(0.7)
							//item.SetUseMask(true)
							if (this.time_style) {
								item.SetClickCallBack(() => {
									this.ClickView()
									item.DefaultCallFun()
								})
							}
							item.Load()
						}
						item.SetVisible(true)
						item.SetData(goods_vo.type_id, vo[2], lock)
						index = index + 1
					}
				}
			}

			//for (let i = 1; i <= reward_list_.length; i++){
			//reward_list_[i].SetVisible(false)
			//}

			for (let j = 1; j <= 3; j++) {
				let bool = selectIndex_ == j
				let text_color = null
				let line_color = null
				let text_size = null
				if (bool) {
					text_color = "'#ffffff'"
					line_color = "'#e76329'"
					text_size = 30
				} else {
					text_color = "'#6b2918'"
					line_color = "'#e3aa60'"
					text_size = 24
				}

				this["select" + j].visible = bool
				// this["_Text" + j].color = text_color
				// this["_Text" + j].strokeColor = line_color
				this["_Text" + j].fontSize = text_size
				this["_img_"+j].scaleX = bool ? 1 : 0.8
				this["_img_"+j].scaleY = bool ? 1 : 0.8
				if(bool){
					if(j==1 ){
						this["_img_"+j ].pos(94,735)
					}else if ( j== 2) {
						this["_img_"+j ].pos(308,802)
					}else{
						this["_img_"+j ].pos(529,735)
					}
				}else{
					if(j==1 ){
						this["_img_"+j ].pos(109,755)
					}else if ( j== 2) {
						this["_img_"+j ].pos(327,811)
					}else{
						this["_img_"+j ].pos(543,755)
					}
				}

			}
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			if(open_day == 2 && model.IsNoFirstRecharge()){
				this._img_1.visible=true
				this._img_2.visible=true
			}else if(open_day>=3 && model.IsNoFirstRecharge()){
				this._img_1.visible=true
				this._img_2.visible=true
				this._img_3.visible=true
			}

		}

		this.ShowEffect = () => {
			if (client_cfg_) {
				let leftmodel, rightmodel
				let career = role_mgr.GetMainRoleVo().career
				let cfg = client_cfg_["view_show"][selectIndex_ + "@" + career]
				this.ClearOld()
				for (let key in cfg) {

					let vo = cfg[key]
					let obj = null
					if ("image" == vo.type) {
						obj = this["_" + vo.obj]
						SetLocalScale(this["_" + vo.obj], vo.scale)
						if (vo.obj == "left" || vo.obj == "right") {
							obj.alpha=1
							ResManager.GetInstance().SetImageSpriteTrans(this, obj, GameResPath.GetIcon("recharge", vo.res_name), true, () => {
								SetAlpha(obj, 1)
							})
						} else {
							// ResManager.GetInstance().SetOutsideImageSprite(this, obj, GameResPath.GetIcon("recharge", vo.res_name), true)
							obj.text = vo.res_name
						}
					} else if ("effect" == vo.type) {
						//obj = this["trans_" + vo.obj]
						//let effect_ref = ResManager.GetInstance().SetUIEffect2(this,vo.res_name, obj, null, vo.scale, vo.is_loop)
						//table.insert(effectList_, obj)
					} else if ("model" == vo.type) {
						obj = this["_" + vo.obj]
						this.ShowModel(obj, vo)
					} else if ("foot" == vo.type) {
						//obj = eui. new Group()
						//obj.height = 0
						//obj.width = 0
						//obj.scaleY = vo.scale
						//obj.scaleX = obj.scaleY
						//this._gp_show.addChild(obj)
						//let fun = (list?) => {
						//if (list ) {
						//let tmp = null
						//let i = list.length
						//do {
						//tmp = list[i]
						//if (tmp && (tmp.figure_type == FigureProtoVo.FigureType.Wing || tmp.figure_type == FigureProtoVo.FigureType.Horse) ) {
						//list:splice(i, 1)
						//}
						//i=i-1
						//} while ((i >= 0))
						//}
						//return list
						//}

						//let main_role = scene.GetMainRole().vo
						//let role_vo = SceneManager.GetInstance().CreateRoleVo()
						//role_vo.role_id = main_role.role_id
						//role_vo.sex = main_role.sex
						//role_vo.career = main_role.career
						//role_vo.pos_x = 0
						//role_vo.pos_y = 0
						//role_vo.fashion_model_list = local_Util.DeepCopy(main_role.fashion_model_list)
						//role_vo.level_model_list = local_Util.DeepCopy(main_role.level_model_list)
						//role_vo.figure_list = fun(local_Util.DeepCopy(main_role.figure_list))
						//role_vo.revelation_suit = 0
						//role_vo.force_show_foot_effect = true
						//role_vo.foot_effect_scale =  new Vector2(1.4, 1.4)
						//role_vo.dress_list = [{dress_type:DressType.Foot, dress_id:vo.res}]
						//local_GlobalEventSystem:Fire(local_SceneEventType.UIROLE_VO_ADD, role_vo, obj, obj)
					} else if ("head" == vo.type) {
						// obj = this["trans_" + vo.obj]
						// SetLocalScale(this["trans_" + vo.obj], vo.scale)
						// this.head = new PlayerHead(obj)
						// let roleVo = role_mgr.GetMainRoleVo()
						// this.head.setData(null, roleVo.sex, roleVo.picture, false, null, vo.res_name)
						// this.head.Load()
					} else if ("text" == vo.type) {
						if (vo.obj == "title") {

							this["_head"].style.fontSize = 22
							this["_head"].style.valign = "center"
							this["_head"].style.color = "#ffffff"
							this["_head"].width = 500
							this["_head"].innerHTML = Util.StrToHTML(vo.res_label)
							this.head_gp.refresh()

							SetSizeDeltaX(this["_" + vo.obj], vo.width)
						}
					}


					//this["trans_" + vo.obj].anchoredPosition = Vector2(vo.x, vo.y)
					if (vo.z) {
						//SetLocalPositionZ(this["trans_" + vo.obj], vo.z)
					}

					if (vo.float) {
						this["_left"].y=200
						this["_right"].y=200
						let tween_obj = SYTweenLite.to(this, this["_" + (vo.obj)], SYTweenLite.UiAnimationType.POSY, this.tween_pos+ 15, 2, null, SYTweenFunc.PINGPONG, true)
						table.insert(floatList_, tween_obj)
					}
				}
			}
			let image = this._mright.getChildAt(0) as Laya.Image
			if (image) {
				image.x = -75
			}
		}

		this.ShowModel = (parent, vo) => { //type, res, ui_scale, pos, action_name_list
			this.mainVo = RoleManager.GetInstance().GetMainRoleVo()

			let head_wear_id, head_texture_id
			if(vo.model_type == UI_MODEL_TYPE.ROLE){
				[head_wear_id, head_texture_id] = this.mainVo.GetRoleHeadId()
				head_wear_id=model_head[role_mgr.GetMainRoleVo().career-1] 
				head_texture_id = 0
			}

			let action_name_list = Util.DeepCopy(vo.action_name_list)
			let default_state = action_name_list[vo.action_name_list.length - 1]
			//第一次展示过后，切界面只显示默认动作
			if(this.init_model_dic[vo.obj]){
				action_name_list = [default_state]
			}

			this.init_model_dic[vo.obj] = true

			let data = {
				type: vo.model_type,
				clothe_res_id: vo.res,
				position: { x: vo.x, y: vo.y },
				scale: vo.scale,
				action_name_list: action_name_list,
				can_rotate: false,
				default_state: default_state,
				head_wear_id: head_wear_id,
				head_clothe_id: head_texture_id,
				layout_file: "FirstRechargeView"
			}
			ResManager.GetInstance().SetRoleModel(this, parent, data)
			parent.alpha = 1
		}

		this.ClearModel = () => {

		}

		this.ClearOld = () => {
			this.ClearModel()

			for (let k in effectList_) {
				var obj = effectList_[k]
				if (obj) {
					//ResManager.GetInstance().ClearParentUIEffect(this, obj)
				}
			}
			effectList_ = []

			for (let _tmpi in floatList_) {
				var obj = floatList_[_tmpi]
				if (obj) {
					SYTweenLite.Stop(obj)
				}
			}
			floatList_ = []
			if (this.head) {
				this.head.DeleteMe()
			}
			this.head = null

			//UI_scene:ClearUIScene()
			//this._gp_show.removeChildren()

			//lua_resM:SetRawImage(this,this._left,"common_asset","com_empty")
			//lua_resM:SetRawImage(this,this._right,"common_asset","com_empty")
			// this._left.y = 150
			// this._right.y = 150
			SetAlpha(this._left, 0)
			SetAlpha(this._right, 0)
			SetLocalScale(this._left, 1)
			SetLocalScale(this._right, 1)

			SetAlpha(this._mleft, 0)
			SetAlpha(this._mright, 0)

			//ResManager.GetInstance().SetImageSprite(this, this._down, "common_asset", "com_empty")
		}

	}

	public StartTimer() {

		//确保是倒计时模式
		if (!this.time_style) {
			return
		}

		this.CancelTimer()
		if (!this.timer) {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigFirstRecharge", true)
			this.etime = cfg.tips_close_time + TimeUtil.getServerTime()
			this.timer = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnTimer()
			}, 1, -1)
			this.OnTimer()
		}
	}

	public OnTimer() {

		if (this.use_delete_method || this._time == undefined) {
			return
		}
		let time = this.etime - TimeUtil.getServerTime()
		if (time >= 0) {
			this._time.text = time + "秒后关闭界面"
		} else {
			this._time.text = ""
			this.CancelTimer()
			this.Close()
		}
	}

	public CancelTimer() {

		if (this.timer) {
			GlobalTimerQuest.CancelQuest(this.timer)
			this.timer = null
			this._time.text = ""
		}
	}

	public ClickView() {

		if (this.time_style) {
			this.CancelTimer()
		}
	}

	public Open(_style?) {

		if (_style) {
			this.time_style = _style
		}
		super.Open()
	}


	public GetComponents() {
		[
			this._img_bg,
			this.view_ui,
			this.bg1,
			this.bg2,
			this.bg3,
			this._gp_reward,
			this._gp_show,
			this._title,
			this._head,
			this._img_l,
			this._img_r,
			this._desc_left,
			this._desc_right,
			this._gp_behindL,
			this._left,
			this._gp_behindR,
			this._right,
			this._gp_recharge,
			this._Image1,
			this._lb_recharge,
			this._img_recharge_red,
			this._img_close,
			this.Btn1,
			this._Image2,
			this.select1,
			this._Text1,
			this.red1,
			this.Btn2,
			this._Image4,
			this.select2,
			this._Text2,
			this.red2,
			this.Btn3,
			this._Image6,
			this.select3,
			this._Text3,
			this.red3,
			this._mleft,
			this._mright,
			this._time,
			this.head_gp,
			this._lb_name_r,
			this._lb_name_l,
			this._img_1,
			this._img_2,
			this._img_3,
			this._bg_effect
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"view_ui",
				"bg1",
				"bg2",
				"bg3",
				"_gp_reward",
				"_gp_show",
				"_title",
				"_head",
				"_img_l",
				"_img_r",
				"_desc_left",
				"_desc_right",
				"_gp_behindL",
				"_left",
				"_gp_behindR",
				"_right",
				"_gp_recharge",
				"_Image1",
				"_lb_recharge",
				"_img_recharge_red",
				"_img_close",
				"Btn1",
				"_Image2",
				"select1",
				"_Text1",
				"red1",
				"Btn2",
				"_Image4",
				"select2",
				"_Text2",
				"red2",
				"Btn3",
				"_Image6",
				"select3",
				"_Text3",
				"red3",
				"_mleft",
				"_mright",
				"_time",
				"head_gp",
				"_lb_name_r",
				"_lb_name_l",
				"_img_1",
				"_img_2",
				"_img_3",
				"_bg_effect"
			])
	}
}
window["FirstRechargeView"] = FirstRechargeView
