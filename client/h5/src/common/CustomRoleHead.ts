import { LoginManager } from "../login/LoginManager"
import { LoginModel } from "../login/LoginModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { HttpUtil } from "../util/HttpUtil"
import { Util } from "../util/Util"
import { BaseClass } from "./BaseClass"
import { Config } from "./Config"
import { EventName } from "./EventName"
import { ResManager } from "./ResManager"
import { DressModel } from "../commonModel/DressModel"

export class CustomRoleHead extends BaseClass {
	public static Instance

	sent_data_state
	un_destroy_buff_list
	cache_data_state
	image_buff_list
	public constructor() {
		super()

		if (CustomRoleHead.Instance != null) {
			Error("attempt to create singleton(CustomRoleHead) twice!")
			return
		}
		CustomRoleHead.Instance = this

		this.image_buff_list = []
		//切场景不清除的头像
		this.un_destroy_buff_list = []

		this.cache_data_state = 0
		this.sent_data_state = false

		// let scene_change = () => {
		//     this.UpdateData()
		// }
		// GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, scene_change)
		/*
				let onPhonePhotoLoad = (image_path?) => {
					//let sent_succeed = (result?, image?) => {
					//    if (result ) {
					//        Message.show("图片上传成功")
					//        GlobalEventSystem.Fire(EventName.ROLEHEAD_UPLOAD_SUCCEED)
					//    }else{
					//        Message.show("图片上传失败，请再次尝试")
					//    }
					//}
		
					SettingModel.GetInstance().Fire(SettingModel.SETTING_OPEN_VIEW, "SettingUploadHeadView", image_path)
		
					//let mainrole_vo = RoleManager.Instance.mainRoleInfo
					//if (mainrole_vo ) {
					//    CustomRoleHead.GetInstance().Sent(sent_succeed, mainrole_vo.picture_ver + 1)
					//}
				}
				GlobalEventSystem.Bind(EventName.PHONE_PHOTO_LOADBACK, onPhonePhotoLoad)
				*/
	}

	public static GetInstance() {

		if (CustomRoleHead.Instance == null) {
			new CustomRoleHead()
		}
		return CustomRoleHead.Instance
	}

	// 加载成功回调
	// ref_tar目标
	// raw_image图片容器
	// role_id 角色ID
	// role_career  角色职业
	// role_sex性别
	// role_turn转身数
	// out_server 已不用 可以传 null
	// head_ver 角色头像版本号
	// picture      角色头像路径，如无可传 null
	// is_big是否大图
	// local_picture_id 本地图标的id
	// is_ear //是否露头

