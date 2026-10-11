
//require("game.setting.SettingChangeHeadView")
//require("game.setting.SettingChangeNameView")
//require("game.setting.SettingUploadHeadView")
//require("game.setting.SettingHeadItem")
//require("game.common.SettingModel")
//require("game.setting.SettingShieldItem")

import { AppConst } from "../common/AppConst"
import { BaseController } from "../common/BaseController"
import { Config } from "../common/Config"
import { EventName, SceneEventType } from "../common/EventName"
import { GameSettingManager } from "../common/GameSettingManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { SettingModel } from "../commonModel/SettingModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { LoadLuaClassAB, Util } from "../util/Util"
import "../setting/SettingView"
import "../setting/SettingChangeNameView"
import "../setting/SettingChangeHeadView"
import "../setting/SettingSubscriptionItem"
import { PlatformManager } from "../PlatformManager"
import { LoginManager } from "../login/LoginManager"

let Config_PRELOAD_CLIENT_CONFIG = Config.PRELOAD_CLIENT_CONFIG
let local_GlobalEventSystem = GlobalEventSystem
export class SettingController extends BaseController {
    InitEvent
    InitInfo
    public constructor() {
        super()

        let model:SettingModel = SettingModel.GetInstance()
        let setting_type = SettingModel.SettingType
        let user_msg_adapter = UserMsgAdapter.GetInstance()
        let game_setting_mgr = GameSettingManager.GetInstance()
        let block_subtype_2_game_block = SettingModel.BlockSubType2GameBlockType
        let global_setting_model = SettingModel
        let view_dic_ = {}

        this.InitEvent = () => {
            model.Bind(
                SettingModel.SETTING_REQUEST_PROTO, (id, fmt, ...new_args) => {
                    this.SendFmtToGame(id, fmt, ...new_args)
                }
            )

            model.Bind(
                SettingModel.SETTING_REQUEST_PROTO_10203, (list?) => {
                    this.WriteBegin(10203)
                    this.WriteFMT("h", list.length)
                    for (let _tmpi = 0; _tmpi < list.length; _tmpi++) {
                        let vo = list[_tmpi]
                        this.WriteFMT("c", vo.type)
                        this.WriteFMT("c", vo.subtype)
                        this.WriteFMT("c", vo.is_open)
                    }
                    this.SendToGame()
                }
            )

            model.Bind(
                SettingModel.SETTING_REQUEST_PROTO_11305, (id?) => {
                    this.WriteBegin(11305)
                    let package_code = PlatformManager.GetInstance().GetWXPackageCode() || "yy25dlaya_kf"
                    this.WriteFMT("i", id)
                    this.WriteFMT("s", package_code)
                    this.SendToGame()
                }
            )

            model.Bind(
                SettingModel.SETTING_REQUEST_PROTO_11306, (list?) => {
                    this.WriteBegin(11306)
                    this.WriteFMT("h", list.length)
                    for (let _tmpi = 0; _tmpi < list.length; _tmpi++) {
                        let vo = list[_tmpi]
                        this.WriteFMT("i", vo)
                    }
                    this.SendToGame()
                }
            )


            model.Bind(
                SettingModel.SETTING_OPEN_VIEW, (view_name: string, ...new_args) => {
                    let parms_ = new_args
                    let callback = () => {
                        let view = view_dic_[view_name]
                        if (!view) {
                            view = new window[view_name]
                            view_dic_[view_name] = view
                        }
                        if (view.HasOpen()) {
                            view.Close()//BaseView.Close(view)
                        } else {
                            view.Open(parms_)
                        }
                    }
                    LoadLuaClassAB(view_name, callback)
                }
            )
            local_GlobalEventSystem.Bind(EventName.INIT_CONFIG, () => {}
            )

            local_GlobalEventSystem.Bind(EventName.REQUEST_10202, () => {
                model.ClearSettingData()
                model.Fire(SettingModel.SETTING_REQUEST_PROTO, 10202, "c", setting_type.SysSetting)
            })

            local_GlobalEventSystem.Bind(
                EventName.GAME_START, () => {
                    model.InitSystemSetting()
                    model.Fire(SettingModel.SETTING_REQUEST_PROTO, 10202, "c", setting_type.AutoSmelt)
                    model.RequestWxSubsState()
                }
            )
            local_GlobalEventSystem.Bind(
                SceneEventType.SCENE_CHANGED, () => {
                    let scene_mgr = SceneManager.GetInstance()
                    let last_scene_id = scene_mgr.GetLastSceneId()
                    let last_dun_id = scene_mgr.last_dun_id
                    if (scene_mgr.IsFullEffectScene() && !scene_mgr.IsFullEffectScene(last_scene_id, last_dun_id)) {
                        model.EnterFullEffectFunc()
                    }
                    else if (scene_mgr.IsForceBlockScene() && !scene_mgr.IsForceBlockScene(last_scene_id, last_dun_id)) {
                        model.EnterForceBlockFunc()
                    }
                    else if (last_scene_id != 0 && (!scene_mgr.IsForceBlockScene() && scene_mgr.IsForceBlockScene(last_scene_id, last_dun_id)) ||
                        !scene_mgr.IsFullEffectScene() && scene_mgr.IsFullEffectScene(last_scene_id, last_dun_id)
                    ) {
                        model.ExitForceBlockFunc()
                    }
                }
            )
            
            let onBlockSettingChange = (scmd) => {
                let block_subtype = Config_PRELOAD_CLIENT_CONFIG.ClientBlockConfig.BlockSubType
                let subtype = scmd.subtype
                let value = scmd.is_open
                if (block_subtype.sound_open == subtype) {
                    game_setting_mgr.SetSoundValue(value)
                }
                else if (block_subtype.sound_effect_open == subtype) {
                    game_setting_mgr.SetEffectSoundValue(value)
                }
                else if (block_subtype.same_screen_role_num == subtype) {
                    //game_setting_mgr:SetPlayerCounts(value)
                    SettingModel.GetInstance().other_role_number = value
                    let game_block = block_subtype_2_game_block[subtype]
                    game_setting_mgr.SetBlockProperty(game_block, value, subtype)
                    GlobalEventSystem.Fire(SceneEventType.UPDATE_ROLE_LIMIT, SceneObj.ModelHideFlag.RoleNumLimit)
                }
                else if (block_subtype.effect_num == subtype) {
                    SettingModel.GetInstance().effect_num = value//game_setting_mgr.SetEffectCounts(value)
                } else {
                    let game_block = block_subtype_2_game_block[subtype]
                    if (game_block) {
                        game_setting_mgr.SetBlockProperty(game_block, value == 1, subtype)
                    }
                }
            }
            model.Bind(SettingModel.UPDATE_ONE_SETTING_INFO, onBlockSettingChange)

            let onUploadPhoto = () => {
                // let operate_str = "pickPhoto"
                // let mainrole_vo = RoleManager.Instance.mainRoleInfo
                // let file_path, file_name = UtilGetRolePicPath(mainrole_vo.role_id, null, mainrole_vo.picture_ver + 1)
                // SDKUtil.CallSDKFunc("PhonePhoto", operate_str, { imagePath : file_path, imageName : file_name, imageWidth : 200, imageHeight : 200 })
            }
            model.Bind(global_setting_model.UPLOAD_PHOTO, onUploadPhoto)
        }

        this.InitInfo = () => {
            let Handler10202 = () => {
                let scmd = user_msg_adapter.GetSCMD(10202)
                for (let _tmpi in scmd.setting_list) {
                    let vo = scmd.setting_list[_tmpi]
                    //@ts-ignore
                    vo.type = scmd.type
                }
                model.SetSettingData(scmd)
                if(scmd.type == setting_type.SysSetting){
                    LoginManager.GetInstance().SetGameStartReceiveFlag("10202@3", true)
                }
            }

            let Handler10203 = () => {
                let scmd = user_msg_adapter.GetSCMD(10203)
                if (scmd.error_code == 1) {
                    if (model.cache_setting_list) {
                        model.UpdataSettingDataList(model.cache_setting_list)
                        model.Fire(SettingModel.UPDATE_CONTENT)
                    }
                } else {
                    Util.ErrorCodeShow(scmd.error_code)
                }
                model.cache_setting_list = null
            }

            let Handler42604 = () => {
                let result = user_msg_adapter.ReadFmt('i')
                GlobalEventSystem.Fire(SettingModel.CAN_USE_THIS_NAME, { result: result })
            }

            let Handler10204 = () => {
                let scmd = user_msg_adapter.GetSCMD(10204)
                if (scmd.error_code != 1) {
                    Util.ErrorCodeShow(scmd.error_code)
                }
            }

            let Handler10210 = () => {
                let scmd = user_msg_adapter.GetSCMD(10210)
                if (scmd.code != 1) {
                    Util.ErrorCodeShow(scmd.code)
                }
            }

            //微信订阅
            let Handler11306 = () => {
                let scmd = user_msg_adapter.GetSCMD(11306)
                let arr = scmd.temp_list || []
                for (let i = 0; i < arr.length; i++) {
                    let obj = arr[i]
                    if(!model.wx_subs_data["info"]){
                        model.wx_subs_data["info"]={}
                    }
                    model.wx_subs_data["info"][obj.temp_id] = obj.state
                }

                GlobalEventSystem.Fire(SettingModel.UPDATE_SUBSCRIPTION)
            }

            //微信订阅开关
            let Handler11307 = () => {
                let scmd = user_msg_adapter.GetSCMD(11307)
                let state = scmd && scmd["res"] == 1
                model.wx_subs_data["state"] = state
                GlobalEventSystem.Fire(SettingModel.UPDATE_SUBSCRIPTION_SWITCH, state)
            }

            this.RegisterProtocal(10202, Handler10202)
            this.RegisterProtocal(10203, Handler10203)
            this.RegisterProtocal(10204, Handler10204)
            this.RegisterProtocal(10210, Handler10210)
            this.RegisterProtocal(11306, Handler11306)
            this.RegisterProtocal(11307, Handler11307)
        }

        this.InitInfo()
        this.InitEvent()
    }
}
window["SettingController"] = SettingController