import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { GameResPath } from "../util/GameResPath"
import { Util, HtmlColorTxt, SetHtmlStyle } from "../util/Util"
import { HolyBattleRewardView } from "./HolyBattleRewardView"

export class HolyBattleRewardItem extends BaseItemRenderer {
	//Emp_gp_get
	VHS_Scroller1
	reward_array

	public WIDTH = 576
	public HEIGT = 138

	public constructor(parent) {
		super()

		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleRewardItem"
		//this.layer_value = Enum_UILayer.Activity
		this.reward_array = null
		this.load_callback = () => {
			SetHtmlStyle(this._lb_desc, { c: "#663915", f: 18, w: 400, ww: false })
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {

		Util.AddClickEvent(this._gp_get, () => {
			if (this.data.status == 1) {
				HolyBattleModel.GetInstance().Fire(HolyBattleModel.REQUEST_PROTO, 21806, this.data.stage)
			}
		}, this, true)



		//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("holyBattle","uism_057"), true)
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		let data = this.data

		let str = null
		if (data.type == HolyBattleRewardView.Score) {
			str = "个人积分达到" + HtmlColorTxt(data.need_point, "'#d15e00'") + "积分可领取"
			let text_color = data.point >= data.need_point && "'#d15e00'" || "'#ff4f50'"
			str = str + HtmlColorTxt("(" + data.point + "/" + data.need_point + ")", text_color)

			
			if (data.status == 0) {
				this._gp_get.visible = true
				this._img_get.visible = false
				this._lb_get.text = "未达到"
				this._img_red.visible = false

				this._Image1.gray=true
				this._lb_get.stroke=0
			} else if (data.status == 1) {
				this._gp_get.visible = true
				this._img_get.visible = false
				this._lb_get.text = "领  取"
				this._img_red.visible = true

				this._Image1.gray=false
				this._lb_get.stroke=2
			} else if (data.status == 2) {
				this._gp_get.visible = false
				this._img_get.visible = true
				this._lb_get.text = "已领取"
				this._img_red.visible = false

				this._Image1.gray=true
				this._lb_get.stroke=0
			}

			

		} else if (data.type == HolyBattleRewardView.Camp) {
			this._img_get.visible = false
			this._gp_get.visible = false
			str = data.desc
		}
		this._lb_desc.innerHTML = str


		let list = []
		for (let _tmpi in data.reward) {
			var vo = data.reward[_tmpi]
			table.insert(list,
				{
					size: 89,
					vo: {
						style: vo[0],
						typeId: vo[1],
						count: vo[2]
					},
					layer_value: "Activity"
				})
		}
		if (!this.reward_array) {
			this.reward_array = new LoopScrowViewMgr()
			this.reward_array.SetData(this._list_award_con, CommonRewardItem, list, LoopScrCon.Horizontal)
		} else {
			this.reward_array.replaceAll(list)
		}

		this._list_award_con.scrollBar.touchScrollEnable=list.length>3

	}

	public DeleteMe() {

		if (this.reward_array) {
			this.reward_array.DeleteMe()
			this.reward_array = null
		}
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_lb_desc: Laya.HTMLDivElement
	_list_award_con: Laya.List
	_gp_get: Laya.Box
	_Image1: Laya.Image
	_lb_get: Laya.Label
	_img_red: Laya.Image
	_img_get: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._lb_desc,
			this._list_award_con,
			this._gp_get,
			this._Image1,
			this._lb_get,
			this._img_red,
			this._img_get,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_lb_desc",
				"_list_award_con",
				"_gp_get",
				"_Image1",
				"_lb_get",
				"_img_red",
				"_img_get",
			])
	}
}
window["HolyBattleRewardItem"] = HolyBattleRewardItem