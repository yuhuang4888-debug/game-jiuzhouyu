import { BaseItem1 } from "../common/BaseItem1";
import { ResManager } from "../common/ResManager";
import { DemonDefine } from "../commonModel/DemonDefine";
import { DemonModel } from "../commonModel/DemonModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class DemonFettersHeadItem extends BaseItem1 {
	_img_bg: Laya.Image
	_img_head_mask: Laya.Image
	_img_head: Laya.Image
	_img_tips: Laya.Image


	demons_cfg
	need_refresh_data

	public constructor(parent) {
		super(parent)

		this.base_file = "demon"
		this.layout_file = "DemonFettersHeadItem"
		this.need_refresh_data = false
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		// this._img_head.mask = this._img_head_mask

		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdateView()
		}
	}

	public SetData(demons_cfg?) {
		this.demons_cfg = demons_cfg
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}
	public UpdateView() {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_head,GameResPath.GetIcon("demon",`demon_head_${this.demons_cfg.demons_id}`))
		let source = DemonDefine.Quality2Setting[this.demons_cfg.color].circle_source
		this._img_bg.skin = GameResPath.GetIcon(source[0],source[2])

		let tips_source = DemonDefine.tips_source[this.demons_cfg.realm + "@" + this.demons_cfg.color]
		if (tips_source) {
			this._img_tips.source = tips_source
		}

		if (DemonModel.GetInstance().IsActive(this.demons_cfg.demons_id)) {
			Util.SetImageGray(this._img_head, false)
			Util.SetImageGray(this._img_bg, false)
			Util.SetImageGray(this._img_tips, false)
		} else {
			Util.SetImageGray(this._img_head, true)
			Util.SetImageGray(this._img_bg, true)
			Util.SetImageGray(this._img_tips, true)
		}

	}

	public DeleteMe() {
		this.need_refresh_data = false
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._img_bg,
			this._img_head_mask,
			this._img_head,
			this._img_tips,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_head_mask",
				"_img_head",
				"_img_tips",
			])
	}
}
window["DemonFettersHeadItem"]=DemonFettersHeadItem