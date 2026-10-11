import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { PrayModel } from "../commonModel/PrayModel"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetSizeDeltaY, Util, Color, GlobalTimerQuest, SetAnchoredPosition } from "../util/Util"
import { SoundManager } from "../common/SoundManager"

export class PrayItemView extends BaseItem1 {
	Emp_btn_glodpray
	_Group1
	_Group2
	_Group3
	_Group4
	_Group5
	_Image1
	_Image11
	_Image2
	_Image3
	_Image4
	_Image5
	_Image6
	_Image7
	_Label1
	_Label2
	_Label3
	_btn_glodpray
	_gp_btn
	_gp_effect
	_gp_strike_effect
	_img_icon
	_img_item_bg
	_img_red
	_img_title
	_lb_countdown
	_lb_gain
	_lb_goldcost
	_lb_rem_num
	_lb_total_num
	cost
	labelDisplay
	pray_free_time
	pray_info_list
	pray_time
	pray_type
	timeout_list
	voice
	channel
	strikeToRes = {
		"0": 1,
		"1": 2,
		"2": 3,
		"10": 4,
	}
	public constructor(parent?, prefab_asset?, layer_value?, _type?, _info_list?) {
		super(parent)


		this.pray_time = 0;
		this.pray_free_time = 0;
		this.timeout_list = [];
		this.base_file = "pray"
		this.layout_file = "PrayItemView"
		this.layer_value = Enum_UILayer.UI
		this.pray_type = _type
		this.pray_info_list = _info_list
		this.preload_server_config = { "config_num_by_vip_info": false, "config_num_by_vip": false, "config_pray": false, "config_pray_cost": false, "config_pray_reward": false }
		this.voice=["Gold_drop","Epicitem_drop"]
		this.load_callback = () => {

			// if (PlatformManager.GetInstance().IsEyouEnPlatform() ) {
			// 	this._Label1.size  = 18
			// 	this._Label3.size  = 18
			// }
			// if (PlatformManager.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._lb_goldcost.size  = 20
			// }
			// if (PlatformManager.GetInstance().IsEyouThPlatform() ) {
			// 	SetSizeDeltaY(this._lb_gain,35)
			// }
			this.UpdatePrayItem()
			this.InitEvent()
		}
	}

	public InitEvent() {


		let PrayBtnCallBack = () => {
			if (this.pray_time != 0 || this.pray_free_time != 0) {
				let show_alert = (this.pray_type == 1 && (PrayModel.GetInstance().show_one_alert) || (PrayModel.GetInstance().show_two_alert))
				let ok_callback = () => {
					this.cost = null
					PrayModel.GetInstance().Fire(PrayModel.SCMD_REQUEST, 41502, this.pray_type)
					if (this.pray_type == 1) {
						PrayModel.GetInstance().show_one_alert = show_alert
					} else {
						PrayModel.GetInstance().show_two_alert = show_alert
					}
					if(this.channel){
						SoundManager.GetInstance().StopSoundEffect(this.channel)
					}
					this.channel=SoundManager.GetInstance().PlaySoundEffect(this.voice[this.pray_type-1],true,null,"ui")

				}
				let check_callback = () => {
					show_alert = !show_alert
				}
				if (this.cost && !show_alert && this.pray_free_time == 0) {
					let text = this.cost[1] == "1" && "勾玉" || "勾玉"
					let type_text = this.pray_type == 1 && "铜币" || "经验"
					let str = "是否消耗" + "<font color='#0a953e'>" + this.cost[2] + text + "</font>" + "进行" + type_text + "祈愿"
					// if (PlatformManager.GetInstance().IsEyouIdnPlatform() ) {
					// 	text = this.cost[1] == "1" && " Berlian" || " Berlian Terikat"
					// 	str = "Yakin konsumsi " + "<font color=0x639c12>" + this.cost[3] + text + "</font>" + " utk Pray " + type_text
					// 	Alert.Show(str, Alert_Type.AlertTypeCheckBox,ok_callback,null,null,null,null,null,check_callback)
					// } else if (PlatformManager.GetInstance().IsEyouJpPlatform() ) {
					// 	Alert.Show(text + "<font color=0x639c12>" + this.cost[3] + "</font>個で" + type_text + "祈願を実行しますか？", Alert_Type.AlertTypeCheckBox,ok_callback,null,null,null,null,null,check_callback)
					// }else{
					// 	Alert.Show(str, Alert_Type.AlertTypeCheckBox,ok_callback,null,null,null,null,null,check_callback)
					// }
					Alert.Show(str, Alert_Type.AlertTypeCheckBox, ok_callback, null, null, null, null, null, check_callback)
				} else {
					ok_callback()
				}
			} else {
				Message.show("祈愿次数已用完")
			}
		}

		Util.AddClickEvent(this._gp_btn, PrayBtnCallBack, this, true)
		let UpdateCountDown = (_time?) => {
			if (_time > 0) {
				this.ShowCountDown(_time)
				this._img_red.visible = false
			} else if (this.pray_type == 1) {
				this._lb_countdown.visible = false
			}
		}

		this.BindEvent(PrayModel.GetInstance(), PrayModel.UPDATE_COUNTDOWN, UpdateCountDown)
	}

