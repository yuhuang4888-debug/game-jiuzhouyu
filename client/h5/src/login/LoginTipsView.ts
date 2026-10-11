import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Util } from "../util/Util"
import { LoginTipsItem } from "./LoginTipsItem"

export class LoginTipsView extends BaseView1 {

	content = [
		"（1）本游戏是一款3d角色扮演挂机类游戏，游戏内容适用于年满16周岁及以上的用户。",
		"（2）本游戏基于架空的故事背景和世界观，剧情简单且积极向上，没有基于真实历史和现实事件所改编的内容。游戏玩法基于玩家点击操作，鼓励玩家通过任务进行成长达成目标，游戏中有基于文字的社交系统。",
		"（3）游戏中有用户实名制认证系统，当认证为未成年人的用户将接受以下管理：",
		"游戏中部分玩法和道具需要付费，未满8周岁的用户不能付费；8周岁以上未满16周岁的未成年人用户，单次充值金额不得超过50元人民币，每月充值金额累计不得超过200元人民币；16周岁以上的未成年人用户，单次充值金额不得超过100元人民币，每月充值金额累计不得超过400元人民币。未成年人用户仅可在周五、周六、周日和法定节假日每日20时至21时登录游戏，其他时间无法登陆。",
		"（4）本游戏的类型为自动挂机功能，玩家可以通过挂机放置轻松获得收益，降低节约用户的时间成本和负担。游戏内有社交功能以及组队玩法，需要玩家间进行社交和互相帮助配合，有助于培养玩家的沟通以及团队协作能力。"
	]
	item_list = []

	public constructor() {
		super()
		this.base_file = "login"
		this.layout_file = "LoginTipsView"
		this.layer_value = Enum_UILayer.Top
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true

		this.load_callback = function () {
			this._panel_item.vScrollBarSkin = ""
			this.InitEvent()
		}

		this.open_callback = function () {
			this.UpdateView()
		}

		this.destroy_callback = function () {
			for(let i in this.item_list){
				let item = this.item_list[i]
				item.DeleteMe()
			}
			this.item_list = []
		}
	}

	public UpdateView() {
		for (let i in this.content) {
			let item = this.item_list[i]
			if(!item){
				item = new LoginTipsItem(this._vbox_con)
				item.Load()
				this.item_list[i] = item
			}
			item.SetData(this.content[i])
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true)
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_close: Laya.Image
	_panel_item: Laya.Panel
	_vbox_con: Laya.VBox
	_lb_title: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_close,
			this._panel_item,
			this._vbox_con,
			this._lb_title,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_close",
				"_panel_item",
				"_vbox_con",
				"_lb_title",
			])
	}
}
window["LoginTipsView"] = LoginTipsView