import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"

export class MainUITeamHeadItem extends BaseItemRenderer {
	InitEvent
	click_bg
	is_delay_callback
	model
	role_name

	public constructor(parent) {
		super()

		// this.skinName = "resource/game/mainUI/exml/MainUITeamHeadItemExml.exml"
		// this.model = TeamModel.GetInstance()
		this.is_delay_callback = false

		this.InitEvent = () => {
			let click_fun = () => {
				// this.model.Fire(TeamEvent.TEAM_OPEN_VIEW, "TeamView")
			}
			Util.AddClickEvent(this.click_bg, click_fun, this)
		}
	}

	public createChildren() {
		super.createChildren()
		this.InitEvent()
	}

	// public DeleteMe(){ 

	// 	console.log("MainUITeamHeadItem      DeleteMeDeleteMeDeleteMeDeleteMe")
	// }

	public dataChanged() {

		if (this.data && this.data.id) {
			// let frame_id = DressModel.GetInstance().GetDressByType(this.data.dress_list, DressType.Photo)
			// this.role_head.setData(this.data.level, this.data.career, this.data.picture, null, null, frame_id)
			// this.role_name.text = this.data.name
		}
	}

}

window["MainUITeamHeadItem"] = MainUITeamHeadItem