import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { BrightSeaEvent, BrightSeaModel } from "../commonModel/BrightSeaModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetAnchoredPositionY, GlobalTimerQuest } from "../util/Util"
import { BrightSeaBattleResultItem } from "./BrightSeaBattleResultItem"

export class BrightSeaBattleResultView extends BaseView1 {
	CancelTime
	InitEvent
	LoadSuccess
	OnTime
	Remove
	StartTime
	UpdateView
	aer_item
	award_item_list
	cache_sort_order
	click_bg_toClose
	der_item
	destroy_callback
	destroy_imm
	is_center
	left_time
	not_show_main_msg
	open_callback
	rank_change
	time_event_id
	time_list
	use_background
	wx_share_tips
	_end_time
	public constructor() {
		super()

		this.base_file = "brightSea"
		this.layout_file = "BrightSeaBattleResultView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.preload_server_config = { "config_sea_treasure_kv": false }
		this.left_time = 10
		this.not_show_main_msg = true
		this.award_item_list = null
		this.time_event_id = null
		this.rank_change = null
		this.wx_share_tips = null
		this._end_time = null
		this.time_list = []
		let voice
		let model = BrightSeaModel.GetInstance()
		//let friend_invite_model = FriendInviteModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let local_TimeUtil = TimeUtil
		let scene_mgr = SceneManager.GetInstance()

		let has_reward = false

		this.load_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}

