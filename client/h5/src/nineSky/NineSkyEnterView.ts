import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { kfStageModel } from "../commonModel/kfStageModel"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Split, Util } from "../util/Util"

import "./NineSkyRewardView"

export class NineSkyEnterView extends BaseItem1 {

	goods_model: GoodsModel
	nine_sky_model: NineSkyModel
	item_list: BaseAwardItem[]

	public constructor(parent) {
		super(parent)

		this.base_file = "nineSky"
		this.layout_file = "NineSkyEnterView"

		this.nine_sky_model = NineSkyModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.preload_client_config = {
			"ConfigBattleField": false
		}
	}

	public SetKfInfo() {
		let info = this.nine_sky_model.GetStateInfo()
		if ((info && info.mod)) {
			this._html_kf_mode.innerHTML = `当前模式：<font color='#d15e00'>${(info.mod == 1 && "本" || info.mod)}服模式</font>`
		}
	}

	public LoadSuccess() {

		this._html_desc2.style.color = "#ffffff"
		this._html_desc2.style.fontSize = 20
		this._html_desc2.style.leading = 16
		this._html_desc2.style.wordWrap = false

		this._html_kf_mode.style.color = "#663915"
		this._html_kf_mode.style.fontSize = 20
		this._html_kf_mode.style.wordWrap = false

		this._panel_reward.hScrollBarSkin = ""

		this.InitView()
		this.InitEvent()
	}

	public InitEvent() {

		Util.AddClickEvent(this._img_reward_show, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "NineSkyRewardView")
		}, this, true)

		Util.AddClickEvent(this._box_challenge, () => {
			this.nine_sky_model.Fire(NineSkyModel.REQUEST_CCMD_EVENT, 13502)
		}, this, true)

		Util.AddClickEvent(this._box_kf, () => {
			kfStageModel.GetInstance().OpenKfStageView(kfStageModel.FUNC_135)
		}, this, true)

		this.BindVar(this.nine_sky_model, "state_info", (event_name?, now_value?) => {
			let state = this.nine_sky_model.GetRedState()
			this._img_challenge_red.visible = state
			this.SetKfInfo()
		}
		)
	}


	public InitView() {
		let state = this.nine_sky_model.GetRedState()
		this._img_challenge_red.visible = state
		let battle_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigBattleField")
		let nine_cfg = battle_cfg && battle_cfg["nine_sky"]
		if (nine_cfg) {
			let rules = nine_cfg["rule"]
			if (rules) {
				let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
				let rune = null
				for (let key in rules) {
					let open_day_list = Split(key, "@")
					if (open_day >= Number(open_day_list[0]) && open_day <= Number(open_day_list[1])) {
						rune = rules[key]
						break
					}
				}

				if (rune) {
					this._lb_desc.text = rune.title
					this._html_desc2.innerHTML = rune.desc
				}
			}

			let show_reward = nine_cfg["show_reward"]
			if (show_reward) {
				let len = show_reward.length

				if (!this.item_list) {
					this.item_list = []
				}

				let i = len
				if (i < this.item_list.length) {
					do {
						this.item_list[i].SetVisible(false)
						i = i + 1
					} while ((i < this.item_list.length)
					)
				}

				if (len > 0) {
					for (let key in show_reward) {
						let item = this.item_list[key]
						if (!item) {
							item = new BaseAwardItem(this._panel_reward)
							this.item_list[key] = item
							item.SetItemSize(85, 85)
							item.Load()
						}
						item.SetPosition(Number(key) * 97, 0)
						let vo = show_reward[key]
						let [type_id, lock] = this.goods_model.GetMappingTypeId(vo[0], vo[1])
						let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
						if (goods_vo) {
							item.SetData(goods_vo.type_id, vo[2], lock)
						}
					}
				}
			}
		}
		this.SetKfInfo()
	}

	public DeleteMe() {
		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var obj = this.item_list[_tmpi]
				obj.DeleteMe()
			}
			this.item_list = null
		}
		super.DeleteMe()
	}

	_box_kf: Laya.Box
	_img_kf: Laya.Image
	_lb_kf: Laya.Label
	_lb_title: Laya.Label
	_lb_title2: Laya.Label
	_lb_desc: Laya.Label
	_img_bg2: Laya.Image
	_img_bg: Laya.Image
	_img_reward_show: Laya.Image
	_box_challenge: Laya.Box
	_img_challenge: Laya.Image
	_lb_challenge: Laya.Label
	_img_challenge_red: Laya.Image
	_html_desc2: Laya.HTMLDivElement
	_html_kf_mode: Laya.HTMLDivElement
	_panel_reward: Laya.Panel
	public GetComponents() {
		[
			this._box_kf,
			this._img_kf,
			this._lb_kf,
			this._lb_title,
			this._lb_title2,
			this._lb_desc,
			this._img_bg2,
			this._img_bg,
			this._img_reward_show,
			this._box_challenge,
			this._img_challenge,
			this._lb_challenge,
			this._img_challenge_red,
			this._html_desc2,
			this._html_kf_mode,
			this._panel_reward,
		]
			= this.GetChildrenByNames([

				"_box_kf",
				"_img_kf",
				"_lb_kf",
				"_lb_title",
				"_lb_title2",
				"_lb_desc",
				"_img_bg2",
				"_img_bg",
				"_img_reward_show",
				"_box_challenge",
				"_img_challenge",
				"_lb_challenge",
				"_img_challenge_red",
				"_html_desc2",
				"_html_kf_mode",
				"_panel_reward",
			])
	}
}
window["NineSkyEnterView"] = NineSkyEnterView