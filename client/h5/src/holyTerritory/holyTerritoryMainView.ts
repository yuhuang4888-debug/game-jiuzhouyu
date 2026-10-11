import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { HolyTerritoryModel, HTEvent } from "../commonModel/HolyTerritoryModel"
import "./HolyTerritoryDsgtView"
import "./HolyTerritoryTotalView"
import "../sacredShop/SacredShopView"
import "../snatchTreasure/SnatchTreasureView"
import { SetLocalPositionX, Util } from "../util/Util"
import { StoryModel } from "../commonModel/StoryModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { CookieWrapper } from "../common/CookieWrapper"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { RedKey } from "../common/RedDotDefine"
export class holyTerritoryMainView extends BaseWindowComponent {
	bg_list
	tabStrList
	titleStr
	viewClassList

	public constructor() {
		super()
        this.destroy_imm = true;
        this.money_list = [2, 1, 0]
		this.dependent_res = ["holyTerritory", "snatchTreasure"]
		if (!HolyTerritoryModel.GetInstance().IsRealOpen()) {
			this.tabStrList = [{ label: "异域称号" }, { label: "异域争霸" ,red_key: RedKey.HOLY_TERRITORY}]
			this.viewClassList = ["HolyTerritoryDsgtView", "HolyTerritoryTotalView"]
			this.bg_list = ["uisy_002.jpg", "uisyld_015.jpg"]
		} else {
			this.tabStrList = [{ label: "异域称号" }, { label: "异域争霸",red_key: RedKey.HOLY_TERRITORY }, { label: "异域夺宝" }, { label: "异域商店" }]//, {label:"圣域夺宝"}
			this.viewClassList = ["HolyTerritoryDsgtView", "HolyTerritoryTotalView", "SnatchTreasureView", "SacredShopView"]
			this.bg_list = ["uisy_002.jpg", "uisyld_015.jpg", "uisydb_001.jpg", "ui_holyland_bg4.jpg"]
		}
		this.titleStr = "holyTerritory.uisy_001"
		this.window_open_back = () => {
			Util.AddClickEvent(this._story_bar2, () => {
				this.SetSelectIndex(1, null, true)
			}, false)
			SetLocalPositionX(this._story_bar2, 230) //第二个选项卡位置
			StoryModel.GetInstance().story_index = 1

			StoryModel.GetInstance().story_obj = this
			let is_login = CookieWrapper.GetInstance().GetCookie(CookieWrapper.HT_LOGIN_STATE, true)
			if (!is_login && ServerTimeModel.GetInstance().GetOpenServerDay() == 2) {
				this._story_bar2.mouseEnabled = true
				this._story_bar2.mouseThrough = false
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._story_bar2, this.layer_value, false, false, false, true,
					{ text: "参与异域争霸，获取影装和异域积分", direction: 2, "effect_scaleX": 0.65, "effect_scaleY": 0.9 }, true)
			}


		HolyTerritoryModel.GetInstance().icon_red = false
		HolyTerritoryModel.GetInstance().SetIconRed()
		}
	

	}

	public Open(...new_args) {

		let parm = new_args[0]
			if (parm != undefined) {
				this.SetDefaultIndex(parm)
			}
			super.Open()
	}
	public Close() {
		CookieWrapper.GetInstance().SaveCookie(CookieWrapper.HT_LOGIN_STATE, 1)
		super.Close()
	}

	public SetSelectIndex(index, is_real_index?, delete_arrow?) {
		if (delete_arrow)
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._story_bar2);
		super.SetSelectIndex(index, is_real_index)
	}
    public DeleteMe() {
        super.DeleteMe();
    }

}
window["holyTerritoryMainView"] = holyTerritoryMainView