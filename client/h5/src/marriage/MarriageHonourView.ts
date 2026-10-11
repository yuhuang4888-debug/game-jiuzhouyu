import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { MarriageModel } from "../commonModel/MarriageModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { MarriageHonourItem } from "./MarriageHonourItem"

export class MarriageHonourView extends BaseView1 {
	LoadSuccess
	InitEvent
	UpdateView
	UpdateItems

	loop_mgr
	cfg_fame_lv

	public constructor() {
		super()
		this.base_file = "marriage"
		this.dependent_res = ["marriage2"]
		this.layout_file = "MarriageHonourView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.destroy_imm = true
		this.preload_server_config = {
			"config_fame_lv": false
		}

		let _model = MarriageModel.GetInstance()
		//_ac_item_: eui.ArrayCollection

		this.load_callback = function () {
			this.cfg_fame_lv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_fame_lv", false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("marriage", "ui_role_04"))
			this.LoadSuccess()
		}
		
		this.close_callback = function () {
			if(this.loop_mgr){
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}

		this.LoadSuccess = () => {
			// _ac_item_ = new eui.ArrayCollection()
			// this._list.dataProvider = _ac_item_
			// this._list.itemRenderer = MarriageHonourItem
			this.InitEvent()
			this.UpdateItems()
			this.UpdateView()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_go, () => {
				// this.Close()
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageFlowerView")
			}, this, true)

			this.BindVar(_model, "_flower_info", () => {
				this.UpdateView()
			})
		}

		this.UpdateView = () => {
			this._lb_honour.text = _model.GetRoleFame().toString()
		}

		this.UpdateItems = () => {
			let list = _model.GetFameList(this.cfg_fame_lv)
			if(!this.loop_mgr){
				if(list){
					this.loop_mgr = new LoopScrowViewMgr()
					this.loop_mgr.SetData(this._gp_con, MarriageHonourItem, list, LoopScrCon.Vertical)
				}
			} else {
				this.loop_mgr.replaceAll(list)
			}
		}
	}

	_img_bg: Laya.Image
	_img_title: Laya.Image
	_img_icon: Laya.Image
	_lb_tips: Laya.Label
	_lb_tips2: Laya.Label
	_lb_honour: Laya.Label
	_btn_go: Laya.Box
	_img_go: Laya.Image
	_lb_go: Laya.Label
	_btn_close: Laya.Image
	_gp_con: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._img_icon,
			this._lb_tips,
			this._lb_tips2,
			this._lb_honour,
			this._btn_go,
			this._img_go,
			this._lb_go,
			this._btn_close,
			this._gp_con,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_title",
				"_img_icon",
				"_lb_tips",
				"_lb_tips2",
				"_lb_honour",
				"_btn_go",
				"_img_go",
				"_lb_go",
				"_btn_close",
				"_gp_con",
			])
	}
}
window["MarriageHonourView"] = MarriageHonourView