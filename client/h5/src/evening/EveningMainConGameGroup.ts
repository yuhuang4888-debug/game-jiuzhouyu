import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GuildActivityModel } from "../commonModel/GuildActivityModel"
import { GameResPath } from "../util/GameResPath"
import { RefBoxVLayout } from "../util/Util"
import { Evening1MainConItem } from "./Evening1MainConItem"

/**游戏阶段 */
export class EveningMainConGameGroup extends BaseItem1 {
	_ac_item
	_data
	_model: GuildActivityModel
	is_set
	public constructor(parent?) {
		super(parent)
		this.is_set = false
		this.base_file = "evening"
		this.layout_file = "EveningMainConGameGroup"
		this._model = GuildActivityModel.GetInstance()
		this.load_callback = () => {
			this._Scroller_1.vScrollBarSkin = ""
			this._Scroller_2.vScrollBarSkin = ""
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconOtherPath("evening", "ui_Guild_48"), false)


			let type = GuildActivityModel.GetInstance().EveningGameType()
			this._img_light.x= type ==2?329:3

			if (!this.is_set && this._data) {
				this.UpdateData()
			}
		}
	}

	public DeleteMe() {

		super.DeleteMe()
	}

	public UpdateData(data?) {
		if (!this._data) return
		let obj = this._data[1]
		this._lb_1.wordWrap = true
		this._lb_2.wordWrap = true
		this._lb_1.text = obj.content
		this._lb_2.text = obj.content2
		this._lb_1.height = this._lb_1.textField.textHeight+20
		this._lb_2.height = this._lb_2.textField.textHeight+20
	}

	public SetData(data?) {
		let GetClientCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigGuildAct", true)
		this._data = this._model.GetClientCfg(GetClientCfg, "evening_intro_cfg")

		if (this.is_loaded) {
			this.UpdateData()
			this.is_set = true
		} else {
			this.is_set = false
		}

	}


	_img_bg: Laya.Image
	_img_1: Laya.Image
	_img_2: Laya.Image
	_img_light: Laya.Image
	_Scroller_1: Laya.Panel
	_lb_1: Laya.Label
	_Scroller_2: Laya.Panel
	_lb_2: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_1,
			this._img_2,
			this._img_light,
			this._Scroller_1,
			this._lb_1,
			this._Scroller_2,
			this._lb_2,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_1",
				"_img_2",
				"_img_light",
				"_Scroller_1",
				"_lb_1",
				"_Scroller_2",
				"_lb_2",
			])
	}
}
window["EveningMainConGameGroup"] = EveningMainConGameGroup