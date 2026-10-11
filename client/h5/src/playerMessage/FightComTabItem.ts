import { BaseItem1 } from "../common/BaseItem1"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { Util, SetSizeDeltaY, SetAnchoredPosition, GlobalTimerQuest } from "../util/Util"
import { FightComSubItem } from "./FightComSubItem"

export class FightComTabItem extends BaseItem1 {
	CallBack
	DesList
	ImgWidth
	Info
	InitEvent
	ItemHeight
	desHeight
	hasCreate
	need_refreshData
	p1
	p1Img
	p2
	p2Img
	state
	tab_img

	title
	p1Lb
	p2Lb
	desBg
	bg1
	upBtn
	tabBtn
	desGp

	_Group1: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	lable_tabbtn_text: Laya.Label

	public constructor(parent?) {
		super(parent)


		this.desHeight = 130;
		this.ImgWidth = 227;
		this.ItemHeight = 44;
		this.DesList = [];
		this.hasCreate = false;
		this.need_refreshData = false;
		this.base_file = "playerMessage"
		this.layout_file = "FightComTabItem"
		this.load_callback = () => {
			this.p1 = this.p1Img
			this.p2 = this.p2Img
			this.tab_img = this.tabBtn
			this.desBg.visible=false
			this.InitEvent()
			this.SetData(this.Info, this.CallBack)
		}
		this.InitEvent = () => {
			Util.AddClickEvent(this.upBtn, () => {
				if (this.Info) {
					FriendModel.GetInstance().Fire(FriendEvent.CLOSE_MES_VIEW)
					OpenFun.OpenFunHandler(this.Info.jumpId)
				}
			}
				, this, true)
			Util.AddClickEvent(this.tabBtn, () => {
				if (this.Info) {
					this.SetState(!this.state)
				}
				if (this.CallBack) {
					this.CallBack(this)
				}
			}
				, this, true)
		}



	}

	public SetData(info?, CallBack?) {

		this.Info = info
		this.CallBack = CallBack



		if (this.is_loaded && this.Info) {
			this.tabBtn.visible = this.Info.tab.length != 0
			this.title.text = info.name
			let max = Math.max(info.value1, info.value2, 1)
			this.p1Img.width = info.value1 / max*281
			this.p2Img.width = info.value2 / max*281
			let num1=null
			let num2=null
			if(info.value1>100000000){
				num1=WordManager.ConvertNum(info.value1,true)
				this.p1Lb.text=num1
			}else{
				this.p1Lb.text=info.value1
			}
			if(info.value2>100000000){
				num2=WordManager.ConvertNum(info.value2,true)
				this.p2Lb.text=num2
			}else{
				this.p2Lb.text=info.value2
			}
			// this.p1Lb.text = info.value1
			// this.p2Lb.text = info.value2
		} else {
			this.need_refreshData = true
		}
	}

	public SetState(bool?) {

		if (bool == this.state) {
			return
		}
		this.state = bool
		if (bool) {
			ResManager.GetInstance().SetImageSprite(this, this.tab_img, "playerMessage", "uickwj_013", true)
			this.lable_tabbtn_text.text = "收起列表"
			this.desGp.visible = true
			let count = this.Info.tab.length
			let hide = 0
			if (!this.hasCreate) {
				this.hasCreate = true
				let i = 0
				do {
					if (!this.Info.tab[i].hide) {
						let item = new FightComSubItem(this.desGp)
						item.SetSubData(this.Info.tab[i])
						item.Load()
						this.DesList[i] = item
					} else {
						hide = hide + 1
					}
					i = i + 1
				} while ((i < count)
				)
			}else{
				let i = 0
				do {
					if (!this.Info.tab[i].hide) {

					} else {
						hide = hide + 1
					}
					i = i + 1
				} while (i < count)
			}
			this.desBg.visible=true
			SetSizeDeltaY(this.desBg, (count - hide) * this.ItemHeight)
			SetSizeDeltaY(this.display_obj, this.desHeight + ((count - hide) * this.ItemHeight) + 20)
			SetSizeDeltaY(this.bg1, this.display_obj.height)
			SetAnchoredPosition(this.tabBtn, this.tabBtn.x, this.tabBtn.y+this.desBg.height+20)
		} else {
			this.desBg.visible=false
			SetSizeDeltaY(this.desBg, 0)
			ResManager.GetInstance().SetImageSprite(this, this.tab_img, "playerMessage", "uickwj_012", true)
			this.lable_tabbtn_text.text = "展开列表"
			this.desGp.visible = false
			SetSizeDeltaY(this.display_obj, this.desHeight)
			SetSizeDeltaY(this.bg1, this.display_obj.height)
			SetAnchoredPosition(this.tabBtn, this.tabBtn.x, 90)
		}

		GlobalTimerQuest.AddDelayQuest(() => {
			FriendModel.GetInstance().Fire(FriendEvent.UPDATE_MESSAGE_TAB)
		}, 0.1)
	}

	public DeleteMe() {

		for (let key in this.DesList) {

			// [ts2lua]this.DesList下标访问可能不正确
			this.DesList[key].DeleteMe()
			// [ts2lua]this.DesList下标访问可能不正确
			this.DesList[key] = null
		}
		this.DesList = []
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this.bg1,
			this._Group1,
			this._Image1,
			this.title,
			this._Image2,
			this.upBtn,
			this.tabBtn,
			this.desBg,
			this.desGp,
			this._Image3,
			this.p1Img,
			this._Image4,
			this.p2Img,
			this.p1Lb,
			this.p2Lb,
			this.lable_tabbtn_text
		]
			= this.GetChildrenByNames([

				"bg1",
				"_Group1",
				"_Image1",
				"title",
				"_Image2",
				"upBtn",
				"tabBtn",
				"desBg",
				"desGp",
				"_Image3",
				"p1Img",
				"_Image4",
				"p2Img",
				"p1Lb",
				"p2Lb",
				"lable_tabbtn_text"
			])
	}
}


window["FightComTabItem"] = FightComTabItem