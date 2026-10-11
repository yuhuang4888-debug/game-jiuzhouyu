
// import { MapEnterView } from "../map/MapEnterView"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { Config } from "./Config"
import { CookieWrapper } from "./CookieWrapper"
import { SceneEventType } from "./EventName"
import { SoundManager } from "./SoundManager"

export class GameSettingManager extends EventDispatcher {
	auto_lock
	blockHaveSet
	camera_view_setting
	chatVoiceSet
	ctrlSet
	powerSet
	soundSet
	sysSet
	blockSet = {}
	temp_blockSet = {}
	static Instance
	//屏蔽
	public static BLOCK_SETTING_CHANGE = "BLOCK_SETTING_CHANGE"
	// 性能设置
	public static PerformanceList = {

		[1]:
		{
			title: "帧数设置<font color='#f18c4a'>（立即生效；若运行卡顿、发热量和耗电量过大可适当降低）</font>",
			name_list: ["低", "中", "高"],
			val_list: [40, 50, 60],
			setting_str: "fps",
		},



		[2]:
		{
			title: "画质设定<font color='#f18c4a'>（若感觉卡顿可降低画质）</font>",
			name_list: ["低", "中", "高"],
			val_list: [1, 2, 3],
			setting_str: "quality"
		},

		[3]:
		{
			title: "镜头设置<font color='#f18c4a'>（2.5D、3D视角自由切换）</font>",
			name_list: ["2.5D", "3D"],
			val_list: [false, true],
			setting_str: "view",
		},
	}

	public constructor() {
		super()
		
		let sysSet = CookieWrapper.Instance.GetCookie(CookieWrapper.SYSTEM_SETTING)
		if(sysSet){
			this.sysSet = JSON.parse(sysSet)
		}

		let ctrlSet = CookieWrapper.Instance.GetCookie(CookieWrapper.CONTROL_SETTING)
		if(ctrlSet){
			this.ctrlSet = JSON.parse(ctrlSet)
		}

		let soundSet = CookieWrapper.Instance.GetCookie(CookieWrapper.SOUND_SETTING)
		if(soundSet){
			this.soundSet = JSON.parse(soundSet)
		}

		let blockSet = CookieWrapper.Instance.GetCookie(CookieWrapper.BLOCK_SETTING)
		if(blockSet){
			this.blockSet = JSON.parse(blockSet)
		}

		let blockHaveSet = CookieWrapper.Instance.GetCookie(CookieWrapper.BLOCK_HAVE_SET_SETTING)
		if(blockHaveSet){
			this.blockHaveSet = JSON.parse(blockHaveSet)
		}
		// this.auto_lock = CookieWrapper.Instance.GetCookie(CookieKey.AUTO_LOCK_STATE)
		// this.temp_blockSet = []
		// let performanceCfg = GameSettingManager.PerformanceList && GameSettingManager.PerformanceList[1].val_list || null

		if (!this.sysSet) {
			let effectQuality = 2
			let screenQuality = 3
			let frameCount = 50

			// if (SystemMemoryLevel.Cur == SystemMemoryLevel.Low ) {
			// 	effectQuality = 1
			// 	frameCount = performanceCfg && performanceCfg[SystemMemoryLevel.Low] || 30
			// } else if (SystemMemoryLevel.Cur == SystemMemoryLevel.Middle ) {
			// 	effectQuality = 2
			// 	frameCount = performanceCfg && performanceCfg[SystemMemoryLevel.Middle] || 45
			// }else{
			// 	effectQuality = 3
			// 	frameCount = performanceCfg && performanceCfg[SystemMemoryLevel.Hight] || 60
			// }
			this.sysSet = {quality :screenQuality, effect : effectQuality, fps : frameCount,playerCounts : 10, effectCounts : 18,touch : true, rocker : true, release : 1,view : false}
		}else{
			if (! this.sysSet.effectCounts ) { this.sysSet.effectCounts = 18 }

			let frameCount = 50
			// if (SystemMemoryLevel.Cur == SystemMemoryLevel.Low ) {
			// 	frameCount = performanceCfg && performanceCfg[SystemMemoryLevel.Low] || 30
			// } else if (SystemMemoryLevel.Cur == SystemMemoryLevel.Middle ) {
			// 	frameCount = performanceCfg && performanceCfg[SystemMemoryLevel.Middle] || 45
			// }else{
			// 	frameCount = performanceCfg && performanceCfg[SystemMemoryLevel.Hight] || 60
			// }

			if (! this.sysSet.fps ) { this.sysSet.fps = frameCount }
			if (! this.sysSet.quality ) { this.sysSet.quality = 3 }
			if (! this.sysSet.view ) { this.sysSet.view = false }
			this.sysSet.playerCounts = 10
		}

		// if (! this.ctrlSet ) {
		// 	this.ctrlSet = [release = 1, touch = true, rocker = true]
		// }
		// ResManager.GetInstance().LoadGameConfig(this,"ConfigSound",true,null,(cfg)=>{
			let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigSound
			if (cfg && ! this.soundSet ) {
				this.soundSet = {sound : cfg.TotalVloume, effectSound : cfg.TotalSoundEffect}
			}
		// })

		if (! this.blockSet ) {
			this.blockSet = GameSettingManager.blockDefualt
		} else { //默认强制勾选星灵 宝具隐藏
			// this.blockSet["talisman"] = true
			// this.blockSet["starsoul"] = true
			// this.blockSet["otherPtc"] = true
			// this.blockSet["headFashion"] = true
		}

		// if (! this.blockHaveSet ) {
		// 	this.blockHaveSet = GameSettingManager.blockHaveSetDefualt
		// }

		// if (! this.auto_lock ) {
		// 	this.auto_lock = [ lock = true ]
		// }

		this.InitEvent()
	}

