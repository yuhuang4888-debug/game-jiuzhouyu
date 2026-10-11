
//require("game.topPk.TopPkBuyCountView")
//require("game.topPk.TopPkDailyRewardView")
//require("game.topPk.TopPkEnterRankItem")
//require("game.topPk.TopPkEnterView")
//require("game.topPk.TopPkFightSceneView")
//require("game.topPk.TopPkLevelRewardView")
//require("game.topPk.TopPkMatchSuccessView")
//require("game.topPk.TopPkMatchView")
//require("game.topPk.TopPkModel")
//require("game.topPk.TopPkRankRewardView")
//require("game.topPk.TopPkResultView")
//require("game.topPk.TopPkRewardView")
//require("game.topPk.TopPkDefine")
//require("game.topPk.TopPkDailyRewardItem")
//require("game.topPk.TopPkLevelRewardItem")
//require("game.topPk.TopPkRankRewardItem")
//require("game.topPk.TopPkRewardTabItem")
//require("game.baseEnterView.WorldBattleEnterView")
//require("game.baseEnterView.BattleFieldEnterView")

import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { TopPkDefine, TopPkModel } from "../commonModel/TopPkModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { MainUIController } from "./MainUIController"
import "../topPk/TopPkBuyCountView"
import "../topPk/TopPkDailyRewardView"
import "../topPk/TopPkFightSceneView"
import "../topPk/TopPkLevelRewardView"
import "../topPk/TopPkMatchSuccessView"
import "../topPk/TopPkMatchView"
import "../topPk/TopPkRankRewardView"
import "../topPk/TopPkResultView"
import "../topPk/TopPkRewardView"
// import "../baseEnterView/WorldBattleEnterView"

//require("game.proto.281.Require281")
export class TopPkController extends BaseController {
    Init

