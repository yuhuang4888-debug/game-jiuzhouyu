// console.warn("SoundManager@HashEventDispatcher")
import { HashEventDispatcher } from "./HashEventDispatcher";
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Util } from "../util/Util";
import { EventName } from "./EventName";
import { PlatformManager } from "../PlatformManager";
// TypeScript file
export class SoundManager extends HashEventDispatcher {
    static Instance: SoundManager;
    // sound_effect_sound_cache:Array<egret.Sound> = []
    //function
    PlaySceneSound;
    PauseSceneSound;
    ResoveSceneSound;
    SetVolume;
    PlaySoundEffect;
    StopSoundEffect;
    ClearAllSoundEffect;
    ChangeVolume;
    ChangeVolumeEffect;
    PlaySoundEffectDownOtherVoice;
    public constructor() {
        super();
        if(!Util.IsWXGame() && ClientConfig && ClientConfig.solveRepeatMusic)
        {
            Laya.SoundManager.useAudioMusic = true//解决app链接包会出现同时播放两次的bug
        }else
        {
            Laya.SoundManager.useAudioMusic = false
        }
        Laya.SoundManager.autoStopMusic = true
        Laya.SoundManager.autoReleaseSound = false
        let _curr_scene_sound_name: string = "", curr_scene_base_volume = 0.3, user_setting_scene_volume = 1

        GlobalEventSystem.Bind(EventName.WINDOW_RESUME, () =>
        {
            let curr_channel:Laya.SoundChannel = Laya.SoundManager["_musicChannel"]
            let replay_pos = 0
            if(curr_channel)
            {
                replay_pos = curr_channel.position
            }
            this.PlaySceneSound(null, replay_pos)
        })
        //播放场景音乐     
        this.PlaySceneSound = (sound_volume: number = null, play_pos: number = 0, sound_name:string = null): void => {
            let SceneManager = window["SceneManager"]
            let cfg = window["Config"].PRELOAD_CLIENT_CONFIG.ConfigSound
            if(cfg)
            {
                if(!sound_name)
                {
                    let scene_id = SceneManager.GetInstance().GetSceneId();
                    let scene_type = SceneManager.GetInstance().GetSceneType();
                    sound_name = cfg.Scene[scene_id] || cfg.DefaultSceneType[scene_type] || cfg.DefaultScene || "city"
                }
                if(sound_volume == null && sound_name)
                {
                    sound_volume = cfg.DefaultSceneTypeVolume[sound_name] || cfg.DefaultSceneVolume || 0.3
                }
            }
            sound_name = sound_name || _curr_scene_sound_name
            if(!sound_name) return
            _curr_scene_sound_name = sound_name
            sound_volume = sound_volume == null ? curr_scene_base_volume : sound_volume;
            curr_scene_base_volume = sound_volume
            play_pos = play_pos == null ? 0 : play_pos;
            this.ChangeVolume()
            let url 
            // if(Util.IsConch())
            // {
            //     // console.warn("---------原生包暂时屏蔽播放背景音乐-------------------")
            //     // return
            //     url = `resource/sound/scene/${sound_name}.wav`;
            // }else
            // {
                url = `resource/sound/scene/${sound_name}.mp3`;
            // }
            // if (url != _curr_scene_sound_url) {
                Laya.SoundManager.playMusic(url, 0, null, play_pos)
                // _curr_scene_sound_url = url;
            // }
        };
        //暂停背景音乐
        this.PauseSceneSound = () => {
            Laya.SoundManager.musicMuted = true
        };
        //恢复背景音乐
        this.ResoveSceneSound = () => {
            Laya.SoundManager.musicMuted = false
        };
        //设置背景音乐和音效
        this.SetVolume = (volume: number) => {
            this.ChangeVolume(volume)
            Laya.SoundManager.setSoundVolume(volume)
        };

        //设置背景音乐
        this.ChangeVolume = (value) =>{
            user_setting_scene_volume = value== undefined ? user_setting_scene_volume : value
            Laya.SoundManager.setMusicVolume(user_setting_scene_volume * curr_scene_base_volume)
        }
        //设置音效
        this.ChangeVolumeEffect = (value) =>{
            Laya.SoundManager.setSoundVolume(value)
            if(value == 0 ){
                Laya.SoundManager.soundMuted = true
            }else{
                Laya.SoundManager.soundMuted = false
            }
        }
        //播放音效
        this.PlaySoundEffect = (sound_name: string, use_cache = true, sound_volume = null, sound_type = "ui") => {
            if(PlatformManager.IsEyouThPlatform()){
                //@泰语暂时屏蔽
                if(sound_type=="role"||sound_type=="novice_voice"||sound_type=="npc")
                {
                    return
                }
            }
            if(sound_name)
            {
                let url
                if(Util.IsConch())
                {
                    // if(sound_name == "2_dianji")
                    // {

                        url = `resource/sound/${sound_type}/${sound_name}.wav`;
                    // }else

                    // {
                    //     console.warn("---------原生包暂时屏蔽播放音效-------------------")
                    //     return
                    // }
                }else
                {
                    url = `resource/sound/${sound_type}/${sound_name}.mp3`;
                }
                let playend
                if(Util.IsWXGame())
                {
                    playend = null
                }else
                {
                    playend = Laya.Handler.create(this, () =>
                    {
                        if(!use_cache)
                            Laya.SoundManager.destroySound(url)
                    })
                }
                let channel = Laya.SoundManager.playSound(url, 1, playend)
                if(channel && sound_volume != null)
                {
                    channel.volume = sound_volume
                }
                return channel
            }
        };
        //暂停音效
        this.StopSoundEffect = (channel: Laya.SoundChannel) => {
            if(channel)
            {
                channel.stop()
            }
        };
        //清除所有音效
        this.ClearAllSoundEffect = (is_change_scene?: boolean) => {
            Laya.SoundManager.stopAllSound()
        };
        /**播放需要在播放音效时降低其他所有音效的音量。并在播放完后恢复。并且在同类型（类型可用文件夹名作为类型区分）音效冲突的时候，停止上一条，播放下一条 */
        this.PlaySoundEffectDownOtherVoice = (sound_name: string, sound_file_name: string, down_voice: number, sound_volume: number = null, use_cache = false, is_sound_cj = false) => {
        //     let url;
        //     let cache_sound_effect_dic = _cache_sound_effect_dic; //缓存字典
        //     ++_sound_effect_id;
        //     let sound_effect_id = _sound_effect_id;
        //     let sound_type; //可用文件夹名作为声音类型的区分
        //     url = `resource/sound/${sound_file_name}/${sound_name}.mp3`;
        //     sound_type = sound_file_name;
        //     if (sound_volume == null) {
        //         sound_volume = _sound_volume;
        //     }
        //     let loadCompleted = (sound: egret.Sound) => {
        //         if (sound && _sound_effect_dic[sound_effect_id] == false) //处理加载过程中被stop掉的情况 就不再播放该音效
        //          {
        //             let onSoundComplete = () => {
        //                 if (is_sound_cj)
        //                     channel.stop();
        //                 this.SetVolume(_sound_volume);
        //                 delete _sound_effect_dic[sound_effect_id];
        //                 delete _sound_effect_type_dic[sound_file_name];
        //                 if (!use_cache && !is_sound_cj) {
        //                     sound.close();
        //                     _res_mgr.ReduceReferenceCount(_sound_effect_hashcode_target.hashCode, url);
        //                 }
        //             };
        //             //如果两个音效重合，停止上一个，播放下一个
        //             if (_sound_effect_type_dic[sound_file_name]) {
        //                 let sound_id = _sound_effect_type_dic[sound_file_name];
        //                 let sound_obj = _sound_effect_dic[sound_id];
        //                 if (sound_obj) {
        //                     sound_obj.stop();
        //                     sound_obj.removeEventListener(egret.Event.SOUND_COMPLETE, onSoundComplete, this);
        //                     delete _sound_effect_dic[sound_id];
        //                 }
        //                 delete _sound_effect_type_dic[sound_file_name];
        //             }
        //             _sound_effect_type_dic[sound_file_name] = sound_effect_id;
        //             let channel = sound.play(0, 1);
        //             _sound_effect_dic[sound_effect_id] = channel;
        //             this.SetVolume(down_voice, false);
        //             channel.volume = sound_volume;
        //             if (use_cache && !cache_sound_effect_dic[sound_name]) {
        //                 cache_sound_effect_dic[sound_name] = sound;
        //             }
        //             channel.once(egret.Event.SOUND_COMPLETE, onSoundComplete, this);
        //         }
        //     };
        //     _sound_effect_dic[sound_effect_id] = false;
        //     if (use_cache) {
        //         if (cache_sound_effect_dic[sound_name]) {
        //             loadCompleted(cache_sound_effect_dic[sound_name]);
        //         }
        //         else {
        //             _res_mgr.GetResByUrl(this.hashCode, url, loadCompleted, this, _sound_type, _load_high);
        //         }
        //     }
        //     else {
        //         _res_mgr.GetResByUrl(_sound_effect_hashcode_target.hashCode, url, loadCompleted, this, _sound_type, _load_high);
        //     }
        //     return _sound_effect_id;
        };
    }
    public static GetInstance() {
        if (!SoundManager.Instance) {
            SoundManager.Instance = new SoundManager();
        }
        return SoundManager.Instance;
    }
}

//3d有两种声音 h5只有一种  默认都为true
export class LuaSoundManager {
    public static SOUND_UI = {
        CLOSE : true,
        DEFAULT : true
    }
}
window["SoundManager"] = SoundManager
window["LuaSoundManager"] = LuaSoundManager