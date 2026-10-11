import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager";
import { GoodsModel } from "../commonModel/GoodsModel"
import { SevenDayModel } from "../commonModel/SevenDayModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ResManager } from "../common/ResManager"
import { Message } from "../sysInfo/SysInfoController"
import { Split, SetSizeDeltaX, SetSizeDeltaY, SetLocalScale, Trim, SetAnchoredPosition, Util } from "../util/Util"
import { SYTweenLite } from "../util/SYTweenLite"
import { GameResPath } from "../util/GameResPath"
import { ErlangParser } from "../util/ErlangParser"
import { LuaSoundManager } from "../common/SoundManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { EquipmentItem } from "../common/EquipmentItem"
import { table } from "../common/table"
import { SevenDayItem } from "../sevenDay/SevenDayItem"
import { SevenEightDayItem } from "../sevenDay/SevenEightDayItem"
import { SevenMergeItem } from "../sevenMergeDay/SevenMergeItem";
//import { SevenMergeItem } from "../sevenMergeDay/SevenMergeItem"


export class SevenDayView extends BaseView1 {
	_Group2: Laya.Box
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_btn_claim: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_img_close: Laya.Image
	_scl_reward: Laya.Panel
	Content: Laya.HBox
	_gp_tab: Laya.HBox
	_gp_effect1: Laya.Box
	_gp_model_effect: Laya.Box
	_Group1: Laya.Box
	_img_model: Laya.Image
	_gp_model: Laya.Box
	_gp_effect2: Laya.Box
	_img_red: Laya.Image
	img_reward_name: Laya.Image
	_Image2: Laya.Image
	_lb_title: Laya.Label
	_img_day: Laya.Image
	bg1: Laya.Image
	_day_text: Laya.Label
	model_img: Laya.Image
	receive_img
	day_img
	_img_title
	_lb_day
	_lb_name
	login_day



	Clear
	ClearModel
	ClearTween
	CreateAwardItem
	CreateRewardScroller
	Emp_btn_claim
	GetIndexByDayID
	ImgModelAnimation
	InitEvent
	InitTabIcon
	InitView
	Scr_scl_reward
	SetClaimBut
	SetType
	ShowModel
	ShowRewardModel
	ShowSevenDayTab
	ShwoCurDayInfo
	SetMergerData

	_gp_reward
	destroy_callback
	destroy_imm
	is_center
	is_lastView_close
	not_show_main_msg
	open_callback
	tween_id
	use_background




	AddPreLoadList
	RegisterMask
	AddCurrLayerSortingOrder

