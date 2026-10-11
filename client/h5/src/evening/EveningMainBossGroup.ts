import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GuildActivityModel, GuildActEvent } from "../commonModel/GuildActivityModel"
import { GuildModel, GuildPermission } from "../commonModel/GuildModel"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { SetAnchoredPositionX, SetSizeDeltaY, Util } from "../util/Util"

export class EveningMainBossGroup extends BaseItem1 {
	_data
	_item
	_model
	preload_server_config

	is_check: boolean

	public constructor(parent?) {
		super(parent)

		this.base_file = "evening"
		this.layout_file = "EveningMainBossGroup"
		this._model = GuildActivityModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.preload_server_config = { "config_gboss": false, "config_gfeast": false }
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}
		super.DeleteMe()
	}

	public InitEvent() {

		this.BindEvent(this._model, GuildActEvent.UPDATE_BOSS_DATA, (scmd?) => {
			this.UpdateView(scmd)
			
		}
		)
		this.BindEvent(this._model, GuildActEvent.UPDATE_AUTO, (scmd?) => {
			this.is_check = scmd.is_auto == 1
			this.UpdateCheckImg()
		}
		)

		Util.AddClickEvent(this._box_check, () => {
			if(GuildModel.IsGuildMaster()||GuildModel.IsGuildViceMaster()){
				this.is_check = !this.is_check
				this.ClickCheckBox()
			}else{
				Message.show("会长/副会长才能设置自动召唤")
			}
		}, this, true)
	}

	public LoadSuccess() {

		// this._cb_auto.addEventListener(Laya.Event.CHANGE, this.ClickCheckBox, this)
		if (!this._item) {
			this._item = new BaseAwardItem(this._gp_item)
			this._item.SetItemSize(89, 89)
			this._item.Load()
		}
		this.InitEvent()
		this.InitView()
		this._model.Fire(GuildActEvent.REQUEST_PROTO, 40201)
	}

	public UpdateView(scmd?) {

		this._lb_own.text = scmd.gboss_mat
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_gboss", false)
		// [ts2lua]cfg下标访问可能不正确
		let limit = cfg[1].value
		let cur_summon_time = Number(limit - scmd.remain_times)
		this._lb_times.text = cur_summon_time + "/" + limit

		let cost = JSON.parse(cfg[9].value)
		if (cur_summon_time >= cost.length) {
			this._Label4.text = "本周召唤次数已用完"
			this._lb_cost.text = ""
		} else {
			this._Label4.text = "召唤大蛇消耗："
			this._lb_cost.text = cost[cur_summon_time][1]
		}

		this.is_check = scmd.is_auto == 1
		this.UpdateCheckImg()

	}

	public InitView() {

		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_gboss", false)
		let cfg2 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_gfeast", false)
		// [ts2lua]cfg下标访问可能不正确
		// this._lb_cost.text = cfg[9].value

		// [ts2lua]cfg下标访问可能不正确
		let time_list = JSON.parse(cfg[2].value)
		let start = time_list[0][0]
		let tsvar_end = time_list[0][1]
		// [ts2lua]cfg2下标访问可能不正确
		let start_min = Math.floor(cfg2[61].value / 60) + Number(start[1])
		this._lb_time.text = start[0] + ":" + start_min + "～" + tsvar_end[0] + ":" + tsvar_end[1]
		this._lb_time_auto.text = start[0] + ":" + start_min
		// [ts2lua]cfg下标访问可能不正确
		this._item.SetData(cfg[7].value)
	}

	public SetData(data?) {

		this._data = data
	}


	public ClickCheckBox() {

		let has_pms = GuildModel.GetInstance().HasPermission(GuildPermission.OPEN_ACT)
		if (has_pms) {
			let is_auto = (this.is_check && (1) || (0))
			this._model.Fire(GuildActEvent.REQUEST_PROTO, 40209, "c", is_auto)
		} else {
			Message.show("您的权限不足，无法开启自动召唤")
			this.is_check = false
			this.UpdateCheckImg()
		}
		
		
	}


	UpdateCheckImg(){
		if (this.is_check) {
			ResManager.GetInstance().SetImageSprite(this, this._img_check, "common_asset", "com_ui_gx1")
		} else {
			ResManager.GetInstance().SetImageSprite(this, this._img_check, "common_asset", "com_ui_gx")
		}
	}

_Image11:Laya.Image
_Image2:Laya.Image
_Image4:Laya.Image
_Image5:Laya.Image
_Image6:Laya.Image
_Label1:Laya.Label
_Label2:Laya.Label
_lb_own:Laya.Label
_Label3:Laya.Label
_lb_times:Laya.Label
_Label4:Laya.Label
_lb_cost:Laya.Label
_Label5:Laya.Label
_lb_time:Laya.Label
_Label6:Laya.Label
_Label7:Laya.Label
_lb_time_auto:Laya.Label
_gp_item:Laya.Box
_box_check:Laya.Box
_img_check:Laya.Image
public GetComponents() {
[
this._Image11,
this._Image2,
this._Image4,
this._Image5,
this._Image6,
this._Label1,
this._Label2,
this._lb_own,
this._Label3,
this._lb_times,
this._Label4,
this._lb_cost,
this._Label5,
this._lb_time,
this._Label6,
this._Label7,
this._lb_time_auto,
this._gp_item,
this._box_check,
this._img_check,
]
 = this.GetChildrenByNames([

"_Image11",
"_Image2",
"_Image4",
"_Image5",
"_Image6",
"_Label1",
"_Label2",
"_lb_own",
"_Label3",
"_lb_times",
"_Label4",
"_lb_cost",
"_Label5",
"_lb_time",
"_Label6",
"_Label7",
"_lb_time_auto",
"_gp_item",
"_box_check",
"_img_check",
])
}
}
 window["EveningMainBossGroup"]= EveningMainBossGroup