	public InitEvent() {

		var onStartGame = () => {
			this.LoadAccountSetting()
		}
		// GlobalEventSystem.Bind(EventName.COOKIE_INIT_FINISH, onStartGame)
		var onSceneStartHandler = () => {
			this.ChangeScene()
		}
		GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, onSceneStartHandler)
	}

	//加载账号角色的游戏设置
	public LoadAccountSetting() {

		// this.camera_view_setting = CookieWrapper.Instance.GetCookie(CookieLevelType.Account,CookieKey.CAMERA_VIEW_SETTING)
		// if (this.camera_view_setting == null ) {
		// 	this.camera_view_setting = [is_3d = false, is_lock = true, is_follow = true]
		// }
	}
	public SetCameraView3DMode(bool?) {

		// this.camera_view_setting.is_3d = bool
		// CookieWrapper.Instance.SaveCookie(CookieLevelType.Account, CookieTimeType.TYPE_ALWAYS, CookieKey.CAMERA_VIEW_SETTING, this.camera_view_setting)
		// CookieWrapper.Instance.WriteAll()
		// GlobalEventSystem.Fire(EventName.CHANGE_OF_VIEW)
	}
	public IsCameraView3DMode() {

		if (this.camera_view_setting == null) {
			this.LoadAccountSetting()
		}
		return this.camera_view_setting.is_3d
	}
	public SetCameraViewLockMode(bool?) {

		// this.camera_view_setting.is_lock = bool
		// CookieWrapper.Instance.SaveCookie(CookieLevelType.Account, CookieTimeType.TYPE_ALWAYS, CookieKey.CAMERA_VIEW_SETTING, this.camera_view_setting)
		// CookieWrapper.Instance.WriteAll()
		// GlobalEventSystem.Fire(EventName.CHANGE_OF_VIEW)
	}
	public IsCameraViewLockMode() {

		return this.camera_view_setting.is_lock
	}
	public SetCameraViewFollowMode(bool?) {

		// this.camera_view_setting.is_follow = bool
		// CookieWrapper.Instance.SaveCookie(CookieLevelType.Account, CookieTimeType.TYPE_ALWAYS, CookieKey.CAMERA_VIEW_SETTING, this.camera_view_setting)
		// CookieWrapper.Instance.WriteAll()
	}
	public IsCameraViewFollowMode() {

		return this.camera_view_setting.is_follow
	}

	public ChangeScene() {

		// let sceneId = SceneManager.GetInstance().GetSceneId() || 0
		// if (this.GetBlockHaveSet("otherPtc") == true ) { return }
		// for (let key in Config.ConfigBlockSetting.SceneBlockList) {
		// 	var list = Config.ConfigBlockSetting.SceneBlockList[key]
		// 	//if (! (this.GetBlockHaveSet(key) == true) ) {	// 检查玩家是否设置过
		// 		let now_block = true
		// 		for (let _ in list) {
		// 			var scene = list[_]				// 检查当前是否需要设为配置值的场景
		// 			if (scene == sceneId  || this.NotBlockEffecScene(sceneId) ) {
		// 				now_block = false
		// 				this.blockSet[key] = now_block
		// 				this.SaveBlockSet()
		// 				return
		// 			}
		// 		}

		// 	//}
		// }

		// if (! (this.GetBlockHaveSet("otherPtc") == true)  ) {
		// 	this.blockSet["otherPtc"] = true
		// 	this.SaveBlockSet()
		// }
	}

	// SettingType = {
	// 	None = 0,
	// 	Low = 1,
	// 	Medium = 2,
	// 	High = 3,
	// }

	// SkillMode = {
	// 	Simple = 1,
	// 	Advanced = 2,
	// }

	public static Resolution = [
		0.6,
		0.8,
		1,
	]

	public static basicDefualt = {
		music: 50,
		soundEffect: 50,
		playerCounts: 15,
	}

	/*
		other.他人
		active：日常活动度外观
		title = 称号
		otherPtc = 他人特效
		wing = 翅膀
		talisman = 圣物
		pet = 精灵
		baby = 孩子
		horse = 坐骑
		godWeapon = 神兵
		foot = 足迹
		fashion = 时装
		flower = 礼物特效
		monster = 怪物
		scenePtc = 场景特效
		chatVoice = 聊天语音
		shakeScreen = 震屏
		headFashion = 头饰
	//*/
	public static blockDefualt = {
		other: false,
		active: true,
		title: false,
		otherPtc: false,
		wing: false,
		back: false,
		talisman: true,
		pet: true,
		baby: true,
		horse: false,
		godWeapon: true,
		foot: true,
		fashion: false,
		flower: false,
		monster: false,
		scenePtc: false,
		shakeScreen: false,
		starsoul: true,
		headFashion: true,
		sameScreenRoleNum: 5,
	}

	// 需要记录玩家人为设置 的屏蔽 的默认值
	public static blockHaveSetDefualt = {
		otherPtc: false,
		flower: false,
	}

	//频道屏蔽语音
	public static blockChannel = [
		"world",
		"area",
		"guild",
		"cross",
	]

	// 性能设置默认值
	/*
	fps 帧数
	auto_fluency 自动设置帧数
	quality 画质
	//*/
	public static performanceSetDefualt = {
		fps: 50,
		quality: 3,
	}

	public GetBasicDefualt(key?) {

		// return this.basicDefualt[key]
	}

	public GetBlockDefualt(key?) {

		// return this.blockDefualt[key]
	}

	public GetPerformanceDefualt(key?) {

		// return this.performanceSetDefualt[key]
	}

	// 还原屏蔽默认设置
	public SetBlockDefualt() {

		// this.blockSet = GameSettingManager.blockDefualt
		// this.blockHaveSet = GameSettingManager.blockHaveSetDefualt
		// this.SaveBlockSet()
		// this.SaveBlockHaveSet()
	}

	public static GetInstance() {

		if (GameSettingManager.Instance == null) {
			GameSettingManager.Instance = new GameSettingManager()
		}
		return GameSettingManager.Instance
	}

	public ApplySetting() {

		// if (this.sysSet.powerSave ) {
		// 	this.ApplyPowerSave()
		// }else{
		this.ApplyQualityLevel()
		this.ApplyEffectLevel()
		this.ApplyPlayerCounts()
		this.ApplyFPSLevel()
		this.ApplySceneEffect()
		// }
	}

	public SaveSoundSet() {
		if(this.soundSet){
			CookieWrapper.Instance.SaveCookie(CookieWrapper.SOUND_SETTING, JSON.stringify(this.soundSet))
		}
	}

	public SaveCtrlSet() {

		// CookieWrapper.Instance.SaveCookie( CookieTimeType.TYPE_ALWAYS, CookieKey.CONTROL_SETTING, this.ctrlSet)
	}

	public SaveSysSet() {
		if(this.sysSet){
			CookieWrapper.Instance.SaveCookie(CookieWrapper.SYSTEM_SETTING, JSON.stringify(this.sysSet))
		}
	}

	public SaveBlockSet() {
		if(this.blockSet){
			CookieWrapper.Instance.SaveCookie(CookieWrapper.BLOCK_SETTING, JSON.stringify(this.blockSet))
		}
	}

	public SaveBlockHaveSet() {
		if(this.blockHaveSet){
			CookieWrapper.Instance.SaveCookie(CookieWrapper.BLOCK_HAVE_SET_SETTING, JSON.stringify(this.blockHaveSet))
		}
	}

	public SetSoundValue(value?) {

		SoundManager.GetInstance().ChangeVolumeEffect(value/100)
		this.soundSet = this.soundSet || {}
		this.soundSet.sound = value
		this.SaveSoundSet()
	}

	public SetEffectSoundValue(value?) {

		SoundManager.GetInstance().ChangeVolume(value/100)
		this.soundSet = this.soundSet || {}
		this.soundSet.effectSound = value
		this.SaveSoundSet()
	}

	public SetSkillMode(mode?) {

		this.ctrlSet.release = mode
		this.SaveCtrlSet()
	}

	public GetSkillMode() {

		return this.ctrlSet.release || 1
	}

	public EnableTouch(state?) {

		this.ctrlSet.touch = state
		this.SaveCtrlSet()
	}

	public EnableRocker(state?) {

		this.ctrlSet.rocker = state
		this.SaveCtrlSet()
	}

	public GetQualityLevel() {

		// if (this.sysSet.powerSave ) {
		// 	return this.powerSet.quality
		// }else{
		return this.sysSet.quality
		// }
	}

	//设置屏幕分辨率
	public SetResolution(level?) {

		// if (RuntimePlatform ) {
		// 	if (Application.platform == RuntimePlatform.Android || Application.platform == RuntimePlatform.IPhonePlayer || ClientConfig.iphone_x_model ) {
		// 		ResolutionWidth = OriginalResolutionWidth * GameSettingManager.Resolution[level]
		// 		ResolutionHeight = OriginalResolutionHeight * GameSettingManager.Resolution[level]
		// 		UnityEngine.Screen.SetResolution(ResolutionWidth, ResolutionHeight, true)
		// 		ScreenConvertRatio = Math.min(ResolutionWidth / OriginalScreenWidth,ResolutionHeight / OriginalScreenHeight)
		// 		ScreenWidth = ResolutionWidth / ScreenConvertRatio //游戏中的屏幕逻辑像素宽度 也就是所谓的视口坐标 用来逻辑运算用的
		// 		ScreenHeight = ResolutionHeight / ScreenConvertRatio //游戏中的屏幕逻辑像素高度 也就是所谓的视口坐标 用来逻辑运算用的
		// 	}
		// }
	}

	public SetQualityLevel(level?) {

		// // if (this.sysSet.powerSave ) {
		// // 	this.powerSet.quality = level
		// // 	this.ApplyQualityLevel(this.powerSet.quality)
		// // }else{
		// 	this.sysSet.quality = level
		// 	this.ApplyQualityLevel()
		// 	this.SaveSysSet()
		// 	GlobalEventSystem.Fire(GameSettingEvent.ON_QUALITY_SETTING_CHANGE, level)
		// // }
	}

	public ApplyQualityLevel(level?) {

		level = level || this.sysSet.quality
		//QualitySettings.SetQualityLevel(level - 1, false)
		this.SetResolution(level)
	}

	public GetEffectCounts() {

		return this.sysSet.effectCounts
	}

	public SetEffectCounts(number?) {

		this.sysSet.effectCounts = number
		this.SaveSysSet()
	}

	public GetEffectLevel() {

		// if (this.sysSet.powerSave ) {
		// 	return this.powerSet.effect
		// }else{
		return this.sysSet.effect
		// }
	}

	public SetEffectLevel(level?) {

		// if (this.sysSet.powerSave ) {
		// 	this.powerSet.effect = level
		// 	this.ApplyEffectLevel(this.powerSet.effect)
		// }else{
		this.sysSet.effect = level
		this.SaveSysSet()
		this.ApplyEffectLevel()
		// }
	}

	public ApplyEffectLevel(level?) {

		// if (MapView && MapView.Instance ) {
		// 	MapView.Instance.RefreshEffect()
		// }
	}

	public ApplySceneEffect() {

		// if (MapView && MapView.Instance ) {
		// 	MapView.Instance.RefreshEffect()
		// }
	}

	public GetFPSLevel() {

		return this.sysSet.fps
	}


	public SetSceneEffect(state?) {

		// if (MapView && MapView.Instance ) {
		// 	MapView.Instance.SetHideRefreshEffect(state)
		// }
	}

	public ApplyFPSLevel() {


		// FINAL_FRAMERATE = this.sysSet.fps || FINAL_FRAMERATE
		// SetGameFrameRate(FINAL_FRAMERATE)
	}

	/*
		包含了同屏人数
	*/
	public GetRealPlayerCounts() {

		let same_screen_num = this.GetSameScreenNum()
		if (same_screen_num) {
			return this.GetPlayerCounts() > same_screen_num && same_screen_num || this.GetPlayerCounts()
		}
		return this.GetPlayerCounts()
	}

	public GetSameScreenNum() {

		return this.GetBlockProperty("sameScreenRoleNum") || GameSettingManager.blockDefualt.sameScreenRoleNum
	}

	/*
		根据角色数量，生成隐藏标签，用于同屏和系统屏蔽
	*/
	public GenPlayerHideFlagByPlayerNum(cur_player_num?) {

		let same_screen_num = this.GetSameScreenNum()
		let sys_player_num = this.GetBlockProperty("other") && 0 || this.GetPlayerCounts()
		let SceneObj = window["SceneObj"]
		let hide_flag = SceneObj.ModelHideFlag.RoleNumLimit
		// if (! LuaViewManager.GetInstance().is_lock_screen ) {
		// 	if (cur_player_num > same_screen_num && cur_player_num <= sys_player_num ) {
		// 		hide_flag = SceneObj.ModelHideFlag.RoleNumLimit
		// 	}
		// }
		return hide_flag
	}

	public GetPlayerCounts() {

		// if (this.sysSet.powerSave ) {
		// 	return this.powerSet.playerCounts
		// }else{
		return this.sysSet.playerCounts
		// }
	}

	/*
		系统屏蔽
	*/
	public SetPlayerCounts(number?) {

		// if (this.sysSet.powerSave ) {
		// 	this.powerSet.playerCounts = number
		// }else{
		this.sysSet.playerCounts = number
		this.SaveSysSet()
		// }
	}

	public ApplyPlayerCounts() {

		GlobalEventSystem.Fire(SceneEventType.UPDATE_ROLE_LIMIT)
	}

	public ApplyMonsterVisibleState() {

		if (this.GetBlockProperty("monster")) {
			GlobalEventSystem.Fire(SceneEventType.HIDE_ALL_MONSTER)
		} else {
			GlobalEventSystem.Fire(SceneEventType.SHOW_ALL_MONSTER)
		}
	}

	public EnableEffectSound(state?) {

		// this.sysSet.effectSound = state
		// this.SaveSysSet()
		// lua_soundM.SwitchEffectState(state)
	}

	public EnableMusicSound(state?) {

		// this.sysSet.musicSound = state
		// this.SaveSysSet()
		// lua_soundM.SwitchMusicState(state)
	}

	public EnablePowerSave(state?) {

		this.sysSet.powerSave = state
		this.SaveSysSet()
		this.ApplyPowerSave()
	}

	public ApplyPowerSave() {

		// if (this.sysSet.powerSave ) {
		// 	this.powerSet = this.powerSet || {quality = 1, effect = 1, playerCounts = 10}
		// 	this.SetQualityLevel(this.powerSet.quality)
		// 	this.SetEffectLevel(this.powerSet.effect)
		// 	this.SetPlayerCounts(this.powerSet.playerCounts)
		// 	Application.targetFrameRate = 15
		// }else{
		this.powerSet = null
		//Application.targetFrameRate = AppConst.GameFrameRate
		// }
	}

	public GetTargetPriority() {

		// let state_list = CookieWrapper.Instance.GetCookie(CookieLevelType.Account, CookieKey.AUTO_FIGHT_ATTACK_FIRST_STATE)
		// if (! state_list ) {
		// 	return 2
		// } else if (state_list.unLimit ) {
		// 	return 1
		// } else if (state_list.npcFirst ) {
		// 	return 2
		// } else if (state_list.roleFirst ) {
		// 	return 3
		// }
	}

	public SetTargetPriority(value?) {

		// let list = [unLimit = value == 1, npcFirst = value == 2, roleFirst = value == 3]
		// CookieWrapper.Instance.SaveCookie(CookieLevelType.Account, CookieTimeType.TYPE_ALWAYS, CookieKey.AUTO_FIGHT_ATTACK_FIRST_STATE, list)
	}

	public GetBlockProperty(key?) {
		return this.blockSet[key]
	}

	public SetBlockProperty(key?, value?,subtype?) {

			if (this.blockSet[key] && this.blockSet[key] == value ) { return }
			this.blockSet[key] = value
			this.SaveBlockSet()
			// ResManager.GetInstance().LoadGameConfig(this,"ConfigBlcokS")
			if (Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig.BlockSubType[key] ) {
				this.SetBlockHaveSet(key,true)	// 表示人为设置过
			}
			if(subtype){
				this.Fire(GameSettingManager.BLOCK_SETTING_CHANGE, subtype, value)
			}else{
				this.Fire(GameSettingManager.BLOCK_SETTING_CHANGE, key, value)
			}

	}

	// 获取该屏蔽设置是否经过玩家人为设置
	public GetBlockHaveSet(key?) {

		return this.blockHaveSet[key]
	}

	public SetBlockHaveSet(key?, value?) {
		let SceneManager = window["SceneManager"]
		let sceneId = SceneManager.GetInstance().GetSceneId() || 0
		let list = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig.BlockSubType[key]
		if (list == null ) { return }
		for (let k in list) {
		var v = list[k]
			if (v == sceneId ) {
				this.blockHaveSet[key] = value
			}
		}
		this.SaveBlockHaveSet()
	}

	// performance的cookie也存在sysSet里面
	public GetPerformanceProperty(key?) {

		return this.sysSet[key]
	}

	public SetPerformanceProperty(key?, value?) {

		if (this.sysSet[key] && this.sysSet[key] == value) { return }
		this.sysSet[key] = value
		this.SaveSysSet()
		if (key == "quality") {
			this.SetQualityLevel(value)
		} else if (key == "fps") {
			this.ApplyFPSLevel()
		}
	}

	//临时设置屏蔽标识
	public SetBlockPropertyTemp(key?, value?) {

		if ((this.blockSet[key] && this.blockSet[key] == value) || (this.temp_blockSet[key] && this.temp_blockSet[key] == value)) { return }
		this.temp_blockSet[key] = value
		this.Fire(GameSettingManager.BLOCK_SETTING_CHANGE, key, value)
	}

	//获得是否存在标识
	public ExistBlockSet(key?) {
		return this.blockSet[key] || this.temp_blockSet[key]
	}


	//是否屏蔽特效副本场景
	public NotBlockEffecScene(sceneId?) {

		//以下玩法需要根据内存情况 判断是否默认开启特效
		// if (SceneManager.GetInstance():IsLeagueWarScene(sceneId) || SceneManager.GetInstance():IsCSPvP(sceneId) || SceneManager.GetInstance().IsPkBattleScene(sceneId) ) {
		// 	if (SystemMemoryLevel.Cur == SystemMemoryLevel.Hight ) {
		// 		return true
		// 	}else{
		// 		return false
		// 	} 
		// }
		// if (SceneManager.GetInstance():IsDiamondFightScene(sceneId) || SceneManager.GetInstance().IsTopPkScene(sceneId) ) {
		// 	return true
		// }
		// return false
	}

	public SetAutoLockCookie(bool?) {


		this.auto_lock["lock"] = bool

		// CookieWrapper.Instance.SaveCookie( CookieTimeType.TYPE_ALWAYS, CookieKey.AUTO_LOCK_STATE, this.auto_lock)
		// CookieWrapper.Instance.WriteAll()
	}

	public GetAutoLockCookie() {

		let bool = this.auto_lock["lock"]
		return bool
	}

	// function GameSettingManager.LoadChatVoiceSetting()
	// 	this.chatVoiceSet = CookieWrapper.Instance.GetCookie(CookieLevelType.Account,CookieKey.CHAT_VOICE_SETTING)
	// 	if (! this.chatVoiceSet ) {
	// 		this.chatVoiceSet = [textOnly = false, world = true, around = true, guild = true, team = true, friend = true, career = true, autoPlay = true]
	// 	}
	// }

	// function GameSettingManager.SetChatVoiceProperty(key, value)
	// 	this.chatVoiceSet[key] = value
	// 	this.SaveChatVoiceSet()
	// }

	// function GameSettingManager.GetChatVoiceProperty(key)
	// 	return this.chatVoiceSet[key]
	// }

	// function GameSettingManager.SaveChatVoiceSet()
	// 	if (EnglineVersion && Number(AppConst.EnglineVer) >= 5 ) {
	// 		CookieWrapper.Instance.SaveCookie(CookieLevelType.Account, CookieTimeType.TYPE_ALWAYS, CookieKey.CHAT_VOICE_SETTING, this.chatVoiceSet)
	// 	}
}

window["GameSettingManager"] = GameSettingManager