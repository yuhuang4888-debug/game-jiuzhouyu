import { ArrowComponent } from "../common/ArrowComponent"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { StoryModel } from "../commonModel/StoryModel"
import { TaskModel } from "../commonModel/TaskModel"
import { WelfareEvent, WelfareModel } from "../commonModel/WelfareModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util, HtmlColorTxt, Color } from "../util/Util"
import { LevelReward } from "./LevelReward"

export class LevelRewardItem extends BaseItemRenderer {
	Emp_gp_get
	Out_lb_get
	VHS_Scroller1
	_Group1
	_Viewport1
	_gp_get
	_gp_item_con
	_img_bg
	_img_get
	_img_mask
	_img_received
	_img_red
	_lb_get
	_lb_left_count
	_lb_lv
	award_list
	destiny_gp
	model
	timer_id
	task_model
	story_model
	_Scroller1: Laya.Panel
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Label1: Laya.Label
	fly_reward
	is_request

	public WIDTH = 695
	public HEIGT = 130

	public constructor(parent) {
		super()


		this.base_file = "levelReward"
		this.layout_file = "LevelRewardItem"
		// this.layer_value = Enum_UILayer.UI
		this.model = WelfareModel.GetInstance()
		this.task_model = TaskModel.GetInstance()
		this.story_model = StoryModel.GetInstance()
		this.Load()
	}

	public load_callback() {

		this.LoadSuccess()
		// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 	SetAnchoredPositionY(this._Group1,-26)
		// }
	}

	public LoadSuccess() {


		ResManager.GetInstance().SetImageSpriteTrans(this, this._img_bg, GameResPath.GetIcon("levelReward", "ui_activity_02"))

		// this.RegisterMask(this._Viewport1, 2)
		// let parent_scr = this.parent_wnd.GetComponentInParent(typeof(UnityEngine.UI.ScrollRect))
		// this.VHS_Scroller1.parentScroll = parent_scr

		Util.AddClickEvent(this._gp_get, () => {
			if (this.data && this.data.vo) {
				let receive_key = this.data.vo.received
				if (receive_key == 0) {
					Message.show("条件不足")
				} else if (receive_key == 1) {
					// for (let key in this.data.reward) {
					// 	let vo = this.data.reward[key]
					// 	for (let _ in vo) {
					// 		let vo1 = vo[_]
					// 		if (vo1 == 38067001) {
					// 			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(38067001)
					// 			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "ItemUseView", goods_vo)
					// 			break
					// 		}
					// 	}
					// }
					WelfareModel.GetInstance().Fire(WelfareEvent.WELFARE_REQUEST_PROTO, 41701, "h", this.data.vo.lv)
					this.is_request=true
				} else if (receive_key == 2) {
					Message.show("已领取～")
				} else if (receive_key == 4) {
					Message.show("已被领完~")
				}
				let main_role_task = TaskModel.GetInstance().GetMainLineTaskVo()
				if (main_role_task && main_role_task.task_id == 100420) {
					let view = BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT
					if (view) {
						view.Close()
					}
				}
			}
		}, this, true)

		let update_reward_num = (lv?, remain_num?) => {
			if (this.data && lv == this.data.vo.lv) {
				this.data.vo.remain_num = this.data.max_count - remain_num
				this.dataChanged()
				if(this.is_request){
					this.is_request=false
					CustomActivityModel.GetInstance().ShowActFlyReward(this.fly_reward,this._gp_get)
				}
		
			}
		}
		this.BindEvent(this.model, WelfareEvent.UPDATE_LEVEL_REWARD_NUM, update_reward_num)
	}

