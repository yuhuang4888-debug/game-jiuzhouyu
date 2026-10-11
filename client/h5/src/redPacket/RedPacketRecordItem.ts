import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { ChatModel } from "../commonModel/ChatModel"
import { TimeUtil } from "../util/TimeUtil"
import { Trim, Util } from "../util/Util"
import { RedPacketModel } from "../commonModel/RedPacketModel"

export class RedPacketRecordItem extends BaseItem1 {
	_model
	data
	needRefreshData

	public static width = 580
	public static height = 25

	public constructor(parent) {
		super(parent)

		this.base_file = "redPacket"
		this.layout_file = "RedPacketRecordItem"
		this._model = RedPacketModel.GetInstance()

		this.load_callback = () => {
			if (this.needRefreshData) {
				this.SetData(this.data)
				this.needRefreshData = null
			}
		}

	}

	public DeleteMe() {

		super.DeleteMe()
	}


	public SetData(data?) {

		this.data = data || this.data
		if (this.is_loaded) {
			this.PreSetHtml()
			// let role_name = Util.HtmlColorTxt(data.role_name, Enum_ColorUtil_Light.BLUE)
			let stime = TimeUtil.timeConversion(data.time, "mm-dd hh:MM")
			// let rdata = this._model.GetRedPacketData(data.cfg_id)
			// let name = rdata ? Util.HtmlColorTxt(rdata.name, Enum_ColorUtil_Dark.GREEN) : ""
			// this._lb_content.textFlow = Util.StrToHTML( ${role_name}获得${name}!`)
			let config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_red_envelopes", false)
			let rdata = this._model.GetRedPacketData(data.cfg_id, config)
			let desc: string = rdata ? rdata.desc : ""
			desc = desc.replace("{1}", data.role_name)
			desc = ChatModel.GetInstance().FormatColorTag(desc)
			desc = ChatModel.GetInstance().changeToDark(desc)
			this._lb_content.innerHTML = Util.StrToHTML(`${stime} &nbsp;${desc}`)

		} else {
			this.needRefreshData = true
		}
        
	}

	PreSetHtml = () => {
		this._lb_content.width = 545
		this._lb_content.style.fontSize = 20
		this._lb_content.style.color = "#5a1c20"
		this._lb_content.style.wordWrap = true
		this._lb_content.style.leading = 4

	}




	_lb_content: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._lb_content,
		]
			= this.GetChildrenByNames([

				"_lb_content",
			])
	}
}
window["RedPacketRecordItem"] = RedPacketRecordItem