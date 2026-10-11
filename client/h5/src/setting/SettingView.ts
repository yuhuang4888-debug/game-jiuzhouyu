import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager, SoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { WithBtnHSlider } from "../common/WithBtnHSlider"
import { SettingModel } from "../commonModel/SettingModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Message } from "../sysInfo/SysInfoController"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util, SetSizeDeltaX, SetAnchoredPosition, GetSizeDeltaX, DEVICE_OS, IsInTable } from "../util/Util"
import { SettingShieldItem } from "./SettingShieldItem"
import { MainRole } from "../scene/sceneobj/MainRole"
import { SettingSubscriptionItem } from "./SettingSubscriptionItem"
import { EquipmentViewSecond_Menu_Type } from "../commonModel/EquipModel"
import { OpenFun } from "../common/OpenFun"
import { DressType } from "../commonModel/DressModel"
import { TaskModel } from "../commonModel/TaskModel"


let local_Util = Util
let local_GlobalEventSystem = GlobalEventSystem
export class SettingView extends BaseView1 {

	static TabType = {
		Setting: 1,
		Shield: 2,
		Subs: 3
	}


	static ShowInShieldDic = [
		SettingModel.BlockSubType.sprite,
		SettingModel.BlockSubType.wing,
		SettingModel.BlockSubType.shengqi,
		SettingModel.BlockSubType.weapon,
		SettingModel.BlockSubType.demon,
		SettingModel.BlockSubType.partner,
		SettingModel.BlockSubType.shield_channel,
		SettingModel.BlockSubType.wx_board,
		SettingModel.BlockSubType.back,
		SettingModel.BlockSubType.liveness,
		SettingModel.BlockSubType.shock_screen,
	]


	music_value_change
	role_head
	same_screen_value_change

	slider1
	slider2
	slider_sound
	slider_music_audio
	sound_value_change


	effect_num_value_change
	shield_loop_mgr
	auto_pick_loop_mgr
	sys_setting_data
	config_setting
	god_setting_data
	horse_setting_data
	task_setting_data
	local_auto_task_state


	cur_tab_type = SettingView.TabType.Setting
	model: SettingModel = SettingModel.GetInstance()
	scene: Scene = Scene.GetInstance()
	role_mgr: RoleManager = RoleManager.GetInstance()
	scene_mgr: SceneManager = SceneManager.GetInstance()

	public constructor() {
		super()

		this.base_file = "setting"
		this.layout_file = "SettingView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.back_login_toClose = true

		this.preload_client_config = {
			"ClientBlockConfig": false
		}
		this.preload_server_config = {
			"config_setting": false
		}

		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._list_shield.spaceX = 20
				this._btn_changename.x = 578
				this._btn_changename.y = 24.5
				this._lb_name.x = 65
				this._lb_name.y = 2
				this.id_ser_name.x = 341
				this.id_ser_name.y = 75
				this.id_number1.x = 341
				this.id_number1.y = 118
				this.id_number.x = 341
				this.id_number.y = 118
			}
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.close_callback = () => {
			this.SendSetSliderNum()
		}