			if (scene_mgr.IsBrightSeaScene()) {
				model.Fire(BrightSeaEvent.REQUEST_PROTO, 18918)
			}
			this.Remove()
		}

		this.open_callback = () => {
			//this.cache_sort_order = this.AddCurrLayerSortingOrder(this.layer_value)

			this.UpdateView()
		}

		this.LoadSuccess = () => {
			this._Scroller1.hScrollBarSkin = ""
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._ok_btn, () => {
				//if (! has_reward || ! model.result_info ) { 
				//	return 
				//}

				//if (model.result_info.reward && next(model.result_info.reward) ) {
				//	let rewardsList = GoodsModel.RewardKeyToNumber(model.result_info.reward)
				//	let view =  new CongratulationObtainView(rewardsList, 10)
				//	view.Open()
				//}
				this.Close()
			}, this, true)
		}

		this.UpdateView = () => {
			//1\复仇成功 2\复仇失败  3\掠夺成功  4\掠夺失败
			let state = 0
			let data = model.result_info
			//let data = this.GetTestData()
			if (data) {
				let result = data.res == 1
				let is_plunderer = data.battle_type == 1
				let is_this = data.be_helper_id == role_mgr.GetMainRoleId() || data.be_helper_id == null
				this._img_win_reward.visible = result
				this._img_fail_reward.visible = !result

				let state=result?2:1
				voice=CommonManager.GetInstance().PlayFightingVoice(state)

				if (result) {
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("brightSea", "com_up_bg1"), false)
					//SoundManager:GetInstance():PlaySoundEffect("1_jiesuan")
					
					if (!is_plunderer) {
						if (is_this) {
							//复仇成功
							state = 1
						} else {
							let aer = data.aer[0]
							state = (aer.hp_per || 40) >= 40 && 7 || 8   //大胜||险胜
						}
					}else{
						state = 3//掠夺成功
					}
				} else {
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("brightSea", "com_up_bg2"), false)
				
					if (!is_plunderer) {
						if (is_this) {
							//复仇失败
							state = 2
						} else {
							let hp_cfg_value = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_treasure_kv", false)["back_reward_with_hp"].value
							if (hp_cfg_value) {
								let hp_list = ErlangParser.GetInstance().parse(hp_cfg_value)
								if (hp_list) {
									let low_pre = 1
									for (let _ in hp_list) {
										var info = hp_list[_]
										if (low_pre > Number(info[1])) {
											low_pre = Number(info[1])
										}
									}
									let der = data.der[0]
									state = (der.hp_per || 1) <= low_pre && 6 || 5  //惜败||大败
								}
							}
						}
					}else{
						state = 4  //掠夺失败
					}

					Util.SetImageGray(this._img_vs, !result)
				}
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("brightSea", `ui_bright_title${state}`), true)

				let aer = data.aer
				if (aer) {
					let data = aer[0]
					data.is_win = result
					this.aer_item = new BrightSeaBattleResultItem(this._con_left)
					this.aer_item.SetData(data)
					this.aer_item.Load()
				}

				let der = data.der
				if (der) {
					let data = der[0]
					data.is_win = !result
					this.der_item = new BrightSeaBattleResultItem(this._con_right)
					this.der_item.SetData(data)
					this.der_item.Load()
				}

				this.award_item_list = this.award_item_list || []
				let result_list = data.reward
				if (result_list && result_list.length > 0) {
					has_reward = true
					for (let index in result_list) {
						var vo = result_list[index]
						let item = this.award_item_list[index]
						if (!item) {
							item = new BaseAwardItem(this._gp_reward_con, null, "Activity")
							item.Load()
							item.SetVisible(true)
							table.insert(this.award_item_list, item)
							item.SetItemSize(89, 89)
						}
						let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo.style, vo.typeId)
						let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
						if (goods_vo) {
							item.SetData(goods_vo.type_id, vo.count, lock)
						}
					}
				}
			


				// if (result_list && result_list.length > 0) {
				// 	has_reward = true
				// 	this.award_item_list = this.award_item_list || []
				// 	result_list = GoodsModel.RewardKeyToNumber(data.reward)
				// 	let index = 0
				// 	for (let key in result_list) {
				// 		var vo = result_list[key]
				// 		let ret = model.LoadAndRefreshAwardItem(vo, this._gp_reward_con, this.award_item_list, index, this.layer_value)
				// 		if (ret) {
				// 			index = index + 1
				// 		}
				// 	}
				// }


				if (!has_reward) {
					this._ok_btn.visible = has_reward
					this._Group4.visible = false
					this._img_bg.height = 424
				}
				this._lb_count_time.y = has_reward ? 876 : 740
				this._img_bg.height = has_reward ? 551 : 424
				this.StartTime()
			}
		}

		this.StartTime = () => {
			this.CancelTime()
			this._end_time = this.left_time + local_TimeUtil.getServerTime()
			this.time_event_id = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnTime()
			}, 1, -1)
			this.OnTime()
		}

		this.OnTime = () => {
			let left_time = this._end_time - local_TimeUtil.getServerTime()
			if (left_time < 0) {
				this.Close()
				return
			}
			this._lb_count_time.text = `点击任意位置关闭(${left_time}s)`
		}

		this.CancelTime = () => {
			if (this.time_event_id) {
				GlobalTimerQuest.CancelQuest(this.time_event_id)
				this.time_event_id = null
			}
		}

		this.Remove = () => {
			has_reward = false
			model.result_info = null
			this.CancelTime()
			if (this.award_item_list) {
				for (let _tmpi in this.award_item_list) {
					var obj = this.award_item_list[_tmpi]
					obj.DeleteMe()
				}
				this.award_item_list = []
			}
			if (this.aer_item) {
				this.aer_item.DeleteMe()
				this.aer_item = null
			}
			if (this.der_item) {
				this.der_item.DeleteMe()
				this.der_item = null
			}
		}
	}

	//测试数据
	GetTestData() {
		let data
		data = {
			aer: [{
				hp_per: 0,
				name: "塞西克伦尔",
				pic: "404",
				pic_ver: 0,
				power: 443320,
				role_id: 4294967301,
				ser_id: 1,
				ser_num: 1
			}],
			auto_id: 4294969516,
			battle_type: 1,
			be_helper_id: 0,
			der: [{
				career: 1,
				hp_per: 100,
				name: "摩利蓓姬",
				pic: "104",
				pic_ver: 0,
				power: 8879408462,
				role_id: 4294967299,
				ser_id: 1,
				ser_num: 1,
				sex: 1,
				turn: 0
			}],
			goods_list: [{
				count: 8,
				style: 0,
				typeId: 35
			}],
			res: 1,//0失败  1胜利
			reward: [{
				count: 8,
				style: 0,
				typeId: 35
			}],
			shipping_id: 1,
		}
		return data
	}

	public DeleteMe() {
		super.DeleteMe()
	}





	_img_bg: Laya.Image
	_img_title: Laya.Image
	_gp_base: Laya.Box
	_gp_victroy: Laya.Box
	_gp_success: Laya.Box
	_Group4: Laya.Box
	_Group3: Laya.Box
	_img_bg_group3: Laya.Image
	_img_fail_reward: Laya.Image
	_img_win_reward: Laya.Image
	_Scroller1: Laya.Panel
	_gp_reward_con: Laya.HBox
	_con_left: Laya.Box
	_con_right: Laya.Box
	_img_vs: Laya.Image
	_lb_count_time: Laya.Label
	_ok_btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._gp_base,
			this._gp_victroy,
			this._gp_success,
			this._Group4,
			this._Group3,
			this._img_bg_group3,
			this._img_fail_reward,
			this._img_win_reward,
			this._Scroller1,
			this._gp_reward_con,
			this._con_left,
			this._con_right,
			this._img_vs,
			this._lb_count_time,
			this._ok_btn,
			this._Image1,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title",
				"_gp_base",
				"_gp_victroy",
				"_gp_success",
				"_Group4",
				"_Group3",
				"_img_bg_group3",
				"_img_fail_reward",
				"_img_win_reward",
				"_Scroller1",
				"_gp_reward_con",
				"_con_left",
				"_con_right",
				"_img_vs",
				"_lb_count_time",
				"_ok_btn",
				"_Image1",
				"labelDisplay",
			])
	}
}
window["BrightSeaBattleResultView"] = BrightSeaBattleResultView