import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, Util } from "../util/Util"
import { FlowerRankRewardItem } from "./FlowerRankRewardItem"

export class FlowerRankRewardView extends BaseView1 {


	act_info
	act_data
	cur_sex

	model: CustomActivityModel
	act_timer
	item_loop_mgr: LoopScrowViewMgr
	public constructor() {
		super()
		this.base_file = "flowerRank"
		this.layout_file = "FlowerRankRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.model = CustomActivityModel.GetInstance()

		this.load_callback = () => {
			//resource/game/flowerRank/texture/ui_content_bg1.png
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("flowerRank", "ui_content_bg1"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.Separate_img2, "resource/game/common2/texture/com_line_5.png", true)

			this._html_rank.style.fontSize = 22
			this._html_rank.style.color = "#663915"
			this._html_rank.style.wordWrap = false

			this.InitEvent()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true)
	}


	public UpdateView() {
		if (!this.act_info || !this.act_data) {
			return
		}	

		let cur_sex = this.cur_sex
		let my_sex = RoleManager.GetInstance().mainRoleInfo.sex
		this._html_rank.visible = cur_sex == my_sex
		if (cur_sex == my_sex) {
			let str = this.act_data.sel_rank == 0 && "未上榜" || this.act_data.sel_rank
			this._html_rank.innerHTML = `当前排名:&nbsp;${HtmlColorTxt(str, "'#0a953e'")}`
		}
		if (this.act_timer) {
			this.act_timer.DeleteMe()	
			this.act_timer = undefined
		}
		this.act_timer = this.model.LoadActTimer(this._box_time, this.act_info.etime, 22, "#0a953e", null, "#663915", "活动剩余时间：")
		this.InitRewardItem()
	}

	public InitRewardItem() {
		let data = CustomActivityModel.GetInstance().GetActData(this.act_info.base_type, this.act_info.sub_type)
		if (!data) {
			return
		}
		let list = data.reward_list

		list.sort((a?, b?) => {
			return a.grade - b.grade
		})


		let reward_list = []

		for (let vo of list) {
			reward_list.push({
				info: this.act_info,
				data: vo,
				cur_sex: this.cur_sex,
				my_rank: this.act_data.sel_rank
			})
		}


		if (this.item_loop_mgr) {
			this.item_loop_mgr.replaceAll(reward_list)
		} else {
			this.item_loop_mgr = new LoopScrowViewMgr()
			this.item_loop_mgr.SetData(this._list_item, FlowerRankRewardItem, reward_list, LoopScrCon.Vertical, 1)

		}
	}

	public Remove() {
		if (this.act_timer) {
			this.act_timer.DeleteMe()
			this.act_timer = undefined
		}
		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = undefined
		}
	}


	public Open(...parms): void {
		if (parms && parms[0]) {
			this.act_info = parms[0]
			this.act_data = parms[1]
			this.cur_sex = parms[2]
		}
		super.Open()
	}


	_img_close: Laya.Image
	_img_bg:Laya.Image
	_list_item: Laya.List
	_html_rank: Laya.HTMLDivElement
	_box_time: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_close,
			this._img_bg,
			this._list_item,
			this._html_rank,
			this._box_time
		]
			= this.GetChildrenByNames([

				"_img_close",
				"_img_bg",
				"_list_item",
				"_html_rank",
				"_box_time"
			])
	}
}
window["FlowerRankRewardView"] = FlowerRankRewardView