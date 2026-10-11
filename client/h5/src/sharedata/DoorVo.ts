import { EventDispatcher } from "../util/EventDispatcher";
import { SceneBaseType } from "../scene/SceneConfig";
// TypeScript file
export class DoorVo extends EventDispatcher {
    // _iid = _in_obj_ins_id;
    id = 0; //流水ID int32
    // _cid = this._id;
    vo_type = SceneBaseType.Door;
    enter_scene_id = 0; //进入场景ID int32
    enter_scene_name = ""; //进入的场景名字 string
    pixel_x = 0; //传送门X坐标 int16		 
    pixel_y = 0; //传送门Y坐标 int16
    t_scene_x = 0; //目标场景传送点X坐标
    t_scene_y = 0; //目标场景传送点Y坐标
    is_hide = false; //所属玩家
    public constructor() {
        super();
    }
    public CreateDoorInfo(doorInfo) {
        // let sceneInfo = SceneManager.Instance.GetSceneInfo(doorInfo.scene)
        if (!doorInfo) {
            return;
        }
        this.id = doorInfo.door_id;
        this.enter_scene_id = doorInfo.enter_scene_id;
        this.t_scene_x = doorInfo.t_scene_x;
        this.t_scene_y = doorInfo.t_scene_y;
        this.pixel_x = doorInfo.pixel_x;
        this.pixel_y = doorInfo.pixel_y;
    }
}

window["DoorVo"] = DoorVo