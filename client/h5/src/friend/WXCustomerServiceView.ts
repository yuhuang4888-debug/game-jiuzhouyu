import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { Util } from "../util/Util"

export class WXCustomerServiceView extends BaseItem1 {
	AddEvents
	Content
	LoadSuccess
	Scr_Scroller1
	SetContent
	_Image1
	_Scroller1
	desc
	image
	image2
	image3
	image4
	image5
	image6
	openBtn
	top_title

	public constructor(parent?) {
		super(parent)

		this.base_file = "friend"
		this.layout_file = "WXCustomerServiceView"
		this.preload_client_config = { "ConfigInstruction": false }
		this.load_callback = () => {
			this.LoadSuccess()
			this.AddEvents()
		}

		this.LoadSuccess = () => {

			//lua_resM:SetOutsideImageSprite(this, this.top_title, GameResPath.GetIcon("friend","uilxkf_003"))  
		}

		this.AddEvents = () => {
			let openBtnFun = () => {
				// PlatformManager.ShowSdkCustomer()
			}
			Util.AddClickEvent(this.openBtn, openBtnFun, this, true)

			this.SetContent()
		}

		this.SetContent = () => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigInstruction", true)
			if (cfg && cfg[1409]) {
				let instruct_cfg = cfg[1409]
				if (instruct_cfg && instruct_cfg[0] && instruct_cfg[0].content && instruct_cfg[0].content.item_List[0]) {
					let desc_list = instruct_cfg[0].content.item_List[0].item_content
					if (desc_list) {
						let str = ""
						let vo = null
						let i = 0
						let length = desc_list.length
						do {
							vo = desc_list[i]
							if (i == 0) {
								str = vo
							} else {
								str = str + "\n" + vo
							}
							i = i + 1
						} while ((i < length))
						this.desc.textFlow = Util.StrToHTML(str)
						this.desc.lineSpacing = 1.2
						//SetSizeDeltaY(this.desc, this.desc.preferredHeight + 10)
						//SetSizeDeltaY(this.Content, this.desc.preferredHeight + 10)
					}
				}
			}
		}
	}

	public GetComponents() {
		[
			this.top_title,
			this._Image1,
			this.openBtn,
			this._Scroller1,
			this.Content,
			this.image,
			this.image2,
			this.image3,
			this.image4,
			this.image5,
			this.image6,
			this.desc,
		]
			= this.GetChildrenByNames([

				"top_title",
				"_Image1",
				"openBtn",
				"_Scroller1",
				"Content",
				"image",
				"image2",
				"image3",
				"image4",
				"image5",
				"image6",
				"desc",
			])
	}
}

window["WXCustomerServiceView"] = WXCustomerServiceView