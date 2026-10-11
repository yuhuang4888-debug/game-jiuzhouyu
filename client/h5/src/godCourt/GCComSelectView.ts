import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { ColorUtil } from "../util/ColorUtil"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GCComSelectItem } from "./GCComSelectItem"

export class GCComSelectView extends BaseView1 {
	InitView
	Open

	bagArr

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GCComSelectView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.destroy_imm = true

		let data = null
		let MatIndex = null
		let color = 2
		let local_goodsIns = GoodsModel.GetInstance()

		this.load_callback = () => {
			this.needLb.style.fontSize = 20
			this.needLb.style.wordWrap = false
			this.needLb.style.color = "#663915"
			this.InitView()
			Util.AddClickEvent(this.close_btn, () => {
				this.Close()
			}, this, true)
		}

		this.destroy_callback = () => {
			if (this.bagArr) {
				this.bagArr.DeleteMe()
				this.bagArr = null
			}
		}

		this.Open = (...new_args) => {
			let parms = new_args
			if (parms) {
				MatIndex = parms[0]
				data = []
				if (parms[1]) {
					for (let _tmpi in parms[1]) {
						let vo = parms[1][_tmpi]
						data[Number(vo)] = true
					}
					let goodsBasic = local_goodsIns.GetGoodsBasicByTypeId(parms[1][0])
					if (goodsBasic) {
						color = goodsBasic.color
					}
				}
			}
			super.Open()
		}

		this.InitView = () => {
			if (this.is_loaded && data) {
				let list = local_goodsIns.godCourtBagList
				let showList = []
				let selectedList = GodCourtModel.GetInstance().comSelect
				for (let _tmpi in list) {
					let vo = list[_tmpi]
					if (data[vo.type_id] && selectedList[vo.goods_id] == null) {
						vo.comIndex = MatIndex
						table.insert(showList, vo)
					}
				}

				if (!this.bagArr) {
					this.bagArr = new LoopScrowViewMgr()
					this.bagArr.SetData(this._Scroller1, GCComSelectItem, showList, LoopScrCon.Vertical, 5)
				} else {
					this.bagArr.replaceAll(showList)
				}

				this.needLb.innerHTML = Util.StrToHTML("需放入" + ColorUtil.GetColorName(color) + "品质的<font color='#4ba800'>" + "纹章" + "</font>")
				this.tips_label.visible = showList.length == 0
			}
		}
	}

	bg: Laya.Image
	item_bg: Laya.Image
	tips_label: Laya.Label
	_Scroller1: Laya.List
	needLb: Laya.HTMLDivElement
	close_btn: Laya.Image
	img_title: Laya.Image
	lb_title: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this.item_bg,
			this.tips_label,
			this._Scroller1,
			this.needLb,
			this.close_btn,
			this.img_title,
			this.lb_title,
		]
			= this.GetChildrenByNames([
				"bg",
				"item_bg",
				"tips_label",
				"_Scroller1",
				"needLb",
				"close_btn",
				"img_title",
				"lb_title",
			])
	}
}
window["GCComSelectView"] = GCComSelectView