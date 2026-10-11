import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
// TypeScript file
export class MainUIFightModeItem extends BaseItem1 {
	info
	need_refresh_data
	need_refresh_pk_status
	call_func
	is_pk_status = false

	constructor(parent) {
		super(parent)
		this.base_file = "mainUI"
		this.layout_file = "MainUIFightModeItem"
		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._lb_desc.fontSize = 16
			}
			this.InitEvent()
		}
	}
	private InitEvent() {
		
		Util.AddClickEvent(this._img_bg,()=>{
			if (this.call_func && this.info)
				this.call_func(this.info.pk_status)
		},this,false)

		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
		if (this.need_refresh_pk_status) {
			this.SetSelect(this.is_pk_status)
		}
	}

	public SetData(info, call_func) {
		this.info = info
		this.call_func = call_func
		if (this.is_loaded) {
			this.UpdateView()
		}
		else {
			this.need_refresh_data = true
		}
	}

	public UpdateView() {
		this._lb_desc.text = this.info.desc
		this._img_status.skin = GameResPath.GetIcon("mainUI", this.info.source)
		this._img_bg.skin = GameResPath.GetIcon("mainUI", this.info.bg_source)
		// ResManager.GetInstance().SetTexture(this, this._img_bg, GameResPath.GetIcon("mainUI", this.info.bg_source))
	}

	public SetSelect(bool: boolean) {
		this.is_pk_status = bool
		if (this.is_loaded) {
			this._img_select.visible = bool
		}
		else {
			this.need_refresh_pk_status = true
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_lb_desc: Laya.Label
	_img_status: Laya.Image
	_img_select: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._lb_desc,
			this._img_status,
			this._img_select,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_desc",
				"_img_status",
				"_img_select",
			])
	}
}
window["MainUIFightModeItem"] = MainUIFightModeItem