	public Create(result_callback?, ref_tar?, raw_image?, role_id?, role_career?, role_sex?, role_turn?, out_server?, head_ver?, picture?, is_big?, local_picture_id?, is_ear?) {

		let call_func = (result?, image?) => {
			if (ref_tar.use_delete_method) {
				return
			}

			if (result && image) {//&& !IsNull(raw_image)
				raw_image.source = image
				if (result_callback) {
					result_callback(true, picture, head_ver)
				}
			} else {
				console.warn("load imagse is null")
				if (result_callback) {
					result_callback(false, picture, head_ver)
				}
			}
		}

		if (role_id == "" || !role_id) {
			console.warn("CustomRoleHead role_id is error")
			return
		}

		let now_role_ver = head_ver || ""
		let has_load = false

		let load_default_res = () => {
			if (has_load) {
				return
			}


			let config_reincarnation_cfg = ResManager.GetInstance().GetGameConfigFromCache(ref_tar, "config_reincarnation_cfg", false)
			has_load = true
			role_turn = role_turn || 1
			let sex_ = null
			if (role_sex && role_sex != 0) {
				sex_ = role_sex
			} else {
				
				for (let _ in config_reincarnation_cfg) {
					var v = config_reincarnation_cfg[_]
					if (v.career == role_career) {
						sex_ = v.sex
						break
					}
				}
			}
			sex_ = sex_ || 1
			role_career = role_career || 1
			let cfg = config_reincarnation_cfg[role_career + "@" + sex_ + "@" + role_turn]
			if (!cfg) {
				console.log("no Reincarnationcfg by roleid:" + role_id)
				return
			}
			//转生的图片资源名称要到Config.Picture里面获取
			let _picture_resource = DressModel.GetInstance().getHeadICon(Number(cfg.icon))
			if (_picture_resource) {
				console.log("no Reincarnationcfg picture cfg by roleid:" + role_id)
				return
			}
			//玩家默認職業相片 加載後可常存
			let default_call = (obj?) => {
				if (obj) {
					call_func(true, obj)
				} else {
					call_func(false, null)
				}
			}

			// let ab_name = "icon_head_" + picture_cfg.resource
			default_call(_picture_resource)
			// ResManager.GetInstance().LoadTexture(this, ab_name, { res_name + ".png"}, default_call, ASSETS_LEVEL.LOW)
		}
		load_default_res()
		/*
		let load_local_picture_res = () => {
		if (has_load || !local_picture_id) {
			return
		}
	
		has_load = true
	
		//玩家默认职业相片 加载后可常存
		let default_call = (obj?) => {
			if (obj && obj[0]) {
				call_func(true, obj[0], role_id)
			} else {
				call_func(false, null, role_id)
			}
		}
		let res_name = ""
		let ab_name = ""
		//if (is_big ) {
		//res_name = "head_big_" + local_picture_id
		//ab_name = "icon_head_big_" + res_name
		//}else{
		//if (is_ear ) {
		//res_name = "head_ear_" + local_picture_id
		//}else{
		//res_name = "head_circle_" + local_picture_id
		//}
		//ab_name = "icon_head_" + res_name
		//}
		ab_name = "icon_head_" + local_picture_id
		ResManager.GetInstance().LoadTexture(this, ab_name, { res_name + ".png"}, default_call, ASSETS_LEVEL.LOW)
		}
	if ((now_role_ver == "" || now_role_ver == 0 || picture == "") && (!local_picture_id || local_picture_id == "" || local_picture_id == 0)) {
		load_default_res()
		return
	} else if (local_picture_id && (local_picture_id != 0 && local_picture_id != "")) {
		load_local_picture_res()
		return
	} else {
		setTimeout(load_default_res, 3)
	}
	
	let main_role_info = RoleManager.GetInstance().GetMainRoleVo()
	let server_id = out_server || main_role_info.server_unique_id
	let role_info = role_id
	let role_info_cache = role_info + now_role_ver
	
	this.cache_data_state = this.cache_data_state + 1
	
	let res_callback = (is_succ?, is_cache?, buffer?) => {
		let result = false
		if (is_succ && buffer) {
			has_load = true
			if (!is_cache) {
				this.image_buff_list[role_info_cache] = buffer
				if (role_id == RoleManager.Instance.GetMainRoleId()) {
					this.un_destroy_buff_list[role_info_cache] = true
				}
			}
			result = true
		}
		if (call_func) {
			call_func(result, buffer, role_id)
		}
	
		this.cache_data_state = this.cache_data_state - 1
	
		//下载成功 ，头像是自己的,只存拍照和相册的
		if (is_succ && role_id == RoleManager.Instance.GetMainRoleId() && (!local_picture_id || local_picture_id == 0 || local_picture_id == "")) {
			GlobalEventSystem.Fire(EventName.SAVE_CUSTOME_HEAD)
		}
	
	}
	
	let res_path, res_name = UtilGetRolePicPath(role_id, server_id, now_role_ver)
	let save_path = res_path + res_name
	
	let role_image = this.image_buff_list[role_info_cache]
	if (role_image) {
		console.log("cache role head")
		res_callback(true, true, role_image)
		return
	}
	
	let read_local_date = (result?) => {
		if (!result) {
			return
		}
	
		let load_func = (image?) => {
			if (image) {
				res_callback(true, false, image)
			} else {
				res_callback(false, false, image)
			}
		}
		Util.LoadRawTexture(save_path, load_func)
	}
	
	let is_exsit = false
	is_exsit = Util.FileExists(save_path)
	if (is_exsit) {
		console.log("let role head")
		read_local_date(true)
		return
	}
	let url = ClientConfig.rolehead_download_url + "img/" + role_info + ".jpg"
	console.log("download role head")
	HttpUtil.HttpDownLoad(url, save_path, read_local_date, timeout)
	*/
	}

