import { BaseWindowComponent } from "../common/BaseWindowComponent"

export class DailyLivenessView extends BaseWindowComponent {
// CheckLivenessFindRedDot
// CheckRedDot
// InitMyEvent
// destroy_imm
// is_lastView_close
// money_list
// tabStrList
// titleStr
// viewClassList
// window_load_back

// public constructor(){
// super() 
	
  
//   let daily_model = DailyModel.GetInstance()
//   let local_DailyEvent = DailyEvent
//   let local_GlobalEventSystem = GlobalEventSystem
//   let update_window_red_event = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
//   this.dependent_res = ["daily"]
//   this.destroy_imm = true
//   this.tabStrList = [{label:"活跃度"}, {label:"找回"}]
//   this.viewClassList = [DailyLivenessMsgView, DailyLivenessFindView]
//   this.titleStr = "daily_asset.uirw_008"
//   this.money_list = [2, 1, 0]
//   this.is_lastView_close = false
//   this.window_load_back = () => {
//     this.InitMyEvent()
//     this.CheckRedDot()
//     this.CheckLivenessFindRedDot()
//   }
  
//   this.InitMyEvent = () => {
//     let update_livenss_image_fun = () => {
//       this.CheckRedDot()
//     }
    
//     this.BindEvent(daily_model, local_DailyEvent.UPDATE_LIVENESS_IMAGE_DATA, update_livenss_image_fun)
//     let update_livenss_find_fun = () => {
//       this.CheckLivenessFindRedDot()
//     }
    
//     this.BindEvent(daily_model, local_DailyEvent.UPDATE_HUOYUEDU_DATA, update_livenss_find_fun)
//   }
  
//   this.CheckRedDot = () => {
//     let red = daily_model.LivenessCanUpgrade()
//     local_GlobalEventSystem.Fire(update_window_red_event, "DailyLivenessView", 0, red)
//   }
  
//   this.CheckLivenessFindRedDot = () => {
//     if (daily_model.liveness_dot_not_show == false)
//     {
//       let red = daily_model.LivenessCanFind()
//       local_GlobalEventSystem.Fire(update_window_red_event, "DailyLivenessView", 1, red)
//     }
//   }
  

// }

// public CloseFunc(){ 
	
//   super.CloseFunc()
// }
}

window["DailyLivenessView"] = DailyLivenessView