	public dataChanged() {

		if (super.dataChanged()) {
			let lv = this.data.desc > 370 && this.data.desc - 370 || this.data.desc
			let sc_lv = (this.data.desc > 370 && (true) || (false))
			this.destiny_gp.visible = sc_lv
			this._lb_lv.text = lv
			// LayoutRebuilder(this._Group1)

			//this._img_mask.visible = this.data.vo.received == 2 

			let bool = this.data.max_count != 0 && (this.data.vo.received < 2 || this.data.vo.received == 4)
			this._lb_left_count.visible = bool
			this._lb_left_count.style.fontSize = 20
			this._lb_left_count.style.color = "#663915"
			if (this.data.max_count > 0) {
				let color = null
				let str = null
				if (this.data.vo.remain_num == 0) {
					color = "'#ff4f50'"
				} else {
					color = "'#639c12'"
				}
				if (this.data.vo.draw_num && this.data.vo.draw_num > 0) {
					this.data.vo.remain_num = this.data.max_count - this.data.vo.draw_num
				}
				if (this.data.vo.remain_num > 0) {
					str = "剩余:" + HtmlColorTxt(this.data.vo.remain_num, color) + "/" + this.data.max_count
					// if (PlatformMgr.GetInstance().IsEyouThPlatform() ) {
					// 	this._lb_left_count.size  = 20
					// }
				} else {
					str = "限量奖励已领完"
					// if (PlatformMgr.GetInstance().IsEyouThPlatform() ) {
					// 	this._lb_left_count.size  = 14
					// }
				}
				this._lb_left_count.innerHTML = str
				this._lb_left_count.width = 500
				this._lb_left_count.x = 71 - this._lb_left_count.contextWidth / 2
			}


			let reward_list = []
			if (this.data.limit_reward.length > 0) {
				for (let i in this.data.limit_reward) {

					table.insert(reward_list, this.data.limit_reward[i])
				}
			}
			reward_list = reward_list.concat(this.data.reward)
			this.fly_reward = CustomActivityModel.GetInstance().GetFlyRewardList(reward_list)
			if (!this.award_list) {
				this.award_list = []
			}


			// this.VHS_Scroller1.horizontalNormalizedPosition = 0
			for (let i = 0; i < this.award_list.length; i++) {
				this.award_list[i].DeleteMe()
				this.award_list[i] = null
			}

			this.award_list = []
			for (let key = 0; key < reward_list.length; key++) {

				let vo = reward_list[key]
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					let item = this.award_list[key]
					if (!item) {
						item = new LevelReward(this._gp_item_con)
						if (key == 1) {
							// item.SetMaskId(2)
							// item.SetMaskRect(this.data.parent_mask)
							// item.SetMaskItemMaterial(this.data.mask_item_mat)
						}
						this.award_list[key] = item
						item.Load()
					}
					item.SetData(goods_vo.type_id, vo[2], lock, this.data)
					item.SetVisible(true)
				}
			}


			this._img_red.visible = this.data.vo.received == 1
			this._img_received.visible = this.data.vo.received == 2
			this._gp_get.visible = this.data.vo.received != 2
			if (this._gp_get.visible) {
				let rece_key = this.data.vo.received
				if (rece_key == 1) {
					this._lb_get.text = "领取"
					Util.SetImageGray(this._gp_get, false)
					// this.Out_lb_get.effectColor =  new Color(211/255, 106/255, 36/255, 1)
					//lua_resM:SetImageSprite(this, this._img_get, "common_asset", "com_rect_btn1")

				} else if (rece_key == 0) {
					this._lb_get.text = "未达到"
					//this._lb_get.strokeColor = "#8d8d8d"
					// this.Out_lb_get.effectColor = ColorUtilValue.GRAY
					Util.SetImageGray(this._gp_get, true)

				} else if (rece_key == 3
					|| rece_key == 4) {
					this._lb_get.text = "领取"
					// this.Out_lb_get.effectColor =  new Color(211/255, 106/255, 36/255, 1)
					Util.SetImageGray(this._gp_get, true)
				}

			}
			this.ShowFinger()
		}

	}

	public ShowFinger() {


		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
		let main_line_vo = this.task_model.GetMainLineTaskVo()
		if (this.data
			&& this.data.vo
			&& this.data.vo.received == 1
			&& main_line_vo
			&& main_line_vo.id == this.data.vo.lv) {
			this.story_model.curr_view_story_step = 1
			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._gp_get, "UI", null, null, null, null)

			if (this.timer_id) {
				clearTimeout(this.timer_id)
				this.timer_id = null
			}
			// let call_fun = () => {
			// 	if (!this.use_delete_method) {
			// 		let finger:ArrowComponent = this.story_model.GetFinger(this, this._gp_get)
			// 		if (finger) {
			// 			//finger.SetCoverMode()
			// 		}
			// 	}
			// }
			// this.timer_id = setTimeout(call_fun, 0.2)



		} else {
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._gp_get)
		}
	}

	public DeleteMe() {

		if (this.timer_id) {
			clearTimeout(this.timer_id)
			this.timer_id = null
		}
		if (this.award_list) {
			for (let _tmpi in this.award_list) {
				var obj = this.award_list[_tmpi]
				obj.DeleteMe()
			}
			this.award_list = null
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._img_bg,
			this._Scroller1,
			this._gp_item_con,
			this._gp_get,
			this._img_get,
			this._img_red,
			this._lb_get,
			this._img_received,
			this._Image1,
			this._lb_left_count,
			this._Group1,
			this.destiny_gp,
			this._Image2,
			this._Image3,
			this._lb_lv,
			this._Label1,
			this._img_mask,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Scroller1",
				"_gp_item_con",
				"_gp_get",
				"_img_get",
				"_img_red",
				"_lb_get",
				"_img_received",
				"_Image1",
				"_lb_left_count",
				"_Group1",
				"destiny_gp",
				"_Image2",
				"_Image3",
				"_lb_lv",
				"_Label1",
				"_img_mask",
			])
		this._Scroller1.hScrollBarSkin = ""
	}
}
window["LevelRewardItem"] = LevelRewardItem