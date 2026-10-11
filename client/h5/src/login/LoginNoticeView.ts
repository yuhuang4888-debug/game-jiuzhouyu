import { BaseView1 } from "../common/BaseView1"
import { ResManager } from "../common/ResManager"
import { LoginModel } from "./LoginModel"
import { LoginStateEvent } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { GlobalTimerQuest, SetHtmlStyle, Util } from "../util/Util"
import { LoginManager } from "./LoginManager"
import { LoginNoticeItem } from "./LoginNoticeItem"
import { TimeUtil } from "../util/TimeUtil"
import { Enum_LoginState } from "./LoginStateManager"
import "./LoginNoticeItem"
import "./LoginNoticeBtnItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { LoginNoticeBtnItem } from "./LoginNoticeBtnItem"
export class LoginNoticeView extends BaseView1 {

	cfg_list


	LoadSuccess
	InitEvent
	UpdateTab
	UpdateTestServer
	CancelTestServerTimer
	update_timer
	UpdateTimer
	loop_tab: LoopScrowViewMgr
	public constructor() {
		super()
		let res_mgr = ResManager.GetInstance(),
			login_model = LoginModel.GetInstance(),
			local_LoginStateEvent = LoginStateEvent,
			notice_cfg_, notice_list_, content_cfg_, item_list_ = [],
			test_server_time_id_, test_server_time_func_
		this.base_file = "login"
		this.layout_file = "LoginNoticeView"
		this.layer_value = Enum_UILayer.Message
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.load_callback = () => {
			this._scroll_con.vScrollBarSkin = ""
			SetHtmlStyle(this._lb_test_server, { c: "#663915", f: 24, ww: false, w: 627 })
			this.LoadSuccess()
			this.InitEvent()
		}
		this.LoadSuccess = () => {
			let cfg = login_model.notice_cfg
			this.cfg_list = login_model.GetCurPlatConfig(cfg)

			if (this.cfg_list && this.cfg_list.length <= 0) {
				this.Close()
				return
			}

			if (!this.loop_tab) {
				this.loop_tab = new LoopScrowViewMgr()
				this.loop_tab.SetData(this._list_tab, LoginNoticeBtnItem, this.cfg_list, LoopScrCon.Horizontal, 1, (index?) => {
					this._scroll_con.vScrollBar.value = 0
					content_cfg_ = this.cfg_list[index]
					if(content_cfg_&&content_cfg_.content.length>0){
						this.UpdateTab()
					}
				}, 0)
			} else {
				this.loop_tab.replaceAll(this.cfg_list)
			}

			res_mgr.SetTexture(this, this._img_bg, "resource/game/login/texture/uidl_029.jpg")
			res_mgr.SetImageSprite(this, this._img_title, "login", "uigxgg_002")
			this.UpdateTestServer()
		}
		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_read, () => {
				this.Close()
			}, this, true)
			this.BindEvent(LoginManager.GetInstance(), LoginStateEvent.UPDATE_TEST_SERVER_DATA, () => {
				this.UpdateTestServer()
			})
		}
		this.UpdateTab = () => {
			let notice_cont = content_cfg_.content[0]
			notice_list_ = notice_cont.content.split("\n\n##")

			if (notice_list_) {

				for (let p = 0; p < item_list_.length; p++) {
					item_list_[p].SetVisible(false)
				}

				for (let i = 0; i < notice_list_.length; i++) {
					if (!notice_list_[i])
						break
					let item: LoginNoticeItem = item_list_[i]
					if (!item) {
						item = new LoginNoticeItem(this._gp_item)
						item.Load()
						item_list_.push(item)
					}
					item.SetVisible(true)
					item.SetData(notice_list_[i])
				}
			}

			this.CallLater(() => {
				this._gp_item.refresh()
			})
		}
		this.UpdateTestServer = () => {
			this.CancelTestServerTimer()
			let data = login_model.GetTestServerData()
			let bool = false
			let name = ""
			let get_left_time = () => {
				let data = login_model.GetTestServerData()
				if (data) {
					let now_time = Math.floor(new Date().getTime() / 1000)
					let targer_time = data.testotime
					return targer_time - now_time
				}
				return 0
			}
			let left_time = get_left_time()
			bool = left_time > 0 && left_time < LoginModel.TestServerShowTime
			if (bool) {
				this._scroll_con.y = 155//256
				this._scroll_con.height = 723
				name = data.testname
				this._lb_test_server.visible = true
				this._lb_test_server.innerHTML = Util.StrToHTML(`${Util.HtmlColorTxt(data.testname, "'#663915'")} 将于 ${Util.HtmlColorTxt(TimeUtil.timeConversion(data.testotime, "yyyy/mm/dd hh:MM"), "'#639c12'")} 开启`)
			}
			else {
				this._scroll_con.y = 229//330
				this._scroll_con.height = 671
				this._lb_test_server.visible = false
			}


			if (left_time > 0) {
				this.update_timer = GlobalTimerQuest.AddPeriodQuest(() => {
					this.UpdateTimer(get_left_time())
				}, 1, -1)
				this.UpdateTimer(get_left_time())
			}
		}

		this.UpdateTimer = (left_time) => {
			if (left_time < 0) {
				LoginManager.GetInstance().RequestTestServerData()
				LoginManager.GetInstance().Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, Enum_LoginState.ServerList)
				return
			}
			if (left_time > 0 && left_time < LoginModel.TestServerShowTime) { //
				this._gp_test_server.visible = true
				this._lb_server_name.text = `新服开启倒计时`
				this._lb_server_time.text = TimeUtil.timeConvert(left_time, "mm-ss")
			}
			else {
				this._gp_test_server.visible = false
			}
		}


		this.CancelTestServerTimer = () => {
			if (this.update_timer) {
				GlobalTimerQuest.CancelQuest(this.update_timer)
				this.update_timer = null
			}
		}


		this.destroy_callback = () => {
			if (this.loop_tab) {
				this.loop_tab.DeleteMe()
				this.loop_tab = null
			}


			if (item_list_) {
				for (let i = 0; i < item_list_.length; i++) {
					item_list_[i].DeleteMe()
				}
				item_list_.length = 0
			}
			this.CancelTestServerTimer()
		}
	}

	public DeleteMe() {


		super.DeleteMe()
	}



	_img_bg: Laya.Image
	_img_title: Laya.Image
	_lb_test_server: Laya.HTMLDivElement
	_btn_read: Laya.Box
	_Image122: Laya.Image
	labelDisplay: Laya.Label
	_scroll_con: Laya.Panel
	_gp_item: Laya.VBox
	_gp_test_server: Laya.Box
	_Image1: Laya.Image
	_lb_server_time: Laya.Label
	_lb_server_name: Laya.Label
	_list_tab: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._lb_test_server,
			this._btn_read,
			this._Image122,
			this.labelDisplay,
			this._scroll_con,
			this._gp_item,
			this._gp_test_server,
			this._Image1,
			this._lb_server_time,
			this._lb_server_name,
			this._list_tab,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title",
				"_lb_test_server",
				"_btn_read",
				"_Image122",
				"labelDisplay",
				"_scroll_con",
				"_gp_item",
				"_gp_test_server",
				"_Image1",
				"_lb_server_time",
				"_lb_server_name",
				"_list_tab",
			])
	}
}
window["LoginNoticeView"] = LoginNoticeView
