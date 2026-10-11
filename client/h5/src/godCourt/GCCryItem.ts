import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GodCourtModel } from "../commonModel/GodCourtModel"

export class GCCryItem extends BaseItem1 {
	DeleteMe1
	InitEvent
	SetAlpha
	SetEffect

	color
	effectShow
	hasEffect
	cache_alpha
	cache_effect
	cache_pos

	public constructor(parent?) {
		super(parent)
		this.base_file = "godCourt"
		this.layout_file = "GCCryItem"

		this.effectShow = -1
		this.hasEffect = false
		this.hasEffect = false

		this.load_callback = () => {
			ResManager.GetInstance().SetImageSprite(this, this.Img1, "godCourt", "stone" + ((this.color + 1)), true)
			this.InitEvent()
			if (this.cache_alpha) {
				this.SetAlpha(this.cache_alpha)
			}
			if (this.effectShow != this.cache_effect) {
				this.SetEffect(this.cache_effect)
			}
			if (this.cache_pos){
				this.SetPos(this.cache_pos[0], this.cache_pos[1])
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.clickGp, () => {
				GodCourtModel.GetInstance().Fire(GodCourtModel.OPEN_VIEW, "GodCourtRewardView", this.color + 1)
			}, this, true)
		}

		this.SetEffect = (bool?) => {
			if (!this.is_loaded) {
				this.cache_effect = bool
				return
			}
			if (this.effectShow != bool) {
				if (bool) {
					if (!this.hasEffect) {
						if (this.color >= 3) {
							//SetLocalPosition(this.effectGp,-125,127,0)
						}
						//let pos_info = GodCourtModel.GCEffectOffset[this.color + 1]
						let res = GodCourtModel.GetColorEffectName(this.color + 1) + "1"
						this.AddUIEffect(res, this.effectGp, null, 7, true)
						this.hasEffect = true
					}
					this.effectGp.visible = true
					this.Img1.visible = false
				} else {
					this.effectGp.visible = false
					this.Img1.visible = true
				}
			}
		}

		this.SetAlpha = (alpha?) => {
			if (this.is_loaded) {
				this.Img1.alpha = alpha
			} else {
				this.cache_alpha = alpha
			}
		}

		this.DeleteMe1 = () => {
			this.ClearUIEffect(this.effectGp)
		}
	}

	public SetColor(color?) {
		this.color = color
	}

	public SetPos(x, y) {
		if (this.is_loaded) {
			this.display_obj.x = x
			this.display_obj.y = y
		} else {
			this.cache_pos = [x, y]
		}
	}

	public DeleteMe() {
		this.DeleteMe1()
		super.DeleteMe()
	}

	_Group1: Laya.Box
	Img1: Laya.Image
	effectGp: Laya.Box
	clickGp: Laya.Box
	public GetComponents() {
		[
			this._Group1,
			this.Img1,
			this.effectGp,
			this.clickGp,
		]
			= this.GetChildrenByNames([
				"_Group1",
				"Img1",
				"effectGp",
				"clickGp",
			])
	}
}
window["GCCryItem"] = GCCryItem