    public constructor() {
        super()


        this.Init = () => {
            let _global_event_system = GlobalEventSystem
            let _model = TopPkModel.GetInstance()
            let _view_dic = []
            let local_TopPkModel = TopPkModel
            let local_EventName = EventName
            let role_mgr = RoleManager.GetInstance()
            let local_TopPkDefine = TopPkDefine
            let local_ServerTimeModel = ServerTimeModel

            let user_msg_adapter = UserMsgAdapter.GetInstance()
            let scene_mgr = SceneManager.GetInstance()
            let auto_fight_mgr = AutoFightManager.GetInstance()
            let request_data = () => {
                _model.Fire(local_TopPkModel.REQUEST_SCMD, 28101)
                _model.Fire(local_TopPkModel.REQUEST_SCMD, 28105)
                _model.Fire(local_TopPkModel.REQUEST_SCMD, 28107)
            }

            _global_event_system.Bind(local_EventName.GAME_START, () => {
                
                _model.ResetData()
                let delay_fun = () => {
                    _model.InitCfg()
                    request_data()
                }
                setTimeout(delay_fun, 3000)
            }
            )
            let get_time = false
            let try_check_done = () => {
                if (get_time) {
                    request_data()
                    if (!_model.GetOpenState()) {
                        let level_id = null
                        level_id = role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, (level?) => {
                            if (level == TopPkDefine.OPEN_LV) {
                                request_data()
                                role_mgr.GetMainRoleVo().UnBind(level_id)
                            }
                        }
                        )
                    }
                }
            }

            let time_id = _global_event_system.Bind(local_ServerTimeModel.REFRESH_SERVER_TIME, () => {
                _global_event_system.UnBind(time_id)
                get_time = true
                try_check_done()
            }
            )
            _global_event_system.Bind(local_ServerTimeModel.DAY_CHANGE, () => {
                _model.change_day = true
                request_data()
            }
            )
            let onRequestHandler = (cmd, ...new_args) => {
                let args = new_args
                if (28103 == cmd) {
                    this.SendFmtToGame(cmd, "c", args[0])
                } else if (28106 == cmd) {
                    this.SendFmtToGame(cmd, "c", args[0])
                } else if (28104 == cmd) {
                    this.SendFmtToGame(cmd, "h", args[0])
                } else {
                    this.SendFmtToGame(cmd)
                }
            }

            _model.Bind(local_TopPkModel.REQUEST_SCMD, onRequestHandler)
            _model.Bind(local_TopPkModel.OPEN_VIEW, (view_name: string, ...new_args) => {
                // [ts2lua]_view_dic下标访问可能不正确
                let view = _view_dic[view_name]
                if (!view) {
                    _view_dic[view_name] = true
                    if (_view_dic[view_name] == true) {
                        // [ts2lua]window下标访问可能不正确
                        let view_class = window[view_name]
                        view = new view_class()
                        // [ts2lua]_view_dic下标访问可能不正确
                        _view_dic[view_name] = view
                    }
                }
                if (view && !view.HasOpen()) {
                    view.Open(...new_args)
                }
            }
            )
            _model.Bind(local_TopPkModel.CLOSE_VIEW, (view_name?) => {
                // [ts2lua]_view_dic下标访问可能不正确
                let view = _view_dic[view_name]
                if (view) {
                    if (view != true && view.HasOpen()) {
                        view.Close()
                    }
                    // [ts2lua]_view_dic下标访问可能不正确
                    _view_dic[view_name] = null
                }
            }
            )
            let On28100 = () => {
                let scmd = user_msg_adapter.GetSCMD(28100)
                Util.ErrorCodeShow(scmd.code, scmd.args)
            }

            let On28101 = () => {
                let scmd = user_msg_adapter.GetSCMD(28101)
                _model.ChangeVar("season_data", { season_count: scmd.season_count, season_num: scmd.season_num, season_end_time: scmd.season_end_time, season_win_count: scmd.season_win_count })
                _model.ChangeVar("level_data", { rank_lv: scmd.rank_lv, point: scmd.point })
                _model.ChangeVar("daily_count_data", { daily_buy_count: scmd.daily_buy_count, daily_count: scmd.daily_count, daily_reward_counts: scmd.daily_reward_counts })
                _model.RefreshDailyCountRed()
                _model.ChangeVar("daily_reward_data", { honor_is_got: scmd.honor_is_got, daily_honor_value: scmd.daily_honor_value, yesterday_rank_lv: scmd.yesterday_rank_lv })
                _model.RefreshDailyRewardRed()
            }

            let On28102 = () => {
                let scmd = user_msg_adapter.GetSCMD(28102)
                let daily_reward_data = _model.daily_reward_data
                if (daily_reward_data) {
                    daily_reward_data.honor_is_got = 0
                }
                _model.ChangeVar("daily_reward_data", daily_reward_data, false, true)
                _model.RefreshDailyRewardRed()
                Util.ShowCongratulationView(scmd.reward_obj_list)
            }

            let On28103 = () => {
                let scmd = user_msg_adapter.GetSCMD(28103)
                let daily_count_data = _model.daily_count_data
                if (daily_count_data) {
                    for (let _tmpi in daily_count_data.daily_reward_counts) {
                        var vo = daily_count_data.daily_reward_counts[_tmpi]
                        if (vo.count == scmd.count) {
                            vo.state = 0
                            break
                        }
                    }
                    _model.ChangeVar("daily_count_data", daily_count_data, false, true)
                    _model.RefreshDailyCountRed()
                }
                _model.Fire(local_TopPkModel.GET_DAILY_COUNT_REWARD, scmd)
            }

            let On28104 = () => {
                let scmd = user_msg_adapter.GetSCMD(28104)
                Message.show("购买成功")
                let daily_count_data = _model.daily_count_data
                if (daily_count_data) {
                    daily_count_data.daily_buy_count = scmd.daily_buy_count
                    _model.ChangeVar("daily_count_data", daily_count_data, false, true)
                }
            }

            let On28105 = () => {
                let scmd = user_msg_adapter.GetSCMD(28105)
                _model.ChangeVar("level_reward_data", scmd)
                _model.RefreshLevelRewardRed()
            }

            let On28106 = () => {
                let scmd = user_msg_adapter.GetSCMD(28106)
                let level_reward_data = _model.level_reward_data
                if (level_reward_data) {
                    for (let _tmpi in level_reward_data.got_list) {
                        var value = level_reward_data.got_list[_tmpi]
                        if (value && value.rank_lv == scmd.rank_lv) {
                            value.state = 0
                            break
                        }
                    }
                    _model.ChangeVar("level_reward_data", level_reward_data, false, true)
                    _model.RefreshLevelRewardRed()
                }
                Util.ShowCongratulationView(scmd.reward_obj_list)
            }

            let On28107 = () => {
                let scmd = user_msg_adapter.GetSCMD(28107)
                _model.ChangeVar("act_state_data", scmd)
                if (_model.GetOpenState()) {
                    _model.SetRedFlag(local_TopPkModel.RedFlag.Act_Open, scmd.state == 1)
                    if (scmd.state == 0) {
                        _model.ChangeVar("auto_match_state", false)
                    }
                }
            }

            let On28110 = () => {
                let scmd = user_msg_adapter.GetSCMD(28110)
                if (scmd.res == 1) {
                    _model.Fire(local_TopPkModel.OPEN_VIEW, "TopPkMatchView")
                } else {
                    Util.ErrorCodeShow(scmd.res)
                }
            }

            let On28111 = () => {
                let scmd = user_msg_adapter.GetSCMD(28111)
                _model.ChangeVar("match_data", scmd)
                _model.Fire(local_TopPkModel.CLOSE_VIEW, "TopPkMatchView")
            }

            let On28112 = () => {
                let scmd = user_msg_adapter.GetSCMD(28112)
                if (1 == scmd.stage) {
                    _model.ChangeVar("fight_start_time", scmd.time)
                } else if (2 == scmd.stage) {
                    _model.ChangeVar("fight_end_time", scmd.time)
                } else if (3 == scmd.stage) {
                    _model.ChangeVar("quit_scene_time", scmd.time)
                }
            }

            let On28113 = () => {
                let scmd = user_msg_adapter.GetSCMD(28113)
                //let cfgs = Config.Toppkrankreward
                ResManager.GetInstance().GetGameConfigWithAutoDestory("config_top_pk_rank_reward", (cfgs?) => {
                    let daily_count_data = _model.daily_count_data
                    if (daily_count_data) {
                        daily_count_data.daily_count = daily_count_data.daily_count + 1
                        for (let _tmpi in daily_count_data.daily_reward_counts) {
                            var obj = daily_count_data.daily_reward_counts[_tmpi]
                            if (daily_count_data.daily_count >= obj.count) {
                                if (obj.state == 1) {
                                    obj.state = 2
                                }
                            }
                        }
                        _model.ChangeVar("daily_count_data", daily_count_data, false, true)
                        _model.RefreshDailyCountRed()
                        let left_count = daily_count_data.daily_buy_count + TopPkDefine.DAILY_MATCH_COUNT - daily_count_data.daily_count
                        if (left_count <= 0 && _model.auto_match_state) {
                            _model.ChangeVar("auto_match_state", false)
                        }
                        let level_data = _model.level_data
                        if (level_data) {
                            // [ts2lua]scmd下标访问可能不正确
                            scmd["old_rank_lv"] = level_data.rank_lv
                            // [ts2lua]scmd下标访问可能不正确
                            scmd["old_point"] = level_data.point
                            if (scmd.flag == 1) {
                                level_data.point = level_data.point + scmd.point
                            } else {
                                let point = level_data.point - scmd.point
                                level_data.point = Math.max(point, 0)
                            }
                            let [now_rank_lv, now_point] = _model.TurnRankLvByPoint(level_data.rank_lv, level_data.point, cfgs)
                            level_data.point = now_point
                            level_data.rank_lv = now_rank_lv
                            // [ts2lua]scmd下标访问可能不正确
                            scmd["now_rank_lv"] = now_rank_lv
                            // [ts2lua]scmd下标访问可能不正确
                            scmd["now_point"] = now_point
                            _model.ChangeVar("level_data", level_data, false, true)
                            if (scene_mgr.IsTopPkScene()) {
                                auto_fight_mgr.SetAutoFight(false)
                            }
                        }
                        _model.RefreshLevelRewardState()
                        _model.RefreshLevelRewardRed()
                    }
                    _model.Fire(local_TopPkModel.OPEN_VIEW, "TopPkResultView", scmd)

                }
                    , false)

            }

            let On28114 = () => {
                let scmd = user_msg_adapter.GetSCMD(28114)
                if (scmd.res) {
                    _model.Fire(local_TopPkModel.CLOSE_VIEW, "TopPkMatchView")
                    if (_model.auto_match_state) {
                        _model.ChangeVar("auto_match_state", false)
                    }
                }
            }

            let On28115 = () => {
                let scmd = user_msg_adapter.GetSCMD(28115)
                _model.ChangeVar("rank_data", scmd)
            }

            let On28116 = () => {
                let scmd = user_msg_adapter.GetSCMD(28116)
            }

            let On28117 = () => {
                let scmd = user_msg_adapter.GetSCMD(28117)
            }

            let setMainUIVisible = (bool?) => {
                let mainUI_controller = MainUIController.GetInstance()
                mainUI_controller.SetMainUIViewVisible(0, bool)
                mainUI_controller.SetMainUIViewVisible(1, bool)
                mainUI_controller.SetMainUIViewVisible(2, bool)
                mainUI_controller.SetMainUIViewVisible(5, bool)
                mainUI_controller.SetMainUIViewVisible(11, bool)
                mainUI_controller.SetHeadVisible(bool)
                mainUI_controller.SetMapVisible(bool)
                mainUI_controller.SetCareerLevelVisible(bool)
            }

            _global_event_system.Bind(SceneEventType.SCENE_CHANGED, () => {
                if (scene_mgr.IsTopPkScene() && !scene_mgr.IsTopPkScene(scene_mgr.GetLastSceneId())) {
                    setMainUIVisible(false)
                    auto_fight_mgr.SetAutoFight(false)
                    _model.Fire(local_TopPkModel.OPEN_VIEW, "TopPkFightSceneView")
                } else if (!scene_mgr.IsTopPkScene() && scene_mgr.IsTopPkScene(scene_mgr.GetLastSceneId())) {
                    setMainUIVisible(true)
                    _model.ResetFightData()
                    _model.Fire(local_TopPkModel.CLOSE_VIEW, "TopPkFightSceneView")
                    _model.Fire(local_TopPkModel.CLOSE_VIEW, "TopPkMatchSuccessView")
                    auto_fight_mgr.SetAutoFight(true)
                    //TopPkModel:GetInstance():OpenTopView()
                }
                if (scene_mgr.IsTopPkScene() && !scene_mgr.IsTopPkScene(scene_mgr.GetLastSceneId())) {
                    _model.Fire(local_TopPkModel.OPEN_VIEW, "TopPkMatchSuccessView")
                } else if (!scene_mgr.IsTopPkScene() && scene_mgr.IsTopPkScene(scene_mgr.GetLastSceneId())) {
                    setTimeout(() => {
                        TopPkModel.GetInstance().OpenTopView()
                    }, 1000);
                    
                }
            }
            )
            _global_event_system.Bind(local_EventName.SCENELOADVIEWE_CLOSE, () => {
                // if (scene_mgr.IsTopPkScene() && !scene_mgr.IsTopPkScene(scene_mgr.GetLastSceneId())) {
                //     _model.Fire(local_TopPkModel.OPEN_VIEW, "TopPkMatchSuccessView")
                // } else if (!scene_mgr.IsTopPkScene() && scene_mgr.IsTopPkScene(scene_mgr.GetLastSceneId())) {
                //     TopPkModel.GetInstance().OpenTopView()
                // }
            }
            )
            this.RegisterProtocal(28100, On28100)
            this.RegisterProtocal(28101, On28101)
            this.RegisterProtocal(28102, On28102)
            this.RegisterProtocal(28103, On28103)
            this.RegisterProtocal(28104, On28104)
            this.RegisterProtocal(28105, On28105)
            this.RegisterProtocal(28106, On28106)
            this.RegisterProtocal(28107, On28107)
            this.RegisterProtocal(28110, On28110)
            this.RegisterProtocal(28111, On28111)
            this.RegisterProtocal(28112, On28112)
            this.RegisterProtocal(28113, On28113)
            this.RegisterProtocal(28114, On28114)
            this.RegisterProtocal(28115, On28115)
            this.RegisterProtocal(28116, On28116)
            this.RegisterProtocal(28117, On28117)
        }

        this.Init()
    }

}
window["TopPkController"] = TopPkController