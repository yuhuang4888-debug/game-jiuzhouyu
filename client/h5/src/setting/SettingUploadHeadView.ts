import { BaseView1 } from "../common/BaseView1"
// import { CustomRoleHead } from "../common/CustomRoleHead"
// import { EventName } from "../common/EventName"
// import { Enum_UILayer } from "../common/LayerManager"
// import { ResManager } from "../common/ResManager"
// import { SettingModel } from "../commonModel/SettingModel"
// import { RoleManager } from "../role/RoleManager"
// import { Message } from "../sysInfo/SysInfoController"
// import { GlobalEventSystem } from "../util/DeclareGlobalVar"
// import { Util } from "../util/Util"

export class SettingUploadHeadView extends BaseView1 {
// Cirtexture_photo
// Dispose
// Emp_btn_upload
// EmpokBtn
// InitEvent
// LoadSuccess
// Local_Open
// UpdateView
// UploadImage
// _btn_upload
// _close_btn
// click_bg_toClose
// destroy_callback
// destroy_imm
// is_center
// okBtn
// open_callback
// show_open_movie
// texture_photo
// use_background

// public constructor(){
// super() 
	
//     this.base_file = "setting"
//     this.layout_file = "SettingUploadHeadViewExml"
//     this.layer_value = Enum_UILayer.Activity
//     this.is_center = true
//     this.destroy_imm = true
//     this.use_background = true
//     this.click_bg_toClose = true
//     this.show_open_movie = true
//     let model = SettingModel.GetInstance()
//     let role_mgr = RoleManager.GetInstance()
//     let global_event_sys = GlobalEventSystem
//     let local_EventName = EventName
//     let res_path = null
//     let is_upload = null
//     this.load_callback = () => {
        
//         this.InitEvent()
//         this.LoadSuccess()
//     }

//     this.open_callback = () => {
//         this.UpdateView()
//     }

//     this.destroy_callback = () => {

//     }

//     this.LoadSuccess = () => {
//         let load_func = (image?) => {
//             if (! this.Cirtexture_photo || this.use_delete_method)
//             {
//                 return
//             }
//             if (image)
//             {
//                 this.Cirtexture_photo.texture = image
//             }else{
//                 Message.show("图片读取为空")
//                 this.Close()
//             }
//         }
//         //if (res_path && res_path != "" ) {
//             let mainrole_vo = RoleManager.Instance.mainRoleInfo
//             let local_res_path, res_name = UtilGetRolePicPath(mainrole_vo.role_id, null, mainrole_vo.picture_ver + 1)
//             Util.LoadRawTexture(local_res_path + res_name, load_func)
//             ResManager.GetInstance()
//         //}else{
//         //    this.Close()
//         //}
//     }

//     this.UploadImage = () => {
//         let sent_succeed = (result?, image?) => {
//             if (result)
//             {
//                 Message.show("图片上传成功")
//                 GlobalEventSystem.Fire(local_EventName.ROLEHEAD_UPLOAD_SUCCEED)
//                 this.Close()
//             }else{
//                 Message.show("图片上传失败，请再次尝试")
//             }
//             is_upload = false
//         }

//         let mainrole_vo = RoleManager.Instance.mainRoleInfo
//         if (mainrole_vo)
//         {
//             is_upload = true
//             CustomRoleHead.GetInstance().Sent(sent_succeed, mainrole_vo.picture_ver + 1)
//         }
//     }

//     this.InitEvent = () => {
//         let close_fun = () => {
//             this.Close()
//         }
//         Util.AddClickEvent(this._close_btn, close_fun, this, true)

//         //this:BindEvent(global_event_sys, SettingModel.SELECT_ROLE_HEAD_ICON_SUCCESS, close_fun)

//         let okBtn_fun = () => {
//             role_mgr.Fire(EventName.REQUEST_ROLE_PROTO, 13082)
//             this.Close()
//         }
//         Util.AddClickEvent(this.okBtn, okBtn_fun, this, true)
//         Util.AddClickEvent(this._btn_upload,() => {
//             if (is_upload)
//             {
//                 return
//             }
//             this.UploadImage()
//         }, this, true)
//     }

//     this.UpdateView = () => {
      
//     }

//     this.Local_Open = ( parms?) => {
//         res_path = parms
//         super.Open()
//     }

//     this.Dispose = () => {
//         res_path = null
//         is_upload = null
//     }
// }

// public DeleteMe(){ 
	
//     this.Dispose()
// }

// public Open(...new_args){ 
	
//     this.Local_Open(...new_args)
// }

}

window["SettingUploadHeadView"]=SettingUploadHeadView