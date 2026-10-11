import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { GuildActivityModel } from "../commonModel/GuildActivityModel"
import { HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util"
import { EveningRankRewardItem } from "./EveningRankRewardItem"

export class EveningRankRewardView extends BaseView1 {
	_ac_item
	_list_item
	back_login_toClose
	click_bg_toClose
	close_callback
	is_center
	model
	open_callback
	preload_server_config
	show_open_movie
	use_background
	type = 0

	public constructor() {
		super()

		this.base_file = "evening"
		this.layout_file = "EveningRankRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.back_login_toClose = true
		this.preload_server_config = { "config_guild_point_rank": false }
		this.model = GuildActivityModel.GetInstance()
		this.load_callback = () => {
			SetHtmlStyle(this._lb_tips11,{c:"#663915",f:18,ww:false,w:550})
			this.LoadSuccess()
		}

		this.open_callback = () => {

		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public LoadSuccess() {

		this.InitEvent()
		this.InitView()
		let str_1 = GuildActivityModel.GetInstance().GetEveningGameName()
		this._lb_tips11.innerHTML=`1、${HtmlColorTxt(`${str_1}结束后`,'"#b94a00"')}进行奖励结算`
	}

	public InitEvent() {

		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}
			, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
	}

	public InitView() {

		let reward_dic = ResManager.GetInstance().GetGameConfigFromCache(this, "config_guild_point_rank", false)
		let reward_list = []
		//config_guild_point_rank  game_type==1 为消消乐奖励  0为答题奖励
		this.type = GuildActivityModel.GetInstance().EveningGameType()==2?1:0  
		for (let key in reward_dic) {
			let reward = reward_dic[key]
			if (reward && reward.game_type == this.type)
				table.insert(reward_list, reward_dic[key])
		}
		table.sort(reward_list, (a?, b?) => {
			return a.rank < b.rank
		})


		this._ac_item = new LoopScrowViewMgr()
		this._ac_item.SetData(this._list_items, EveningRankRewardItem, reward_list, LoopScrCon.Vertical)
	}

	public Remove() {

		if (this._ac_item) {
			this._ac_item.DeleteMe()
			this._ac_item = null
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}
	public Open(type?) {
		super.Open()
	}


image1:Laya.Image
_image_title:Laya.Image
_img_close:Laya.Image
_Image2:Laya.Image
_lb_tips11:Laya.HTMLDivElement
_list_items:Laya.List
_lb_1:Laya.Label
_lb_2:Laya.Label
_Image222:Laya.Image
_lb_win_name:Laya.Label
public GetComponents() {
[
this.image1,
this._image_title,
this._img_close,
this._Image2,
this._lb_tips11,
this._list_items,
this._lb_1,
this._lb_2,
this._Image222,
this._lb_win_name,
]
 = this.GetChildrenByNames([

"image1",
"_image_title",
"_img_close",
"_Image2",
"_lb_tips11",
"_list_items",
"_lb_1",
"_lb_2",
"_Image222",
"_lb_win_name",
])
}
}
 window["EveningRankRewardView"]= EveningRankRewardView