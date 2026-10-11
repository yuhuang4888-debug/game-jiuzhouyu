import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { FriendInviteModel } from "../commonModel/FriendInviteModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { FriendInviteShopItem } from "./FriendInviteShopItem"
import { FriendInviteTabItem } from "./FriendInviteTabItem"

export class FriendInviteShopView extends BaseView1 {
	_img_bg: Laya.Image
	_img_close: Laya.Image
	_img_sub_bg: Laya.Image
	_img_title: Laya.Image
	Content1: Laya.List
	Content: Laya.List
	_Group1: Laya.HBox
	_lb_count: Laya.Label
	_img_icon: Laya.Image
	Init
	InitEvent
	InitTab
	LoadSuccess
	Remove
	Scr_Scroller1
	Scr_Scroller2
	SetDefaultIndex
	SwitchTab
	UpdateView
	_list_item_con
	_list_tab_con
	append_to_ctl_queue
	loop_mgr
	loop_mgr1

	public constructor() {
		super()

		this.base_file = "friendInvite"
		this.layout_file = "FriendInviteShopView"
		this.layer_value = Enum_UILayer.Activity
		this.change_scene_close = true
		this.use_background = true
		this.is_center = true
		this.destroy_imm = true
		this.show_open_movie = true
		this.append_to_ctl_queue = true
		let model = FriendInviteModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let local_FriendInviteModel = FriendInviteModel
		let tab_arr_ = null
		let item_arr_ = null
		let default_index_ = 0
		let now_index_ = null
		let item_list_ = null
		let box_tab_list_ = ["求助", "助力"]
		let index2Type_ = [2, 3]
		this.load_callback = () => {

			this.Init()
		}
		this.preload_server_config = {
			"config_goods_exchange_rule": false
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.Init = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("friendInvite", "uiyqkbx_001"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_sub_bg, GameResPath.GetIcon("friendInvite", "uiyqkbx_033"), true)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("friendInvite", "uiyqkbx_035"), true)
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}
				, this, true)

			this.BindEvent(goods_model, local_GoodsModel.UPDATE_GOODS_EXCHANGE_DATA, (vo?) => {
				let type = index2Type_[now_index_]
				if (vo.type == type) {
					this.UpdateView(vo.exchange_list)
				}
			}
			)
			this.BindEvent(goods_model, local_GoodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
				let type_id = now_index_ == 1 && local_FriendInviteModel.currency_type_one || local_FriendInviteModel.currency_type_two
				if (vo.currency_id == type_id) {
					this._lb_count.text = "" + vo.num
				}
			}
			)
		}

		this.LoadSuccess = () => {
			this.InitTab()
			this.loop_mgr.SetSelectIndex(default_index_)
			//this:SwitchTab(default_index_)
		}

		this.InitTab = () => {
			let tab_list = []
			for (let _tmpi in box_tab_list_) {
				var obj = box_tab_list_[_tmpi]
				table.insert(tab_list, { "name": obj })
			}
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this.Content1, FriendInviteTabItem, tab_list, LoopScrCon.Horizontal, 1, (item?) => {
				this.SwitchTab(this.Content1.selectedIndex)
			})
		}

		this.UpdateView = (data?) => {
			let type_id = now_index_ == 0 && local_FriendInviteModel.currency_type_one || local_FriendInviteModel.currency_type_two
			this._lb_count.text = "持有货币：" + goods_model.GetSpecialScore(type_id)
			//LayoutRebuilder(this._Group1)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(type_id))
			let type = index2Type_[now_index_]
			let rule_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_exchange_rule", false)
			let list = []
			for (let _tmpi in data) {
				var vo = data[_tmpi]
				let cfg = rule_cfg[vo.id]
				table.insert(list, { "cfg": cfg, "count": vo.count })
			}
			table.sort(list,(a,b)=>{
				return a.cfg.id < b.cfg.id
			})
			if (!this.loop_mgr1) {
				this.loop_mgr1 = new LoopScrowViewMgr()
				this.loop_mgr1.SetData(this.Content, FriendInviteShopItem, list, LoopScrCon.Vertical)
			} else {
				this.loop_mgr1.replaceAll(list)
			}
		}

		this.SwitchTab = (index?) => {
			if (now_index_ == index) {
				return
			}
			now_index_ = index
			goods_model.Fire(local_GoodsModel.REQUEST_EXCHANGE_GOODS, index2Type_[now_index_])
		}

		this.Remove = () => {
			if (this.loop_mgr1) {
				this.loop_mgr1.DeleteMe()
				this.loop_mgr1 = null
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			now_index_ = null
		}

		this.SetDefaultIndex = (index?) => {
			default_index_ = index
		}
	}



	public GetComponents() {
		[
			this._img_bg,
			this._img_close,
			this._img_sub_bg,
			this._img_title,
			this.Content1,
			this.Content,
			this._Group1,
			this._lb_count,
			this._img_icon,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_close",
				"_img_sub_bg",
				"_img_title",
				"Content1",
				"Content",
				"_Group1",
				"_lb_count",
				"_img_icon",
			])
	}
}
window["FriendInviteShopView"] = FriendInviteShopView