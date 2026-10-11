import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { LuaSoundManager } from "../common/SoundManager"
import { BossModel } from "../commonModel/BossModel"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { OperateManager } from "../operation/OperateManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Message } from "../sysInfo/SysInfoController"

export class BossHelpRolePanel extends BaseItem1 {
	Emp_btn_go
	FindWay
	InitEvent
	LoadSuccess
	Out_Label1
	SetData
	_data
	_finding
	_head1
	_pos
	res_mgr
	_pos_display
	public constructor(parent?) {
		super(parent)

		this._finding = false
		this._head1 = null
		this.base_file = "suitboss"
		this.layout_file = "BossHelpRolePanel"
		this.layer_value = Enum_UILayer.Activity
		let gmodel = GuildModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.preload_server_config = {
			"config_boss_type": false,
			"config_eudemons_boss_cfg": false,
			"config_decoration_boss": false
		}

		this.load_callback = () => {
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_go, () => {
				this.FindWay()
			}
				, this, true)

			Util.AddClickEvent(this._btn_close, () => {
				if (!this._data) {
					return
				}
				if (this._data.type == 2 || this._data.assist_id == 0) {
					Message.show("当前在副本中~")
					return
				}
				Alert.Show("是否要退出协助？", Alert_Type.Two, () => {
					gmodel.Fire(GuildEvent.REQUEST_PROTO, 40403, "l", this._data.assist_id)
				})
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			this.BindEvent(gmodel, GuildEvent.CANCEL_HELP_SUCCESS, (scmd?, req_id?) => {
				//非求助者自己，则执行一系列取消操作
				let not_req = req_id && req_id != RoleManager.GetInstance().GetMainRoleId()
				if (not_req) {
					this.display_obj.visible = false
					let scene = Scene.GetInstance()
					scene.SetClickTarget(null)
					scene.clearGoToData()
					AutoFightManager.GetInstance().SetAutoFight(false)
					OperateManager.GetInstance().StopMove()
				}
			}
			)
			this.BindEvent(gmodel, GuildEvent.UPDATE_HELP_OBJ, (scmd?) => {
				this._data = scmd
				let is_show = scmd.assist_id != 0 && scmd.role_id != RoleManager.GetInstance().GetMainRoleId() && (scmd.type == 1 && SceneManager.GetInstance().IsBossScene() || scmd.type == 2 && SceneManager.GetInstance().IsDungeonScene())
				this.display_obj.visible = is_show
				if (is_show) {
					this.SetData(scmd)
				}
			}

			)

			//帮助其他人，重新获取信息
			this.BindEvent(gmodel, GuildEvent.HELP_SUCCESS, (scmd?) => {
				GuildModel.GetInstance().Fire(GuildEvent.REQUEST_PROTO, 40408)
			}
			)

			//帮助完成
			this.BindEvent(gmodel, GuildEvent.ASSIST_SUCCESS, (scmd?) => {
				this.display_obj.visible = false
			}
			)

		}

		this.LoadSuccess = () => {
			if (!this._head1) {
				this._head1 = new CustomHeadItem(this._head)
				this._head1.Load()
			}
			GuildModel.GetInstance().Fire(GuildEvent.REQUEST_PROTO, 40408)

		}

		this.SetData = (data?) => {
			if (!data) {
				return
			}
			let head_data = { role_id: data.role_id, career: data.career, picture: data.pic, picture_ver: data.pic_ver }
			this._head1.SetRoleVoData(head_data,null,null,data.level)
			this._lb_name.text = data.name
			if (data.sub_type == BossModel.BossType.domainserver) {
				let cfg = this.res_mgr.GetGameConfigFromCache(this, "config_decoration_boss", false)
				let vo = cfg[data.target_cfg_id]
				if (vo) {
					this._pos = { x: vo.x, y: vo.y }
				}
			} else if (data.sub_type == BossModel.BossType.eudaemon) {
				let cfg1 = this.res_mgr.GetGameConfigFromCache(this, "config_eudemons_boss_cfg", false)
				let vo = cfg1[data.target_cfg_id]
				if (vo) {
					let list = JSON.parse(vo.fixed_xy)[0]
					this._pos = { x: list[0], y: list[1] }
				}
			} else {

				let cfg2 = this.res_mgr.GetGameConfigFromCache(this, "config_eudemons_boss_cfg", false)
				let cfg3 = this.res_mgr.GetGameConfigFromCache(this, "config_boss_type", false)
				if(this._data.type != 2){
					this._pos = BossModel.GetInstance().GetBossPos(data.target_cfg_id, data.sub_type, cfg2, cfg3)
				}
			
			}
			let rdata = GuildModel.GetInstance().GetAssistData(data.role_id)
			if (rdata) {
				this.FindWay()
			}
			
			this._btn_go.visible=this._pos!=null
			this._Image1.height=this._pos!=null?236:190


		}

		this.FindWay = () => {
			if (!this._pos) {
				return
			}
			this._finding = true
			GuildModel.GetInstance().FindWay(this._pos.x, this._pos.y, () => {
				this._finding = false
			}
			)
		}
	}

	public DeleteMe() {

		if (this._head1) {
			this._head1.DeleteMe()
			this._head1 = null
		}
		super.DeleteMe()
	}


	// public Open(...new_args) {

	// 	this._pos_display = new_args[0]
	// 	super.Open()
	// }


	_Image1: Laya.Image
	_Group5: Laya.Box
	_img_g5_title: Laya.Image
	_lb_win_name: Laya.Label
	_head: Laya.Box
	_Image3: Laya.Image
	_lb_name: Laya.Label
	_btn_go: Laya.Box
	_Image4: Laya.Image
	_Label1: Laya.Label
	_btn_close: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._Group5,
			this._img_g5_title,
			this._lb_win_name,
			this._head,
			this._Image3,
			this._lb_name,
			this._btn_go,
			this._Image4,
			this._Label1,
			this._btn_close,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Group5",
				"_img_g5_title",
				"_lb_win_name",
				"_head",
				"_Image3",
				"_lb_name",
				"_btn_go",
				"_Image4",
				"_Label1",
				"_btn_close",
			])
	}
}
window["BossHelpRolePanel"] = BossHelpRolePanel