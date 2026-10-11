import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { GetSexByCareer, Util } from "../util/Util"

export class DiamondFightBetItem extends BaseItem1 {



	call_back
	choose_id
	data
	is_bet
	is_stage
	model: DiamondFightModel
	res_mgr: ResManager
	need_refresh_data


	head_left
	head_right

	public constructor(parent?) {
		super(parent)

		this.base_file = "diamondFight"
		this.layout_file = "DiamondFightBetItem"
		this.model = DiamondFightModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {

		//resource/game/diamondFight/texture/ui_activity_02.png
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("diamondFight","ui_activity_02"))


		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdateView()
		}
		this.InitEvent()
	}

	public InitEvent() {

		Util.AddClickEvent(this._box_head0, () => {
			if (this.is_bet) {
				Message.show("已竞猜～")
				return
			}
			if (!this.is_stage) {
				Message.show("当前不是竞猜阶段～")
				return
			}
			this.SwitchRole(0)
		}, this, true)

		Util.AddClickEvent(this._box_head1, () => {
			if (this.is_bet) {
				Message.show("已竞猜～")
				return
			}
			if (!this.is_stage) {
				Message.show("当前不是竞猜阶段～")
				return
			}
			this.SwitchRole(1)
		}, this, true)

		Util.AddClickEvent(this._box_bet, () => {
			if (!this.choose_id || this.choose_id == 0) {
				Message.show("请先选择一个竞猜对象")
				return
			}
			this.call_back(this.choose_id, this.data.action)
		}, this, true)
	}

	public SetData(data?, is_bet?, call_back?, is_stage?) {

		this.data = data
		this.is_bet = is_bet
		this.call_back = call_back
		this.is_stage = is_stage
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

		let config_career = this.res_mgr.GetGameConfigFromCache(this, "config_career", false)
		if (!this.head_left) {
			this.head_left = new CustomHeadItem(this._box_head0)
			this.head_left.CloseClick()
			this.head_left.Load()
		}
		this.head_left.SetData(data.arid, data.acareer, GetSexByCareer(data.acareer, config_career), data.apic, data.apicver, null, data.asid, null, data.alv)

		if (!this.head_right) {
			this.head_right = new CustomHeadItem(this._box_head1)
			this.head_right.CloseClick()
			this.head_right.Load()
		}
		this.head_right.SetData(data.brid, data.bcareer, GetSexByCareer(data.bcareer, config_career), data.bpic, data.bpicver, null, data.bsid, null, data.blv)


		this._lb_name0.text = "S" + data.asnum + "." + data.aname
		this._lb_name1.text = "S" + data.bsnum + "." + data.bname

		if (data.arid == data.suprid || data.brid == data.suprid) {
			this._box_bet.visible = false
			this._img_beted.visible = true
			this.choose_id = data.suprid
			this.UpdateBetImg()
		} else if (!this.is_stage) {
			this._box_bet.visible = false
			this._img_beted.visible = false
		} else {
			this._box_bet.visible = !this.is_bet
			this._img_beted.visible = false
		}
	}

	public DeleteMe() {

		this.choose_id = null

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

	public SwitchRole(index?) {

		if (!this.data) {
			return
		}
		let attr = index == 0 && "arid" || "brid"
		let choose_id = this.data[attr]
		if (this.choose_id == choose_id) {
			return
		}
		this.choose_id = choose_id
		this.UpdateBetImg()
	}

	public UpdateBetImg() {

		if (this.choose_id && this.data && (this.data.arid == this.choose_id || this.data.brid == this.choose_id)) {
			this._img_right.visible = true
			let index 
			if(this.data.arid == this.choose_id){
				index = 0
			}
			else{
				index = 1
			}
			this[`_box_head${index}`].addChild(this._img_right)
			this._img_right.x = 65
			this._img_right.y = 10
		}
	}


	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_right: Laya.Image
	_img_beted: Laya.Image
	_lb_name0: Laya.Label
	_lb_name1: Laya.Label
	_box_head0: Laya.Box
	_box_head1: Laya.Box
	_box_bet: Laya.Box
	_img_bet: Laya.Image
	_lb_bet: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_right,
			this._img_beted,
			this._lb_name0,
			this._lb_name1,
			this._box_head0,
			this._box_head1,
			this._box_bet,
			this._img_bet,
			this._lb_bet,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_right",
				"_img_beted",
				"_lb_name0",
				"_lb_name1",
				"_box_head0",
				"_box_head1",
				"_box_bet",
				"_img_bet",
				"_lb_bet",
			])
	}
}
window["DiamondFightBetItem"] = DiamondFightBetItem