import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { GetSexByCareer, Util } from "../util/Util"

export class DiamondFightBetRecordItem extends BaseItem1 {

	data
	model: DiamondFightModel
	res_mgr: ResManager
	need_refresh_data

	head_left
	head_right
	public constructor(parent?) {
		super(parent)

		this.base_file = "diamondFight"
		this.layout_file = "DiamondFightBetRecordItem"
		this.model = DiamondFightModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		//resource/game/diamondFight/texture/ui_activity_02_2.png
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("diamondFight", "ui_activity_02_2"))

		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdateView()
		}
		this.InitEvent()
	}

	public InitEvent() {
		Util.AddClickEvent(this._box_get, () => {
			if (this.data && this.data.reward_st == 0) {
				this.model.Fire(DiamondFightModel.REQUEST_SCMD, 13723, this.data.zone, this.data.action, this.data.suprid)
			}
		}, this, true)
	}

	public SetData(data?) {

		this.data = data
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateView() {

		let data = this.data
		if (!data) {
			return
		}
		this._lb_round.text = "16强第" + (data.action - DiamondFightModel.HAIXUAN_ROUNDS) + "/4轮"


		let config_career = this.res_mgr.GetGameConfigFromCache(this, "config_career", false)
		if (!this.head_left) {
			this.head_left = new CustomHeadItem(this._box_head0)
			this.head_left.Load()
		}
		this.head_left.SetData(data.arid, data.acareer, GetSexByCareer(data.acareer, config_career), data.apic, data.apicver, null, data.asid, null, data.alv)

		if (!this.head_right) {
			this.head_right = new CustomHeadItem(this._box_head1)
			this.head_right.Load()
		}
		this.head_right.SetData(data.brid, data.bcareer, GetSexByCareer(data.bcareer, config_career), data.bpic, data.bpicver, null, data.bsid, null, data.blv)

		this._lb_name0.text = "S" + data.asnum + "." + data.aname
		this._lb_name1.text = "S" + data.bsnum + "." + data.bname
		let a_bool = data.winner == data.arid
		this._lb_result0.text = a_bool && "【胜利】" || "【失败】"
		this._lb_result0.color = a_bool && "#639C12" || "#FF0102"

		let b_bool = data.winner == data.brid
		this._lb_result1.text = b_bool && "【胜利】" || "【失败】"
		this._lb_result1.color = b_bool && "#639C12" || "#FF0102"

		if (data.winner && data.arid == data.winner || data.brid == data.winner) {
			this._img_right.visible = true

			let index 
			if(data.arid == data.winner){
				index = 0
			}
			else{
				index = 1
			}

			this[`_box_head${index}`].addChild(this._img_right)
			this._img_right.x = 61.5
			this._img_right.y = -7
		}

		if (data.winner == data.suprid) {
			this._img_fail.visible = false
			this._box_win.visible = true
			let config_drumwar_choose = this.res_mgr.GetGameConfigFromCache(this, "config_drumwar_choose", false)
			let cfg = config_drumwar_choose[data.guess_type]
			if (cfg) {
				let output = JSON.parse(cfg.output)[0][2]
				this._lb_reward.text = output
			}
			this._lb_get.text = data.reward_st == 0 && "领取奖励" || "已领取"
			this._box_get.gray = data.reward_st == 1
			this._img_get_red.visible = data.reward_st == 0
		} else {
			this._img_fail.visible = true
			this._box_win.visible = false
		}
	}

	public DeleteMe() {

		if (this.head_left) {
			this.head_left.DeleteMe()
			this.head_left = null
		}

		if (this.head_right) {
			this.head_right.DeleteMe()
			this.head_right = null
		}
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_lb_round: Laya.Label
	_box_win: Laya.Box
	_img_win: Laya.Image
	_img_icon: Laya.Image
	_lb_reward: Laya.Label
	_box_get: Laya.Box
	_img_get: Laya.Image
	_lb_get: Laya.Label
	_img_get_red: Laya.Image
	_img_fail: Laya.Image
	_lb_result0: Laya.Label
	_lb_result1: Laya.Label
	_lb_name0: Laya.Label
	_lb_name1: Laya.Label
	_box_head0: Laya.Box
	_box_head1: Laya.Box
	_img_right: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._lb_round,
			this._box_win,
			this._img_win,
			this._img_icon,
			this._lb_reward,
			this._box_get,
			this._img_get,
			this._lb_get,
			this._img_get_red,
			this._img_fail,
			this._lb_result0,
			this._lb_result1,
			this._lb_name0,
			this._lb_name1,
			this._box_head0,
			this._box_head1,
			this._img_right,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_lb_round",
				"_box_win",
				"_img_win",
				"_img_icon",
				"_lb_reward",
				"_box_get",
				"_img_get",
				"_lb_get",
				"_img_get_red",
				"_img_fail",
				"_lb_result0",
				"_lb_result1",
				"_lb_name0",
				"_lb_name1",
				"_box_head0",
				"_box_head1",
				"_img_right",
			])
	}
}
window["DiamondFightBetRecordItem"] = DiamondFightBetRecordItem