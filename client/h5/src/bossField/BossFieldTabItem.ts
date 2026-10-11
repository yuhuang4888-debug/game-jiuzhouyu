import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"
import { PlatformManager } from "../PlatformManager"
import { ColorUtil } from "../util/ColorUtil"
import { SetAnchoredPositionY } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class BossFieldTabItem extends BaseItemRenderer {
	public WIDTH = 128
	public HEIGT = 54

	UpdateRed
	public constructor(parent) {
		super()
		this.base_file = "bossField"
		this.layout_file = "BossFieldTabItem"

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.UpdateRed=()=>{
			if(!this.data)return
			if(!this.data.boss_type){
				this._img_red.visible = this.data.red_state
				return
			}
			if(this.data.boss_type==BossModel.BossType.abyss){
				this._img_red.visible = BossModel.GetInstance().CheckBossAbyssLayer(this.data.layer)
			}else{
				this._img_red.visible = this.data.red_state
			}
		}
		this.Load()
	}

	public LoadSuccess() {
		this.BindEvent(BossModel.GetInstance(), BossModel.UPDATE_ABYSS_BOSS_RED, () => {
			this.UpdateRed()
		})

	}

	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data

			if (this.selected) {
				ResManager.GetInstance().SetImageSprite(this, this._img_bg, this.base_file, "ui_chief_btn_1", true)
				this._lb_floor.color = "#9b572f"
			} else {
				let ui_res = "ui_chief_btn_2"
				if (data.boss_type) {
					if (data.boss_type == BossModel.BossType.abyss) {
						ui_res = "ui_chief_btn_3"
					}
					else if (data.boss_type == BossModel.BossType.suit) {
						ui_res = "ui_chief_btn_4"
					} else {
						ui_res = "ui_chief_btn_2"
					}
				}
				ResManager.GetInstance().SetImageSprite(this, this._img_bg, this.base_file, ui_res, true)
				this._lb_floor.color = "#ffffff"
			}

			this._lb_floor.text = data.label
			this.UpdateRed()
		}
	}
	_img_bg: Laya.Image
	_lb_floor: Laya.Label
	_img_red: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._lb_floor,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_floor",
				"_img_red",
			])
	}
}
window["BossFieldTabItem"] = BossFieldTabItem