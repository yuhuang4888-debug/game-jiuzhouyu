import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { ArenaModel } from "../commonModel/ArenaModel"
import { Util } from "../util/Util"
import { ArenaRankBreachRewardView } from "./ArenaRankBreachRewardView"
import { ArenaRankRewardView } from "./ArenaRankRewardView"
import { ArenaRankTabItem } from "./ArenaRankTabItem"

export let ArenaRankRewardTab = [{ index: 1, name: "突破奖励" },
{ index: 2, name: "排名奖励" }]

export class ArenaRankRewardMainView extends BaseView1 {
	_bg_img: Laya.Image
	_img_close: Laya.Image
	_Group1: Laya.HBox
	_Image1: Laya.Image
	_top_img: Laya.Image
	_Image2: Laya.Image
	scroll: Laya.List
	_view_group: Laya.Box
	_lb_titile: Laya.Label
	InitEvent
	InitTab
	OntabTouch
	OpenCallback
	Scrscroll
	SelectView
	click_bg_toClose
	close_callback
	destroy_imm
	is_center
	model
	open_callback
	preload_server_config
	rank_breach_view
	rank_reward_view
	select_tab
	show_open_movie
	tab_array
	use_background
	viewport

	public constructor() {
		super()


		this.base_file = "arena"
		this.layout_file = "ArenaRankRewardMainView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true

		this.select_tab = -1
		this.model = ArenaModel.GetInstance()
		this.tab_array = null
		this.rank_reward_view = null
		this.rank_breach_view = null

		this.load_callback = () => {

			this.InitEvent()
		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.close_callback = () => {
			if (this.rank_reward_view) {
				this.rank_reward_view.DeleteMe()
				this.rank_reward_view = null
			}
			if (this.rank_breach_view) {
				this.rank_breach_view.DeleteMe()
				this.rank_breach_view = null
			}
			if (this.tab_array) {
				this.tab_array.DeleteMe()
				this.tab_array = null
			}

			this.select_tab = 0
		}

		//this.preload_server_config = [Jjcrankreward=false, Jjcrewardbreak=false]
		this.OpenCallback = () => {
			if (!this.select_tab || this.select_tab < 0) {
				this.select_tab = 0
			}
			this.InitTab()
			this.SelectView(this.select_tab)
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			Util.AddClickEvent(this._img_close, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
		}

		this.OntabTouch = (index?) => {
			if (this.select_tab == this.scroll.selectedIndex) {
				return
			}
			this.select_tab = this.scroll.selectedIndex
			this.SelectView(this.select_tab)
		}

		this.InitTab = () => {
			if (!this.tab_array) {
				this.tab_array = new LoopScrowViewMgr()
				this.tab_array.SetData(this.scroll, ArenaRankTabItem, ArenaRankRewardTab, LoopScrCon.Horizontal, 1, (index?) => {
					this.OntabTouch(index)
				})

			}
		}

		this.SelectView = (select_tab?) => {

			if (select_tab == 0) {
				// ResManager.GetInstance().SetImageSprite(this, this._top_img, "arena_asset", "uijj_023", true)
				this._lb_titile.text="突破奖励"
				if (!this.rank_breach_view) {
					this.rank_breach_view = new ArenaRankBreachRewardView(this._view_group)
					this.rank_breach_view.Load()
				}
				this.PopUpChild(this.rank_breach_view)
			} else if (select_tab == 1) {
				// ResManager.GetInstance().SetImageSprite(this, this._top_img, "arena_asset", "uijj_022", true)
				this._lb_titile.text="排名奖励"
				if (!this.rank_reward_view) {
					this.rank_reward_view = new ArenaRankRewardView(this._view_group)
					this.rank_reward_view.Load()
				}
				this.PopUpChild(this.rank_reward_view)
			}
		}


	}

	public GetComponents() {
		[
			this._bg_img,
			this._img_close,
			this._Group1,
			this._Image1,
			this._top_img,
			this._Image2,
			this.scroll,
			this._view_group,
			this._lb_titile
		]
			= this.GetChildrenByNames([

				"_bg_img",
				"_img_close",
				"_Group1",
				"_Image1",
				"_top_img",
				"_Image2",
				"scroll",
				"_view_group",
				"_lb_titile"
			])
		this.scroll.scrollBar.visible=false
	}
}
window["ArenaRankRewardMainView"]=ArenaRankRewardMainView