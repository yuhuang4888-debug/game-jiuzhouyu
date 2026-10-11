
//require("game.map.AreaMapMonItem")
//require("game.map.AreaMapPonitItem")
//require("game.map.AreaMapView")
//require("game.map.AreaMapWayPonitItem")
//require("game.map.MapModel")
//require("game.map.MapEnterView")
//require("game.map.WorldMapItem")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { MapEvent, MapModel } from "../commonModel/MapModel"
import  "../map/MapEnterView"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

//require("game.map.WorldMapView")
export class MapController extends BaseController {
InitEvent
RegisterAllProtocals
_hash_code_target
static Instance
public constructor(){
super() 
	
  //this._hash_code_target =  new BaseClass();
  let local_GlobalEventSystem = GlobalEventSystem
  let local_EventName = EventName
  let model = MapModel.GetInstance()
  let view_dic_ = []
  this.RegisterAllProtocals = () => {
    
  }
  
  this.InitEvent = () => {
    model.Bind(MapEvent.MAP_REQUEST_PROTO,(id, fmt, ...new_args) => {
      this.SendFmtToGame(id, fmt, ...new_args)
    }
    )
    local_GlobalEventSystem.Bind(local_EventName.OPEN_MAP_VIEW,(view_class:string, ...new_args) => {
      if (! model.CanOpenMapView())
      {
        Message.show("当前场景没有小地图")
        return
      }
      let view_name = view_class
      // [ts2lua]view_dic_下标访问可能不正确
      let view = view_dic_[view_name]
      if (! view)
      {
        let viewClass = window[view_class]
        view =new viewClass()
        // [ts2lua]view_dic_下标访问可能不正确
        view_dic_[view_name] = view
      }
      view.Open(...new_args)
    }
    )
    local_GlobalEventSystem.Bind(local_EventName.CLOSE_MAP_VIEW,(view_class:string, ...new_args) => {
      let view_name = view_class
      let view = view_dic_[view_name]
      if (view && view.HasOpen())
      {
        view.Close()
      }
    }
    )
    local_GlobalEventSystem.Bind(local_EventName.GAME_START,() => {
      model.InitConfig()
    }
    )
  }
  
  this.RegisterAllProtocals()
  this.InitEvent()
}

public static GetInstance(){ 
	
  if (! MapController.Instance)
  {
    MapController.Instance =  new MapController()
  }
  return MapController.Instance
}

}
window["MapController"] = MapController