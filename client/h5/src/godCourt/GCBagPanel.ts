import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { ColorUtil } from "../util/ColorUtil"
import { GoodsModel } from "../commonModel/GoodsModel"
import { DownDropBtn } from "../common/DownDropBtn"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GCBagItem } from "./GCBagItem"

export class GCBagPanel extends BaseItem1 {
	DeleteMe1
	InitEvent
	InitView
	UpdateBagData

	colorBtn
	godCourtId
	typeBtn

	public constructor(parent?) {
		super(parent)
		this.base_file = "godCourt"
		this.layout_file = "GCBagPanel"

		let local_goodsIns = GoodsModel.GetInstance()
		let model = GodCourtModel.GetInstance()
		let showList = null
		let bagArr = null

		this.load_callback = () => {
			this._Scroller1.vScrollBarSkin = ""
			this.InitView()
			this.InitEvent()
		}

		this.InitView = () => {
			this.colorBtn = new DownDropBtn(this.colorBtnGp)
			this.typeBtn = new DownDropBtn(this.typeBtnGp)
			let ClickPos = (index?, data?) => {
				if (data) {
					model.showType = data.cond
					this.UpdateBagData()
				}
			}

			let defaultText = "任意部位"
			let PosList = [{ id: 0, content: "任意部位", cond: 0 }]
			let i = 1
			let cfg = GodCourtModel.SubtypeNameList
			for (let key in cfg) {
				var vo = cfg[key]
				table.insert(PosList, { id: i, content: vo, cond: i })
				i = i + 1
			}
			for (let key in PosList) {
				let vo = PosList[key]
				if (vo.cond == model.showType) {
					defaultText = vo.content
					break
				}
			}
			this.typeBtn.Init(PosList, ClickPos, defaultText, "content", "Activity", 7, false, false)
			this.typeBtn.Load()

			let ClickColor = (index?, data?) => {
				if (data) {
					model.showColor = data.cond
					this.UpdateBagData()
				}
			}

			let colorList = []
			table.insert(colorList, { id: 0, content: "任意品质", cond: 0 })
			i = 0
			do {
				let color = i + 2
				table.insert(colorList, { id: i, content: ColorUtil.GetColorName(color) + "及以上", cond: color })
				i = i + 1
			} while ((i < 4))
			defaultText = "任意品质"
			for (let key in colorList) {
				let vo = colorList[key]
				if (vo.cond == model.showColor) {
					defaultText = vo.content
					break
				}
			}
			this.colorBtn.Init(colorList, ClickColor, defaultText, "content", "Activity", null, false, false)
			this.colorBtn.Load()

			this.UpdateBagData()
		}

		this.InitEvent = () => {
			this.BindEvent(local_goodsIns, GoodsModel.CHANGE_GODCOURT_BAG, () => {
				if (!this.use_delete_method) {
					this.UpdateBagData()
				}
			})
		}

		this.UpdateBagData = () => {
			let list = local_goodsIns.godCourtBagList
			showList = []
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				if (((model.showColor == 0) || vo.color >= model.showColor) && ((model.showType == 0) || vo.subtype == model.showType)) {
					vo.bagGodCourtId = this.godCourtId
					table.insert(showList, vo)
				}
			}

			for (let i = list.length; i < local_goodsIns.godCourtBagMaxCell; i++) {
				table.insert(showList, {})
			}

			if (!bagArr) {
				bagArr = new LoopScrowViewMgr()
				bagArr.SetData(this._Scroller1, GCBagItem, showList, LoopScrCon.Vertical, 6)
			} else {
				bagArr.replaceAll(showList)
			}
			this.countLb.text = "容量：" + list.length + "/" + local_goodsIns.godCourtBagMaxCell
		}

		this.DeleteMe1 = () => {
			if (bagArr) {
				bagArr.DeleteMe()
				bagArr = null
			}
			if (this.colorBtn) {
				this.colorBtn.DeleteMe()
				this.colorBtn = null
			}
			if (this.typeBtn) {
				this.typeBtn.DeleteMe()
				this.typeBtn = null
			}
		}
	}

	public SetId(id?) {
		this.godCourtId = id
	}

	public DeleteMe() {
		this.DeleteMe1()
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_Scroller1: Laya.List
	countLb: Laya.Label
	colorBtnGp: Laya.Box
	typeBtnGp: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._Scroller1,
			this.countLb,
			this.colorBtnGp,
			this.typeBtnGp,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_Scroller1",
				"countLb",
				"colorBtnGp",
				"typeBtnGp",
			])
	}
}
window["GCBagPanel"] = GCBagPanel