	public UpdatePrayItem() {


		if (this.pray_type == 1) {
			this.GoldPray()
		} else if (this.pray_type == 2) {
			this.ExpPray()
		}
		this.UptatePrayNum(this.pray_info_list, this.pray_type)
	}

	public UptatePrayNum(_info_list?, _type?, bool?, strike?) {


		let _effect_url = null
		// [ts2lua]_info_list下标访问可能不正确
		let _sub_info = _info_list[_type-1]
		if (!_sub_info) {
			return
		}
		// [ts2lua]_sub_info下标访问可能不正确
		this._lb_rem_num.text = _sub_info["remain_times"]
		// [ts2lua]_sub_info下标访问可能不正确
		if (_sub_info["remain_times"] > 0) {
			this._lb_rem_num.color = "#ffffff" //"#ffffff"
		} else {
			this._lb_rem_num.color = "#ff4f50" //"#ff4f50"
		}
		// [ts2lua]_sub_info下标访问可能不正确
		this.pray_time = Number(_sub_info["remain_times"])
		// [ts2lua]_sub_info下标访问可能不正确
		this.pray_free_time = Number(_sub_info["free_times"])
		if (this.pray_type == 1) {
			_effect_url = "ui_qiyuanjb"
			// [ts2lua]_sub_info下标访问可能不正确
			this.ShowCost(1, _sub_info["remain_times"])
			// [ts2lua]_sub_info下标访问可能不正确
			if (Number(_sub_info["free_times"]) > 0) {
				this.labelDisplay.text = "免费祈愿"
				this._lb_goldcost.text = "免费"
				this._lb_goldcost.y=4
				this._lb_countdown.visible = false
				this._img_red.visible = true
			} else {
				this._img_red.visible = false
				this._lb_countdown.visible = true
				this.labelDisplay.text = "祈愿富饶"
				this.ShowCountDown(PrayModel.GetInstance().time)
			}
		} else if (this.pray_type == 2) {
			_effect_url = "ui_qiyuanjy"
			// [ts2lua]_sub_info下标访问可能不正确
			this.ShowCost(2, _sub_info["remain_times"])
		}
		if (bool) {
			let data = {
				load_call_back: () => {
					let timeout = () => {
						// let start_pos = [x = GetGlobalPositionX(this._gp_effect),y =GetGlobalPositionY(this._gp_effect) ]
						// PrayModel.GetInstance().Fire(PrayModel.PLAY_ANIME, this.pray_type, start_pos)
					}
					let id = GlobalTimerQuest.AddDelayQuest(timeout, 0.4)
					table.insert(this.timeout_list, id)
				}
			}
			this.AddUIEffect(_effect_url, this._gp_effect, null, 3, false, data,null,null,null,null,null,null,false)
		}

		if (strike && strike > 1) {
			// let effect_url = "UI_2016_" + this.strikeToRes[strike]
			// let group = UiFactory.CreateChild(this._gp_strike_effect,UIType.EmptyObject,"group")
			// let x = this._gp_effect.anchoredPosition.x + (this._gp_strike_effect.numChildren - 1) * 10
			// let y = this._gp_effect.anchoredPosition.y + (this._gp_strike_effect.numChildren - 1)  * -50
			// SetAnchoredPosition(group.transform,x,y)
			// let data = {
			// 	last_time : 1,
			// 	call_back_func :() => {
			// 		destroy(group,true)	
			// 	}	
			// }
			// this.AddUIEffect(effect_url,this.layer_value, group.transform, null, null, false,data)
		}
	}

	public ShowCountDown(_time?) {

		if(this.use_delete_method){
			return;
		}
		if (_time < 0) {
			this._lb_countdown.text = null
			return
		}
		let time = TimeUtil.timeConvert(_time, "hh:MM:ss")
		this._lb_countdown.text = time + "后免费"
	}

