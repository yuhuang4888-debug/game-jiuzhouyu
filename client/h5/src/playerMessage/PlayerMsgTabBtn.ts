import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { Util } from "../util/Util"

export class PlayerMsgTabBtn extends BaseItem1 {
	public clickBox
	_Image1
	_Image2
	click
	data
	dummy_type
	index
	labelDisplay
	model
	need_refreshData
	select

	public constructor(parent) {
		super(parent)


		this.base_file = "playerMessage"
		this.layout_file = "PlayerMsgTabBtn"
		this.need_refreshData = false;
		this.select = false
		this.model = FriendModel.GetInstance()
		this.load_callback = () => {
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this.labelDisplay.size  = 18
			// }
			if (this.need_refreshData) {
				this.SetData(this.data, this.index, this.dummy_type)
				this.need_refreshData = false
			}
			Util.AddClickEvent(this.click,() => {
					if (this.model.now_select_index == this.index ) { return }
					if (this.dummy_type && this.dummy_type > 0 ) {
						Message.show("对方不愿意和你对比")
						return
					}
					FriendModel.GetInstance().Fire(FriendEvent.SELECT_TAB, this.index)
					this.SetSelect()
					this.model.now_select_index = this.index
				}
				, this)

			this.BindEvent(this.model, FriendEvent.SELECT_TAB, (index?) => {
				if (index != this.index) {
					this.SetSelect(false)
				}else{
					this.SetSelect(true)
				}
			})
		}

	}

	public SetData(data?, index?, dummy_type?) {

		this.data = data
		this.index = index
		this.dummy_type = dummy_type
		if (this.is_loaded) {
			this.labelDisplay.text = this.data.name
			if (this.labelDisplay.text == "玩家信息") {
				this.SetSelect()
			}else{
				this.SetSelect(false)
			}
		} else {
			this.need_refreshData = true
		}
	}
	public SetSelect(bool?) {
		if(bool!=null){
			this.select=bool
		}else[
			this.select = !this.select
		]
		// let str = this.select == true && "uilwmb_041" || "uilwmb_042"
		if(this.select){
			this._Image1.visible=true
			this._Image2.visible=false
		}else{
			this._Image1.visible=false
			this._Image2.visible=true
		}
		let color = this.select == true && "#ffffff" || "#4f538f"
		let strokeColor=this.select== true && "#ad455c" || "#c6c3f4"
		let effect_color = this.select == true && ColorUtil.TryParseHtmlString("#cc7652") || ColorUtil.TryParseHtmlString("#785A49")
		// ResManager.GetInstance().SetImageSprite(this, this._Image1, "friend_asset", str)
		this.labelDisplay.color = color
		this.labelDisplay.strokeColor=strokeColor
		// this.labelDisplay.GetComponent("Outline").effectColor = effect_color
	}



	public GetComponents() {
		[
			this._Image1,
			this.labelDisplay,
			this.clickBox,
			this._Image2
		]
			= this.GetChildrenByNames([

				"_Image1",
				"labelDisplay",
				"clickBox",
				"_Image2"
			])
	}
}

window["PlayerMsgTabBtn"] = PlayerMsgTabBtn