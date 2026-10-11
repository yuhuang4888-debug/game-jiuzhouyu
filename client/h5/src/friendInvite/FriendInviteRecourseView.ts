import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { FriendInviteModel } from "../commonModel/FriendInviteModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { FriendInviteRecourseItem } from "./FriendInviteRecourseItem"

export class FriendInviteRecourseView extends BaseItem1 {
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
	InitEvent
	LoadSuccess
	Scr_Scroller1
	UpdateView
	_list_item_con
	loop_mgr

	public constructor(parent?) {
		super(parent)

		this.base_file = "friendInvite"
		this.layout_file = "FriendInviteRecourseView"
		let model = FriendInviteModel.GetInstance()
		let local_FriendInviteModel = FriendInviteModel
		let progress_width_ = 300
		let info_ = null
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("friendInvite", "uiyqkbx_011"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("friendInvite", "uiyqkbx_013"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_progress, GameResPath.GetIcon("friendInvite", "uiyqkbx_014"))
			if (this.use_delete_method) {
				return
			}
			this.InitEvent()
			model.Fire(local_FriendInviteModel.SCMD_REQUEST, 34001)
		}

		this.InitEvent = () => {
			this.BindVar(model, "info", (event_type?, value?) => {
				info_ = value
				this.UpdateView()
			}
			)
			Util.AddClickEvent(this._img_box_shop, () => {
				model.Fire(local_FriendInviteModel.OPEN_FRIEND_INVITE_SHOP_VIEW, 0)
			}
				, this, true)
		}

		this.UpdateView = () => {
			let info = info_
			let reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_invite_reward", false)
			let find_cfg: any = false
			let list = []
			for (let i in info.reward_list) {
				var vo = info.reward_list[i]
				let cfg = reward_cfg["1@" + vo.reward_id]
				if (cfg) {
					table.insert(list, { "id": vo.reward_id, "reward": JSON.parse(cfg.reward), "num": cfg.num, "now_num": info.total_count, "state": vo.status })
					if (cfg.num > info.total_count) {
						if (!find_cfg) {//|| find_cfg.num > cfg.num
							find_cfg = cfg
						}
					}
				}
			}
			table.sort(list, (a?, b?) => {
				if (a.state == b.state) {
					return a.id < b.id
				} else {
					if (a.state == 1) {
						return false
					}
					if (b.state == 1) {
						return true
					}
					return a.state > b.state
				}
			})

			if (find_cfg) {
				let n = info.total_count / find_cfg.num
				if (n > 1) {
					n = 1
				}
				this._img_progress.width = n * 300
				this._lb_count.text = info.total_count + " / " + find_cfg.num
			} else {
				this._img_progress.width = 300
				this._lb_count.text = "已领取所有奖励"
			}
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, FriendInviteRecourseItem, list, LoopScrCon.Vertical)
			} else {
				this.loop_mgr.replaceAll(list)
			}
		}
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
			])
	}
}
window["FriendInviteRecourseView"] = FriendInviteRecourseView