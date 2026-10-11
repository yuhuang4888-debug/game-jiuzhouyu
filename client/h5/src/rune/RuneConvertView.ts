import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { LuaSoundManager } from "../common/SoundManager";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { Message } from "../sysInfo/SysInfoController";
import { LOAD_QUEUE } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { RuneConvertItem } from "./RuneConvertItem";
import { RuneTreasureModel } from "../commonModel/RuneTreasureModel";
import { RuneTreasureEvent } from "../commonModel/RuneTreasureModel";

export class RuneConvertView extends BaseView1 {
	LoadSuccess
	InitEvent
	OpenCallback
	SetBagItemList
	item_list
	public constructor() {
		super();
		this.base_file = "rune";
		this.layout_file = "RuneConvertView";
		this.layer_value = Enum_UILayer.Activity;
		this.destroy_imm = true;
		this.use_background = true;
		this.click_bg_toClose = true;
		this.is_center = true
		this.show_open_movie = true;
		let model = RuneModel.GetInstance(),
			local_Util = Util,
			config_rune_exchange_,
			item_list_: Array<RuneConvertItem>,
			cost_item_: BaseAwardItem,
			compose_cfg_list_
		this.load_callback = function () {
			this.LoadSuccess();
			this.InitEvent();
		}
		this.open_callback = function () {
			this.OpenCallback();
		}
		this.destroy_callback = function () {
			if (item_list_) {
				for (let obj of item_list_) {
					obj.DeleteMe()
				}
				item_list_ = null
			}
			if (cost_item_) {
				cost_item_.DeleteMe()
				cost_item_ = null
			}
			compose_cfg_list_ = null
			config_rune_exchange_ = null

			if (this.item_list) {
				this.item_list.DeleteMe()
				this.item_list = null
			}
		}
		this.preload_server_config = {
			"config_rune_attr_num": false,
			"config_rune_exchange": false,
			// "config_rune_attr_coefficient": false,
		}

		this.LoadSuccess = () => {
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("common", "uisy_023"))
			// this.bg.scale9Grid = new Laya.Rectangle(200, 200, 20, 20)
			//this.scroll_group.vScrollBar.visible = false
			config_rune_exchange_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_exchange", false)

			item_list_ = []
			compose_cfg_list_ = []
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			local_Util.AddClickEvent(this.closeBtn, close_fun, this, true)

			local_Util.AddClickEvent(this.getBtn, () => {
				if (!CommonManager.GetInstance().CheckFuncOpenState("RuneTreasureMainView")) {
					return
				}
				RuneTreasureModel.GetInstance().Fire(RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW, "RuneTreasureBaseView", 1)
				this.Close()
			}, this, true)

			let update_fun = () => {
				this.OpenCallback()
			}
			this.BindEvent(model, RuneEvent.UPDTE_RUNE_CONVERT_VIEW, update_fun)
		}

		this.OpenCallback = () => {
			this.SetBagItemList()
			if (!cost_item_) {
				cost_item_ = new BaseAwardItem(this.icon_conta)
				cost_item_.Load()
				cost_item_.SetData(RuneModel.RuneStone)
				cost_item_.SetItemSize(50, 50)
				cost_item_.SetItembgVisible(false)
			}
			this.num.text = model.rune_info ? String(model.rune_info.rune_chip) : "0"
		}

		this.SetBagItemList = () => {
			if (compose_cfg_list_.length <= 0) {
				for (let key in config_rune_exchange_) {
					compose_cfg_list_.push(config_rune_exchange_[key])
				}
				let sort_fun = (a, b) => {
					return a.id - b.id
				}
				compose_cfg_list_.sort(sort_fun)
			}

			if (!this.item_list) {
				this.item_list = new LoopScrowViewMgr()
				this.item_list.SetData(this.scroll_group, RuneConvertItem, compose_cfg_list_, LoopScrCon.Vertical)
			} else {
				this.item_list.replaceAll(compose_cfg_list_)
			}

			// let item: RuneConvertItem
			// for (let i = 0; i < compose_cfg_list_.length; i++) {
			// 	item = item_list_[i]
			// 	if (!item) {
			// 		item = new RuneConvertItem(this.scroll_group)
			// 		item_list_[i] = item
			// 		item.Load()
			// 	}
			// 	item.SetPosition(i % 3 * RuneConvertItem.WIDTH, Math.floor(i / 3) * RuneConvertItem.HEIGHT)
			// 	item.SetData(compose_cfg_list_[i])
			// }
		}
	}

	bg: Laya.Image
	_Image0: Laya.Image
	_Image2: Laya.Image
	label1: Laya.Label
	getBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	closeBtn: Laya.Image
	_Image4: Laya.Image
	own: Laya.Label
	num: Laya.Label
	tips: Laya.Label
	icon_conta: Laya.Box
	scroll_group: Laya.List
	public GetComponents() {
		[
			this.bg,
			this._Image0,
			this._Image2,
			this.label1,
			this.getBtn,
			this._Image1,
			this.labelDisplay,
			this.closeBtn,
			this._Image4,
			this.own,
			this.num,
			this.tips,
			this.icon_conta,
			this.scroll_group,
		]
			= this.GetChildrenByNames([

				"bg",
				"_Image0",
				"_Image2",
				"label1",
				"getBtn",
				"_Image1",
				"labelDisplay",
				"closeBtn",
				"_Image4",
				"own",
				"num",
				"tips",
				"icon_conta",
				"scroll_group",
			])
	}
}
window["RuneConvertView"] = RuneConvertView