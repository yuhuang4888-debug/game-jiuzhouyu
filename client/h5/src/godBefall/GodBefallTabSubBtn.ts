import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"
import { RedDotManager } from "../common/RedDotManager"
import { PlatformManager } from "../PlatformManager"
import { GodBefallModel, GodBefallEvent, GodBefallRedList } from "../commonModel/GodBefallModel"

export class GodBefallTabSubBtn extends BaseItem1 {
	_model
	call_back
	id
	needRefresh
	parent
	parent_index
	red_state
	refresh_red
	select_cache
	sub_index

	public static Height = 120

	public constructor(parent?) {
		super(parent)
		this.base_file = "godBefall"
		this.layout_file = "GodBefallTabSubBtn"
		this.parent = parent

		this.needRefresh = false
		this.parent_index = 0
		this.sub_index = 0
		this._model = GodBefallModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public DeleteMe() {
		this.parent = null
		super.DeleteMe()
	}

	public LoadSuccess() {
		if (PlatformManager.IsEyouEnPlatform()) {
			this._lb_name.fontSize = 16
		}
		if (this.needRefresh) {
			this.SetSubData(this.id, this.parent_index, this.sub_index, this.call_back)
		}
		if (this.refresh_red) {
			this.SetRedDot(this.red_state)
		}
	}

	public SetSubData(id?, parent_index?, sub_index?, call_back?) {
		this.id = id
		this.parent_index = parent_index
		this.sub_index = sub_index
		this.call_back = call_back
		if (this.is_loaded) {
			if (this.select_cache != null) {
				this.SetSelected(this.select_cache)
				this.select_cache = null
			}
			this.SetData()
		} else {
			this.needRefresh = true
		}
	}

	public SetSelected(bool?) {
		if (this.is_loaded) {
			if (bool && this.call_back) {
				this.call_back(this.id)
			}
			this._img_select.visible = bool
		} else {
			this.select_cache = bool
		}
	}

	public SetRedDot(bool?) {
		this.red_state = bool
		if (this.is_loaded) {
			this.refresh_red = false
			this.red_dot.visible = bool
		} else {
			this.refresh_red = true
		}
	}

	public SetData() {
		if (!this.id) {
			return
		}
		let vo = this._model.GetGodVoInDic(this.id)
		let data = this._model.GetGodData(this.id)
		this._img_tips.visible = (vo && (vo.is_battle == 1 || (false)))
		//ResManager.GetInstance().SetImageSprite(this, this._img_icon, "godBefall", this.id + "")
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, "resource/game/godBefall/other/" + this.id + ".png")
		this._img_icon.gray = !vo ? true : false
		this._lb_name.text = data.name
		let color = (!vo && ("#6A625E") || ("#fe6000"))
		this._lb_name.color = ColorUtil.TryParseHtmlString(color)
		let red = RedDotManager.GetInstance().CheckAnyRedStatusMultModule(GodBefallRedList, this.id)
		if (!red) {
			red = GodBefallModel.GetInstance().GetGodSepcRedStatusAll(this.id)
		}
		this.SetRedDot(red)
	}

	public InitEvent() {
		Util.AddClickEvent(this.sub_conta, () => {
			GlobalEventSystem.Fire(EventName.SUB_TAB_BTN_BE_SELECTED, this.parent_index, this.sub_index)
		}, this)

		this.BindEvent(this._model, GodBefallEvent.UPDATE_GOD_VO, (id?) => {
			if (this.id != id) {
				return
			}
			this.SetData()
		})

		this.BindEvent(this._model, GodBefallEvent.UPDATE_BATTLE_ID, (id?) => {
			this._img_tips.visible = this.id == id
		})
	}

	sub_conta: Laya.Box
	_img_bg: Laya.Image
	_img_icon: Laya.Image
	img_title: Laya.Image
	_img_select: Laya.Image
	_lb_name: Laya.Label
	_img_tips: Laya.Image
	red_dot: Laya.Image
	public GetComponents() {
		[
			this.sub_conta,
			this._img_bg,
			this._img_icon,
			this.img_title,
			this._img_select,
			this._lb_name,
			this._img_tips,
			this.red_dot,
		]
			= this.GetChildrenByNames([
				"sub_conta",
				"_img_bg",
				"_img_icon",
				"img_title",
				"_img_select",
				"_lb_name",
				"_img_tips",
				"red_dot",
			])
	}
}
window["GodBefallTabSubBtn"] = GodBefallTabSubBtn