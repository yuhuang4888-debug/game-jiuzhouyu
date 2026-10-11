import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class DungeonFailureStrengItem extends BaseItemRenderer {
	InitEvent
	LoadSuccess
	SetData
	UpdateView
	public WIDTH = 89
	public HEIGT = 89
	public constructor(parent?) {
		super()

		let dungeon_model = BaseDungeonModel.GetInstance()
		let vo_ = null
		let need_refresh_data_ = null
		this.base_file = "dungeonCommon"
		this.layout_file = "DungeonFailureStrengItem"
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.InitEvent = () => {

			//this._lb_jump.text = "前往"

			Util.AddClickEvent(this._img_icon, () => {
				if (vo_) {
					dungeon_model.SetDunFailureJumpData(vo_.jump_id)
					dungeon_model.streng_item_click = true
				}

				GlobalEventSystem.Fire(EventName.CLOSE_VIEW,"DungeonFailureView")
			}, this, true)
		}

		this.LoadSuccess = () => {

			this.InitEvent()

			if (need_refresh_data_) {
				this.UpdateView()
				need_refresh_data_ = false
			}


		}

		this.SetData = (vo?) => {
			vo_ = vo
			if (this.is_loaded) {
				this.UpdateView()
			} else {
				need_refresh_data_ = true
			}
		}





		this.UpdateView = () => {
			if (vo_) {
				//this._lb_desc.text = vo_.desc

				// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetIcon("dailyIcon", vo_.icon_id))
				// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetIcon("dailyIcon", vo_.icon_id))

				//日常模块还没接 临时写死
				if (vo_.id == "4004") {
					ResManager.GetInstance().SetImageSpriteTrans(this, this._img_icon, GameResPath.GetIcon("dungeonCommon", "icon_gn_01"))
				} else if (vo_.id == "4001") {
					ResManager.GetInstance().SetImageSpriteTrans(this, this._img_icon, GameResPath.GetIcon("dungeonCommon", "icon_gn_04"))
				} else if (vo_.id == "4002") {
					ResManager.GetInstance().SetImageSpriteTrans(this, this._img_icon, GameResPath.GetIcon("dungeonCommon", "icon_gn_03"))
				}else{
					ResManager.GetInstance().SetImageSpriteTrans(this, this._img_icon, GameResPath.GetIcon("icon", vo_.id))
				}
			}
		}

		this.Load()
	}

	public DeleteMe(): void {
		super.DeleteMe()
	}


	public dataChanged() {
		if (!super.dataChanged()) return
		this.SetData(this.data)
	}


	_img_icon: Laya.Image
	public GetComponents() {
		[
			this._img_icon,
		]
			= this.GetChildrenByNames([

				"_img_icon",
			])
	}
}
window["DungeonFailureStrengItem"] = DungeonFailureStrengItem