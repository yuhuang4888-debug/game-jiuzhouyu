import { AppConst } from "../common/AppConst"
import { BaseClass } from "../common/BaseClass"
import { SoundManager } from "../common/SoundManager"
import { ChatModel } from "../commonModel/ChatModel"
import { Message } from "../sysInfo/SysInfoController"
import { Status } from "../util/Status"
import { GlobalTimerQuest } from "../util/Util"
import { ChatVoiceManager } from "./ChatVoiceManager"

export class VoiceVo extends BaseClass {
abort_play
is_loading
last_play_start_time
voice_clip
voice_data
voice_id
	voice_path: any

public constructor(){
super() 
	
}

public __defineVar(){ 
	
	return {
		voice_id :0,
		voice_path: null,
		voice_data : null,
		voice_clip : null,
		is_loading : null,
		abort_play : null,
		last_play_start_time : null,
	}
}

public IsPlaying(){ 
	
	if (! this.last_play_start_time ) { return false }
	let leftTime = this.voice_clip.length - Status.NowTime + this.last_play_start_time
	if (leftTime <= 0 ) {
		return false
	}else{
		return leftTime
	}
}

public Play(){ 
	
	// if (ApplicationPlatform == RuntimePlatform.WindowsEditor || ApplicationPlatform == RuntimePlatform.WindowsPlayer ) {
	// 	return
	// }
	if (this.is_loading ) { return }
	if (this.voice_clip && this.voice_clip.length != 0 ) {
		this.last_play_start_time = Status.NowTime
		ChatVoiceManager.GetInstance().PlayAudioClip(this.voice_id, this.voice_clip)
	} else if (this.voice_data && (! this.voice_clip || this.voice_clip.length != 0) ) {
		let version = ChatVoiceManager.GetInstance().GetVoiceVersion(this.voice_id)
		console.log("CreateAudioClip", this.voice_data, version, typeof(version))
		// lua_soundM.CreateAudioClip(this.voice_data, ChatVoiceManager.GetInstance().GetVoiceVersion(this.voice_id),(ac?) => {
		// 	if (this.abort_play ) {
		// 		this.abort_play = null
		// 		return
		// 	}
		// 	if (this.use_delete_method ) {
		// 		return
		// 	}
		// 	if (ac && ac != -1 ) {
		// 		this.voice_clip = ac
		// 		this.Play()
		// 	}else{
		// 		console.log("Generate audioclip by data failed!!!")
		// 	}
		// })
		if (this.voice_clip && ! this.use_delete_method ) {
			this.Play()
		}
	} else if (this.voice_path ) {
		let mp3Path
		// if (AppConst.DebugMode && ! Application.isMobilePlatform ) {
		// 	mp3Path = this.voice_path
		// }else{
		// 	mp3Path = string.gsub(this.voice_path, ".wav", ".mp3")
		// 	SDKUtil.CallSDKFunc("ChatSpeaker", "Convert", {wavPath = this.voice_path, mp3Path = mp3Path})
		// }
		this.is_loading = true
		this.StartLoadingChecker()
		var onLoadVoiceCallback =(ac)=> {
			this.StopLoadingChecker()
			this.is_loading = null
			if (this.abort_play ) {
				this.abort_play = null
				return
			}
			if (this.use_delete_method ) {
				return
			}
			if (ac && ac != -1 ) {
				if (ac.length >= 1 ) {
					this.voice_clip = ac
					// this.voice_data = data
					this.Play()
				}else{
					this.voice_clip = null
					this.voice_data = null
					Message.show("录音时间太短了！")
				}
			}else{
				console.log("load audioclip failed!!")
			}
		}
		// lua_soundM.LoadVoice(mp3Path, onLoadVoiceCallback)
	} else if (this.voice_clip && this.voice_clip.length == 0 ) {
		ChatVoiceManager.GetInstance().PlayAudioClip(this.voice_id, this.voice_clip)
	}else{
		console.log("//////////////-VoiceVo play error//////////////")
	}
}

public SetVoiceData(voice_id?, voice_data?){ 
	
	this.voice_id = voice_id
	this.voice_data = voice_data
}

public GetVoiceData(callback?){ 
	
	if (this.is_loading ) { return }
	if (this.voice_path ) {
		let mp3Path
		// if (AppConst.DebugMode && ! Application.isMobilePlatform ) {
		// 	mp3Path = this.voice_path
		// }else{
		// 	mp3Path = string.gsub(this.voice_path, ".wav", ".mp3")
		// 	SDKUtil.CallSDKFunc("ChatSpeaker", "Convert", {wavPath = this.voice_path, mp3Path = mp3Path})
		// 	console.log("mp3Path, wavPath", mp3Path, this.voice_path)
		// }
		this.is_loading = true
		this.StartLoadingChecker()
		var onLoadVoiceCallback =(ac, data)=> {
			console.log("onLoadVoiceCallback", ac, data)
			let cModel = ChatModel.GetInstance()
			this.StopLoadingChecker()
			cModel.loading_voice = null
			this.is_loading = null
			if (this.use_delete_method ) {
				return
			}
			console.log("test111", this.use_delete_method, callback)
			if (ac && ac != -1 ) {
				if (ac.length >= 1 ) {
					this.voice_clip = ac
					this.voice_data = data
					if (callback ) {
						callback(this.voice_data, this.voice_clip.length)
						if (cModel.end_speech_data && cModel.end_speech_data != "" ) {
							Message.show(cModel.end_speech_data)
						}
					}
				}else{
					this.voice_clip = null
					this.voice_data = null
					Message.show("录音时间太短了！")
				}
			}else{
				console.log("没有听到录音哦！")
				Message.show("没有听到录音哦！")
			}
			cModel.end_speech_data = null
		}
		// lua_soundM.LoadVoice(mp3Path, onLoadVoiceCallback)
	}else{
		console.log("Can't ! load data from a null voice path!!")
	}
}

public StartLoadingChecker(){ 
	
	this.StopLoadingChecker()
	ChatModel.GetInstance().timer_loading = GlobalTimerQuest.AddPeriodQuest(() => {
		ChatModel.GetInstance().loading_voice = null
		this.abort_play = null
		console.log("Generate voice data overtime!!")
	}, 3, 1)
}

public StopLoadingChecker(){ 
	
	if (ChatModel.GetInstance().timer_loading ) {
		GlobalTimerQuest.CancelQuest(ChatModel.GetInstance().timer_loading)
	}
}

public Stop(){ 
	
	if (this.is_loading ) {
		this.abort_play = true
	}else{
		ChatVoiceManager.GetInstance().StopAudioClip(this.voice_id, this.voice_clip)
	}
}

public CheckCanDelete(){ 
	
	if (this.last_play_start_time && Status.NowTime - this.last_play_start_time > 10 ) {
		return true
	}
	return false
}

public DeleteMe(){ 
	
	this.Stop()
	// SoundManager.StopVoice(this.voice_id, this.voice_clip)
	this.voice_data = null
	this.voice_clip = null
	super.DeleteMe()
}

}
window["VoiceVo"] = VoiceVo