import { BaseView1 } from "../common/BaseView1";

export class DailyBoxRewardView extends BaseView1 {
// InitEvent
// LoadSuccess
// Local_Open
// OpenCallback
// SetItemList
// click_bg_toClose
// destroy_callback
// destroy_imm
// horizontalCenter
// open_callback
// preload_server_config
// show_open_movie
// use_background
// verticalCenter

// public constructor(){
// super() 
	
  
//   this.base_file = "daily"
//   this.layout_file = "DailyBoxRewardViewExml"
//   this.layer_value = Enum_UILayer.Activity
//   this.destroy_imm = true
//   this.use_background = true
//   this.click_bg_toClose = true
//   this.show_open_movie = true
//   let model = DailyModel.GetInstance()
//   let _config_activity_reward = null
//   let _id = null
//   let _item_list = null
//   this.horizontalCenter = 0
//   this.verticalCenter = 0
//   this.preload_server_config = [config_activity_reward=false]
//   this.load_callback = () => {
//     this.LoadSuccess()
//     this.InitEvent()
//   }
  
//   this.open_callback = () => {
//     this.OpenCallback()
//   }
  
//   this.destroy_callback = () => {
//     for (let key in _item_list) {
	
//       // [ts2lua]_item_list下标访问可能不正确
//       _item_list[key].DeleteMe()
//     }
//     _item_list = null
//   }
  
//   this.LoadSuccess = () => {
//     _item_list = []
//   }
  
//   this.InitEvent = () => {
//     let close_fun = () => {
//       this.Close()
//     }
    
//     Util.AddClickEvent(this.closeBtn, close_fun, this, true)
//   }
  
//   this.Local_Open = ( parms?) => {
//     _id = parms
//     super.Open()
//   }
  
//   this.OpenCallback = () => {
//     if (! _id)
//     {
//       return
//     }
//     let config_activity_reward = ResManager.GetInstance().GetGameConfigFromCache(this, "config_activity_reward", false)
//     let reward_list = model.GetBoxRewardListById(_id, config_activity_reward)
//     if (reward_list)
//     {
//       this.SetItemList(reward_list)
//     }
//   }
  
//   this.SetItemList = ( reward_list?) => {
//     let bag_list = (reward_list && ( reward_list ) || ( {} ) )
//     let i = 0
//     do {
//       let info = bag_list[i]
//       let item = _item_list[i]
//       if (! item)
//       {
//         item =  new BaseAwardItem(this.scroll_group)
//         item.Load()
//         _item_list[i] = item
//       }
//       let type_id, lock = GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
//       item.SetData(type_id, info[2], lock)
//       item.SetVisible(true)
//       i=i+1
//     } while ((i < bag_list.length))
//     let i = bag_list.length
//     do {
//       _item_list[i].SetVisible(false)
//       i=i+1
//     } while ((i < _item_list.length))
//   }
  

// }

// public Open(...new_args){ 
	
//   this.Local_Open(parms)
// }


}

window["DailyBoxRewardView"] = DailyBoxRewardView