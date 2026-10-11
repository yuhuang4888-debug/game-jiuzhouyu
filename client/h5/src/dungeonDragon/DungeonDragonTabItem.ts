import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { PlatformManager } from "../PlatformManager"
import { SetSizeDeltaX, SetAnchoredPositionX, SetAnchoredPositionY } from "../util/Util"

export class DungeonDragonTabItem extends BaseItemRenderer {
	is_delay_callback

	public WIDTH = 95
	public HEIGT = 92

	public constructor(parent) {
		super()

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonTabItem"
		this.is_delay_callback = false

		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._lb_cond2.width = 94
				this._lb_cond2.height = 68
				this._lb_cond2.centerX = 0
				this._lb_cond2.y = 13
				this._lb_cond2.leading = 0.1
			}
		}
		this.Load()
	}



	public dataChanged() {
		if (!super.dataChanged()) return
		let state = this.data.state


		//ResManager.GetInstance().SetImageSprite(this, this._img_bg, "dungeonDragon", this.data.img_source, true)
		this._img_select.visible = this.selected
		this._img_tips.visible = state==2
		let id = this.data.dun_id % 100
		ResManager.GetInstance().SetImageSprite(this, this._img_bg, "dungeonDragon", `ui_copy_${id+26}`, true)//25-30
		ResManager.GetInstance().SetImageSprite(this, this._img_tips, "dungeonDragon", `ui_copy_lw${id}`, true)
		let sclv = 370
		this._lb_cond2.visible=false
		let dataLv = BaseDungeonModel.GetInstance().GetDungeonUnlockLv(this.data.dun_id)
		switch (state) {
			case 0://未解锁
				let lv = (dataLv > sclv && (dataLv - sclv) || (dataLv))
				this.destiny_img.visible = dataLv > sclv
				this._lb_cond.centerX = dataLv > sclv ? 10 : 0
				this._lb_cond.fontSize = 20
				if (PlatformManager.IsEyouEnPlatform()) {
					this._lb_cond.text = "Lv."+lv
				}else{
					this._lb_cond.text = lv + "级"
				}
				this._gp_cond.visible=true
				break;
			case 1://已解锁但要通关上一关
			    this._lb_cond2.text = "通关\n上一难度"
				this._lb_cond2.visible=true
				this._gp_cond.visible=false
				break;
			case 2://已通关
			     this._gp_cond.visible=false
				break;
		}


		


	}


	_img_bg: Laya.Image
	_img_tips: Laya.Image
	_gp_cond: Laya.Box
	_Image1: Laya.Image
	_Group1: Laya.Box
	destiny_img: Laya.Image
	_lb_cond: Laya.Label
	_lb_cond2: Laya.Label
	_img_select: Laya.Image
	_img_st: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_tips,
			this._gp_cond,
			this._Image1,
			this._Group1,
			this.destiny_img,
			this._lb_cond,
			this._lb_cond2,
			this._img_select,
			this._img_st,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_tips",
				"_gp_cond",
				"_Image1",
				"_Group1",
				"destiny_img",
				"_lb_cond",
				"_lb_cond2",
				"_img_select",
				"_img_st",
			])
	}
}
window["DungeonDragonTabItem"] = DungeonDragonTabItem