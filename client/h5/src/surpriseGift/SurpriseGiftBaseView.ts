import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { SurpriseGiftModel } from "../commonModel/SurpriseGiftModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import "../surpriseGift/SurpriseGiftMainView"
import "../surpriseGift/GiftView"
import "../surpriseGift/DrawView"

export class SurpriseGiftBaseView extends BaseWindowComponent {
	CheckRed
	InitSubEvent
	LoadSuccess
	bg_list
	change_scene_close
	money_list
	tabStrList
	tab_item_renderer
	titleStr
	touchEnabled
	viewClassList
	window_load_back

	public constructor() {
		super()


		this.dependent_res = ["surpriseGift"]
		//this.tabStrList = [{icon_up_source:"surpriseGift_asset.uizqzp_000a", icon_down_source:"surpriseGift_asset.uizqzp_000a", x:-5,y:-25}, {icon_up_source:"surpriseGift_asset.uizqzp_001a", icon_down_source:"surpriseGift_asset.uizqzp_001b", x:-20,y:-30}, {icon_up_source:"surpriseGift_asset.uizqzp_002a", icon_down_source:"surpriseGift_asset.uizqzp_002b", x:-20,y:-30}, {icon_up_source:"surpriseGift_asset.uizqzp_003a", icon_down_source:"surpriseGift_asset.uizqzp_003b", x:-20,y:-30}, {icon_up_source:"surpriseGift_asset.uizqzp_004a", icon_down_source:"surpriseGift_asset.uizqzp_004b", x:-20,y:-30}, {icon_up_source:"surpriseGift_asset.uizqzp_005a", icon_down_source:"surpriseGift_asset.uizqzp_005b", x:-20,y:-30}]
		this.titleStr = "surpriseGift.uijxlb_001"
		this.tabStrList = [{ label: "vip专属",image: false }, { label: "超帅时装",image: {show:false} }, { label: "斗花魁",image: {show:false} }, { label: "流鸢之羽",image: {show:false} }, { label: "蓝鹊秋千",image: {show:false} }, { label: "免费抽奖",image: {show:false} }]
		this.bg_list = ["uijxlb_304.jpg", "uijxlwcj_032a.jpg", "uijxlwcj_032a.jpg", "uijxlwcj_032a.jpg", "uijxlwcj_032a.jpg", "uijxlb_201.jpg"]
		this.viewClassList = ["SurpriseGiftMainView", "GiftView", "GiftView", "GiftView", "GiftView", "DrawView"]
		//this.tab_item_renderer = TabButtonTwoSkin
		this.change_scene_close = false
		this.money_list = [2, 1, 0]
		let local_SurpriseGiftModel = SurpriseGiftModel
		let model = local_SurpriseGiftModel.GetInstance()
		this.window_load_back = () => {
			let view_name = this.viewClassList[0]
			if (view_name) {
				let func_is_open = CommonManager.GetInstance().CheckFuncOpenState(view_name)
				if (!func_is_open) {
					this.Close()
				}
			}
			//this._story_bar2.includeInLayout = false
			//this._story_bar2.touchThrough = true
			//this.touchEnabled = false
			//this._img_tab_bg.y = 30
			//this._img_tab_bg.width = 620
			//SetSizeDeltaY(this._tab_scroller,120)
			//lua_resM:SetImageSprite(this,this._img_tab_bg,"surpriseGift_asset", "uijxlwcj_0013")
			//SetSizeDelta(this._img_tab_bg,600,90)
			this.InitSubEvent()
			this.CheckRed()
			let view_info = model.GetViewInfo()
			if (view_info && view_info.gift_list && view_info.gift_list.length > 0) {
				for (let _ in view_info.gift_list) {
					var v = view_info.gift_list[_]
					this.SetTabImage(v.gift_id, true, "buy", -2, 3)
				}
			}
			//
		}

		//this.LoadSuccess = () => {

		////this._img_tab_bg.scale9Grid = Laya. new Rectangle(5, 5, 10, 67)
		//}

		this.InitSubEvent = () => {
			this.BindEvent(model, local_SurpriseGiftModel.SELECT_VIEW, (i?) => {
				let index = i
				this.SetSelectIndex(index)
				this._list_tab_con.scrollBar.value = Math.max((150 + 0) * (Number(index) + 1) - this._list_tab_con.width, 0)
				//if (index >= 5 ) {
				//this._list_tab_con.scrollH = 120 * index - 4
				//}
				//this.tab_loop_mgr.LastOnChild(index)
			}
			)
			this.BindEvent(model, local_SurpriseGiftModel.REF_TAB_RED, () => {
				this.CheckRed()
			}
			)
			this.BindEvent(model, local_SurpriseGiftModel.BUY_SUCCESS, (gift_id?) => {
				this.SetTabImage(gift_id, true, "buy", -2, 3)
			})
		}

		this.CheckRed = () => {
			let len = this.viewClassList.length
			let i = 0
			do {
				let status = model.CheckGradeRed(i)
				GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SurpriseGiftBaseView", i, status)
				i = i + 1
			} while ((i < len))
		}


	}
}
window["SurpriseGiftBaseView"] = SurpriseGiftBaseView