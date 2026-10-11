import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { RewardPreView } from "../common/RewardPreView"
import { table } from "../common/table"
import { FriendInviteModel } from "../commonModel/FriendInviteModel"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"
import { FriendInviteHelpItem } from "./FriendInviteHelpItem"

export class FriendInviteHelpView extends BaseItem1 {
	_img_bg: Laya.Image
	Content: Laya.List
	_Group3: Laya.Box
	_Image1: Laya.Image
	_Group1: Laya.Box
	_Image2: Laya.Image
	_img_progress: Laya.Image
	_lb_count: Laya.Label
	_Label1: Laya.Label
	_Label2: Laya.Label
	_img_box_shop: Laya.Image
	_gp_icon: Laya.Box
	_img_icon: Laya.Box
	_Image3: Laya.Image
	_img_icon_red: Laya.Image
	InitEvent
	LoadSuccess
	Scr_Scroller1
	StartAction
	StopAction
	UpdateView
	_role_item_con
	horizontalCenter
	loop_mgr
	tween_id

	public constructor(parent?) {
		super(parent)

		this.base_file = "friendInvite"
		this.layout_file = "FriendInviteHelpView"
		this.horizontalCenter = 0
		let model = FriendInviteModel.GetInstance()
		let local_FriendInviteModel = FriendInviteModel
		let local_Util = Util
		let progress_width_ = 300
		let arr_ = null
		let help_info_ = null
		let now_cfg_ = null
		let state_ = null
		let reward_cache_ = null
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("friendInvite", "uiyqkbx_011"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image2, GameResPath.GetIcon("friendInvite", "uiyqkbx_013"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_progress, GameResPath.GetIcon("friendInvite", "uiyqkbx_014"))
			this.InitEvent()
			model.Fire(local_FriendInviteModel.SCMD_REQUEST, 34005)
			if (!reward_cache_) {
				reward_cache_ = []
			}
			let cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_invite_lv_reward", false)
			for (let main_key in cfg_) {
				var cfg = cfg_[main_key]
				if (cfg.lv == local_FriendInviteModel.help_lv_key) {
					for (let i = cfg.min - 1; i < cfg.max; i++) {
						reward_cache_[i] = JSON.parse(cfg.reward)[0]
					}
				}
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_box_shop, () => {
				model.Fire(local_FriendInviteModel.OPEN_FRIEND_INVITE_SHOP_VIEW, 0)
			}
				, this, true)

			Util.AddClickEvent(this._gp_icon, () => {
				if (state_ == 0) {
					let view = new RewardPreView()
					view.Open(JSON.parse(now_cfg_.reward))
				} else if (state_ == 1) {
					Message.show("已领取所有奖励")
				} else if (state_ == 2) {
					model.Fire(local_FriendInviteModel.SCMD_REQUEST, 34004, 2, now_cfg_.reward_id)
				}
			}
				, this, true)

			this.BindVar(model, "help_info", (event_type?, value?) => {
				help_info_ = value
				this.UpdateView()
			}
			)
		}

		this.UpdateView = () => {
			if (this.use_delete_method) {
				return
			}
			if (!help_info_) {
				return
			}
			let info = help_info_
			now_cfg_ = null
			let cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_invite_reward", false)
			for (let _tmpi in info.reward_list) {
				var vo = info.reward_list[_tmpi]
				if (vo.status != 1) {
					state_ = vo.status
					let key = "2@" + vo.reward_id
					let cfg = cfg_[key]
					if (cfg) {
						now_cfg_ = cfg
					}
					break
				}
			}
			if (now_cfg_) {
				let n = info.count / now_cfg_.num
				if (n > 1) {
					n = 1
				}
				this._img_progress.width = n * progress_width_
				this._lb_count.text = info.count + " / " + now_cfg_.num
			} else {
				state_ = 1
				this._img_progress.width = progress_width_
				this._lb_count.text = "已领取所有奖励"
			}
			this._img_icon_red.visible = state_ == 2
			if (state_ == 2) {
				//this.StartAction()
			} else {
				//this.StopAction()
			}
			let list = []
			for (let i = 0; i < local_FriendInviteModel.role_count; i++) {
				table.insert(list, { "pos": i + 1, "reward": reward_cache_[i], "lv_key": local_FriendInviteModel.help_lv_key })
			}
			for (let _tmpi in info.pos_list) {
				var vo = info.pos_list[_tmpi]
				let obj = list[vo.pos - 1]
				if (obj) {
					obj.vo = vo
				}
			}
			//arr_ = eui. new ArrayCollection()
			//this._role_item_con.dataProvider = arr_
			//this._role_item_con.itemRenderer = FriendInviteHelpItem
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, FriendInviteHelpItem, list, LoopScrCon.Horizontal)
			} else {
				this.loop_mgr.replaceAll(list)
			}
		}

		this.StartAction = () => {
			this.StopAction()
			// this._img_icon.localRotation = Quaternion.Euler(0,-20,0)
			// this.tween_id = SYTweenLite.to(this,this._img_icon,SYTweenLite.UiAnimationType.ROTATION_Y,20,0.15,() => {

			// 	},SYTweenFunc.PINGPONG)
			//local_laya.Tween.get(this._img_icon, {loop=true}):to({rotation=20}, 150, local_laya.Ease.circIn).to({rotation=-20}, 300, local_laya.Ease.circOut)
		}

		this.StopAction = () => {
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
				this.tween_id = null
			}
			//this._img_icon.localRotation = Quaternion.Euler(0,0,0)
		}
	}
	public DeleteMe() {

		this.StopAction()
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._img_bg,
			this.Content,
			this._Group3,
			this._Image1,
			this._Group1,
			this._Image2,
			this._img_progress,
			this._lb_count,
			this._Label1,
			this._Label2,
			this._img_box_shop,
			this._gp_icon,
			this._img_icon,
			this._Image3,
			this._img_icon_red,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"Content",
				"_Group3",
				"_Image1",
				"_Group1",
				"_Image2",
				"_img_progress",
				"_lb_count",
				"_Label1",
				"_Label2",
				"_img_box_shop",
				"_gp_icon",
				"_img_icon",
				"_Image3",
				"_img_icon_red",
			])
	}
}
window["FriendInviteHelpView"] = FriendInviteHelpView