		this.destroy_callback = () => {
			if (this.slider1) {
				this.slider1.DeleteMe()
				this.slider1 = null
			}
			if (this.slider2) {
				this.slider2.DeleteMe()
				this.slider2 = null
			}

			if (this.slider_sound) {
				this.slider_sound.DeleteMe()
				this.slider_sound = null
			}

			if (this.slider_music_audio) {
				this.slider_music_audio.DeleteMe()
				this.slider_music_audio = null
			}

			if (this.shield_loop_mgr) {
				this.shield_loop_mgr.DeleteMe()
				this.shield_loop_mgr = null
			}

			if (this.auto_pick_loop_mgr) {
				this.auto_pick_loop_mgr.DeleteMe()
				this.auto_pick_loop_mgr = null
			}

			if (this.role_head) {
				this.role_head.DeleteMe()
				this.role_head = null
			}
			this.god_setting_data = null
			this.horse_setting_data = null
			this.task_setting_data = null
			this.local_auto_task_state = null
		}
	}


	public LoadSuccess() {
		this.config_setting = ResManager.GetInstance().GetGameConfigFromCache(this, "config_setting", false)
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line, "resource/game/setting/texture/com_line_5.png")
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line2, "resource/game/setting/texture/com_line_5.png", true)
		this.InitEvent()

		if (ClientConfig.auto_task_setting) {
			let story_model = this.story_model
			if (story_model.main_ui_finger) {
				let obj = story_model.main_ui_finger && story_model.main_ui_finger.target_obj
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, obj, true)
			}
		}

		// if(PlatformManager.IsEyouPlatform() && Util.IsConch() && Laya.Browser.onIOS){
		// 	this.block_user.visible = true
		// 	Util.AddClickEvent(this.block_user, ()=>{
		// 		PlatformManager.GetInstance().ShowTheBlockUserAccountViewBlock()
		// 		this.Close()
		// 	}, this, true)
		// }
		if (ClientConfig.show_agreement == 1) {
			this._lb_agree.visible = true
			this._lb_agree.text = `《${ClientConfig.agree_text}》`
			Util.AddClickEvent(this._lb_agree, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "LoginUserAgreementView", ClientConfig.agreement_type, 1)
			}, this, false)

			if (ClientConfig.privacy_text) {
				this._lb_privacy.visible = true
				this._lb_privacy.text = `《${ClientConfig.privacy_text}》`
				Util.AddClickEvent(this._lb_privacy, () => {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "LoginUserAgreementView", ClientConfig.agreement_type, 2)
				}, this, false)
			}
		}
	}

	public InitEvent() {

		let close_fun = () => {
			this.Close()
		}
		local_Util.AddClickEvent(this._img_empty, close_fun, this)
		local_Util.AddClickEvent(this._img_close, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

		let change_name_btn_fun = () => {
			local_GlobalEventSystem.Fire(EventName.REQUEST_ROLE_PROTO, 42602)
		}
		local_Util.AddClickEvent(this._btn_changename, change_name_btn_fun, this, true)

		local_Util.AddClickEvent(this._btn_copy, () => {
			// SetSystemClipboard(this.id_number.text)
			this.CopyStr(this.id_number.text)
			Message.show("复制成功")
		}, this, true)

		let change_head_btn_fun = () => {
			close_fun();
			OpenFun.OpenFunHandler(203, [DressType.Head])
		}
		local_Util.AddClickEvent(this.change_head_btn, change_head_btn_fun, this, true)

		local_Util.AddClickEvent(this._box_tab_base_setting, () => {
			if (this.cur_tab_type != SettingView.TabType.Setting) {
				this.cur_tab_type = SettingView.TabType.Setting
				this.UpdateTab()
			}
		}, this, true)

		local_Util.AddClickEvent(this._box_tab_shield_setting, () => {
			if (this.cur_tab_type != SettingView.TabType.Shield) {
				this.cur_tab_type = SettingView.TabType.Shield
				this.UpdateTab()
			}
		}, this, true)

		let change_god_box = () => {
			if (this.god_setting_data) {
				let open = this.god_setting_data.is_open == 1 ? 0 : 1
				this.SendProtocal(this.god_setting_data.subtype, open)
			}
		}
		local_Util.AddClickEvent(this._img_god_check, change_god_box, this, true)

		let change_horse_box = () => {
			if (this.horse_setting_data) {
				let open = this.horse_setting_data.is_open == 1 ? 0 : 1
				this.SendProtocal(this.horse_setting_data.subtype, open)
				if (open == 0) {
					Message.show("场景中上下轻滑即可上下坐骑~")
				}
			}
		}
		local_Util.AddClickEvent(this._img_horse_check, change_horse_box, this, true)

		local_Util.AddClickEvent(this._img_task_check1, () => {
			if (this.task_setting_data) {
				if (this.local_auto_task_state) {
					return
				}
				this.SendProtocal(this.task_setting_data.subtype, 1)
			}
		}, this, true)

		local_Util.AddClickEvent(this._img_task_check2, () => {
			if (this.task_setting_data) {
				if (!this.local_auto_task_state) {
					return
				}
				this.SendProtocal(this.task_setting_data.subtype, 0)
			}
		}, this, true)

		local_Util.AddClickEvent(this.change_role, () => {
			if (Alert) {
				Alert.Show("是否返回角色选择界面？", Alert_Type.Two, () => {
					this.Close()
					UserMsgAdapter.GetInstance().wait_player_handle = true
					local_GlobalEventSystem.Fire(EventName.CHANGE_ROLE)
				}, null, "确认", "取消")
			}
		}, this, true, null, null, true)


		local_Util.AddClickEvent(this.return_login, () => {
			if (PlatformManager.GetInstance().SwitchAccount()) {
				return
			}

			Alert.Show("是否返回登录界面？", Alert_Type.Two, () => {
				this.Close()
				UserMsgAdapter.GetInstance().wait_player_handle = true
				local_GlobalEventSystem.Fire(EventName.CHANGE_ACCOUNT)
			}, null, "确认", "取消")

		}, this, true, null, null, true)

		local_Util.AddClickEvent(this.confirm_flee, () => {
			let scene_id = this.scene_mgr.GetSceneId()

			if (Alert) {
				Alert.Show("是否脱离卡死？", Alert_Type.Two, () => {
					if (scene_id) {
						this.model.Fire(SettingModel.SETTING_REQUEST_PROTO, 10210, "i", scene_id)
					}
				}, null, "确认", "取消")
			}

		}, this, true, null, null, true)

		local_Util.AddClickEvent(this.confirm_res, () => {
			let exit_func = () => {
				let ok = () => {
					if (window && window.location) {
						window.location.reload()
					}
				}
				if (Alert) {
					Alert.Show("修复异常后，需要重新启动游戏", Alert_Type.Two, ok)
				}
			}
			exit_func()
		}, this, true, null, null, true)

		let simple_mode_btn_fun = () => {
			if (Alert) {
				Alert.Show("是否还原默认设置", Alert_Type.Two, () => {
					this.SimpleModeFun()
				}, null, "确认", "取消")
			}
		}
		local_Util.AddClickEvent(this.simple_mode_btn, simple_mode_btn_fun, this, true)

		let update_fun = () => {
			this.OpenCallback()
		}
		this.BindEvent(this.model, SettingModel.UPDATE_SETTING_INFO, update_fun)
		this.BindEvent(local_GlobalEventSystem, SettingModel.CHANGE_NAME_SUCCESS, update_fun)

		let update_fun2 = (scmd?) => {
			if ((scmd && this.sys_setting_data) && SettingModel.SettingType.SysSetting == scmd.type) {
				let cfg = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig.BlockSubType
				if (scmd.subtype == cfg["sound_open"]) {
					this.SetAudioBtn()
				} else if ((scmd.subtype == cfg["same_screen_role_num"] || scmd.subtype == cfg["effect_num"]) || scmd.subtype == cfg["simple_mode"]) {
					this.SetNumSlider()
				} else if (scmd.subtype == cfg["sound_effect_open"]) {
					this.SetSoundBtn()
				} else if (scmd.subtype == cfg["godbefall"]) {
					this.UpdateGodCheckBox()
				} else if (scmd.subtype == cfg["auto_horse"]) {
					this.UpdateHorseCheckBox()
				} else if (scmd.subtype == cfg["auto_task"]) {
					this.UpdateTaskCheckBox()
				}
			}
			this.SetSimpleBtnState()
		}
		this.BindEvent(this.model, SettingModel.UPDATE_ONE_SETTING_INFO, update_fun2)

		let head_img_fun = () => {
			this.RefreshHeadIcon()
		}
		this.BindEvent(local_GlobalEventSystem, SettingModel.SELECT_ROLE_HEAD_ICON_SUCCESS, head_img_fun)

		let update_content = () => {
			this.UpdateTab()
			this.UpdateHorseCheckBox()
			this.UpdateGodCheckBox()
		}
		this.BindEvent(this.model, SettingModel.UPDATE_CONTENT, update_content)
	}

	public CopyStr(str: string) {
		if (local_Util.IsConch()) {
			PlatformManager.GetInstance().Clipboard(str)
		} else if (local_Util.IsWXGame() || local_Util.IsQQGame() || local_Util.IsMTGame()) {
			let wx = window["wx"]
			if(!wx) return
			let text = str

			wx.setClipboardData && wx.setClipboardData({
				data: text,
				success: () => {

				},
				fail: () => {

				},
				complete: () => {

				}
			})
		} else if (local_Util.IsTTGame()) {
			let tt = window["tt"]
			if(!tt) return
			let text = str
			tt.setClipboardData && tt.setClipboardData({
				data: text,
				success: () => {

				},
				fail: () => {

				},
				complete: () => {

				}
			})
		} else if (window.getSelection) {
			let input: string = str;
			const el: any = window.document.createElement('textarea');
			el.value = input;
			el.setAttribute('readonly', '');
			el.style.contain = 'strict';
			el.style.position = 'absolute';
			el.style.left = '-9999px';
			el.style.fontSize = '12pt'; // Prevent zooming on iOS
			const selection: any = window.getSelection();
			let originalRange: any = false;
			if (selection.rangeCount > 0) {
				originalRange = selection.getRangeAt(0);
			}
			window.document.body.appendChild(el);
			el.select();
			el.selectionStart = 0;
			el.selectionEnd = input.length;
			let success: boolean = false;
			try {
				success = window.document.execCommand('copy');
			} catch (err) {

			}
			window.document.body.removeChild(el);
			if (originalRange) {
				selection.removeAllRanges();
				selection.addRange(originalRange);
			}
			return success;
		}
	}

	public UpdateGodSetting = () => {
		let is_open = CommonManager.GetInstance().CheckFuncOpenState("GodBefallMainView", true)
		this._box_god.visible = is_open
		if (is_open) {
			this.UpdateGodCheckBox()
		}
	}

	public UpdateGodCheckBox() {
		if (!this.god_setting_data) {
			this.god_setting_data = this.model.GetSubSettingData(SettingModel.SettingType.SysSetting, SettingModel.BlockSubType.godbefall)
		}

		if (this.god_setting_data && this.god_setting_data.is_open == 0) {
			this._img_god_check.x = 10
			this._img_god_check.y = 47
			ResManager.GetInstance().SetImageSprite(this, this._img_god_check, "common_asset", "com_ui_gx")
		} else {
			this._img_god_check.x = 9
			this._img_god_check.y = 43
			ResManager.GetInstance().SetImageSprite(this, this._img_god_check, "common_asset", "com_ui_gx1")
		}
	}

	public UpdateHorseSetting() {
		let is_open = CommonManager.GetInstance().CheckFuncOpenState("HorseComponentView", true)
		this._box_horse.visible = is_open
		if (is_open) {
			this.UpdateHorseCheckBox()
		}
	}

	public UpdateHorseCheckBox() {
		if (!this.horse_setting_data) {
			this.horse_setting_data = this.model.GetSubSettingData(SettingModel.SettingType.SysSetting, SettingModel.BlockSubType.auto_horse)
		}
		if (this.horse_setting_data && this.horse_setting_data.is_open == 0) {
			this._img_horse_check.x = 10
			this._img_horse_check.y = 47
			ResManager.GetInstance().SetImageSprite(this, this._img_horse_check, "common_asset", "com_ui_gx")
		} else {
			this._img_horse_check.x = 9
			this._img_horse_check.y = 43
			ResManager.GetInstance().SetImageSprite(this, this._img_horse_check, "common_asset", "com_ui_gx1")
		}
	}

	public UpdateTaskSetting() {
		let is_open = ClientConfig.auto_task_setting == 1
		this._box_task.visible = is_open
		if (is_open) {
			this.UpdateTaskCheckBox()
		}
	}

	public UpdateTaskCheckBox() {
		if (!this.task_setting_data) {
			this.task_setting_data = this.model.GetSubSettingData(SettingModel.SettingType.SysSetting, SettingModel.BlockSubType.auto_task)
		}
		this.local_auto_task_state = this.task_setting_data.is_open
		if (this.task_setting_data && this.task_setting_data.is_open == 0) {
			this._img_task_check1.x = 10
			this._img_task_check1.y = 47

			this._img_task_check2.x = 169
			this._img_task_check2.y = 43

			ResManager.GetInstance().SetImageSprite(this, this._img_task_check1, "common_asset", "com_ui_gx")
			ResManager.GetInstance().SetImageSprite(this, this._img_task_check2, "common_asset", "com_ui_gx1")

		} else {
			this._img_task_check1.x = 9
			this._img_task_check1.y = 43

			this._img_task_check2.x = 170
			this._img_task_check2.y = 47

			ResManager.GetInstance().SetImageSprite(this, this._img_task_check1, "common_asset", "com_ui_gx1")
			ResManager.GetInstance().SetImageSprite(this, this._img_task_check2, "common_asset", "com_ui_gx")
		}
	}


	public UpdateBaseSettingPanelHeight() {
		let height = 10

		if (this._box_slider.visible) {
			this._box_slider.y = height
			height += (this._box_slider.height + 10)
		}
		else {
			this._box_slider.y = 0
		}

		if (this._box_pick.visible) {
			this._box_pick.y = height
			height += (this._box_pick.height + 10)
		}
		else {
			this._box_pick.y = 0
		}

		if (this._box_horse.visible) {
			this._box_horse.y = height
			height += (this._box_horse.height + 10)
		}
		else {
			this._box_horse.y = 0
		}

		if (this._box_god.visible) {
			this._box_god.y = height
			height += (this._box_god.height + 10)
		}
		else {
			this._box_god.y = 0
		}

		if (this._box_task.visible) {
			this._box_task.y = height
			height += (this._box_task.height + 10)
		}
		else {
			this._box_task.y = 0
		}

		if (height > this._box_base_setting.height) {
			this._box_base_setting.vScrollBarSkin = ""
			this._box_base_setting.elasticEnabled = true
		}
	}


	public OpenCallback() {
		this.sys_setting_data = this.model.GetSettingData(SettingModel.SettingType.SysSetting)
		let main_role = this.role_mgr.mainRoleInfo
		if (!main_role || !this.sys_setting_data) {
			return
		}
		this._lb_name.text = main_role.name
		let size_name_x = GetSizeDeltaX(this._lb_name)
		if (size_name_x > 180) {
			this._lb_name.fontSize = 18
		} else {
			this._lb_name.fontSize = 26
		}
		if (PlatformManager.IsEyouEnPlatform()) {
			this._btn_changename.x = this._Group2.x + this._lb_name.x + this._lb_name.width + 5
		}
		if (Number(main_role.role_id) > 9999999999999) {
			this.id_number.fontSize = 18
		} else {
			this.id_number.fontSize = 24
		}
		//@ts-ignore
		this.id_number.text = main_role.role_id
		this.id_ser_name.text = main_role.server_name

		this.UpdateTab()
		this.RefreshHeadIcon()
		this.SetAudioBtn()
		this.SetSoundBtn()
		this.SetNumSlider()

		this.UpdateGodSetting()
		this.UpdateHorseSetting()
		this.UpdateTaskSetting()

		this.UpdateBaseSettingPanelHeight()

		this.SetSimpleBtnState()
	}

	public UpdateTab() {
		this._box_base_setting.visible = this.cur_tab_type == SettingView.TabType.Setting
		this._box_shield_setting.visible = this.cur_tab_type == SettingView.TabType.Shield

		this.SetBtnStyle(this.cur_tab_type == SettingView.TabType.Setting, this._box_tab_base_setting)
		this.SetBtnStyle(this.cur_tab_type == SettingView.TabType.Shield, this._box_tab_shield_setting)
		if (this.cur_tab_type == SettingView.TabType.Shield) {
			this.SetBlockCheck(this.sys_setting_data)
		} else {
			this.UpdateAutoPickBlockCheck(this.sys_setting_data)
		}
	}

	public SetBtnStyle(select, box: Laya.Box) {
		let img = box.getChildAt(0) as Laya.Image
		let lable = box.getChildAt(1) as Laya.Label

		if (select) {
			img.y = 57
			img.scaleY = -1
			img.width = 150
			img.height = 57
			ResManager.GetInstance().SetImageSprite(this, img, "setting_asset", "ui_button_rect5")
			lable.color = "#9b572f"
		}
		else {
			img.y = 9
			img.scaleY = 1
			img.width = 152
			img.height = 52
			ResManager.GetInstance().SetImageSprite(this, img, "setting_asset", "ui_button_mid_1")
			lable.color = "#ffffff"
		}

	}

	public RefreshHeadIcon() {
		if (!this.role_head) {
			this.role_head = new CustomHeadItem(this._role_head)
			this.role_head.SetActiveLevel(false)
			this.role_head.Load()
		}
		let role_info = RoleManager.GetInstance().GetMainRoleVo()
		this.role_head.SetRoleVoData(role_info)
	}

	public SetAudioBtn() {
		// let audio_open = this.model.GetBlockProperty(SettingModel.SettingType.SysSetting, "sound_open")
		// this.disable_btn_bg.visible = audio_open == 0 
		// this.btn_bg.visible = audio_open != 0 
		// this.close_style.visible = audio_open == 0 
		// this.open_style.visible = audio_open != 0 
	}

	public SetSoundBtn() {
		//let sound_open = this.model.GetBlockProperty(SettingModel.SettingType.SysSetting, "sound_effect_open")
		//this.disable_sound_btn_bg.visible = sound_open == 0 
		//this.sound_btn_bg.visible = sound_open != 0 
		//this.sound_btn_close_style.visible = sound_open == 0 
		//this.sound_btn_open_style.visible = sound_open != 0 
	}

	public UpdateAutoPickBlockCheck(setting_list?) {
		if (setting_list) {
			let list = []
			if (this.config_setting) {
				for (let key in setting_list) {

					let vo = setting_list[key]
					if (vo.subtype >= 17 && vo.subtype < 20) {
						// 容错，客户端表查不到， 不显示
						if (this.config_setting[vo.type + "@" + vo.subtype]) {
							table.insert(list, vo)
						}
					}
				}
			}

			for (let _ = 0; _ < list.length; _++) {
				let data = list[_]
				data.cfg = this.config_setting[data.type + "@" + data.subtype]
			}
			if (!this.auto_pick_loop_mgr) {
				this.auto_pick_loop_mgr = new LoopScrowViewMgr()
				this.auto_pick_loop_mgr.SetData(this._list_pick, SettingShieldItem, list, LoopScrCon.Vertical, 2)
			} else {
				this.auto_pick_loop_mgr.replaceAll(list)
			}
		}
	}

	public SetBlockCheck(setting_list?) {
		if (setting_list) {
			let list = []
			for (let key in setting_list) {
				var vo = setting_list[key]
				if (IsInTable(vo.subtype, SettingView.ShowInShieldDic)) {

					//微信推送只在微信端显示
					if (vo.subtype == SettingModel.BlockSubType.wx_board) {
						if (!Util.IsWXGame()) {
							continue
						}
					}


					// 容错，配置表查不到， 不显示
					if (this.config_setting[vo.type + "@" + vo.subtype]) {
						table.insert(list, vo)
					}
				}
			}
			for (let data of list) {
				data.cfg = this.config_setting[data.type + "@" + data.subtype]
			}
			if (!this.shield_loop_mgr) {
				this.shield_loop_mgr = new LoopScrowViewMgr()
				this.shield_loop_mgr.SetData(this._list_shield, SettingShieldItem, list, LoopScrCon.Vertical, 2)
			} else {
				this.shield_loop_mgr.replaceAll(list)
			}
		}
	}

	public LoadSliderAndSetData(slider?, parent?, now_value?, max_value?, change_value_func?) {
		if (!slider) {
			slider = new WithBtnHSlider(parent)
			slider.SetData(now_value, 1, 0, max_value, false, change_value_func)
			slider.HideNumBtnAndNumBg()
			slider.SetCustomWidth(225)
			slider.Load()
			// slider.SetCustomHeight(32)
		} else {
			slider.SetData(now_value, 1, 0, max_value, false, change_value_func)
		}
		return slider
	}

	public SetNumSlider() {
		let max1 = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig.SameScreenMaxLimitRoleNum
		let max2 = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig.SameScreenMaxLimitRoleNum
		let max_sound = 100
		let max_music = 100

		let now_value1 = this.model.GetBlockProperty(SettingModel.SettingType.SysSetting, "same_screen_role_num")
		let now_value2 = this.model.GetBlockProperty(SettingModel.SettingType.SysSetting, "effect_num")
		let sound_value = this.model.GetBlockProperty(SettingModel.SettingType.SysSetting, "sound_open")
		let music_value = this.model.GetBlockProperty(SettingModel.SettingType.SysSetting, "sound_effect_open")

		if (!this.same_screen_value_change) {
			this.same_screen_value_change = (value?) => {
				this._screen_value.text = Math.floor(value).toString()
				SettingModel.GetInstance().other_role_number = Math.floor(value)
				// SceneObj.ModelHideFlag.RoleNumLimit
			}
		}

		if (!this.effect_num_value_change) {
			this.effect_num_value_change = (value?) => {
				this._effect_value.text = Math.floor(value).toString()
				SettingModel.GetInstance().effect_num = Math.floor(value)
			}
		}

		if (!this.sound_value_change) {
			this.sound_value_change = (value?) => {
				this._sound_value.text = Math.floor(value).toString()
				SoundManager.GetInstance().ChangeVolumeEffect(value / 100)
			}
		}

		if (!this.music_value_change) {
			this.music_value_change = (value?) => {
				this._music_value.text = Math.floor(value).toString()
				SoundManager.GetInstance().ChangeVolume(value / 100)
			}
		}
		this.slider1 = this.LoadSliderAndSetData(this.slider1, this.slider_conta1, now_value1, max1, this.same_screen_value_change)
		this.slider2 = this.LoadSliderAndSetData(this.slider2, this.slider_conta2, now_value2, max2, this.effect_num_value_change)
		this.slider_sound = this.LoadSliderAndSetData(this.slider_sound, this.slider_audio, sound_value, max_sound, this.sound_value_change)
		this.slider_music_audio = this.LoadSliderAndSetData(this.slider_music_audio, this.slider_music, music_value, max_music, this.music_value_change)

		// let is_simple_mode = this.model.GetBlockProperty(SettingModel.SettingType.SysSetting, "simple_mode")
		// this.slider_mask1.visible = is_simple_mode == 1
		// this.slider_mask2.visible = is_simple_mode == 1
	}

	public SetSliderValue(slider?, cfg?, pick_list?, pick_key?) {
		if (slider) {
			let num = slider.GetValue()
			if (num != null) {
				table.insert(pick_list, this.model.Package10203ItemData(cfg[pick_key], num))
			}
		}
	}

	public SendSetSliderNum() {
		let setting_list = []
		let cfg = this.preload_client_config["ClientBlockConfig"].BlockSubType
		this.SetSliderValue(this.slider1, cfg, setting_list, "same_screen_role_num")
		this.SetSliderValue(this.slider2, cfg, setting_list, "effect_num")
		this.SetSliderValue(this.slider_sound, cfg, setting_list, "sound_open")
		this.SetSliderValue(this.slider_music_audio, cfg, setting_list, "sound_effect_open")

		if (setting_list.length > 0) {
			this.model.PackageAndSend10203(setting_list)
		}
	}

	public SetSimpleBtnState() {
		/*
		let is_simple_mode = this.model.GetBlockProperty(SettingModel.SettingType.SysSetting, "simple_mode")
		if (is_simple_mode == 1 ) {
		//this.simple_mode_label.textFlow = local_Util.StrToHTML("<font color=0xcc7652>恢复默认设置</font>")
		this.simple_mode_label.text = "恢复默认设置"
		ResManager.GetInstance().SetImageSprite(this, this.simple_mode_bg, "common_asset", "com_rect_btn5")
		//this.simple_mode_label.strokeColor = "#cc7652"
		}else{
		//this.simple_mode_label.textFlow = local_Util.StrToHTML("<font color=0x2f999f>开启极简模式</font>")
		this.simple_mode_label.text = "开启极简模式"
		ResManager.GetInstance().SetImageSprite(this, this.simple_mode_bg, "common_asset", "com_rect_btn11")
		//this.simple_mode_label.strokeColor = "#2f999f"
		}*///
	}

	public SendProtocal(subtype?, is_open?) {
		if (this.sys_setting_data) {
			let setting_list = []
			table.insert(setting_list, this.model.Package10203ItemData(subtype, is_open, SettingModel.SettingType.SysSetting))
			this.model.PackageAndSend10203(setting_list)
		}
	}

	/*
	设置里头将极简模式改成默认
	*/
	public SimpleModeFun() {
		let cfg = this.preload_client_config["ClientBlockConfig"]
		//let is_simple_mode = this.model.GetBlockProperty(SettingModel.SettingType.SysSetting, "simple_mode")
		//let setting_list = []
		//if (is_simple_mode == 0 ) {
		//	let value = null
		//	for (let key in cfg.SimpleMode) {

		//		value = cfg.SimpleMode[key]
		//		table.insert(setting_list, this.model.Package10203ItemData(cfg.BlockSubType[key], value))
		//	}
		//	table.insert(setting_list, this.model.Package10203ItemData(cfg.BlockSubType["simple_mode"], 1))
		//}else{
		//	table.insert(setting_list, this.model.Package10203ItemData(cfg.BlockSubType["simple_mode"], 0))
		let value = null
		let setting_list = []
		if (Laya.Browser.onIOS) {
			for (let key in cfg.DefaultModeIOS) {

				value = cfg.DefaultModeIOS[key]
				table.insert(setting_list, this.model.Package10203ItemData(cfg.BlockSubType[key], value))
			}
		} else {
			for (let key in cfg.DefaultMode) {

				value = cfg.DefaultMode[key]
				table.insert(setting_list, this.model.Package10203ItemData(cfg.BlockSubType[key], value))
			}
		}
		//}
		if (setting_list.length > 0) {
			this.model.PackageAndSend10203(setting_list)
		}
	}

	_img_bg: Laya.Image
	_box_top: Laya.Box
	_Group1: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_lb_title_name: Laya.Label
	_role_head: Laya.Box
	_Group2: Laya.Box
	_lb_name: Laya.Label
	_ID: Laya.Label
	_label2: Laya.Label
	_label3: Laya.Label
	id_number1: Laya.Label
	change_head_btn: Laya.Box
	_Image4: Laya.Image
	_Label1: Laya.Label
	_btn_copy: Laya.Box
	_Image6: Laya.Image
	_Label41: Laya.Label
	id_number: Laya.Label
	id_ser_name: Laya.Label
	_btn_changename: Laya.Image
	_box_bottom: Laya.HBox
	change_role: Laya.Box
	_Image15: Laya.Image
	_Label8: Laya.Label
	return_login: Laya.Box
	_Image16: Laya.Image
	_Label9: Laya.Label
	simple_mode_btn: Laya.Box
	simple_mode_bg: Laya.Image
	simple_mode_label: Laya.Label
	confirm_flee: Laya.Box
	_Image14: Laya.Image
	_Label7: Laya.Label
	confirm_res: Laya.Box
	_Image141: Laya.Image
	_img_line: Laya.Image
	_img_line2: Laya.Image
	_box_base_setting: Laya.Panel
	_box_slider: Laya.Box
	_con_screen: Laya.Box
	group_screen: Laya.HBox
	_Label511: Laya.Label
	_screen_value: Laya.Label
	slider_conta1: Laya.Box
	_Group7: Laya.Box
	slider_mask1: Laya.Box
	_con_effect: Laya.Box
	group_effect: Laya.HBox
	_Label6: Laya.Label
	_effect_value: Laya.Label
	slider_conta2: Laya.Box
	_Group811: Laya.Box
	slider_mask211: Laya.Box
	_con_music: Laya.Box
	group_music: Laya.HBox
	_Label61: Laya.Label
	_music_value: Laya.Label
	slider_music: Laya.Box
	_Group81: Laya.Box
	slider_mask21: Laya.Box
	_con_audio: Laya.Box
	gourp_audio: Laya.HBox
	_Label611: Laya.Label
	_sound_value: Laya.Label
	slider_audio: Laya.Box
	_Group8: Laya.Box
	slider_mask2: Laya.Box
	_box_pick: Laya.Box
	_list_pick: Laya.List
	_box_horse: Laya.Box
	_img_horse_check: Laya.Image
	_box_god: Laya.Box
	_img_god_check: Laya.Image
	_box_task: Laya.Box
	_img_task_check1: Laya.Image
	_img_task_check2: Laya.Image
	_box_shield_setting: Laya.Box
	_box_shield: Laya.Box
	_list_shield: Laya.List
	_box_tab: Laya.Box
	_box_tab_base_setting: Laya.Box
	_img_tab_setting: Laya.Image
	_lb_tab_setting: Laya.Label
	_box_tab_shield_setting: Laya.Box
	_img_tab_shield: Laya.Image
	_lb_tab_shield: Laya.Label
	_img_empty: Laya.Image
	_img_close: Laya.Image
	block_user: Laya.Box
	_lb_agree: Laya.Label
	_lb_privacy: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._box_top,
			this._Group1,
			this._Image1,
			this._Image2,
			this._Image3,
			this._lb_title_name,
			this._role_head,
			this._Group2,
			this._lb_name,
			this._ID,
			this._label2,
			this._label3,
			this.id_number1,
			this.change_head_btn,
			this._Image4,
			this._Label1,
			this._btn_copy,
			this._Image6,
			this._Label41,
			this.id_number,
			this.id_ser_name,
			this._btn_changename,
			this._box_bottom,
			this.change_role,
			this._Image15,
			this._Label8,
			this.return_login,
			this._Image16,
			this._Label9,
			this.simple_mode_btn,
			this.simple_mode_bg,
			this.simple_mode_label,
			this.confirm_flee,
			this._Image14,
			this._Label7,
			this.confirm_res,
			this._Image141,
			this._img_line,
			this._img_line2,
			this._box_base_setting,
			this._box_slider,
			this._con_screen,
			this.group_screen,
			this._Label511,
			this._screen_value,
			this.slider_conta1,
			this._Group7,
			this.slider_mask1,
			this._con_effect,
			this.group_effect,
			this._Label6,
			this._effect_value,
			this.slider_conta2,
			this._Group811,
			this.slider_mask211,
			this._con_music,
			this.group_music,
			this._Label61,
			this._music_value,
			this.slider_music,
			this._Group81,
			this.slider_mask21,
			this._con_audio,
			this.gourp_audio,
			this._Label611,
			this._sound_value,
			this.slider_audio,
			this._Group8,
			this.slider_mask2,
			this._box_pick,
			this._list_pick,
			this._box_horse,
			this._img_horse_check,
			this._box_god,
			this._img_god_check,
			this._box_task,
			this._img_task_check1,
			this._img_task_check2,
			this._box_shield_setting,
			this._box_shield,
			this._list_shield,
			this._box_tab,
			this._box_tab_base_setting,
			this._img_tab_setting,
			this._lb_tab_setting,
			this._box_tab_shield_setting,
			this._img_tab_shield,
			this._lb_tab_shield,
			this._img_empty,
			this._img_close,
			this.block_user,
			this._lb_agree,
			this._lb_privacy
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_box_top",
				"_Group1",
				"_Image1",
				"_Image2",
				"_Image3",
				"_lb_title_name",
				"_role_head",
				"_Group2",
				"_lb_name",
				"_ID",
				"_label2",
				"_label3",
				"id_number1",
				"change_head_btn",
				"_Image4",
				"_Label1",
				"_btn_copy",
				"_Image6",
				"_Label41",
				"id_number",
				"id_ser_name",
				"_btn_changename",
				"_box_bottom",
				"change_role",
				"_Image15",
				"_Label8",
				"return_login",
				"_Image16",
				"_Label9",
				"simple_mode_btn",
				"simple_mode_bg",
				"simple_mode_label",
				"confirm_flee",
				"_Image14",
				"_Label7",
				"confirm_res",
				"_Image141",
				"_img_line",
				"_img_line2",
				"_box_base_setting",
				"_box_slider",
				"_con_screen",
				"group_screen",
				"_Label511",
				"_screen_value",
				"slider_conta1",
				"_Group7",
				"slider_mask1",
				"_con_effect",
				"group_effect",
				"_Label6",
				"_effect_value",
				"slider_conta2",
				"_Group811",
				"slider_mask211",
				"_con_music",
				"group_music",
				"_Label61",
				"_music_value",
				"slider_music",
				"_Group81",
				"slider_mask21",
				"_con_audio",
				"gourp_audio",
				"_Label611",
				"_sound_value",
				"slider_audio",
				"_Group8",
				"slider_mask2",
				"_box_pick",
				"_list_pick",
				"_box_horse",
				"_img_horse_check",
				"_box_god",
				"_img_god_check",
				"_box_task",
				"_img_task_check1",
				"_img_task_check2",
				"_box_shield_setting",
				"_box_shield",
				"_list_shield",
				"_box_tab",
				"_box_tab_base_setting",
				"_img_tab_setting",
				"_lb_tab_setting",
				"_box_tab_shield_setting",
				"_img_tab_shield",
				"_lb_tab_shield",
				"_img_empty",
				"_img_close",
				"block_user",
				"_lb_agree",
				"_lb_privacy"
			])
	}
}
window["SettingView"] = SettingView