	public constructor() {
		super()


		this.base_file = "sevenDay"
		this.layout_file = "SevenDayView"
		this.use_background = true
		this.is_center = true
		this.layer_value = Enum_UILayer.Activity
		this.not_show_main_msg = true
		this.is_lastView_close = true
		let local_SevenDayModel = SevenDayModel
		let model = local_SevenDayModel.GetInstance()
		let local_GoodsModel = GoodsModel.GetInstance()
		let local_RoleManager = RoleManager.GetInstance()
		let local_ResManager = ResManager.GetInstance()
		let sevenDay_Tab_list = []
		let select_day_id = null
		let reward_status = null
		let awarditem_list = []
		let info = null
		let icon_list = []
		let cur_reward_list = []
		let i_type = null
		let day_type = null
		let view_type = null
		let local_Number = Number
		let local_Message = Message
		let cur_sorting_order = null

		this.destroy_imm = true
		let location_y

		this.preload_server_config = {
			"config_login_reward_day": false,
			"config_login_merge_reward_day": false
		}

		this.load_callback = () => {
			//this.GetComponents()
			//this.RegisterMask(this._gp_reward, 1)
			//location_y =  this._img_model.anchoredPosition.y
			this._scl_reward.hScrollBar.visible = false
		}

		this.open_callback = () => {
			//location_y =  this._img_model.anchoredPosition.y
			//cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			this.InitEvent()
			this.InitView()
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.SetType = (_type?) => {
			if (_type && typeof (_type) == "string") {
				// [ts2lua]local_SevenDayModel.typeToView下标访问可能不正确
				view_type = local_SevenDayModel.typeToView[_type]
				let arr = Split(_type, "@")
				if (arr) {
					i_type = local_Number(arr[0])
					day_type = local_Number(arr[1])
				}
			}
		}

		this.InitView = () => {
			if (i_type == null) {
				return
			}
			let bg_url = null
			let effect1 = null
			let bg_width = null
			let bg_height = null
			if ("SevenDayView" == view_type) {
				bg_url = GameResPath.GetIcon("sevenDay", "uiqrdl_001")
				bg_width = 680
				bg_height = 720
				this.AddUIEffect("ui_fazhen_05", this._gp_effect2, { x: 0, y: -2.5 }, 3.5, true)
				effect1 = "UI_1201"
				local_ResManager.SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("sevenDay", "uiqrdl_011"), true)
				local_ResManager.SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("sevenDay", "ui_gift_02"), true)
			} else if ("SevenEightDayView" == view_type) {
				bg_url = GameResPath.GetIcon("sevenDay", "uiqtdlhl_001")
				// bg_width = 706
				// bg_height = 1006
				local_ResManager.SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("sevenDay", "ui_gift_02"), true)
				local_ResManager.SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("sevenDay", "uiqtdlhl_002"), true)
				effect1 = "UI_1201"
			} else if ("SevenMergeView" == view_type) {
				bg_width = 720
				bg_height = 808
				bg_url = GameResPath.GetIcon("sevenMergeDay", "uihfqrhl_001")
				local_ResManager.SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("sevenMergeDay", "uihfqrhl_002"), true)
			}
			if (effect1) {
				// let data = {
				// 	//custom_sorting_order = cur_sorting_order,
				// 	load_call_back =() => {
				// 		// this.CoverEffect(this._img_model, this.layer_value, cur_sorting_order + 1)
				// 		// this.CoverEffect(this.img_reward_name, this.layer_value, cur_sorting_order + 1)
				// 		// this.CoverEffect(this._Image2, this.layer_value, cur_sorting_order + 1)
				// 		// this.CoverEffect(this._img_day, this.layer_value, cur_sorting_order + 1)
				// 	}
				// }
				//this.AddUIEffect(effect1, this.layer_value, this._gp_effect1, null, null, true, data)
			}
			local_ResManager.SetOutsideImageSprite(this, this._img_bg, bg_url, false, () => {
				if (bg_width) {
					//this._img_bg.width = bg_width
					SetSizeDeltaX(this._img_bg, bg_width)
				}
				if (bg_height) {
					//this._img_bg.height = bg_height
					SetSizeDeltaY(this._img_bg, bg_height)
				}
			}
			)
			info = model.GetInfoByOpenType(i_type, day_type)
			if (!info) {
				return
			}
			reward_status = info.reward_status
			this.InitTabIcon()
			this.ShowSevenDayTab()
			this.ShwoCurDayInfo()
		}

		this.InitTabIcon = () => {
			let status = info.reward_status
			if (!status) {
				return
			}
			for (let i in status) {

				let day_id = status[i].day_id
				let cfg_name = i_type == local_SevenDayModel.act_type.open && "config_login_reward_day" || "config_login_merge_reward_day"
				let cfgs = local_ResManager.GetGameConfigFromCache(this, cfg_name, false)
				if (!cfgs) {
					return
				}
				if (i_type == local_SevenDayModel.act_type.merge) {
					let cfg_merge = this.SetMergerData(cfgs)
					cfgs = Util.DeepCopy(cfg_merge)
				}

				let cfg = cfgs[day_id]
				if (cfg && cfg.reward_list) {
					let _list = cfg.reward_list
					if (typeof (_list) == "string") {


						_list = JSON.parse(_list)
					}
					if (_list.length > 1) {
						let career = local_RoleManager.mainRoleInfo.career - 1
						_list = _list[career] && _list[career][1]
					}
					if (_list && _list.length > 0) {
						cur_reward_list[day_id] = _list
						icon_list[day_id] = _list[0]
					}
				}
			}
		}

		this.InitEvent = () => {
			let close_callback = () => {
				this.Close()
			}

			Util.AddClickEvent(this._img_close, close_callback, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			this.BindEvent(model, local_SevenDayModel.SELECT_DAY, (bool?, day_id?, _type?) => {
				if (i_type == _type) {
					select_day_id = day_id
					this.ShwoCurDayInfo()
				}
			}
			)
			let update_view = (_type?) => {
				if (i_type != _type) {
					return
				}
				if (!info) {
					this.InitView()
					return
				}
				info = model.GetInfoByOpenType(i_type, day_type)
				if (!info) {
					return
				}
				reward_status = info.reward_status
				this.ShowSevenDayTab()
				this.ShwoCurDayInfo()
				this.SetClaimBut()
			}

			this.BindEvent(model, local_SevenDayModel.UPDATE_VIEW, update_view)
			let claim_callback = () => {
				let index = this.GetIndexByDayID()
				// [ts2lua]reward_status下标访问可能不正确
				if (reward_status && reward_status[index]) {
					if (0 == reward_status[index].status) {
						let content = "再登录" + (select_day_id - info.current_day) + "天即可领取"
						local_Message.show(content)
					} else if (1 == reward_status[index].status) {
						//let v = 
						//table.insert(v, )
						let scmd = 17501
						if (i_type == local_SevenDayModel.act_type.merge) {
							scmd = 17503
						}
						model.Fire(local_SevenDayModel.REQUEST_SCMD, scmd, select_day_id)
						//UserMsgAdapter:GetInstance():SendAllFmtToGame(scmd, "c", )
					} else if (2 == reward_status[index].status) {
						local_Message.show("已领取过该奖励")
					}
				}
				// [ts2lua]reward_status下标访问可能不正确
			}


			Util.AddClickEvent(this._btn_claim, claim_callback, this, true)
		}

		this.ShwoCurDayInfo = () => {
			if (!select_day_id) {
				return
			}
			if ("SevenDayView" == view_type) {
				//ResManager.GetInstance().SetImageSprite(this, this._img_day, "sevenDay_asset", "b" + select_day_id, true)
				//this._day_text.text = "第" + select_day_id + "天"
				ResManager.GetInstance().SetImageSprite(this, this.day_img, "sevenDay_asset", "day" + select_day_id, true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.img_reward_name, GameResPath.GetIcon("sevenDay", "t" + select_day_id), true)
				//this._img_day.source = "sevenDay_asset.b" + select_day_id + ""
				//this._reward_name.source = "sevenDay_asset.t" + select_day_id + ""
				// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				// 	this._lb_title.text = "Day " + select_day_id + " login reward"
				// } else if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
				// 	this._lb_title.text = "รางวัลล็อกอินวันที่" + select_day_id
				// } else if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				// 	this._lb_title.text = "Login ke " + select_day_id + " utk ambil hadiah"
				// } else {
				this._lb_title.text = "登录第" + select_day_id + "天奖励"
				this.model_img.visible = select_day_id == 5
				//}
			} else if ("SevenEightDayView" == view_type) {
				let index = this.GetIndexByDayID()
				//this._img_day.source = "sevenDay_asset.uiqtdlhl_007_" + index + ""
				ResManager.GetInstance().SetImageSprite(this, this._img_day, "sevenDay_asset", "uiqtdlhl_007_" + (index + 1), true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.img_reward_name, GameResPath.GetIcon("sevenDay", "uiqtdlhl_005_" + (index + 1)), true)
			} else if ("SevenMergeView" == view_type) {
				let index = this.GetIndexByDayID()
				// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				// 	this._lb_day.text = index + "d"
				// } else if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				// 	this._lb_day.text = index
				// } else {
				this._lb_day.text = "第" + (index + 1) + "天"
				this.login_day.text = `第${index + 1}天奖励`
				//}
				//this.img_reward_name.source = "sevenMergeDay_asset.uihfqrhl_0" + index + ""
				let cfg_name = i_type == local_SevenDayModel.act_type.open && "config_login_reward_day" || "config_login_merge_reward_day"
				let cfg = local_ResManager.GetGameConfigFromCache(this, cfg_name, false)
				if (!cfg) {
					return
				}
				let cfg_merge = this.SetMergerData(cfg)
				cfg = Util.DeepCopy(cfg_merge)
				let resource = cfg && cfg[(index + 1)] && cfg[(index + 1)].resource_id2 ? cfg[(index + 1)].resource_id2 : "uihfqrhl_0" + (index + 1)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.img_reward_name, GameResPath.GetIcon("sevenMergeDay", resource), true)
			}
			this.SetClaimBut()
			this.CreateRewardScroller()
			this.ShowRewardModel()
		}

		this.ShowRewardModel = () => {
			let cfg_name = i_type == local_SevenDayModel.act_type.open && "config_login_reward_day" || "config_login_merge_reward_day"
			let cfg = local_ResManager.GetGameConfigFromCache(this, cfg_name, false)
			if (!cfg) {
				return
			}
			if (i_type == local_SevenDayModel.act_type.merge) {

				let cfg_merge = this.SetMergerData(cfg)
				cfg = Util.DeepCopy(cfg_merge)
			}
			// [ts2lua]cfg下标访问可能不正确
			let cur_day_cfg = cfg[select_day_id]
			if (!cur_day_cfg) {
				return
			}
			this.ClearModel()
			this.ClearUIEffect(this._gp_model_effect)
			//this:ClearTween()

			if ("SevenDayView" == view_type) {
				if (select_day_id == 5) {
					ResManager.GetInstance().SetImageSprite(this, this.model_img, "sevenDay_asset", Trim(cur_day_cfg.resource_id), true)
					this.model_img.scaleX = this.model_img.scaleY = 0.5
				}
				// if (select_day_id == 3)
				// 	this.model_img.scaleX = this.model_img.scaleY = 2
				// else if (select_day_id == 5)
				// 	
			}
			if (cur_day_cfg.show_type == 2) {
				this._img_model.visible = false
				this.ShowModel(cur_day_cfg.resource_id)
			} else if (cur_day_cfg.show_type == 3) {
				this._img_model.visible = false
				let scale = { x: 1, y: 1 }
				if (view_type == "SevenMergeView") {
					scale = { x: 0.8, y: 0.8 }
				}
				// let data = {
				// 	//custom_sorting_order = cur_sorting_order,
				// 	load_call_back = () => {
				// 		// this.CoverEffect(this._img_model, this.layer_value, cur_sorting_order + 1)
				// 		// this.CoverEffect(this.img_reward_name, this.layer_value, cur_sorting_order + 1)
				// 		// this.CoverEffect(this._Image2, this.layer_value, cur_sorting_order + 1)
				// 		// this.CoverEffect(this._img_day, this.layer_value, cur_sorting_order + 1)
				// 	}
				// }
				this._gp_model_effect.width = 720
				this._gp_model_effect.height = 1280
				let scale11 = 1
				this._gp_model_effect.centerY = -208
				if (select_day_id == 4)
					scale11 = 1.5
				else if (select_day_id == 3)
					this._gp_model_effect.centerY = -188
				else if (select_day_id == 5)
					this._gp_model_effect.centerY = -190
				this.AddUIEffect(Trim(cur_day_cfg.resource_id), this._gp_model_effect, null, scale11, true)

			} else {
				if (view_type == "SevenEightDayView") {
					//SetLocalScale(this._img_model, 0.6, 0.6, 1)
				}
				if (!location_y) {
					location_y = this._img_model.y
					// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
					// 	if (view_type == "SevenMergeView") {
					// 		SetLocalScale(this._img_model, 0.6, 0.6, 1)
					// 		location_y = location_y + 136
					// 		SetAnchoredPositionY(this._img_model, location_y)
					// 	}
					// }
				}
				this._img_model.visible = true
				local_ResManager.SetOutsideImageSprite(this, this._img_model, GameResPath.GetIcon("sevenDay", Trim(cur_day_cfg.resource_id)), true)
				this.ImgModelAnimation()
			}
		}

		this.ImgModelAnimation = () => {
			if (!this.tween_id) {
				if (location_y) {
					let off_y = view_type == "SevenMergeView" ? 20 : 30
					this.tween_id = SYTweenLite.to(this, this._img_model, SYTweenLite.UiAnimationType.POSY, location_y - off_y, 2.2, null, SYTweenFunc.PINGPONG, true)
				}
			}
		}

		this.ShowModel = (model_id?) => {
			model_id = JSON.parse(model_id)
			CustomActivityModel.GetInstance().ShowViewModel(this, "SevenDayView", model_id, this._gp_model)
			//let _cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// this.CoverMode(this.img_reward_name, this.layer_value, cur_sorting_order + 1)
			// this.CoverMode(this._Image2, this.layer_value, cur_sorting_order + 1)
			// this.CoverMode(this._img_day, this.layer_value, cur_sorting_order + 1)
		}

		this.SetClaimBut = () => {
			if (!this._btn_claim) {
				return
			}
			let label: Laya.Text = <Laya.Text>this._btn_claim.getChildAt(1)
			let img: Laya.Image = <Laya.Image>this._btn_claim.getChildAt(2)
			let label_stroke = label.strokeColor
			let image: Laya.Image = <Laya.Image>this._btn_claim.getChildAt(0)
			let index = this.GetIndexByDayID()
			// [ts2lua]reward_status下标访问可能不正确
			let cur_day = reward_status && reward_status[index]
			if (cur_day) {
				switch (cur_day.status) {
					case 0:
						if ("SevenDayView" == view_type) {
							label.text = "未达成"
							label_stroke = "#909090"
							//Util.SetImageGray(image, true)
							ResManager.GetInstance().SetImageSprite(this, img, "sevenDay_asset", "notreceive", true)
							image.gray = true
						} else if ("SevenMergeView" == view_type) {
							let day = cur_day.day_id - info.current_day
							if (day == 1) {
								label.text = "明天可领"
							} else {
								label.text = day + "天后领取"
							}
							//Util.SetImageGray(image, true)
							//image.gray = true
						} else if ("SevenEightDayView" == view_type) {
							let day = cur_day.day_id - info.current_day
							if (day == 1) {
								label.text = "明天可领"
							} else {
								label.text = day + "天后领取"
							}
						}
						this._img_red.visible = false
						break;

					case 1:
						if ("SevenDayView" == view_type) {
							label.text = "领取"
							label_stroke = "#81aa33"
							//Util.SetImageGray(image, false)
							if (img)
								ResManager.GetInstance().SetImageSprite(this, img, "sevenDay_asset", "receive", true)
							image.gray = false
						} else if ("SevenEightDayView" == view_type) {
							label.text = "立即领取"
						} else if ("SevenMergeView" == view_type) {
							label.text = "领取"
							label_stroke = "#b91a0c"
							//Util.SetImageGray(image, false)
							image.gray = false
						}
						this._img_red.visible = true
						break;
					case 2:
						if ("SevenDayView" == view_type) {
							label_stroke = "#909090"
							//Util.SetImageGray(image, true)
							image.gray = true
						} else if ("SevenMergeView" == view_type) {
							// label_stroke = "#909090"
							// //Util.SetImageGray(image, true)
							// image.gray = true
						}
						label.text = "已领取"
						if (img)
							ResManager.GetInstance().SetImageSprite(this, img, "sevenDay_asset", "received", true)
						this._img_red.visible = false
						break;


				}
			}
			if (label_stroke)
				label.strokeColor = label_stroke
		}

		this.CreateAwardItem = (good_cfg?, good_num?, index?, lock?) => {
			// [ts2lua]awarditem_list下标访问可能不正确
			let item = awarditem_list[index]
			if (!item) {
				item = new EquipmentItem(this.Content, null, this.layer_value)
				// item.SetCacheSortOrder(cur_sorting_order)
				// item.SetMaskId(1)
				item.Load()
				if ("SevenDayView" == view_type) {
					item.SetItemSize(80, 80)
				} else if ("SevenEightDayView" == view_type) {
					item.SetScale(0.7)
				} else if ("SevenMergeView" == view_type) {
					item.SetScale(0.7)
				}
				table.insert(awarditem_list, item)
			}
			else
				item.ChangeCountVisible(true)
			item.SetData(good_cfg.type_id, good_num, lock)
			item.ExcuteCallback(() => {

				//item.includeInLayout = 
				item.SetVisible(true)
			}
			)
		}
		this.SetMergerData = (cfg) => {
			let data = {}
			let merge_wlv = (info && info.merge_wlv) ? info.merge_wlv : 1
			for (let key in cfg) {
				let vo = cfg[key]
				if (vo.merge_wlv <= merge_wlv && vo.merge_wlv2 >= merge_wlv) {
					data[vo.day_id] = vo
				}
			}
			return data
		}

		this.CreateRewardScroller = () => {
			if (!this.Content) {
				return
			}
			//this._scl_reward.viewport.scrollH = 77
			//this._scl_reward.viewport.validateNow()
			//this.Content.viewport.scrollH = 0
			//SetAnchoredPosition(this.Content, 0, this.Content.y)
			// [ts2lua]lua中0和空字符串也是true，此处type == local_SevenDayModel.act_type.open需要确认
			let cfg_name = i_type == local_SevenDayModel.act_type.open && "config_login_reward_day" || "config_login_merge_reward_day"
			let cfg = local_ResManager.GetGameConfigFromCache(this, cfg_name, false)
			if (!cfg) {
				return
			}
			if (i_type == local_SevenDayModel.act_type.merge) {

				let cfg_merge = this.SetMergerData(cfg)
				cfg = Util.DeepCopy(cfg_merge)
			}
			// [ts2lua]cfg下标访问可能不正确
			let cur_day_cfg = cfg[select_day_id]
			if (!cur_day_cfg) {
				return
			}
			let cur_raward_list = JSON.parse(cur_day_cfg.reward_list)
			let index = 0
			// [ts2lua]cur_raward_list下标访问可能不正确
			let raward_list = cur_raward_list[local_RoleManager.GetMainRoleVo().career - 1][1]
			if (awarditem_list.length > 0) {
				let i = 0
				do {
					awarditem_list[i].SetVisible(false)
					i = i + 1
				} while ((i < awarditem_list.length))
			}
			if (!raward_list) {
				return
			}
			let need_index = 0
			for (let i in raward_list) {

				let raward = raward_list[i]
				if (!raward) {
					return
				}
				let [type_id, lock] = local_GoodsModel.GetMappingTypeId(raward[0], raward[1])
				let good_cfg = local_GoodsModel.GetGoodsBasicByTypeId(type_id)
				if (!good_cfg) {
					return
				}
				if (local_Number(i) == 0 && this._lb_name) {
					this._lb_name.text = good_cfg.goods_name
				}
				if (good_cfg.max_overlap == 0) {
					let j = 0
					do {
						this.CreateAwardItem(good_cfg, 1, index, lock)
						index = index + 1
						j = j + 1
					} while ((j < local_Number(raward[2])))
				} else {
					this.CreateAwardItem(good_cfg, raward[2], index, lock)
					index = index + 1
				}
				need_index++
				if (need_index >= 4) break
			}
		}

		this.ShowSevenDayTab = () => {
			let index = 0
			if (sevenDay_Tab_list.length > 0) {
				if (select_day_id > 0) {
					let index = this.GetIndexByDayID()
					// [ts2lua]sevenDay_Tab_list下标访问可能不正确
					sevenDay_Tab_list[index].SetSelect(false)
					select_day_id = 0
				}
			}
			for (let _tmpi in reward_status) {
				var v = reward_status[_tmpi]
				if (v.status == 1) {
					select_day_id = v.day_id
					break
				}
			}
			if (!select_day_id || select_day_id == 0) {
				for (let _tmpi in reward_status) {
					var v = reward_status[_tmpi]
					if (v.status == 0) {
						select_day_id = v.day_id
						break
					}
				}
			}
			if ((!select_day_id || select_day_id == 0) && reward_status && reward_status[0]) {
				select_day_id = reward_status[0].day_id
			}
			let _class = null
			if ("SevenDayView" == view_type) {
				_class = SevenDayItem
			} else if ("SevenEightDayView" == view_type) {
				_class = SevenEightDayItem
			} else if ("SevenMergeView" == view_type) {
				_class = SevenMergeItem
			}
			for (let i in reward_status) {

				let tab_view = null
				let v = reward_status[i]
				// [ts2lua]sevenDay_Tab_list下标访问可能不正确
				tab_view = sevenDay_Tab_list[local_Number(i)]
				if (!tab_view) {
					tab_view = new _class(this._gp_tab)
					tab_view.Load()
					table.insert(sevenDay_Tab_list, tab_view)

				}
				tab_view.ExcuteCallback(() => {
					// [ts2lua]icon_list下标访问可能不正确
					if (view_type == "SevenMergeView") {
						let radius = 330
						let add_angle = reward_status.length - (local_Number(i) + 1) * 18.8
						let off_x = 0
						let off_y = 0
						switch (local_Number(i)) {
							case 1:
								off_y = 6
								break;
							case 2:
								off_y = 10
								break;
							case 3:
								off_y = 7
								break;
							case 4:
								off_x = -10
								off_y = 5
								break;
							case 5:
								off_x = -15
								off_y = 5
								break;
							case 6:
								off_x = -14

								break;
						}
						let angle = 65 + add_angle
						let radians = angle * Math.PI / 180
						SetAnchoredPosition(tab_view.display_obj, -radius * Math.sin(radians) + off_x, radius * Math.cos(radians) + off_y)

					}
					tab_view.SetData(v, icon_list[v.day_id], i_type, info.current_day, day_type, view_type)
					if (select_day_id == v.day_id) {
						tab_view.SetSelect(true)
					}

				})
			}
		}

		this.GetIndexByDayID = () => {
			if (!select_day_id) {
				return
			}
			if (day_type == 0) {
				return select_day_id - 1
			}
			if (day_type > 0) {
				return select_day_id - day_type * model.limit_day
			}
		}

		this.ClearModel = () => {
			ResManager.GetInstance().ClearRoleMode(this.hashCode)
		}

		this.ClearTween = () => {
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
				this.tween_id = null
			}
		}

		this.Clear = () => {
			this.ClearTween()
			for (let _tmpi in sevenDay_Tab_list) {
				var tab = sevenDay_Tab_list[_tmpi]
				tab.DeleteMe()
			}
			sevenDay_Tab_list = []
			for (let _tmpi in awarditem_list) {
				var item = awarditem_list[_tmpi]
				item.DeleteMe()
			}
			awarditem_list = []
		}
	}



	public GetComponents() {
		[
			this._Group2,
			this._img_bg,
			this._Image1,
			this._btn_claim,
			this._Image11,
			this.labelDisplay,
			this._img_close,
			this._scl_reward,
			this.Content,
			this._gp_tab,
			this._gp_effect1,
			this._gp_model_effect,
			this._Group1,
			this._img_model,
			this._gp_model,
			this._gp_effect2,
			this._img_red,
			this.img_reward_name,
			this._Image2,
			this._lb_title,
			this._img_day,
			this.bg1,
			this._day_text,
			this.receive_img,
			this.day_img,
			this.model_img
		]
			= this.GetChildrenByNames([

				"_Group2",
				"_img_bg",
				"_Image1",
				"_btn_claim",
				"_Image11",
				"labelDisplay",
				"_img_close",
				"_scl_reward",
				"Content",
				"_gp_tab",
				"_gp_effect1",
				"_gp_model_effect",
				"_Group1",
				"_img_model",
				"_gp_model",
				"_gp_effect2",
				"_img_red",
				"img_reward_name",
				"_Image2",
				"_lb_title",
				"_img_day",
				"bg1",
				"_day_text",
				"receive_img",
				"day_img",
				"model_img"
			])
	}
}
window["SevenDayView"] = SevenDayView