	public Sent(sent_callback?, head_ver?) {
		/*
		
			let mainrole_vo = RoleManager.Instance.GetMainRoleVo()
			if (!mainrole_vo) {
				return
			}
		
			let plat_user_info = LoginManager.GetInstance().GetPlatUserInfo()
			if (!plat_user_info) {
				return
			}
		
			this.sent_data_state = true
			let get_param = {
				accname = String(LoginModel.GetInstance().account_id),
				platname = ClientConfig.plat_name,
				server = String(plat_user_info.server_id),
				player_id = mainrole_vo.role_id,
				game = ClientConfig.game_name,
			}
			let res_path, res_name = UtilGetRolePicPath(mainrole_vo.role_id, null, head_ver)
			let sent_back_func = (is_succ?, data?) => {
				let load_succeed = false
				let buffer = null
		
				let call_back = () => {
					if (sent_callback) {
						sent_callback(load_succeed, buffer)
					}
					this.sent_data_state = false
				}
		
				if (is_succ) {
					let json_obj = JsonToTable(data)
					if (json_obj) {
						let ret = json_obj["ret"]
						if (Number(ret) == 0) {
							let load_func = (image?) => {
								if (image) {
									load_succeed = true
									buffer = image
								}
								call_back(load_succeed, buffer)
							}
							Util.LoadRawTexture(res_path + res_name, load_func)
							return
						} else if (Number(ret) == 2) { //len字节
							Message.show("上传图片数据大小超过限制，请重新上传")
							return
						}
					}
				}
		
				call_back(load_succeed, buffer)
			}
			HttpUtil.HttpByteBuffSent(ClientConfig.rolehead_url + "api/upload.php", get_param, res_path + res_name, sent_back_func)
			*/
	}

	public ComplainRoleHead(img_name?) {
		/*
			if (img_name == "" || !img_name) {
				Message.show("玩家头像数据异常")
				return
			}
		
			let sent_back_func = (is_succ?, data?) => {
				// let json_obj = JsonToTable(data)
				// if (is_succ && json_obj ) {
				// let ret = json_obj["ret"]
				// if (Number(ret) == 0 ) {
				// return
				// }
				// }
				if (is_succ) {
					Message.show("您的举报我们已经收到了，请耐心等待结果~")
				} else {
					Message.show("举报失败")
				}
			}
		
			let ticket = "e04201e54b49a941434c48d971b59af5"
			let now_method = "set_img_status"
			let cur_time = String(os.time())
			let post_param = {
				time = cur_time,
				method = now_method,
				sign = string.lower(Util.md5(ticket + cur_time + now_method)),
				game = ClientConfig.game_name,
				imgname = img_name,
			}
		
			HttpUtil.HttpPostRequest(ClientConfig.rolehead_url + "api/api.php", post_param, sent_back_func, 1000)
		
			*/
	}

	public UpdateData() {
		/*
	
		if (this.cache_data_state > 0 || this.sent_data_state) {
			return
		}
	
		for (let role_id in this.image_buff_list) {
			var buffer = this.image_buff_list[role_id]
			if (buffer && !this.un_destroy_buff_list[role_id]) {
				destroy(buffer)
				this.image_buff_list[role_id] = null
			}
		}
		// this.image_buff_list = []
		*/
	}
}

window["CustomRoleHead"] = CustomRoleHead