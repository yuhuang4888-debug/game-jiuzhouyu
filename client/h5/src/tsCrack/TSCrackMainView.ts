import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { RankModel, RankModelEvent } from "../commonModel/RankModel"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { HtmlColorTxt, SetAnchoredPosition, SetLocalPositionX, SetLocalScaleX, SetSizeDelta, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { TSCrackLockItem } from "./TSCrackLockItem"
import { TSCrackStrongholdItem } from "./TSCrackStrongholdItem"
import { Config } from "../common/Config"

export class TSCrackMainView extends BaseItem1 {
	_Scroller1: Laya.Panel
	Content: Laya.Box
	_img_map1: Laya.Image
	_img_map2: Laya.Image
	_gp_path: Laya.Box
	_gp_build: Laya.Box
	_gp_effect: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Label1: Laya.Label
	_lb_turn: Laya.HTMLDivElement
	_lb_tips: Laya.HTMLDivElement
	_img_bg: Laya.Image
	_img_tips1: Laya.Image
	_img_tips2: Laya.Image
	_Label2: Laya.Label
	_Image4: Laya.Image
	_lb_value: Laya.HTMLDivElement
	_gp_lock: Laya.Box
	_Scroller2: Laya.Panel
	Content1: Laya.Box
	_gp_icon: Laya.Box
	_img_bg1: Laya.Image
	_gp_arrow: Laya.Box
	_Image5: Laya.Image
	_img_arrow: Laya.Image
	_img_scramble: Laya.Image
	_img_target: Laya.Image
	_img_reward: Laya.Image
	_img_rule: Laya.Image
	_img_target_red: Laya.Image
	_img_red: Laya.Image
	_bg1: Laya.Image
	set: Laya.Image
	icon_state
	lock_item
	path_dic
	stronghold_item_dic
	ts_crack_model
	tweenId
	first = true

	public constructor(parent?) {
		super(parent)
		this.base_file = "tsCrack"
		this.layout_file = "TSCrackMainView"

		this.ts_crack_model = TSCrackModel.GetInstance()

		this.stronghold_item_dic = null

		this.lock_item = null

		this.icon_state = true

		this.load_callback = () => {
			this._Scroller1.hScrollBar.visible = false
			this._Scroller1.vScrollBar.visible = false
			if (this.ts_crack_model.HasRedFlag(TSCrackModel.RedFlag.Login)) {

				this.ts_crack_model.SetRedFlag(TSCrackModel.RedFlag.Login, false)

			}
			this.LoadSuccess()

		}

	}





	public LoadSuccess() {






		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_map1, GameResPath.GetIconJpg("tsCrack", "uisksh_021_1"))

		//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_map2, GameResPath.GetIconJpg("tsCrack", "uisksh_021_2"))

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("tsCrack", "uisksh_001"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("tsCrack", "uisksh_001"))

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, GameResPath.GetIcon("tsCrack", "uisksh_012"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._bg1, GameResPath.GetIcon("tsCrack", "ui_kaf_di1"))

		//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("tsCrack", "uisksh_021"))





		this.InitStronghold()

		this.UpdateStronghold()

		this.UpdatePath()

		this.UpdateValue()

		this.UpdateCount()

		this.UpdateTurn()

		this.UpdateLock()

		this.UpdateTargetRedState()

		this.InitEvent()

		this.ts_crack_model.StartRefreshData()



	}



	public InitEvent() {




		Util.AddClickEvent(this._gp_arrow, () => {

			this.ShowAni(!this.icon_state)

		}, this, true)



		Util.AddClickEvent(this._img_tips1, () => {

			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, TSCrackModel.InstructionTwo)

		}, this, true)



		Util.AddClickEvent(this._img_tips2, () => {

			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, TSCrackModel.InstructionOne)

		}, this, true)



		Util.AddClickEvent(this._img_scramble, () => {

			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TSCrackScrambleView")

		}, this, true)



		Util.AddClickEvent(this._img_target, () => {

			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TSCrackTargetView")

		}, this, true)



		Util.AddClickEvent(this._img_reward, () => {

			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TSCrackSeasonView")

		}, this, true)



		Util.AddClickEvent(this._img_rule, () => {

			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TSCrackInstructionView")

		}, this, true)

		this.BindEvent(this.ts_crack_model, TSCrackModel.UPDATE_VALUE_DATA, () => {

			this.UpdateValue()

		}

		)

		this.BindEvent(this.ts_crack_model, TSCrackModel.UPDATE_STRONGHOLD_DATA, (id?) => {

			if (id) {

				this.UpdateStrongholdById(id)

			} else {
				this.UpdateStronghold()

			}

			this.UpdateCount()

			this.UpdatePath()

		}

		)

		this.BindEvent(this.ts_crack_model, TSCrackModel.REFRESH_RED_FLAG, (flag?) => {

			if (TSCrackModel.RedFlag.ServerReward == flag) {

				this.UpdateTargetRedState()

			} else if (TSCrackModel.RedFlag.PersonReward == flag) {

				this.UpdateTargetRedState()

			}

		}

		)

		this.BindEvent(RankModel.GetInstance(), RankModelEvent.RANK_DATA_UPDATE, (data?) => {

			if (data && data.rank_type == RankModel.RANK_TYPE.FIGHT) {

				this.UpdateTurn()

			}

		}

		)

	}



	public UpdateTargetRedState() {


		this._img_target_red.visible = this.ts_crack_model.HasRedFlag(TSCrackModel.RedFlag.ServerReward) || this.ts_crack_model.HasRedFlag(TSCrackModel.RedFlag.PersonReward)

		this.UpdateRedState()

	}



	public UpdateRedState() {


		if (this.icon_state) {

			this._img_red.visible = false

		} else {
			this._img_red.visible = this._img_target_red.visible

		}

	}



	public InitStronghold() {


		this.stronghold_item_dic = []

		let chrono_rift_castle_cfg = Config.PRELOAD_SERVER_CONFIG.config_chrono_rift_castle

		let tsCrack_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigTSCrack

		let stronghold_pos = tsCrack_cfg && tsCrack_cfg.stronghold_pos

		if (chrono_rift_castle_cfg && stronghold_pos) {

			let cfg = null

			let item: TSCrackStrongholdItem = null

			let pos_cfg = null

			let id = null

			for (let key in chrono_rift_castle_cfg) {


				cfg = chrono_rift_castle_cfg[key]

				pos_cfg = stronghold_pos[cfg.id]

				item = new TSCrackStrongholdItem(this._gp_build)



				item.SetCfg(cfg)
				item.SetPosition(pos_cfg.x, pos_cfg.y)
				item.ExcuteCallback(() => {
				})
				item.Load()

				this.stronghold_item_dic[cfg.id] = item

				//this:AddUIEffect("ui_goods_1004", this._gp_effect, {x=pos_cfg.x, y=pos_cfg.y + 55}, null, true, null, null, null, null, true)

			}

		}

	}



	public UpdateStronghold() {


		let stronghold_datas = this.ts_crack_model.GetStrongholdData()

		if (stronghold_datas) {

			let item = null

			let data = null

			for (let id in stronghold_datas) {


				this.UpdateStrongholdById(id)

			}

		}

	}



	public UpdateStrongholdById(id?) {


		let stronghold_data = this.ts_crack_model.GetStrongholdDataById(id)

		let item = this.stronghold_item_dic && this.stronghold_item_dic[id]

		if (item && stronghold_data) {

			item.SetData(stronghold_data)

		}

	}



	public UpdatePath() {
		// if (!this.first) return
		// this.first = false
		let stronghold_datas = this.ts_crack_model.GetStrongholdData()

		let tsCrack_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigTSCrack

		let source = tsCrack_cfg && tsCrack_cfg.source
		// for (let key in source) {
		// 	let pos = source[key]
		// 	let img_com: Laya.Image
		// 	img_com = new Laya.Image()
		// 	this._gp_path.addChild(img_com)
		// 	img_com.name = key
		// 	img_com.mouseEnabled = false


		// 	ResManager.GetInstance().SetOutsideImageSprite(this, img_com, GameResPath.GetTsPath("line", key), true)
		// 	if (pos)
		// 		SetAnchoredPosition(img_com, pos.x, pos.y)
		// }

		// return
		this.path_dic = this.path_dic || {}
		let draw_dic = []
		if (stronghold_datas) {
			let data = null
			let start_cfg = null
			for (let id in stronghold_datas) {
				data = stronghold_datas[id]
				let img_trans
				let img_com: Laya.Image
				for (let _tmpi in data.stronghold_castle) {
					let connect_id = data.stronghold_castle[_tmpi]
					let img_name = source[id + "_" + connect_id] ? id + "_" + connect_id : connect_id + "_" + id
					if (this.ts_crack_model.HasOwnership(id)) {//&& this.ts_crack_model.HasOwnership(connect_id)
						if (this.path_dic[img_name]) {
							draw_dic[img_name] = true
						} else {
							img_com = new Laya.Image()
							this._gp_path.addChild(img_com)
							img_com.mouseEnabled = false
							ResManager.GetInstance().SetOutsideImageSprite(this, img_com, GameResPath.GetTsPath("line", img_name), true)
							let pos = source[img_name]
							if (pos)
								SetAnchoredPosition(img_com, pos.x, pos.y)
							let key = id + "_" + connect_id
							img_com.name = key

							this.path_dic[`${id}_${connect_id}`] = img_com
							draw_dic[key] = true
						}

					}

				}

			}

		}



		for (let key in this.path_dic) {
			let img = this.path_dic[key]

			if (!draw_dic[key]) {
				this._gp_path.removeChild(this.path_dic[key])
				//destroy(img.gameObject)
				delete this.path_dic[key]


			}

		}

	}



	public UpdateCount() {


		let stronghold_datas = this.ts_crack_model.GetStrongholdData()

		let chrono_rift_castle_reward_cfg = Config.PRELOAD_SERVER_CONFIG.config_chrono_rift_castle_reward

		let count1 = 0

		let count2 = 0

		let count3 = 0

		let count4 = 0

		let count5 = 0

		if (stronghold_datas) {

			let data = null

			for (let id in stronghold_datas) {


				data = stronghold_datas[id]

				if (this.ts_crack_model.HasOwnership(id)) {

					if (data.lv == 1) {

						count1 = count1 + 1

					} else if (data.lv == 2) {

						count2 = count2 + 1

					} else if (data.lv == 3) {

						count3 = count3 + 1

					} else if (data.lv == 4) {

						count4 = count4 + 1

					} else if (data.lv == 5) {

						count5 = count5 + 1

					}

				}

			}

		}

		let data = null

		let str = ""

		for (let key in chrono_rift_castle_reward_cfg) {


			data = chrono_rift_castle_reward_cfg[key]

			str = str + "		" + data.name + " "

			if (data.lv == 1) {

				str = str + HtmlColorTxt(count1, "'#d7ff5f'") + "&nbsp;"

			} else if (data.lv == 2) {

				str = str + HtmlColorTxt(count2, "'#d7ff5f'") + "&nbsp;"

			} else if (data.lv == 3) {

				str = str + HtmlColorTxt(count3, "'#d7ff5f'") + "&nbsp;"

			} else if (data.lv == 4) {

				str = str + HtmlColorTxt(count4, "'#d7ff5f'") + "&nbsp;"

			} else if (data.lv == 5) {

				str = str + HtmlColorTxt(count5, "'#d7ff5f'") + "&nbsp;"

			}

		}
		this._lb_tips.style.fontSize = 20
		this._lb_tips.style.color = "#ffffff"
		this._lb_tips.style.wordWrap = false
		this._lb_tips.innerHTML = Util.StrToHTML(str)

	}



	public UpdateTurn() {


		let chrono_rift_castle_ratio_cfg = Config.PRELOAD_SERVER_CONFIG.config_chrono_rift_castle_ratio

		let fight_rank_data = RankModel.GetInstance().getRankDate(RankModel.RANK_TYPE.FIGHT)

		let value = 0

		if (chrono_rift_castle_ratio_cfg && fight_rank_data) {

			let data = null

			for (let key in chrono_rift_castle_ratio_cfg) {


				data = chrono_rift_castle_ratio_cfg[key]

				if (data.min_rank <= fight_rank_data.role_rank && data.max_rank >= fight_rank_data.role_rank) {

					value = data.ratio

					break

				}

			}

		}
		this._lb_turn.style.fontSize = 18
		this._lb_turn.style.color = "#ffffff"
		this._lb_turn.style.wordWrap = false
		this._lb_turn.innerHTML = Util.StrToHTML("	当前转化率	" + HtmlColorTxt(value + "%", "'#ffe56e'"))

	}



	public UpdateValue() {


		let value_data = this.ts_crack_model.GetValueData()

		if (value_data) {
			this._lb_value.style.fontSize = 18
			this._lb_value.style.color = "#ffffff"
			this._lb_value.style.wordWrap = false
			this._lb_value.innerHTML = Util.StrToHTML("个人&nbsp;" + HtmlColorTxt(value_data.my_value, "'#d7ff5f'") + "&nbsp;本服&nbsp;" + HtmlColorTxt(value_data.my_server_value, "'#d7ff5f'"))

		}

	}



	public UpdateLock() {


		if (this.ts_crack_model.OpenState()) {

			if (this.lock_item) {

				this.lock_item.SetVisible(false)

			}

		} else {
			if (!this.lock_item) {

				this.lock_item = new TSCrackLockItem(this.display_obj)

				this.lock_item.Load()

			}

			this.lock_item.SetVisible(true)

		}

	}



	public ShowAni(state?) {


		if (this.icon_state == state) {

			return

		}

		if (this.tweenId) {

			SYTweenLite.Stop(this.tweenId)

			this.tweenId = null

		}



		SetLocalScaleX(this._img_arrow, !state && 1 || -1)



		this.tweenId = SYTweenLite.to(this, this._gp_icon, SYTweenLite.UiAnimationType.ANCHORED_POSX, !state ? 390 : 0, 0.3, () => {

			this.tweenId = false
			this._gp_arrow.x = !state ? -50 : 0
		}, SYTweenFunc.LINEAR)



		this.icon_state = state

		this.UpdateRedState()

	}



	public DeleteMe() {


		if (this.lock_item) {

			this.lock_item.DeleteMe()

		}



		if (this.stronghold_item_dic) {

			let item = null

			for (let id in this.stronghold_item_dic) {


				item = this.stronghold_item_dic[id]

				if (item) {

					item.DeleteMe()

				}

			}

			this.stronghold_item_dic = []

		}

		this.ts_crack_model.CancelRefreshData()



		if (this.tweenId) {

			SYTweenLite.Stop(this.tweenId)

			this.tweenId = null

		}



		this.path_dic = false
		super.DeleteMe()
	}




	public GetComponents() {
		[
			this._Scroller1,
			this.Content,
			this._img_map1,
			this._img_map2,
			this._gp_path,
			this._gp_build,
			this._gp_effect,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Label1,
			this._lb_turn,
			this._lb_tips,
			this._img_bg,
			this._img_tips1,
			this._img_tips2,
			this._Label2,
			this._Image4,
			this._lb_value,
			this._gp_lock,
			this._Scroller2,
			this.Content1,
			this._gp_icon,
			this._img_bg1,
			this._gp_arrow,
			this._Image5,
			this._img_arrow,
			this._img_scramble,
			this._img_target,
			this._img_reward,
			this._img_rule,
			this._img_target_red,
			this._img_red,
			this._bg1,
			this.set
		]
			= this.GetChildrenByNames([

				"_Scroller1",
				"Content",
				"_img_map1",
				"_img_map2",
				"_gp_path",
				"_gp_build",
				"_gp_effect",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Label1",
				"_lb_turn",
				"_lb_tips",
				"_img_bg",
				"_img_tips1",
				"_img_tips2",
				"_Label2",
				"_Image4",
				"_lb_value",
				"_gp_lock",
				"_Scroller2",
				"Content1",
				"_gp_icon",
				"_img_bg1",
				"_gp_arrow",
				"_Image5",
				"_img_arrow",
				"_img_scramble",
				"_img_target",
				"_img_reward",
				"_img_rule",
				"_img_target_red",
				"_img_red",
				"_bg1",
				"set"
			])
	}
}
window["TSCrackMainView"] = TSCrackMainView