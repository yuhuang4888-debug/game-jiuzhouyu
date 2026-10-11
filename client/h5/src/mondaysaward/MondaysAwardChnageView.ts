import { BaseView1, OpenMode } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MondaysAwardModel, MondaysAwardEvent } from "../commonModel/MondaysAwardModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { MondaysAwardChnageItem } from "./MondaysAwardChnageItem"
import { MondaysAwardChnageRewardItem } from "./MondaysAwardChnageRewardItem"
import { MondaysAwardChnageTab } from "./MondaysAwardChnageTab"

export class MondaysAwardChnageView extends BaseView1 {
	InitEvent
	LoadSuccess
	Remove
	Scr_item_scroller
	Scr_tab_scroller
	_Label2
	_bg
	_bg_lb
	_btn
	_close
	_gp_item1
	_gp_item2
	_gp_item3
	_gp_item4
	_gp_item5
	_gp_item6
	_gp_item7
	_gp_item8
	_gp_select
	_img
	_img_left
	_img_middle
	_img_right
	_item_list_
	_item_scroller
	_lb_select
	_tab_list
	_tab_scroller
	click_bg_toClose
	close_callback
	destroy_imm
	initTab
	initView
	intitSelect
	is_center
	open_callback
	open_mode
	tabTouchHandler
	use_background

	public constructor() {
		super()


		//this._tab_list = eui. new List();
		let _model = MondaysAwardModel.GetInstance()
		let tab_arr = null
		let _item_list_ = null
		let item_arr = null
		let item_list_ = []
		let _select_tab = 1
		this.base_file = "mondaysaward"
		this.layout_file = "MondaysAwardChnageView"
		this.layer_value = Enum_UILayer.Activity
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.load_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
		}

		this.open_callback = () => {
			_model.initSelectDic()
			this.initView()
			this.initTab()
		}

		this.close_callback = () => {
			this.Remove()
		}

