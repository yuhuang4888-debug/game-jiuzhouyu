import { BaseItem1 } from "../common/BaseItem1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TaskTipType, TaskModel } from "../commonModel/TaskModel"
import { WelfareModel, WelfareEvent } from "../commonModel/WelfareModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPosition } from "../util/Util"
import { LevelRewardItem } from "./LevelRewardItem"

export class LevelRewardView extends BaseItem1 {
	InitEvent
	InitView
	Local_DeleteMe
	Scr_Scroller1
	UpdateView
	_Label1
	_Scroller1
	_Viewport1
	_img_tips
	_img_title
	_list_item_con
	createChildren
	parent_mask_corner
	story_obj_list
	_Image1: Laya.Image
	_Image2: Laya.Image

	public constructor(parent?) {
		super(parent)


		this.base_file = "levelReward"
		this.layout_file = "LevelRewardView"
		this.layer_value = Enum_UILayer.UI
		this.preload_server_config = { "config_rush_giftbag": false }
		//this.dependent_res = ["kaifuactivity"]
		let model = WelfareModel.GetInstance()
		let platform_mgr = PlatformManager.GetInstance()
		let local_WelfareEvent = WelfareEvent
		//let Config = [Rushgiftbag=null]
		let item_array_ = null
		// let mask_item_mat =  new Material(ShaderTools.GetShader("UI-Default_mask"))

		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._Label1.size  = 16
			// 	SetAnchoredPosition(this._Label1, -330, -195)
			// }
			// if (PlatformMgr.GetInstance().IsEyouThPlatform() ) {
			// 	this._Label1.size  = 16
			// }
			this.InitView()
		}

		this.createChildren = () => {
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			if (open_day >= 8 || platform_mgr.is_alpha || platform_mgr.need_alpha_open_charge) {
				this.story_model.curr_view_story_step = 0
				this.story_obj_list = this.story_obj_list || {}
				this.story_obj_list[TaskTipType.Award_eternal_valley] = [BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2]
			}
			super.createChildren()
		}

		this.InitView = () => {
			// this.RegisterMask(this._Viewport1)
			// this.parent_mask_corner = GetWorldCorners(this._Viewport1)

			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIconJpg("levelReward", "uicjhl_001"))
			//lua_resM:SetOutsideImageSprite(this, this._img_tips, GameResPath.GetIcon("levelReward","uicjhl_002"))

			item_array_ = new LoopScrowViewMgr()
			item_array_.SetData(this._list_item_con, LevelRewardItem, [], LoopScrCon.Vertical, 1)

			model.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41700)
			this.InitEvent()
			this.UpdateView()
		}

		this.InitEvent = () => {
			this.BindEvent(model, local_WelfareEvent.UPDATE_LEVEL_REWARD_VIEW, () => {
				this.UpdateView()
			}
			)

			let updata_task_fun = (task_id?, task_tips_list?) => {
				if (this.task_model.MainTaskIsAwardLvGifttaskType() && this.task_model.IsAllStepFinish(task_id)) {
					this.story_model.curr_view_story_step = 2
					GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return, "UI", null, null, null, null)
				}
			}
			this.BindEvent(this.task_model, TaskModel.UPDATE_ONE_TASK, updata_task_fun)
		}

		this.UpdateView = () => {
			let info = model.GetLevelRewardInfo()
			if (info) {
				let sex = RoleManager.GetInstance().GetMainRoleVo().sex

				let list = []
				for (let key in info.giftbag_state) {

					let vo = info.giftbag_state[key]
					let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rush_giftbag", false)[vo.lv]
					if(!cfg) continue
					let sex_attr = sex == 1 && "bag_gift_man" || "bag_gift_woman"
					let limit_sex_attr = sex == 1 && "limit_gift_man" || "limit_gift_woman"
					table.insert(list,
						{
							vo: vo,
							desc: cfg.bag_lv,
							max_count: cfg.bag_upperlimit,
							reward: JSON.parse(cfg[sex_attr]),
							limit_reward: JSON.parse(cfg[limit_sex_attr]),
							parent_mask: this.parent_mask_corner,
							// mask_item_mat : mask_item_mat,
						})
				}
				table.sort(list, (a?, b?) => {
					if (a.vo.received == b.vo.received) {
						return a.vo.lv < b.vo.lv
					}
					if (a.vo.received == 1 || b.vo.received == 2) {
						return true
					}
					if (a.vo.received == 2 || b.vo.received == 1) {
						return false
					}
					return a.vo.received < b.vo.received
				})
				item_array_.replaceAll(list)
			}
		}

		this.Local_DeleteMe = () => {
			GlobalEventSystem.Fire(EventName.CHECK_ITEM_USE)
			if (item_array_) {
				item_array_.DeleteMe()
				item_array_ = null
			}
			
		}

	}

	public DeleteMe() {
		this.Local_DeleteMe()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._img_title,
			this._img_tips,
			this._Image1,
			this._Scroller1,
			this._list_item_con,
			this._Image2,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"_img_title",
				"_img_tips",
				"_Image1",
				"_Scroller1",
				"_list_item_con",
				"_Image2",
				"_Label1",
			])
	}
}
window["LevelRewardView"] = LevelRewardView