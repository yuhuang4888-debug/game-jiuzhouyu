import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Scene } from "../scene/Scene"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { Config } from "../common/Config"
import { Vector2 } from "../util/Vector2"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"

export class SeaAssertSBossItem extends BaseItemRenderer {

    auto_fight_mgr
    coolTime
    _scene
    _timer

    WIDTH = 234;
    HEIGT = 38;

    private kv_cfg: any;

    public constructor() {
        super()

        this.coolTime = 0
        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertSBossItem"

        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent()
        }
        this.Load();
    }

    private LoadSuccess() {
        let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_sea_craft_daily_kv;
        this.kv_cfg = kv_cfg
    }

    public InitEvent() {
        this._scene = Scene.GetInstance()
        this.auto_fight_mgr = AutoFightManager.GetInstance()
        Util.AddClickEvent(this.selectBox, () => {
            if (Scene.GetInstance().main_role && Scene.GetInstance().main_role.vo.brick_id > 0) {
                SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.REQUEST_PROTO, 18706);
            }
            this.Selected();
        }, this, true);

    }

    public Selected() {
        let LogicRealRatio_X = SceneObj.GetLogicRealRatio().x
        let LogicRealRatio_Y = SceneObj.GetLogicRealRatio().y
        if (this.index == 0) {
            // [ts2lua]kv_cfg下标访问可能不正确
            let pos_cfg = this.kv_cfg["guard_coord"].value
            let pos_list = JSON.parse(pos_cfg);
            let pos = new Vector2(pos_list[0] / LogicRealRatio_X, pos_list[1] / LogicRealRatio_Y);
            this._scene.MainRoleMove(
                pos,
                3, () => {
                    if (this._scene.main_role && this._scene.main_role.vo.brick_id <= 0) {
                        this.auto_fight_mgr.SetAutoFight(true)
                    }
                }
            )
        } else {
            // [ts2lua]kv_cfg下标访问可能不正确
            let pos_cfg = this.kv_cfg["statue_coord"].value
            let pos_list = JSON.parse(pos_cfg)
            let pos = new Vector2(pos_list[0] / LogicRealRatio_X, pos_list[1] / LogicRealRatio_Y)
            this._scene.MainRoleMove(
                pos,
                3, () => {
                    if (this._scene.main_role && this._scene.main_role.vo.brick_id <= 0) {
                        this.auto_fight_mgr.SetAutoFight(true)
                    }
                }
            )
        }
    }

    public DeleteMe() {
        this.removeTimer();
        super.DeleteMe();
    }

    public dataChanged() {
        if (super.dataChanged()) {
            this._lb_name.text = this.data.name + "LV." + this.data.lv
            let severTime = TimeUtil.getServerTime()
            this.coolTime = 0
            if (this.data.reborn_time > severTime) {
                this.coolTime = this.data.reborn_time - severTime
                this.removeTimer()
                this.starTimer()
                this._lb_state.text = TimeUtil.convertTime(this.coolTime);
                this._lb_state.color = '#FE1A1A';
            } else {
                this._lb_state.text = "已刷新";
                this._lb_state.color = '#0A953E';
            }
            this._select.visible = this.selected;

        }

    }

    public starTimer() {
        this.removeTimer()
        if (!this._timer) {
            this._timer = GlobalTimerQuest.AddPeriodQuest(() => {
                this.onTimer()
            }, 1)
            this.onTimer()
        }
        //if (! this.timer.running ) {
        //    this.timer.start()
        //}
    }

    public removeTimer() {
        if (this._timer) {
            GlobalTimerQuest.CancelQuest(this._timer)
            this._timer = null
        }
    }

    public onTimer() {
        if (this.coolTime > 0) {
            this._lb_state.text = TimeUtil.convertTime(this.coolTime);
        } else {
            this._lb_state.text = "已刷新";
            this.removeTimer()
        }
        this.coolTime = this.coolTime - 1
    }

    _Image1: Laya.Image
    _select: Laya.Image
    _lb_name: Laya.Label
    _lb_state: Laya.Label
    selectBox: Laya.Box
    public GetComponents() {
        [
            this._Image1,
            this._select,
            this._lb_name,
            this._lb_state,
            this.selectBox,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_select",
                "_lb_name",
                "_lb_state",
                "selectBox",
            ])
    }
}
window["SeaAssertSBossItem"] = SeaAssertSBossItem