		this.InitEvent = () => {
			this.BindEvent(_model, MondaysAwardEvent.CHANGE_VIEW_SELECT, () => {
				this.intitSelect()
			}
			)
			Util.AddClickEvent(this._btn, () => {
				if (!_model.checkSelectLength(_model.selectDic, true)) {
					return
				}
				_model.changePoolReward()
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._close, () => {
				this.Close()
			}
				, this, true)
		}

		this.Remove = () => {
			_select_tab = 1

			if (item_arr) {
				item_arr.DeleteMe()
				item_arr = null
			}

			if (tab_arr) {
				tab_arr.DeleteMe()
				tab_arr = null
			}

			if (item_list_ && item_list_.length > 0) {
				for (let i = 0; i < item_list_.length; i++) {
					var itemVo = item_list_[i]
					if (itemVo) {
						itemVo.DeleteMe()
					}
				}
				item_list_ = []
			}

		}

		this.LoadSuccess = () => {
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._Label2.size  = 18
			// }
			ResManager.GetInstance().SetImageSpriteTrans(this, this._bg, GameResPath.GetIcon("common4", "bg_03"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img, GameResPath.GetIcon("mondaysaward", "uizydj_0026"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._bg_lb, GameResPath.GetIcon("mondaysaward", "uizydj_0023"), true)
			ResManager.GetInstance().SetTexture(this, this._img_middle, GameResPath.GetIcon("mondaysaward", "uizydj_008"),undefined,undefined,true)
			//lua_resM:SetOutsideImageSprite(this, this._img_middle2, GameResPath.GetIcon("mondaysaward","uizydj_0024"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_left, GameResPath.GetIcon("mondaysaward", "uizydj_0029a1"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_right, GameResPath.GetIcon("mondaysaward", "uizydj_0029a1"))
		}

		this.initTab = () => {
			let data = []
			for (let key in _model.config_reward_Id) {

				let cfg = _model.config_reward_Id[key]
				table.insert(data, cfg)
			}
			if (!tab_arr) {
				tab_arr = new LoopScrowViewMgr()
				tab_arr.SetData(this._tab_list, MondaysAwardChnageTab, data, LoopScrCon.Horizontal, 1, (item?) => {
					this.tabTouchHandler(item+1)
				})
			} else {
				tab_arr.replaceAll(data)
			}
		}

		this.tabTouchHandler = (item?) => {
			if (item == _select_tab) {
				return
			}
			let config = _model.getRewardIdById(_select_tab - 1)
			if (_model.selectNum < config.num) {
				tab_arr.SetSelectIndex(_select_tab-1)
				Message.show("请先填满对应奖池奖励")
				return
			}
			_select_tab = item
			this.initView()
		}

		this.initView = () => {
			let config = _model.getRewardIdById(_select_tab - 1)
			_model.selectNum = config.num

			let data = _model.getRewardIdList(_select_tab - 1)
			if (!item_arr) {
				item_arr = new LoopScrowViewMgr()
				item_arr.SetData(this._item_list_, MondaysAwardChnageItem, data, LoopScrCon.Vertical, 5)
			} else {
				item_arr.replaceAll(data)
			}
			_model.showSelectImg(this._gp_select, _select_tab)
			this.intitSelect()
		}

		this.intitSelect = () => {

			let config = _model.getRewardIdById(_select_tab - 1)
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	this._lb_select.textFlow = Util.StrToHTML(config.desc + " <font color=" + ColorUtil.GetColorLight(ColorType.GREEN) + ">(" + _model.selectNum + "/" + config.num + ")</font>"
			// 	)
			// } else {
			this._lb_select.style.fontSize=18
			this._lb_select.style.color="#663915"
			this._lb_select.style.bold=true
			this._lb_select.innerHTML = Util.StrToHTML("已选择&nbsp;" + config.desc + "&nbsp;奖励<font color='#0a953e'>&nbsp;(" + _model.selectNum + "/" + config.num + ")</font>"
			)
			// }
			this._lb_select.width=500


			let showList = _model.showSelectList()
			if (showList.length <= 0) {
				return
			}
			let item = null
			let reward = null

			for (let i = 1; i <= 8; i++) {
				let gp = this["_gp_item" + i]
				item = item_list_[i]
				reward = showList[i-1]
				if (!item) {
					item = new MondaysAwardChnageRewardItem(gp)
					item_list_[i] = item
					item.Load()
				}
				if (reward[0]!=null) {
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
					item.SetData(type_id, reward[2], 0.75)
				} else {
					item.SetData(null, null)
				}
			}

		}


	}

	bg: Laya.Image
	_img_middle2: Laya.Image
	_Group1: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	_Image10: Laya.Image
	_Image11: Laya.Image
	_gp_reward: Laya.Box
	_Image12: Laya.Image
	_Image13: Laya.Image
	_Image14: Laya.Image
	_Image15: Laya.Image
	_Image16: Laya.Image
	_Image17: Laya.Image
	_Image18: Laya.Image
	_Image19: Laya.Image
	_Image20: Laya.Image
	_Group2: Laya.Box
	_Group3: Laya.Box
	_Image21: Laya.Image
	_Label1: Laya.Label
	_Image22: Laya.Image
	_Image23: Laya.Image
	public GetComponents() {
		[
			this._bg,
			this._img,
			this._close,
			this._img_middle,
			this._img_middle2,
			this._Group1,
			this._Image1,
			this._Image2,
			this._Image3,
			this._gp_select,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image8,
			this._Image9,
			this._Image10,
			this._Image11,
			this._gp_reward,
			this._gp_item1,
			this._gp_item2,
			this._gp_item3,
			this._gp_item4,
			this._gp_item5,
			this._gp_item6,
			this._gp_item7,
			this._gp_item8,
			this._Image12,
			this._Image13,
			this._Image14,
			this._Image15,
			this._Image16,
			this._Image17,
			this._Image18,
			this._Image19,
			this._Image20,
			this._Group2,
			this._img_left,
			this._img_right,
			this._tab_scroller,
			this._tab_list,
			this._bg_lb,
			this._lb_select,
			this._Group3,
			this._Image21,
			this._Label1,
			this._Image22,
			this._item_scroller,
			this._item_list_,
			this._btn,
			this._Image23,
			this._Label2,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_img",
				"_close",
				"_img_middle",
				"_img_middle2",
				"_Group1",
				"_Image1",
				"_Image2",
				"_Image3",
				"_gp_select",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image8",
				"_Image9",
				"_Image10",
				"_Image11",
				"_gp_reward",
				"_gp_item1",
				"_gp_item2",
				"_gp_item3",
				"_gp_item4",
				"_gp_item5",
				"_gp_item6",
				"_gp_item7",
				"_gp_item8",
				"_Image12",
				"_Image13",
				"_Image14",
				"_Image15",
				"_Image16",
				"_Image17",
				"_Image18",
				"_Image19",
				"_Image20",
				"_Group2",
				"_img_left",
				"_img_right",
				"_tab_scroller",
				"_tab_list",
				"_bg_lb",
				"_lb_select",
				"_Group3",
				"_Image21",
				"_Label1",
				"_Image22",
				"_item_scroller",
				"_item_list_",
				"_btn",
				"_Image23",
				"_Label2",
			])
	}
}
window["MondaysAwardChnageView"] = MondaysAwardChnageView
