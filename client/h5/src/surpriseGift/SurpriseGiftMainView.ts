import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { table } from "../common/table"
import { SurpriseGiftModel } from "../commonModel/SurpriseGiftModel"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"
import { SurpriseGiftItem } from "./SurpriseGiftItem"

export class SurpriseGiftMainView extends BaseItem1 {
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_gp_item: Laya.List
	_btn_draw: Laya.Box
	labelDisplay: Laya.Label
	_img_draw_red: Laya.Image
	_btn_get_jin: Laya.Box
	_img_get_red: Laya.Image
	_gp_return: Laya.HBox
	_Label1: Laya.Label
	_lb_jin: Laya.Label
	_img_jin: Laya.Image
	_gp_now_return: Laya.HBox
	_Label2: Laya.Label
	_lb_all_jin: Laya.Label
	_img_all_jin: Laya.Image

	loop_mgr: LoopScrowViewMgr
	CustomMehod
	Emp_btn_draw
	Emp_btn_get_jin
	InitEvent
	InitItem
	InitJinLabel
	InitView
	LoadSuccess
	LocalDeleteMe
	ReOpen_callback
	_Image11
	_Image111
	labelDisplay1

	public constructor(parent?) {
		super(parent)


		this.base_file = "surpriseGift"
		this.layout_file = "SurpriseGiftMainView"
		let local_SurpriseGiftModel = SurpriseGiftModel
		let model = local_SurpriseGiftModel.GetInstance()
		let cfg = null
		let info = null
		let index = null
		let item_list = []
		let now_return = null
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
			this.InitView()
		}
		this.ReOpen_callback = () => {
			let _cfg = model.getCfgGift()
			this.InitItem(_cfg)
			if (this._gp_return && this._gp_now_return) {
				// LayoutRebuilder(this._gp_return)
				// LayoutRebuilder(this._gp_now_return)
			}
		}

		this.LoadSuccess = () => {
			//lua_resM:SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("surpriseGift","uijxlwcj_0043"),true)
			//lua_resM:SetOutsideImageSprite(this, this._Image11, GameResPath.GetIcon("surpriseGift","uijxlwcj_0020"),true)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_draw, () => {
				model.SetGradeRed(index)
				this._img_draw_red.visible = model.CheckFreeRed()
				model.Fire(local_SurpriseGiftModel.SELECT_VIEW, 5)
			}
				, this, true)
			Util.AddClickEvent(this._btn_get_jin, () => {
				if (now_return > 0) {
					model.Fire(local_SurpriseGiftModel.SCMD_REQUEST, 49003, 0)
				} else {
					Message.show("暂无可返还勾玉")
				}
			}
				, this, true)
			let callback = (gift_id?) => {
				info = model.GetViewInfo()
				if (!info) {
					return
				}
				let get_num = 0
				if (gift_id == 0) {
					get_num = now_return
				}
				if (get_num > 0) {
					let data = []
					let v = [0, 34, get_num]
					table.insert(data, v)
					let view = new CongratulationObtainView(data)
					view.Open()
				}
				this.InitJinLabel()
			}

			this.BindEvent(model, local_SurpriseGiftModel.GET_SUCCESS, callback)
			this.BindEvent(model, local_SurpriseGiftModel.DRAW_SUCCESS, () => {
				info = model.GetViewInfo()
				if (!info || Util.IsTableEmpty(info)) {
					return
				}
				this._img_draw_red.visible = model.CheckFreeRed()
			}
			)
			this.BindEvent(model, local_SurpriseGiftModel.UPDATA_VIEW, () => {
				info = model.GetViewInfo()
				if (!info) {
					return
				}
				this._img_draw_red.visible = model.CheckFreeRed()
				this.InitJinLabel()
			}
			)
		}

		this.InitView = () => {
			let _cfg = model.getCfgGift()
			if (!_cfg || Util.IsTableEmpty(_cfg)) {
				return
			}
			cfg = _cfg
			this.InitItem(_cfg)
			info = model.GetViewInfo()
			if (!info || Util.IsTableEmpty(info)) {
				return
			}
			this._img_draw_red.visible = model.CheckFreeRed()
			this.InitJinLabel(_cfg)
		}

		this.InitJinLabel = (_cfg?) => {
			if (!_cfg || Util.IsTableEmpty(_cfg)) {
				_cfg = cfg
				if (!_cfg || Util.IsTableEmpty(_cfg)) {
					return
				}
			}
			let gift_list = info.gift_list
			if (!gift_list) {
				return
			}
			let await_return = 0
			let _now_return = 0
			let all_return = 0
			let had_return = 0
			for (let _tmpi in gift_list) {
				var v = gift_list[_tmpi]
				// [ts2lua]_cfg下标访问可能不正确
				let gift_cfg = _cfg[v.gift_id]
				if (!gift_cfg) {
					return
				}
				if (v.back_day > gift_cfg.return_day) {
					break
				}
				let return_gold = gift_cfg.return_gold
				if (typeof (return_gold) == "string") {
					return_gold = JSON.parse(return_gold)[0]
					gift_cfg.return_gold = return_gold
				}
				all_return = all_return + return_gold[2] * gift_cfg.return_day
				had_return = had_return + return_gold[2] * v.back_day
				await_return = all_return - had_return
				if (await_return > 0) {
					// [ts2lua]lua中0和空字符串也是true，此处gift_cfg.return_day < v.buy_time需要确认
					let buy_time = (gift_cfg.return_day < v.buy_time && (gift_cfg.return_day) || (v.buy_time))
					_now_return = _now_return + (buy_time - v.back_day) * return_gold[2]
				}
			}
			this._lb_jin.text = String(await_return)
			this._lb_all_jin.text = String(_now_return)
			now_return = _now_return
			this._img_get_red.visible = _now_return > 0
			// LayoutRebuilder(this._gp_return)
			// LayoutRebuilder(this._gp_now_return)
		}

		this.InitItem = (_cfg?) => {
			let list = []
			if (!_cfg) return
			for (let i in _cfg) {
				table.insert(list, _cfg[i])
			}

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._gp_item, SurpriseGiftItem, list, LoopScrCon.Vertical, 4)
			} else {
				this.loop_mgr.replaceAll(list)
			}
		}

		this.CustomMehod = (_index?, args?) => {
			index = _index
		}

		this.LocalDeleteMe = () => {
			if (item_list.length > 0) {
				for (let _tmpi in item_list) {
					var item = item_list[_tmpi]
					item.DeleteMe()
				}
				item_list = []
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}


	}


	public DeleteMe() {

		this.LocalDeleteMe()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._img_bg,
			this._gp_item,
			this._btn_draw,
			this.labelDisplay,
			this._img_draw_red,
			this._btn_get_jin,
			this.labelDisplay,
			this._img_get_red,
			this._gp_return,
			this._Label1,
			this._lb_jin,
			this._img_jin,
			this._gp_now_return,
			this._Label2,
			this._lb_all_jin,
			this._img_all_jin,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_item",
				"_btn_draw",
				"labelDisplay",
				"_img_draw_red",
				"_btn_get_jin",
				"labelDisplay",
				"_img_get_red",
				"_gp_return",
				"_Label1",
				"_lb_jin",
				"_img_jin",
				"_gp_now_return",
				"_Label2",
				"_lb_all_jin",
				"_img_all_jin",
			])
	}
}
window["SurpriseGiftMainView"] = SurpriseGiftMainView