import { AppConst } from "../common/AppConst"
import { BaseView1, CloseMode } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ChatModel, ChatModelEvent } from "../commonModel/ChatModel"
import { FriendModel } from "../commonModel/FriendModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GlobalTimerQuest } from "../util/Util"
import { ChatVoiceManager } from "./ChatVoiceManager"

export class VoiceChatView extends BaseView1 {
	background_alpha
	chat_model
	click_bg_toClose
	close_callback
	close_mode
	data
	delay_time_id
	destroy_callback
	destroy_imm
	image_img_extend
	model
	open_callback
	record_state
	time_count
	timer
	use_background


	RECORD_STATE = {
		NONE: 0,
		RECORD: 1,
		CANCLE: 2,
	}
	public constructor() {
		super()

		this.base_file = "chat"
		this.layout_file = "VoiceChatView"
		this.layer_value = Enum_UILayer.UI
		this.close_mode = CloseMode.CloseDestroy
		this.destroy_imm = false
		this.click_bg_toClose = false
		this.use_background = false
		this.background_alpha = 0
		this.model = FriendModel.GetInstance()
		this.record_state = 0 // 0为没有录音（未到长按0.5秒之前都是这个状态） 1提示正在录音 2提示松手取消录音
		this.chat_model = ChatModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {

		}

		this.close_callback = () => {
			this.onClose()
		}
		this.destroy_callback = () => {
			this.Remove()
			this.ClearTimer()
		}
	}

	public InitEvent() {

		this.BindEvent(GlobalEventSystem, ChatModelEvent.CHANGE_RECORD_STATE, (state?) => {
			if (this.RECORD_STATE.NONE == state) {
				this.ChangeRecordState(this.RECORD_STATE.CANCLE)
				this.Close()
			}
		})
	}

	public Remove() {


	}

	public LoadSuccess() {

		// this.image_img_extend = this.form.Find("image").GetComponent("ImageExtend")
		this.image_img_extend = this.image
		this.UpdateView()
	}

	public UpdateView() {

		if (!this.is_loaded) {
			return
		}

		this.text.text = "手指上滑 取消发送"
		var SetText = (num) => {
			if (this.timeText) {
				this.timeText.text = num
			}
		}
		this.time_count = 10
		SetText(this.time_count)

		var timer_func = () => {
			this.time_count = this.time_count - 1
			console.log(this.time_count)
			if (this.time_count == 0) {
				this.Close()
			}
			SetText(this.time_count)
		}
		this.timer = GlobalTimerQuest.AddPeriodQuest(timer_func, 1, -1)

		//长按0.5秒才能语音
		this.delay_time_id = GlobalTimerQuest.AddDelayQuest(() => {
			this.ChangeRecordState(this.RECORD_STATE.RECORD)
			this.chat_model.sendAlready = null
			this.chat_model.reg_channel = this.data.channel
			this.chat_model.voice_id, this.chat_model.voice_path = ChatVoiceManager.GetInstance().GenerateVoicePath()
			//console.log("录音文件", this.model.voice_id, this.model.voice_path, AppConst.EnglineVer, recordManager)
			// lua_soundM.AddMuteQuest(this)
			// if (AppConst.EnglineVer >= 98 ) {
			// 	if (ApplicationPlatform == RuntimePlatform.Android ) {
			// 		this.chat_model.wait_record = [tc = this.data.channel, t = os.time()]
			// 		console.log("申请权限", this.chat_model, this.chat_model.wait_record)
			// 		SDKUtil.CallSDKFunc("SDKPlatform", "RequestAudioPermission", {})
			// 	}else{
			// 		recordManager.StartRecord(this.chat_model.voice_path)
			// 	}
			// }else{
			// 	SDKUtil.CallSDKFunc("ChatSpeaker", "StartRecord", {audioPath = this.chat_model.voice_path})
			// }
		}, 0.5)

		// if (this.data.pos) {
		// 	this.display_obj.x = this.data.pos.x
		// 	this.display_obj.y = this.data.pos.y
		// }

		//console.log("测试"+this.display_obj.x+":"+	this.display_obj.y )
	}

	public ClearTimer() {

		if (this.timer) {
			GlobalTimerQuest.CancelQuest(this.timer)
			this.timer = null
		}
		if (this.delay_time_id) {
			GlobalTimerQuest.CancelQuest(this.delay_time_id)
			this.delay_time_id = null
		}
	}

	public ChangeRecordState(state?) {

		this.record_state = state
		if (this) {
			if (this.RECORD_STATE.CANCLE == this.record_state) {
				this.text.text = "手指松开 取消发送"
				this.image_img_extend.alpha = 0.5
			} else if (this.RECORD_STATE.RECORD == this.record_state) {
				this.text.text = "手指上滑 取消发送"
				this.image_img_extend.alpha = 1.0
			}
		}
	}

	public onClose() {

		if (this.record_state == this.RECORD_STATE.RECORD) {
			// this.SendVoice()
			// if (AppConst.EnglineVer < 98 ) {
			// 	SDKUtil.CallSDKFunc("ChatSpeaker", "StopRecord")
			// }else{
			// 	recordManager.StopRecord()
			// }
			// lua_soundM.CancelMuteQuest(this)
			// if (SettingModel.GetInstance().GetBlockProperty(SettingModel.SettingType.SysSetting, "sound_open") != 0 ) {
			// 	lua_soundM.CancelMuteQuest(this)
			// }
			// if (AppConst.DebugMode ) {
			// 	GlobalEventSystem.Fire(ChatModelEvent.ON_END_OF_SPEECH)
			// 	GlobalEventSystem.Fire(ChatModelEvent.ON_RESULT_OF_SPEECH, "测试测试")
			// }
		} else if (this.record_state == this.RECORD_STATE.CANCLE) {
			// if (AppConst.EnglineVer < 98 ) {
			// 	SDKUtil.CallSDKFunc("ChatSpeaker", "CancelRecord")
			// }else{
			// 	recordManager.CancelRecord()
			// }
			// lua_soundM.CancelMuteQuest(this)
		}

		this.ChangeRecordState(this.RECORD_STATE.NONE)
		this.ClearTimer()
	}

	public OnDrage(move_dis?) {

		// console.log(move_dis)
		// if (move_dis > 2000 ) {
		if (move_dis > 100) {
			this.ChangeRecordState(this.RECORD_STATE.CANCLE)
			// this.Close()
		} else {
			if (this.RECORD_STATE.NONE != this.record_state) {
				this.ChangeRecordState(this.RECORD_STATE.RECORD)
			}
		}
	}

	public Open(data?) {

		this.data = data
		this.UpdateView()
		super.Open()
	}
	image: Laya.Image
	timeText: Laya.Label
	text: Laya.Label
	public GetComponents() {
		[
			this.image,
			this.timeText,
			this.text,
		]
			= this.GetChildrenByNames([

				"image",
				"timeText",
				"text",
			])
	}
}
window["VoiceChatView"] = VoiceChatView