	public ShowCost(_type?, _remain_num?) {


		let vip_type = VipModel.GetInstance().GetNobleCardState()
		let vip_level = RoleManager.GetInstance().mainRoleInfo.vip_flag
		let _total_num = null
		// [ts2lua]PrayModel:GetInstance().vip_base下标访问可能不正确
		let vip_base = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip_info", false)

		let _vip = vip_base["415@" + _type]
		let type_num = _type == 1
		let pray_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_pray", false)
		// [ts2lua]PrayModel:GetInstance().vip_num下标访问可能不正确
		let vip_num_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip", false)
		if (vip_num_cfg["415@" + _type + "@" + vip_type + "@" + vip_level]) {
			_total_num = Number(pray_cfgs[_type + 2]["value"]) + Number(vip_num_cfg["415@" + _type + "@" + vip_type + "@" + vip_level]["num"])
		} else {
			_total_num = Number(pray_cfgs[_type + 2]["value"]) + Number(vip_base["415@" + _type]["num"])
		}
		this._lb_total_num.text = _total_num
		let _use_time = _total_num - _remain_num + 1
		let _cost_list = ResManager.GetInstance().GetGameConfigFromCache(this, "config_pray_cost", false)
		for (let _index in _cost_list) {


			if ((_use_time >= _cost_list[_index]["min_times"] && _use_time <= _cost_list[_index]["max_times"]) && _type == _cost_list[_index]["type"]) {

				let _cost = JSON.parse(_cost_list[_index]["cost"])
				this._lb_goldcost.text = _cost[0][2]
				this.cost = _cost[0]
			}
		}
		let _level = RoleManager.GetInstance().mainRoleInfo.level
		let _reward_list = ResManager.GetInstance().GetGameConfigFromCache(this, "config_pray_reward", false)
		for (let _index in _reward_list) {


			if ((_level >= _reward_list[_index]["min_rlv"] && _level <= _reward_list[_index]["max_rlv"]) && _type == _reward_list[_index]["type"]) {

				let _reward = JSON.parse(_reward_list[_index]["reward"])
				if (_type == 1) {
					this._lb_gain.text = _reward[0][2] + "铜币"
				} else {
					this._lb_gain.text = _reward[0][2] + "经验"
				}
			}
		}
		// LayoutRebuilder(this._lb_gain)
		// LayoutRebuilder(this._Group1)
		// LayoutRebuilder(this._lb_rem_num)
		// LayoutRebuilder(this._lb_total_num)
		// LayoutRebuilder(this._Group2)
	}

	public GoldPray() {


		let url = GameResPath.GetIcon("pray", "uiqy_008")
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_item_bg, url, true)
		ResManager.GetInstance().SetImageSprite(this, this._img_title, "pray_asset", "uiqy_002", true)
		ResManager.GetInstance().SetImageSprite(this, this._img_icon, "pray_asset", "gold_icon", true)
	}

	public ExpPray() {


		let url = GameResPath.GetIcon("pray", "uiqy_009")
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_item_bg, url, true)
		ResManager.GetInstance().SetImageSprite(this, this._img_title, "pray_asset", "uiqy_010", true)
		ResManager.GetInstance().SetImageSprite(this, this._img_icon, "pray_asset", "exp_icon", true)
		this._lb_countdown.visible = false
		this.labelDisplay.text = "祈愿成长"
	}

	public DeleteMe() {


		if (this.timeout_list.length > 0) {
			for (let _tmpi in this.timeout_list) {
				var id = this.timeout_list[_tmpi]
				GlobalTimerQuest.CancelQuest(id)
			}
			this.timeout_list = []
		}
		if(this.channel){
			SoundManager.GetInstance().StopSoundEffect(this.channel)
			this.channel=null
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._Group5,
			this._img_item_bg,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._img_title,
			this._Image5,
			this._Group1,
			this._Image6,
			this._lb_gain,
			this._Label1,
			this._gp_btn,
			this._btn_glodpray,
			this._Image11,
			this.labelDisplay,
			this._img_red,
			this._lb_countdown,
			this._Group3,
			this._Group2,
			this._lb_rem_num,
			this._Label2,
			this._lb_total_num,
			this._Label3,
			this._lb_goldcost,
			this._Image7,
			this._Group4,
			this._img_icon,
			this._gp_effect,
			this._gp_strike_effect,
		]
			= this.GetChildrenByNames([

				"_Group5",
				"_img_item_bg",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_img_title",
				"_Image5",
				"_Group1",
				"_Image6",
				"_lb_gain",
				"_Label1",
				"_gp_btn",
				"_btn_glodpray",
				"_Image11",
				"labelDisplay",
				"_img_red",
				"_lb_countdown",
				"_Group3",
				"_Group2",
				"_lb_rem_num",
				"_Label2",
				"_lb_total_num",
				"_Label3",
				"_lb_goldcost",
				"_Image7",
				"_Group4",
				"_img_icon",
				"_gp_effect",
				"_gp_strike_effect",
			])
	}
}
window["PrayItemView"] = PrayItemView