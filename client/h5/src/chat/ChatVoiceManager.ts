import { AppConst } from "../common/AppConst"
import { SoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { ChatModel, ChatModelEvent } from "../commonModel/ChatModel"
import { RoleManager } from "../commonModel/RoleManager"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"
import { VoiceVo } from "./VoiceVo"

export class ChatVoiceManager extends EventDispatcher {
click_voice_list
playing_voice_id
timer_play
voice_list
voice_queue
voice_ver_dic
static Instance

public constructor(){
super() 
	
	ChatVoiceManager.Instance = this
	this.voice_list = []
	this.click_voice_list = []
	this.voice_ver_dic = []
	this.voice_queue = []
	
	var onCheckToDelete =()=> {
		let delete_list = []
		for (let id in this.voice_list) {
			var vo = this.voice_list[id]
			if (vo.CheckCanDelete() ) {
				table.insert(delete_list, id)
			}
		}		

		for (let i = 0; i < delete_list.length; i++) {
			var id = delete_list[i]
			this.DeleteVoice(id)
		}
	}
	GlobalTimerQuest.AddPeriodQuest(onCheckToDelete, 30, -1)
}

public ClickPlay(voice_id?){ 
	
	this.click_voice_list[voice_id] = true
}

public PushPlay(voice_id?){ 
	
	if (this.click_voice_list[voice_id] ) {
		this.click_voice_list[voice_id] = null
		this.PlayVoice(voice_id)
		for (let i = 0; i < this.voice_queue.length; i++) {
			var v = this.voice_queue[i]
			if (v == voice_id ) {
				table.remove(this.voice_queue, i)
				break
			}
		}
	}else{
		if (this.playing_voice_id ) {
			table.insert(this.voice_queue, voice_id)
		}else{
			this.PlayVoice(voice_id)
		}
		// Math.randomseed(os.time())
		// let delayTime = Math.random(0, 100) * 0.005
		// let timer_delay = GlobalTimerQuest.AddPeriodQuest(() => {
		// 	this.PlayVoice(voice_id)
		// 	this.timer_list[voice_id] = null
		// }, delayTime, 1)
		// this.timer_list[voice_id] = timer_delay
	}
}

public PopPlay(){ 
	
	let popId
	if (this.voice_queue.length > 0 ) {
		popId = this.voice_queue[1]
		table.remove(this.voice_queue, 1)
		this.PlayVoice(popId)
	}else{
		// lua_soundM.CancelMuteQuest(this)
	}
}

public Reset(){ 
	
	for (let k in this.voice_list) {
		var v = this.voice_list[k]
		this.DeleteVoice(k)
	}
	this.voice_list = []
	this.voice_ver_dic = []
	if (this.timer_play ) {
		GlobalTimerQuest.CancelQuest(this.timer_play)
		this.timer_play = null
	}
	if (this.playing_voice_id ) {
		this.StopVoice(this.playing_voice_id)
		this.playing_voice_id = null
	}
	this.voice_queue = []
}

public static GetInstance(){ 
	
	if (ChatVoiceManager.Instance==null ) {
		 new ChatVoiceManager()
	}
	return ChatVoiceManager.Instance
} 

//生成语音id，角色id + 时间合成
public GenerateVoiceID(){ 
	
	let time = String(TimeUtil.timeHMS(TimeUtil.getClientTime()))
	time = time.substring(time.length - 9, time.length-1)
	return Number(RoleManager.Instance.mainRoleInfo.role_id + time)
}

//生成语音路径
public GenerateVoicePath(){ 
	
	let voice_id = this.GenerateVoiceID()
	// local 
	let path
	// if (AppConst.DebugMode ) {
	// 	path =  AppConst.CachedVoicePath + "/testAudio.wav"
	// }else{
	// 	path =  AppConst.CachedVoicePath + "/" + voice_id + ".wav"
	// }
	console.log("GenerateVoicePath", path)

	
	return [voice_id, path]
}

public SetVoiceVersion(voice_id?,data_ver?){ 
	
	this.voice_ver_dic[voice_id] = data_ver
}

public GetVoiceVersion(voice_id?){ 
	
	//27为支持语音功能版本,数据未压缩
	return this.voice_ver_dic[voice_id] || 27
}

public GetVoice(voice_id?){ 
	
	return this.voice_list[voice_id]
}

public DeleteVoice(voice_id?){ 
	
	let voice_vo = this.voice_list[voice_id]
	if (voice_vo ) {
		voice_vo.DeleteMe()
		this.voice_list[voice_id] = null
	}
}

//主角录音后主动调用
public AddMainRoleVoicePath(voice_id?, voice_path?){ 
	
	//let voice_id = this.GenerateVoiceID()
	let voice_vo = this.GetVoice(voice_id)
	if (voice_vo == null ) {
		voice_vo =  new VoiceVo()
		this.voice_list[voice_id] = voice_vo
		voice_vo.voice_id = voice_id
		voice_vo.voice_path = voice_path
	}
	return voice_id
}

//加载主角录音
public LoadMainRoleVoiceData(voice_id?, callback?){ 
	
	let voice_vo = this.GetVoice(voice_id)
	console.log("LoadMainRoleVoiceData", voice_id, voice_vo)
	if (voice_vo ) {
		voice_vo.GetVoiceData(callback)
	}
}

//请求服务器返回 其他玩家的语音二进制数据
public AddVoiceData(voice_id?, voice_data?){ 
	
	let voice_vo = this.GetVoice(voice_id)
	if (voice_vo == null ) {
		voice_vo =  new VoiceVo()
		this.voice_list[voice_id] = voice_vo
		voice_vo.SetVoiceData(voice_id, voice_data)
	}
}

public PlayVoice(voice_id?){ 
	
	if (this.playing_voice_id == voice_id ) { return }
	this.StopVoice(this.playing_voice_id)
	let voice_vo = this.GetVoice(voice_id)
	this.playing_voice_id = voice_id
	if (voice_vo ) {
		voice_vo.Play()
	}else{
		console.log("//////////////-ChatVoiceManager has no this voice record to play//////////////")
	}
}

public StopVoice(voice_id?){ 
	
	let voiceVo = this.GetVoice(voice_id)
	if (voiceVo ) {
		if (voice_id == this.playing_voice_id ) {
			this.playing_voice_id = null
			if (this.timer_play ) {
				GlobalTimerQuest.CancelQuest(this.timer_play)
				this.timer_play = null
			}
			if (voiceVo.IsPlaying() ) {
				this.StopAudioClip(voice_id, voiceVo.voice_clip)
			}
		}
	}
}

public PlayAudioClip(voice_id?, voice_clip?){ 
	
	ChatModel.GetInstance().Fire(ChatModelEvent.PLAY_VOICE, voice_id, voice_clip)
	// lua_soundM.AddMuteQuest(this)
	// let engineVer = Number(AppConst.EnglineVer)
	// if (engineVer >= 31 ) {
	// 	SoundManager.PlayVoice(voice_id, voice_clip, 1)
	// 	if (engineVer == 31 ) {
	// 		let trans = SoundManager.transform.Find("Voice_" + voice_id)
	// 		if (trans ) {
	// 			trans.GetComponent("AudioSource").mute = false
	// 		}
	// 	}
	// }else{
	// 	// SoundManager.PlayVoice(voice_id, voice_clip)
	// 	// let trans = SoundManager.transform.Find("Audio_" + voice_id)
	// 	// if (trans ) {
	// 	// 	trans.GetComponent("AudioSource").mute = false
	// 	// }
	// }
	this.timer_play = GlobalTimerQuest.AddPeriodQuest(() => {
		this.playing_voice_id = null
		this.timer_play = null
		this.PopPlay()
	}, voice_clip.length, 1)
}

public StopAudioClip(voice_id?, voice_clip?){ 
	
	ChatModel.GetInstance().Fire(ChatModelEvent.STOP_VOICE_PLAY, voice_id)
	// let trans = soundMgr.transform.Find("Voice_" + voice_id)
	// if (trans ) {
	// 	destroy(trans.gameObject)
	// }
}

}

window["ChatVoiceManager"] = ChatVoiceManager