import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { kfStageModel } from "../commonModel/kfStageModel"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_NEW } from "../util/ColorUtil"
import { HtmlColorTxt, TransformLevel } from "../util/Util"

export class kfStageStartItem extends BaseItemRenderer {
	WIDTH = 398
	HEIGT = 25

	res_mgr
	cfg_icon

	model_: kfStageModel

	public constructor() {
		super()
		this.base_file = "kfStart"
		this.layout_file = "kfStageStartItem"

		this.res_mgr = ResManager.GetInstance()
		this.model_ = kfStageModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {
		this.cfg_icon = this.res_mgr.GetGameConfigFromCache(this, "ConfigKFuncIcon", true)

		this._lb_msg.style.fontSize = 20
		this._lb_msg.style.color = "#663915"
		this._lb_msg.style.wordWrap = false
	}

	protected dataChanged() {
		if (!super.dataChanged()) {
			return
		}

		// {
		// 	mine_server_id :server_info.server_id,
		// 	server_name:server_info.server_name,
		// 	server_id:list[i].server_id,
		// 	is_next_add:is_next_add //是否是下一个跨服阶段新增的区服
		// }

		let str1 = HtmlColorTxt(`S.${this.data.server_id}&nbsp;${this.data.server_name}`, Enum_ColorUtil_Dark.ORANGE)
		this._lb_msg.innerHTML = `${str1}&nbsp;${HtmlColorTxt(`${TransformLevel(this.data.world_lv)}级`, Enum_ColorUtil_Dark.GREEN)}`

		this.box_add.visible = false
		if (this.data.is_next_add) {
			this.box_add.visible = true
			this.box_add.x = this._lb_msg.x + this._lb_msg.contextWidth + 10
		}


	}




	_lb_msg: Laya.HTMLDivElement
	box_add: Laya.Box
	_img_bg: Laya.Image
	_lb_add: Laya.Label
	public GetComponents() {
		[
			this._lb_msg,
			this.box_add,
			this._img_bg,
			this._lb_add,
		]
			= this.GetChildrenByNames([

				"_lb_msg",
				"box_add",
				"_img_bg",
				"_lb_add",
			])
	}
}
window["kfStageStartItem"] = kfStageStartItem