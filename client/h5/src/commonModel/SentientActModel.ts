import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { CrossServerViewIndex } from "../commonController/BossController"
import { SceneManager } from "../scene/SceneManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
export let SentientActEvent = {
    REQUEST_PROTO: "REQUEST_PROTO",
    UPDATE_DOOR_DATA: "UPDATE_DOOR_DATA",
    OPEN_SENTIENTACT_VIEW: "OPEN_SENTIENTACT_VIEW",
    UPDATE_COUNT: "UPDATE_COUNT",
    DELETE_DOOR: "DELETE_DOOR",
    UPDATE_ACT_STATE: "UPDATE_ACT_STATE",
    UPDATE_DUNGEON_INFO: "UPDATE_DUNGEON_INFO",
    FIND_WAY: "FIND_WAY",
    UPDATE_APPLY_RED: "UPDATE_APPLY_RED"

}
window["SentientActEvent"] = SentientActEvent
export class SentientActModel extends EventDispatcher {


    static Instance: SentientActModel
    private portal_data
    private act_data
    private dungeon_info
    public dungeon_id
    /**传送门数量大于0的时候提示一次红点  进入场景后消失*/
    public set_red = true
    /**已参战次数 */
    public enter_num = 0
    /**已协助次数 */
    public assist_num = 0
    public constructor() {
        super()

        if (SentientActModel.Instance) {
            return
        }



    }
    public SetPortalData(data) {
        this.portal_data = data
    }
    public GetPortalData() {
        return this.portal_data
    }

    public SetActData(data) {
        this.act_data = data
    }
    public GetActData() {
        return this.act_data
    }
    public GetDoorNum() {
        let data = this.GetPortalData()
        let num = data && data.length ? data.length : 0
        return num
    }

    public SetRed() {
        // let num = this.GetDoorNum()
        let red = this.GetActiveIconRed()//num > 0 && this.set_red
        let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
        if (open_day > 7) {
            GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CrossServerEnterView", CrossServerViewIndex.SentientAct, red)
        }
        else
            GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WorldBattleEnterViewTwo", 0, red)
        GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "241@1@0")
    }
    public GetActiveIconRed() {
        if (this.act_data && this.set_red) {
            //次数判断
            let boo = this.HaveSentientActCount()

            //传送门数量
            let num = this.GetDoorNum()
            let boo1 = num > 0
            let boo2 = boo && boo1
            return boo2 && this.act_data.state == 1
        }
            return false
    }

    public IsSentientActDungeonScene(cfg, now_scene_id?) {
        if (!cfg) return
        let dungeon_list = cfg.beings_gate_dungeon_scene.value
        dungeon_list = JSON.parse(dungeon_list)
        now_scene_id = now_scene_id || SceneManager.GetInstance().GetSceneId()
        for (let key in dungeon_list) {
            let id = dungeon_list[key]
            if (Number(id) == Number(now_scene_id)) return true
        }
        return false
    }
    public SetDunInfo(scmd) {
        this.dungeon_info = scmd
        this.Fire(SentientActEvent.UPDATE_DUNGEON_INFO, scmd)
    }

    public GetDunInfo() {
        return this.dungeon_info
    }

    public HaveSentientActCount() {

        if(this.act_data){
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_beings_gate_kv
            let max_help_count = cfg && cfg["beings_gate_dungeon_assist"].value || 0
            let max_into_count = cfg && cfg["beings_gate_scene_enter"].value || 0
            let boo = /*((max_help_count - this.assist_num) > 0) ||*/ ((max_into_count - this.enter_num) > 0)
            return boo&&this.act_data.state == 1
        }
        
        return false
    }

    public static GetInstance() {

        if (!SentientActModel.Instance) {
            SentientActModel.Instance = new SentientActModel()
        }
        return SentientActModel.Instance
    }
}

window["SentientActModel"] = SentientActModel