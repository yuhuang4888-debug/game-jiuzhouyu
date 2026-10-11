import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { kfSingleRankModel } from "../commonModel/kfSingleRankModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { kfSRAwardItem } from "./kfSRAwardItem"

export class kfSRRewardItem extends BaseItemRenderer {
	_model
	loop_day
	loop_top
	// vhsr1
	// vhsr2
	public static width = 613
	public static height = 118
	public WIDTH = 613
	public HEIGT = 118
	public constructor(parent) {
		super()

		this.base_file = "kfSingleRank"
		this.layout_file = "kfSRRewardItem"
		this._model = kfSingleRankModel.GetInstance()
		this.Load()
	}

	public load_callback() {

	}

	public DeleteMe() {

		if (this.loop_day) {
			this.loop_day.DeleteMe()
			this.loop_day = null
		}
		if (this.loop_top) {
			this.loop_top.DeleteMe()
			this.loop_top = null
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if(!super.dataChanged())return
		let data = this.data
		this._lb_layer.text = "第" + data.level + "层"
		let dlist = JSON.parse(data.reward)
		let tlist = JSON.parse(data.challenger_reward)
		let pinfo = this._model.GetPlayerInfo()
		let lv = this._model.GetCurLevel()
		let cldata = this._model.GetCurLevelData()
		lv = (lv == 1 && !cldata && (1) || (lv + 1))
		for (let _tmpi in dlist) {
			let vo = dlist[_tmpi]
			vo.rw_state = data.level < lv ? (cldata ? 1 : data.rw_state) : 0
			//vo.rw_state = (data.level < lv && ((cldata && { 1 ) || (data.rw_state))} || { 0})[1]
		}
		this.UpdateDayItems(dlist)
		this.UpdateTopItems(tlist)
	}

	public UpdateDayItems(list?) {
		if (!this.loop_day) {
			this.loop_day = new LoopScrowViewMgr()
			this.loop_day.SetData(this.Content1, kfSRAwardItem, list, LoopScrCon.Horizontal)
		} else {
			this.loop_day.replaceAll(list)
		}


	}

	public UpdateTopItems(list?) {
		if (!this.loop_top) {
			this.loop_top = new LoopScrowViewMgr()
			this.loop_top.SetData(this.Content2, kfSRAwardItem, list, LoopScrCon.Horizontal)
		} else {
			this.loop_top.replaceAll(list)
		}
	}


	_Image1: Laya.Image
	_lb_layer: Laya.Label
	Content1: Laya.List
	Content2: Laya.List
	public GetComponents() {
		[
			this._Image1,
			this._lb_layer,
			this.Content1,
			this.Content2,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_layer",
				"Content1",
				"Content2",
			])
	}
}
window["kfSRRewardItem"] = kfSRRewardItem