
import { ResManager } from '../common/ResManager';
import { SeaHegemonyModel } from '../commonModel/SeaHegemonyModel';
import { Enum_ColorUtil_Light } from '../util/ColorUtil';
import { GameResPath } from '../util/GameResPath';
import { TimeUtil } from '../util/TimeUtil';
import { GlobalTimerQuest, HtmlColorTxt, Util } from '../util/Util';
import { BaseItem1 } from './../common/BaseItem1';
export class SeaAssertLabelView extends BaseItem1 {
    Dispose
    InitEvent
    LoadSuccess
    initView
    onTimer
    removeTimer
    setData
    starTimer

    public constructor(parent?) {
        super(parent)

        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertLabelView"
        let _model: SeaHegemonyModel = SeaHegemonyModel.GetInstance()
        let id = null
        let refresh = false
        let timer = null
        let statue_time = 0
        let boss_time = 0

        this.preload_server_config = {
            config_sea_craft_daily_building: false,
        }


        this.load_callback = () => {

            this.InitEvent()
            this.LoadSuccess()
        }

        this.InitEvent = () => {
        }

        this.LoadSuccess = () => {
            if (refresh) {
                this.initView()
            }
        }

        this.Dispose = () => {
            this.removeTimer()
        }

        this.setData = (_id?) => {
            id = _id
            if (!this.is_loaded) {
                refresh = true
                return
            }
            this.initView()
        }

        this.initView = () => {
            if (!id) {
                return
            }
            let sp_name = "uisdbz_024"
            if (id == 2) {
                sp_name = "uisdbz_021"
            }
            else if (id == 3) {
                sp_name = "uisdbz_023"
            }
            else if (id == 4) {
                sp_name = "uisdbz_022"
            }
            // 判断是否是自己海域/占领
            let isSea: boolean = _model.seaHegemonyData?.camp == id

            ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("seaAssert", isSea ? sp_name + '_1' : sp_name))
            let view_data = _model.getAssertViewData(id)
            if (view_data) {
                let severTime = TimeUtil.getServerTime()
                if (view_data.statue_time > severTime) {
                    statue_time = view_data.statue_time - severTime
                }
                if (statue_time == 0) {
                    this._lb_state.text = "已刷新";
                    this._lb_state.color = '#A2FF00';
                } else {
                    this._lb_state.color = '#FF4C4C';
                    this._lb_state.text = TimeUtil.convertTime(statue_time);
                }
                if (view_data.boss_time > severTime) {
                    boss_time = view_data.boss_time - severTime
                }
                if (boss_time == 0) {
                    this._lb_state2.text = "已刷新";
                    this._lb_state2.color = '#A2FF00';
                } else {
                    this._lb_state2.color = '#FF4C4C';
                    this._lb_state2.text = TimeUtil.convertTime(boss_time);
                }
                if (statue_time > 0 || boss_time > 0) {
                    this.starTimer()
                }
                let brick_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_craft_daily_building", false)
                let info = _model.getBrickCfg(brick_cfg, view_data.brick_num)
                if (info) {
                    let state = _model.getBrickState(info.status)
                    let exp = ""
                    // [ts2lua]lua中0和空字符串也是true，此处info.exp_ratio > 0需要确认
                    let buff = info.exp_ratio > 0 ? `掉率+${info.exp_ratio / 100}%` : ''; //(info.exp_ratio > 0 && (HtmlColorTxt("掉率+" + info.exp_ratio / 100 + " % ", Enum_ColorUtil_Light.GREEN)) || (""))
                    this._lb_state3.text = state + exp + buff;
                }
                let guild_data = _model.GetAssertGuildData(id)
                if (guild_data) {
                    // [ts2lua]lua中0和空字符串也是true，此处guild_data.guild_name == ""需要确认
                    let name = (guild_data.guild_name == "" && ("虚位以待") || (guild_data.guild_name))
                    this._lb_guild.text = name;
                }
            }
        }

        this.starTimer = () => {
            if (!timer) {
                timer = GlobalTimerQuest.AddPeriodQuest(() => {
                    this.onTimer()
                }, 1)
            }
        }

        this.onTimer = () => {
            if (statue_time >= 0) {
                statue_time = statue_time - 1
                if (statue_time <= 0) {
                    this._lb_state.text = "已刷新";
                    this._lb_state.color = '#A2FF00';
                } else {
                    this._lb_state.color = '#FF4C4C';
                    this._lb_state.text = TimeUtil.convertTime(statue_time);
                }
            }
            if (boss_time >= 0) {
                boss_time = boss_time - 1
                if (boss_time <= 0) {
                    this._lb_state2.text = "已刷新";
                    this._lb_state2.color = '#A2FF00';
                } else {
                    this._lb_state2.color = '#FF4C4C';
                    this._lb_state2.text = TimeUtil.convertTime(boss_time);
                }
            }
            if (statue_time < 0 && boss_time < 0) {
                this.removeTimer()
            }
        }

        this.removeTimer = () => {
            if (timer) {
                GlobalTimerQuest.CancelQuest(timer)
                timer = null
            }
        }
    }

    public DeleteMe() {

        this.Dispose()
        super.DeleteMe()
    }

    _img_title: Laya.Image
    _Image1: Laya.Image
    _lb_guild: Laya.Label
    _lb_state: Laya.Label
    _lb_state2: Laya.Label
    _lb_state3: Laya.Label
    public GetComponents() {
        [
            this._img_title,
            this._Image1,
            this._lb_guild,
            this._lb_state,
            this._lb_state2,
            this._lb_state3,
        ]
            = this.GetChildrenByNames([

                "_img_title",
                "_Image1",
                "_lb_guild",
                "_lb_state",
                "_lb_state2",
                "_lb_state3",
            ])
    }
}
window["SeaAssertLabelView"] = SeaAssertLabelView