import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { FriendInviteModel } from "../commonModel/FriendInviteModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { FriendInviteHelpItem } from "./FriendInviteHelpItem"

export class FriendInviteLevelUpView extends BaseItem1 {
	_img_bg: Laya.Image
	Content: Laya.List
	_Group2: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_img_box_shop: Laya.Image
	InitEvent
	LoadSuccess
	Scr_Scroller1
	UpdateView
	_role_item_con
	horizontalCenter
	loop_mgr

	public constructor(parent?) {
		super(parent)

		this.base_file = "friendInvite"
		this.layout_file = "FriendInviteLevelUpView"
		this.horizontalCenter = 0
		let model = FriendInviteModel.GetInstance()

		let local_FriendInviteModel = FriendInviteModel
		let progress_width_ = 300
		let now_cfg_ = null
		let arr_ = null
		let level_up_info_ = null
		let reward_cache_ = null
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			//arr_ = eui. new ArrayCollection()
			//this._role_item_con.dataProvider = arr_
			//this._role_item_con.itemRenderer = FriendInviteHelpItem
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("friendInvite", "uiyqkbx_011"))
			this.InitEvent()
			model.Fire(local_FriendInviteModel.SCMD_REQUEST, 34006)
			if (!reward_cache_) {
				reward_cache_ = []
			}
			let cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_invite_lv_reward", false)
			for (let main_key in cfg_) {
				var cfg = cfg_[main_key]
				if (cfg.lv == local_FriendInviteModel.level_lv_key) {
					let reward = JSON.parse(cfg.reward)[0]
					for (let i = cfg.min - 1; i <= cfg.max; i++) {
						reward_cache_[i] = reward
					}
				}
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_box_shop, () => {
				model.Fire(local_FriendInviteModel.OPEN_FRIEND_INVITE_SHOP_VIEW, 0)
			}
				, this, true)
			this.BindVar(model, "level_up_info", (event_type?, value?) => {
				level_up_info_ = value
				this.UpdateView()
			}
			)
		}

		this.UpdateView = () => {
			if (!level_up_info_) {
				return
			}
			let info = level_up_info_
			//let list = []
			//let i = 0
			//do {
			//table.insert(list, {pos=i + 1, vo=null, reward=reward_cache_[i], lv_key=local_FriendInviteModel.level_lv_key})
			//i=i+1
			//} while ((i < local_FriendInviteModel.role_count))
			//for (let _tmpi in info.pos_list) {
			//var vo = info.pos_list[_tmpi]
			//// [ts2lua]list下标访问可能不正确
			//let obj = list[vo.pos - 1]
			//if (obj ) {
			//obj.vo = vo
			//}
			//}
			let list = []
			for (let i = 0; i < local_FriendInviteModel.role_count; i++) {
				table.insert(list, { "pos": i + 1, "reward": reward_cache_[i], "lv_key": local_FriendInviteModel.level_lv_key })
			}
			for (let _tmpi in info.pos_list) {
				var vo = info.pos_list[_tmpi]
				let obj = list[vo.pos-1]
				if (obj) {
					obj.vo = vo
				}
			}
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, FriendInviteHelpItem, list, LoopScrCon.Horizontal)
			} else {
				this.loop_mgr.replaceAll(list)
			}
		}
	}



	public GetComponents() {
		[
			this._img_bg,
			this.Content,
			this._Group2,
			this._Image1,
			this._Label1,
			this._Label2,
			this._img_box_shop,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"Content",
				"_Group2",
				"_Image1",
				"_Label1",
				"_Label2",
				"_img_box_shop",
			])
	}
}
window["FriendInviteLevelUpView"] = FriendInviteLevelUpView