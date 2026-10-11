import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPosition, Color } from "../util/Util"

export class vipGiftGradeBtn extends BaseItemRenderer {
	private _Image1: Laya.Image
	private labelDisplay: Laya.Label
	private redDisplay: Laya.Image
	private _gp_effect: Laya.Box
	private image: Laya.Image
	is_buy:Laya.Image
	_image
	_img_down
	_img_up
	form
	group
	labalOutLine


	public static width = 137
	public static height = 80
	public constructor(parent) {
		super()	
		this.WIDTH=150
		this.HEIGT=90
		this.base_file = "common"
		this.layout_file = "TabButtonOneSkin"
		this.Load()
	}

	public load_callback = () => {

		SetAnchoredPosition(this._image, 0, -6)
	}

	public dataChanged() {
		if(!super.dataChanged()) return 
		if (this.data) {
			this.InitView()
		}
	}

	public InitView() {
		this.is_buy.visible=true
		let select_bg = this.selected ? "uian_001a" : "uian_001b"
		this._Image1.skin = GameResPath.GetIcon("common", select_bg)
		let stroke_color = this.selected ? "#3E9298" : "#6873A8"
		this.labelDisplay.strokeColor = stroke_color
		// this._img_down.visible = this.selected
		let text_color = null
		let line_color = null
		if (this.selected) {
			text_color = "#ffffff" //Color(1,1,1,1)
			line_color ="#e1743a" //Color(225 / 255, 116 / 255, 58 / 255, 1)
		} else {
			text_color ="#b7a69f"// Color(183 / 255, 166 / 255, 159 / 255, 1)
			line_color = "#b38270" //Color(179 / 255, 130 / 255, 112 / 255, 0)
		}
		// this.labelDisplay.color = text_color
		// this.labalOutLine.effectColor = line_color
		// LayoutRebuilder(this.group)


		let buy_state = (this.data.status == 2 && (true) || (false))
		if (buy_state) {
			ResManager.GetInstance().SetImageSprite(this, this.is_buy, "vipGift_asset", "uihd_001", true)
		} else {
			ResManager.GetInstance().SetImageSprite(this, this.is_buy, "common_asset", "com_empty")
		}
		if (this.data.condition) {
			let cond = this.data.condition
			this.redDisplay.visible = this.data.status == 0
			if (typeof (cond) == "string") {
				cond =ErlangParser.GetInstance().Parse(cond)
			}
			if (cond) {
				for (let i in cond) {
					if (cond[i][0] == "vip") {
						let vip_lv = RoleManager.GetInstance().mainRoleInfo.vip_flag
						this.labelDisplay.text = "v" + cond[i][1] + "礼包"
						if (vip_lv < Number(cond[i][1])) {
							ResManager.GetInstance().SetImageSprite(this, this.is_buy, "vipGift_asset", "uihd_002", true)
						}
						break
					}
				}
			}
		}
	}
	public GetComponents() {
		[
			this._Image1,
			this.labelDisplay,
			this.redDisplay,
			this._gp_effect,
			this.is_buy
		] = this.GetChildrenByNames([
			"_Image1",
			"labelDisplay",
			"redDisplay",
			"_gp_effect",
			"is_buy"
		])
	}
}
window["vipGiftGradeBtn"]=vipGiftGradeBtn
