import { BaseItem1 } from "../common/BaseItem1"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MainUIManager } from "../common/MainUIManager"
import { table } from "../common/table"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Mathf } from "../util/Mathf"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util, SetLocalScaleX } from "../util/Util"
import { BossHelpItem } from "./BossHelpItem"

export class BossHelpPanel extends BaseItem1 {
	InitEvent
	LoadSuccess
	Local_DeleteMe
	Scr_Scroller1
	_ac_list
	_help_data
	panel_state
	panel_playing
	showpanel
	tween_id_list
	_pos_display
	UpdatePos
	ClearAnima
	public constructor(parent?) {
		super(parent)

		this.panel_playing = false
		this.panel_state = false
		this._ac_list = null
		this._help_data = null
		this.tween_id_list = false
		this.base_file = "suitboss"
		this.layout_file = "BossHelpPanel"
		let model = GuildModel.GetInstance()
		this.load_callback = () => {
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._panel_btn, () => {
				this.showpanel(this.panel_state)
			},this,true)

			this.BindEvent(GlobalEventSystem, EventName.UPDATE_ASSIST_DAMAGE, (list?, total_damage?) => {
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					vo.modulus = Mathf.Round(vo.damage * 100 / total_damage)
				}

				if(!this._ac_list){
					this._ac_list = new LoopScrowViewMgr()
					this._ac_list.SetData(this._list, BossHelpItem,list, LoopScrCon.Vertical)
				}else{
					this._ac_list.replaceAll(list)
				}
				
				
			}
			)

			//主动请求协助后要显示
			this.BindEvent(model, GuildEvent.REQ_SUCCESS, (scmd?) => {
				if (scmd.type != 1) {
					return
				}
				this.SetVisible(true)
				model.Fire(GuildEvent.REQUEST_PROTO, 40408)
			}
			)

			//确认协助对象是自己，然后显示
			this.BindEvent(model, GuildEvent.UPDATE_HELP_OBJ, (scmd?) => {
				if (scmd.type != 1) {
					return
				}
				this._help_data = scmd
				let bool = scmd.role_id == RoleManager.GetInstance().GetMainRoleId()
				this.SetVisible(bool)
			}
			)

			//协助删除
			this.BindEvent(model, GuildEvent.DEL_HELP_DATA, (scmd?) => {
				if (this._help_data) {
					if (this._help_data.assist_id == scmd.assist_id) {
						this._help_data = null
						this.SetVisible(false)
					}
				}
			}
			)

		}




		this.LoadSuccess = () => {
		

			this.tween_id_list = []

			model.Fire(GuildEvent.REQUEST_PROTO, 40408)
		}

		this.showpanel = (bool?) => {
			if (this.panel_playing) {
				return
			}
			this.ClearAnima()
			this.panel_state = !bool
			this.panel_playing=true
			if (bool) {
				//展示
				this._panel_gp.visible = true
				table.insert(this.tween_id_list, SYTweenLite.to(this, this._panel_btn, SYTweenLite.UiAnimationType.POSX, 2, 0.2, () => {
					this._panel_btn_img.rotation=270
				}, SYTweenFunc.EASE_IN))


				table.insert(this.tween_id_list, SYTweenLite.to(this, this._panel_gp, SYTweenLite.UiAnimationType.POSX, 23, 0.2, () => {
					this.panel_playing=false
				}, SYTweenFunc.EASE_IN))
			} else {
				//隐藏
				this._panel_gp.visible = true
				table.insert(this.tween_id_list, SYTweenLite.to(this, this._panel_btn, SYTweenLite.UiAnimationType.POSX, 185, 0.2, () => {
					this._panel_btn_img.rotation=90
				}, SYTweenFunc.EASE_IN))


				table.insert(this.tween_id_list, SYTweenLite.to(this, this._panel_gp, SYTweenLite.UiAnimationType.POSX, 188+50, 0.2, () => {
					this.panel_playing=false
					this._panel_gp.visible = false
				}, SYTweenFunc.EASE_IN))
			}
		}

		this.Local_DeleteMe = () => {
			this.ClearAnima()
		}

		this.ClearAnima=()=>{
			if (this.tween_id_list) {
				for (let _ in this.tween_id_list) {
					var key = this.tween_id_list[_]
					SYTweenLite.Stop(key)
				}
				this.tween_id_list = []
			}
		}

	}

	public DeleteMe() {

		this.Local_DeleteMe()
		if (this._ac_list) {
			this._ac_list.DeleteMe()
			this._ac_list = null
		}
		super.DeleteMe()
	}

_Group2:Laya.Box
_panel_gp:Laya.Box
_Image1:Laya.Image
_panel_img:Laya.Image
_lb_txt:Laya.Label
_list:Laya.List
_panel_btn:Laya.Box
_panel_btn_img:Laya.Image
public GetComponents() {
[
this._Group2,
this._panel_gp,
this._Image1,
this._panel_img,
this._lb_txt,
this._list,
this._panel_btn,
this._panel_btn_img,
]
 = this.GetChildrenByNames([

"_Group2",
"_panel_gp",
"_Image1",
"_panel_img",
"_lb_txt",
"_list",
"_panel_btn",
"_panel_btn_img",
])
}
}
 window["BossHelpPanel"]= BossHelpPanel