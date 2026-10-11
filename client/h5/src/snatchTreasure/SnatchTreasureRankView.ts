import { BaseView1, OpenMode } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { SnatchTreasureModel } from "../commonModel/SnatchTreasureModel"
import { Util } from "../util/Util"
import { SnatchTreasureRankItem } from "./SnatchTreasureRankItem"

export class SnatchTreasureRankView extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Group1: Laya.Box
	_Image4: Laya.Image
	_title_lb: Laya.Label
	_Image5: Laya.Image
	_close: Laya.Image
	Content: Laya.List
	InitEvent
	LocalDeleteMe
	_Scroller1
	_rank_list
	close_callback
	initView
	loop_mgr
	open_callback

	public constructor() {
		super()


		this.base_file = "snatchTreasure"
		this.layout_file = "SnatchTreasureRankView"
		this.layer_value = Enum_UILayer.Activity
		//this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.back_login_toClose = true
		let _model = SnatchTreasureModel.GetInstance()
		this.preload_server_config = {
			"config_territory_rank": false
		}
		this.load_callback = () => {

			this.InitEvent()
		}

		this.open_callback = () => {
			//this.RegisterMask(this._rank_list)
			this.initView()
		}

		this.close_callback = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		 }

		this.InitEvent = () => {
			Util.AddClickEvent(this._close, () => {
				this.Close()
			}
				, this, true)
		}

		this.LocalDeleteMe = () => {
			
		}

		this.initView = () => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_territory_rank", false)
			let list = _model.getRankConfig(cfg)
			//table.sort(list,(a?,b?) => {
			//return  a.min_rank < b.min_rank
			//})
			if (list.length > 0 && !this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, SnatchTreasureRankItem, list, LoopScrCon.Vertical)
			}else{
				this.loop_mgr.replaceAll(list)
			}

			//this._rank_list.dataProvider = eui. new ArrayCollection(list)
			//this._rank_list.itemRenderer = SnatchTreasureRankItem


		}
	}

	// public DeleteMe() {

	// 	this.LocalDeleteMe()
	// 	super.DeleteMe()
	// }


	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._Group1,
			this._Image4,
			this._title_lb,
			this._Image5,
			this._close,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"_Group1",
				"_Image4",
				"_title_lb",
				"_Image5",
				"_close",
				"Content",
			])
	}
}
window["SnatchTreasureRankView"] = SnatchTreasureRankView