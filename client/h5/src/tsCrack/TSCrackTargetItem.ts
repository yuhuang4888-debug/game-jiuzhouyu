import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, Util } from "../util/Util"
import { TSCrackTargetView } from "./TSCrackTargetView"



export class TSCrackTargetItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_lb_desc: Laya.HTMLDivElement
	Content: Laya.List
	_gp_btn: Laya.Box
	_img_btn: Laya.Image
	_lb_btn: Laya.Label
	_img_red: Laya.Image
	_img_get: Laya.Image
	Scr_Scroller1
	_list_reward_con
	item_loop_mgr
	reward_array



	public static width = 520

	public static height = 177
	WIDTH = 614
    HEIGT = 136
	public constructor(parent) {
		super()


		this.base_file = "tsCrack"

		this.layout_file = "TSCrackTargetItem"
		this.load_callback = () => {
			this._lb_desc.x = 40
			Util.AddClickEvent(this._gp_btn, () => {

				if (this.data) {
	
					if (this.data.status == 1) {
	
						if (this.data.type == TSCrackTargetView.PersonReward) {
	
							TSCrackModel.GetInstance().Fire(TSCrackModel.REQUEST_PROTO, 20406, this.data.stage)
	
						} else if (this.data.type == TSCrackTargetView.ServerReward) {
	
							TSCrackModel.GetInstance().Fire(TSCrackModel.REQUEST_PROTO, 20408, this.data.goal_id)
	
						}
	
					} else if (this.data.status == 0) {
	
						if (this.data.type == TSCrackTargetView.PersonReward) {
	
							GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "TSCrackTargetView")
	
							GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TSCrackScrambleView")
	
						} else if (this.data.type == TSCrackTargetView.ServerReward) {
	
							GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "TSCrackTargetView")
	
							if ((this.data.goal_id == 1003 || this.data.goal_id == 2003) || this.data.goal_id == 3003) {
	
								GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TSCrackScrambleView", 0)
	
							}
	
						}
	
					}
	
				}
	
			}, this, true)
	
	
	
			// this.reward_array = eui. new ArrayCollection()
	
			// this._list_reward_con.dataProvider = this.reward_array
	
			// this._list_reward_con.itemRenderer = CommonRewardItem
	
	
	
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("tsCrack", "uisksh_108"))
		}
		this.Load()
	}






	public dataChanged() {
		if (super.dataChanged()){
			let data = this.data

			let str = null
	
			if (data.type == TSCrackTargetView.PersonReward) {
	
				str = "每日争夺值达到" + data.need_value + "点"
	
				str = str + HtmlColorTxt("(" + data.value + "/" + data.need_value + ")", data.value >= data.need_value && "'#fff1b9'" || "'#fff1b9'")
	
			} else if (data.type == TSCrackTargetView.ServerReward) {
	
				str = data.doc
	
				str = str + HtmlColorTxt("(" + data.value + "/" + data.need_value + ")", data.value >= data.need_value && "'#fff1b9'" || "'#fff1b9'")
	
			}
	
			if (0 == data.status) {
	
				this._gp_btn.visible = true
	
				this._img_get.visible = false
	
				ResManager.GetInstance().SetImageSprite(this, this._img_btn, "common_asset", "com_rect_btn2")
	
				this._lb_btn.text = "获取"
	
				this._lb_btn.strokeColor = "#3e9298"
	
				this._img_red.visible = false
	
			} else if (1 == data.status) {
	
				this._gp_btn.visible = true
	
				this._img_get.visible = false
	
				ResManager.GetInstance().SetImageSprite(this, this._img_btn, "common_asset", "com_rect_btn1")
	
				this._lb_btn.text = "领取"
	
				this._lb_btn.strokeColor = "#c95b37"
	
				this._img_red.visible = true
	
			} else if (2 == data.status) {
	
				this._gp_btn.visible = false
	
				this._img_get.visible = true
	
				this._img_red.visible = false
	
			}
	
	
			this._lb_desc.style.fontSize = 18
			this._lb_desc.style.color = "#ffffff"
			this._lb_desc.style.wordWrap = false
			this._lb_desc.innerHTML = Util.StrToHTML(str)
	
	
	
			let list = []
	
			for (let _tmpi in data.reward) {
				var vo = data.reward[_tmpi]
	
				table.insert(list, { size: 75, vo: { style: vo[0], typeId: vo[1], count: vo[2] } })
	
			}
	
	
	
			if (this.item_loop_mgr) {
	
				this.item_loop_mgr.replaceAll(list)
	
			} else {
				this.item_loop_mgr = new LoopScrowViewMgr()
	
				this.item_loop_mgr.SetData(this.Content, CommonRewardItem, list, LoopScrCon.Horizontal)
	
			}
		}

		

	}



	public DeleteMe() {


		if (this.item_loop_mgr) {

			this.item_loop_mgr.DeleteMe()

			this.item_loop_mgr = false

		}
		super.DeleteMe()
	}




	public GetComponents() {
		[
			this._img_bg,
			this._lb_desc,
			this.Content,
			this._gp_btn,
			this._img_btn,
			this._lb_btn,
			this._img_red,
			this._img_get,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_desc",
				"Content",
				"_gp_btn",
				"_img_btn",
				"_lb_btn",
				"_img_red",
				"_img_get",
			])
	}
}
window["TSCrackTargetItem"] = TSCrackTargetItem