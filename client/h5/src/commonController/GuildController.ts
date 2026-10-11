import { AutoFightManager } from '../autofight/AutoFightManager';
import { BaseController } from '../common/BaseController';
import { CommonManager } from '../common/CommonManager';
import { Config } from '../common/Config';
import { CongratulationObtainView } from '../common/CongratulationObtainView';
import { EventName } from '../common/EventName';
import { ResManager } from '../common/ResManager';
import { table } from '../common/table';
import { UserMsgAdapter } from '../common/UserMsgAdapter';
import { GoodsModel } from '../commonModel/GoodsModel';
import { GuildEvent, GuildModel, GuildOrder, GuildDefine } from '../commonModel/GuildModel';
import { MainFunc } from '../commonModel/MainUIModel';
import { RoleManager } from '../commonModel/RoleManager';
import { SceneManager } from '../scene/SceneManager';
import { ServerTimeModel } from '../serverTime/ServerTimeModel';
import { Message } from '../sysInfo/SysInfoController';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { ErlangParser } from '../util/ErlangParser';
import { Util, LoadLuaClassAB, LoadLuaConfigAB, NotEnougnDiamond } from '../util/Util';
import { MainUIController } from './MainUIController';
import { RedPacketModel } from '../commonModel/RedPacketModel';
import { ChatModel } from '../commonModel/ChatModel';
import '../guild/GuildJoinBaseView';
import '../guild/GuildJoinView';
import '../guild/GuildBuildView';
import '../guild/GuildMainBaseView';
import '../guild/GuildApplySetView';
import '../guild/GuildApplyLookView';
import '../guild/GuildGiftView';
import '../evening/EveningMainBaseView';
import '../guild/GuildSkillBaseView';
import '../guild/GuildDepotBaseView';
import '../guild/GuildBoardView';
import '../guild/GuildIdolBaseView';
import '../guild/GuildCleanView';
import '../guild/GuildDepotSelectView';
import '../guild/GuildRBSendView';
import '../guild/GuildMemberItem';
import '../guild/GuildMemberView';
import '../guild/GuildRoleMenuView';
import '../guildList/GuildListView';
import '../guild/GuildMainView';
import '../guild/GuildHelpView';
import '../guild/GuildHelpItem';
import '../guild/GuildHelpTipsView';
import '../guild/GuildIntroView';
import '../guild/GuildIntroItem';
import '../guildIdol/GuildIdolAttrItem';
import '../guildIdol/GuildIdolAwakenItem';
import '../guildIdol/GuildIdolMainAwaken';
import '../guildIdol/GuildIdolMainAct';
import '../guildIdol/GuildIdolMainItem';
import '../guildIdol/GuildIdolMainRune';
import '../guildIdol/GuildIdolMainRuneItem';
import '../guildIdol/GuildIdolMainTab';
import '../guildIdol/GuildIdolMainView';
import '../guildIdol/GuildIdolRuneActItem';
import '../guildIdol/GuildIdolRuneActView';
import '../guildIdol/GuildIdolRuneDecItem';
import '../guildIdol/GuildIdolRuneDecomposeView';
import '../guildIdol/GuildIdolRuneMasterItem';
import '../guildIdol/GuildIdolRuneMasterView';
import '../guildIdol/GuildIdolRuneSelItem';
import '../guildIdol/GuildIdolRuneShowAttr';
import '../guildIdol/GuildIdolRuneShowAttr2';
import '../guildIdol/GuildIdolRuneSmallItem';
import '../guildIdol/GuildIdolShowItem';
import '../guildIdol/GuildIdolRuneSelView';
import '../snatchTreasure/SnatchTreasureRankView';
import { Alert, Alert_Type } from '../alert/Alert';
import { RedDotController } from '../common/RedDotController';
import { RedKey } from '../common/RedDotDefine';

export class GuildController extends BaseController {
    view_dic;
    role_mgr: RoleManager;
    user_msg_adapter: UserMsgAdapter;
    erlangParser: ErlangParser;
    goods_model: GoodsModel;
    model: GuildModel;
    resManager_model: ResManager;
    /** 合并公会操作类型 1:同意 2:拒绝 */
    op: number;
    public constructor() {
        super();
        this.view_dic = [];

        this.role_mgr = RoleManager.GetInstance();
        this.user_msg_adapter = UserMsgAdapter.GetInstance();
        // let guild_activity_model = GuildActivityModel.GetInstance()
        // let local_GuildActEvent = GuildActEvent
        this.erlangParser = ErlangParser.GetInstance();
        this.goods_model = GoodsModel.GetInstance();
        this.model = GuildModel.GetInstance();
        this.resManager_model = ResManager.GetInstance();

        this.InitInfo();
        this.InitEvent();
    }

    InitEvent() {
        this.model.Bind(GuildEvent.REQUEST_PROTO, this.SendFmtToGame.bind(this));
        this.model.Bind(GuildEvent.REQUEST_40004, (id, fmt, ...new_args) => {
            if (!this.CheckGuildName(new_args)) {
                return;
            }
            this.SendFmtToGame(id, fmt, ...new_args);
        });
        this.model.Bind(GuildEvent.REQUEST_40006, (id, fmt, ...new_args) => {
            this.SendFmtToGameImme(id, fmt, ...new_args);
        });
        this.model.Bind(GuildEvent.REQUEST_40063, (fmt, op, ...new_args) => {
            this.op = op;
            this.SendFmtToGame(40063, fmt, op, ...new_args);
        });
        this.model.Bind(GuildEvent.REQUEST_40102, (donate_list?) => {
            this.WriteBegin(40102);
            this.WriteFMT('h', donate_list.length);
            for (let donateItem of donate_list) {
                let { goods_id, num } = donateItem;
                this.WriteFMT('l', goods_id);
                this.WriteFMT('i', num);
            }
            this.SendToGame();
        });
        this.model.Bind(GuildEvent.REQUEST_40104, (goods_ids?) => {
            if (goods_ids.length == 0) {
                Message.show('没有需要清理的装备');
                return;
            }
            this.WriteBegin(40104);
            this.WriteFMT('h', goods_ids.length);
            for (let _tmpi in goods_ids) {
                let id = goods_ids[_tmpi];
                this.WriteFMT('l', id);
            }
            this.SendToGame();
        });
        this.model.Bind(GuildEvent.OPEN_VIEW, (view_name: string, ...new_args) => {
            let parms_ = new_args;
            let callback = () => {
                let view = this.view_dic[view_name];
                if (!view) {
                    let view_class = window[view_name];
                    view = new view_class();
                    this.view_dic[view_name] = view;
                }
                if (view) {
                    view.Open(parms_);
                }
            };
            LoadLuaClassAB(view_name, callback);
        });
        this.model.Bind(GuildEvent.CLOSE_VIEW, (view_name?) => {
            // [ts2lua]this.view_dic下标访问可能不正确
            let view = this.view_dic[view_name];
            if (view) {
                if (view.HasOpen()) {
                    view.Close();
                }
                // [ts2lua]this.view_dic下标访问可能不正确
                this.view_dic[view_name] = null;
            }
        });
        this.goods_model.Bind(GoodsModel.CHANGE_BAG_LIST, () => {
            this.model.setActRed();
            this.model.setAwakenRed();
            this.model.setRuneRed();
        });
        this.goods_model.Bind(GoodsModel.CHANGE_GUILD_RUNE_LIST, () => {
            this.model.setRuneRed();
        });
        this.goods_model.Bind(GoodsModel.CHANGE_EQUIPLIST, () => {
            this.model.CheckExchangeRed();
        });

        GlobalEventSystem.Bind(EventName.INIT_CONFIG, () => {
            this.model.InitConfig();
        });
        GlobalEventSystem.Bind(EventName.GAME_START, () => {
            this.model.Reset();
            let main_vo = this.role_mgr.GetMainRoleVo();
            this.model.CheckApplyRedMask()
            if (main_vo.guild_id > 0) {
                setTimeout(() => {
                    this.RequestBaseInfo();
                }, 1);
            } else {
                // let can_open = CommonManager.GetInstance().CheckFuncOpenState('GuildJoinBaseView', true);
                // if (can_open) {
                //     this.model.apply_red_mark = false;
                // }
            }
        });
        this.role_mgr.GetMainRoleVo().BindOne('guild_id', (type?, value?, old_value?) => {
            this.model.CheckApplyRedMask()
            if (old_value == 0) {
                this.RequestBaseInfo();
                this.model.Fire(GuildEvent.CLOSE_VIEW, 'GuildJoinBaseView');
                this.model.Fire(GuildEvent.CLOSE_VIEW, 'GuildListView');
                this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildMainBaseView');
            } else {
                if (value == 0) {
                    this.model.Reset();
                    RedPacketModel.GetInstance().Reset();
                }
            }
            GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
            this.model.Fire(GuildEvent.UPDATE_BASE_RED_STATUS);
            this.model.Fire(GuildEvent.CHANGED_CONDS_ASSIST);
        });
        GlobalEventSystem.Bind(SceneManager.START, () => {
            this.ChangeScene();
        });
        this.role_mgr.GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, () => {
            this.model.Fire(GuildEvent.CHANGED_CONDS_ASSIST);
            this.model.CheckExchangeRed();
            GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
            this.reqRewardBox();
            this.RequestGuildIdol();
            this.model.CheckApplyRedMask()
        });
        GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
            this.model.Fire(GuildEvent.CHANGED_CONDS_ASSIST);
            this.RequestGuildIdol();
            this.model.CheckApplyRedMask()
        });
        GlobalEventSystem.Bind(ServerTimeModel.REFRESH_SERVER_TIME, () => {
            this.model.Fire(GuildEvent.CHANGED_CONDS_ASSIST);
        })

        GlobalEventSystem.Bind(ServerTimeModel.HOUR_REFRESH, (h?) => {
            if (h == 4) {
                setTimeout(() => {
                    this.reqRewardBox();
                }, 5);
            }
        });
    }
    CheckGuildName(args) {
        let [type, text] = args;
        return this.CheckInput(text) && this.CheckDiamond(type);
    }

    CheckDiamond(type) {
        let ndata = this.model.GetGuildKVCfg(type == 1 ? 13 : 12);
        ndata = JSON.parse(ndata)[0];
        let own = GoodsModel.GetInstance().GetRoleSpecGoodsNum(ndata[0], ndata[1]);
        let enough = own >= Number(ndata[2]);
        if (RoleManager.GetInstance().GetMainRoleVo().level < GuildDefine.GUILD_BUILD_LV) {
            Message.show('等级不足');
            return false;
        }
        if (!enough) {
            if (type == 1) {
                NotEnougnDiamond();
            } else {
                Message.show('绑玉不足');
            }
            return false;
        }
        return true;
    }

    CheckInput(text) {
        let maxText = this.model.GetGuildKVCfg(8);
        if (text.length > maxText) {
            Message.show(`结社名不能超过${maxText}个字`);
            return false;
        }
        if (text.length < 1) {
            Message.show('结社名不能为空');
            return false;
        }
        return true;
    }

    ChangeScene() {
        let scene_mgr = SceneManager.Instance;
        if (scene_mgr.IsGuildExploreScene() && !scene_mgr.IsGuildExploreScene(scene_mgr.GetLastSceneId())) {
            AutoFightManager.GetInstance().SetAutoFight(false);
            this.SetMainUIVisible(false);
            this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildExploreSceneView');
        } else if (!scene_mgr.IsGuildExploreScene() && scene_mgr.IsGuildExploreScene(scene_mgr.GetLastSceneId())) {
            AutoFightManager.GetInstance().SetAutoFight(true);
            this.SetMainUIVisible(true);
            this.model.Fire(GuildEvent.CLOSE_VIEW, 'GuildExploreSceneView');
            this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildExploreBaseView');
        }
    }

    SetMainUIVisible(bool?) {
        let mainUI_controller = MainUIController.GetInstance();
        mainUI_controller.SetMainUIViewVisible(1, bool);
        mainUI_controller.SetMainUIViewVisible(2, bool);
        mainUI_controller.SetMainUIViewVisible(5, bool);
        mainUI_controller.SetHeadVisible(bool);
    }

    RequestBaseInfo() {
        this.SendFmtToGame(40005); //请求结社基本信息
        this.SendFmtToGame(40021); //请求权限
        this.SendFmtToGame(40023); //捐献
        this.SendFmtToGame(40040, 'c', 1); //请求技能
        this.SendFmtToGame(33901); //红会红包
        this.SendFmtToGame(40231); //结社守卫
        this.reqRewardBox(); //结社宝箱
        this.RequestGuildIdol(); //武魂信息
        this.SendFmtToGame(40030); //玩家声望信息
        this.SendFmtToGame(40405); //求助列表信息
        this.SendFmtToGame(11016, 'hh', 400, 1);
        this.SendFmtToGame(40101);
        this.SendFmtToGame(40015); //请求结社申请列表
        this.SendFmtToGame(40061); //请求合并公会列表
    }

    RequestGuildIdol() {
        let is_open = this.model.GuildIdolIsOpen();
        if (is_open) {
            this.SendFmtToGame(40501); //武魂信息
        }
    }

    reqRewardBox() {
        let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition;
        let box_cfg = cfg['GuildRewardBoxView'];
        if (box_cfg && !this.model._rewardBoxViewData) {
            let lev = this.role_mgr.GetMainRoleVo().level;
            let open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
            if (lev >= box_cfg.open_lv && open_day >= box_cfg.open_day && RoleManager.GetInstance().GetMainRoleVo().guild_id > 0) {
                this.SendFmtToGame(40301);
            }
        }
    }

    InitInfo() {
        let on40000 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40000);
            Util.ErrorCodeShow(scmd.error_code);
        };

        let on40001 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40001);
            table.sort(scmd.guild_list, (a?, b?) => {
                if (a.guild_lv == b.guild_lv) {
                    return a.guild_id < b.guild_id;
                } else {
                    return b.guild_lv < a.guild_lv;
                }
            });
            this.model.Fire(GuildEvent.UPDATE_JION_LIST, scmd.guild_list);
        };

        let on40002 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40002);
            if (scmd.error_code == 1) {
                if (scmd.apply_type == 1) {
                    Message.show('已发出申请，请耐心等待');
                    this.model.Fire(GuildEvent.APPLY_APPROVE, scmd.guild_id);
                } else if (scmd.apply_type == 2) {
                    Message.show('恭喜成功加入结社');
                    // guild_activity_model.Fire(local_GuildActEvent.REQUEST_PROTO, 40211)
                }
                this.SendFmtToGame(15718);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40003 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40003);
            if (scmd.error_code == 1) {
                if (scmd.guild_id != 0) {
                    this.model.apply_red_mark =false
                    // guild_activity_model.Fire(local_GuildActEvent.REQUEST_PROTO, 40211)
                    this.role_mgr.GetMainRoleVo().ChangeVar('guild_id', scmd.guild_id);
                } else {
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40001, 'shh', '', 999, 1);
                }
                this.SendFmtToGame(15718);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40004 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40004);
            if (scmd.error_code == 1) {
                Message.show('创建结社成功');
                // guild_activity_model.Fire(local_GuildActEvent.REQUEST_PROTO, 40211)
                this.role_mgr.GetMainRoleVo().ChangeVar('position', 1);
                this.role_mgr.GetMainRoleVo().ChangeVar('guild_id', scmd.guild_id);
                this.SendFmtToGame(15718);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40005 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40005);
            let ginfo = this.model.GetGuildInfo();
            if (!ginfo) {
                ChatModel.GetInstance().GuildChat(scmd.announce); //  屏蔽聊天模块
            }
            this.model.SetActivity(scmd.gactivity);
            this.model.SetFunds(scmd.gfunds);
            this.model.SetGuildInfo(scmd);
        };

        let on40006 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40006);
            let role_id = this.role_mgr.GetMainRoleId();
            scmd.member_list.sort((a?, b?) => {
                if (role_id == a.role_id) {
                    return -1;
                } else if (role_id == b.role_id) {
                    return 1;
                } else {
                    if (a.online_flag != b.online_flag) {
                        return b.online_flag - a.online_flag;
                    } else {
                        if (a.position != b.position) {
                            return GuildOrder[a.position] - GuildOrder[b.position];
                        } else {
                            return a.level - b.level;
                        }
                    }
                }
            });
            this.model.SetMemberInfo(scmd);
        };

        let on40007 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40007);
            if (scmd.error_code == 1) {
                this.role_mgr.GetMainRoleVo().ChangeVar('guild_id', 0);
                this.role_mgr.GetMainRoleVo().ChangeVar('guild_name', '');
                this.model.Fire(GuildEvent.CLOSE_VIEW, 'GuildMainBaseView');
                this.model.Reset();
                GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
                Message.show('成功退出结社');
                this.SendFmtToGame(15718);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40008 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40008);
            this.model.SetApplyInfo(scmd);
            if (this.model.apply_request_mark) {
                this.model.apply_request_mark = false;
                if (scmd.apply_list.length > 0) {
                    this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildApplyLookView');
                } else {
                    Message.show('当前没有申请信息');
                }
            }
        };

        let on40009 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40009);
            if (scmd.error_code == 1) {
                let apply_info = this.model.GetApplyInfo();
                if (!apply_info) {
                    return;
                }
                let i = 0;

                if (apply_info.apply_list && apply_info.apply_list.length > 0) {
                    do {
                        let info = apply_info.apply_list[i];
                        if (info.role_id == scmd.role_id) {
                            apply_info.apply_list.splice(i, 2);
                            break;
                        }
                        i = i + 1;
                    } while (i < apply_info.apply_list.length);
                }

                this.model.SetApplyInfo(apply_info);
                this.SendFmtToGame(11016, 'hh', 400, 1);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40010 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40010);
            this.model.Fire(GuildEvent.GET_APPLY_SETTING, scmd);
        };

        let on40011 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40011);
            if (scmd.error_code == 1) {
                Message.show('设置成功');
                this.model.Fire(GuildEvent.CLOSE_VIEW, 'GuildApplySetView');
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40012 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40012);
            if (scmd.error_code == 1) {
                let info = this.model.GetGuildInfo();
                if (!info) {
                    return;
                }
                this.SendFmtToGame(40005);
                Message.show('修改成功');
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40013 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40013);
            if (scmd.error_code == 1) {
                this.SendFmtToGame(40006);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40014 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40014);
            if (scmd.error_code == 1) {
                this.SendFmtToGame(40006);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40015 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40015);
            let main_vo = this.role_mgr.GetMainRoleVo();
            if (main_vo) {
                main_vo.ChangeVar('guild_id', scmd.guild_id);
                main_vo.ChangeVar('guild_name', scmd.guild_name);
                main_vo.ChangeVar('position', scmd.position);
                main_vo.ChangeVar('position_name', scmd.position_name);
                this.SendFmtToGame(11016, 'hh', 400, 1);

                switch (scmd.position) {
                    case 3:
                        RedDotController.ins.up(RedKey.GUILD_APPLY, false);
                        GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
                        break;
                    case 1: //会长
                    case 2: //副会长
                    case 4: //宝贝
                        this.SendFmtToGame(40008);
                        break;
                }
            }
        };

        let on40016 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40016);
            if (scmd.error_code == 1) {
                this.SendFmtToGame(40006);
                Message.show('操作成功');
                let apply_info = this.model.GetApplyInfo();
                if (!apply_info) {
                    return;
                }
                apply_info.apply_list = [];
                this.model.SetApplyInfo(apply_info);
                this.SendFmtToGame(11016, 'hh', 400, 1);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40017 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40017);
            let main_vo = SceneManager.GetInstance().GetRoleVo(scmd.role_id);
            if (main_vo) {
                main_vo.ChangeVar('guild_id', scmd.guild_id);
                main_vo.ChangeVar('guild_name', scmd.guild_name);
                main_vo.ChangeVar('position', scmd.position);
                main_vo.ChangeVar('position_name', scmd.position_name);
            }
        };

        let on40018 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40018);
            if (scmd.error_code == 1) {
                this.SendFmtToGame(40005);
                GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40019 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40019);
        };

        let on40020 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40020);
            ResManager.GetInstance().LoadGameConfig(this, 'config_guild_prestige', false, null, (cfg) => {
                if (scmd.error_code == 1) {
                    Message.show('领取成功');
                    let guild_info = this.model.GetGuildInfo();
                    if (!guild_info) {
                        return;
                    }
                    guild_info.salary_status = 1;
                    this.model.SetGuildInfo(guild_info);
                    this.model.Fire(GuildEvent.GET_SALARY);

                    let vo = this.model.GetPrestigeData();
                    if (vo) {
                        let data = cfg[vo.title_id];
                        if (data) {
                            let award_list = JSON.parse(data.rewards);
                            Util.ShowCongratulationView(award_list);
                        }
                    }
                } else {
                    Util.ErrorCodeShow(scmd.error_code);
                }
                ResManager.GetInstance().DestoryGameConfig(this, 'config_guild_prestige');
            });
        };

        let on40021 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40021);
            this.model.SetPermissionInfo(scmd);
        };

        let on40023 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40023);
            table.sort(scmd.self_gift_list, (a?, b?) => {
                return a.gift_id < b.gift_id;
            });
            this.model.SetActivity(scmd.gactivity);
            this.model.SetDonateInfo(scmd);
        };

        let on40024 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40024);
            if (scmd.error_code == 1) {
                Message.show('捐献成功');
                this.model.SetActivity(scmd.gactivity);
                this.model.SetDonate(scmd.donate);
                let donate_info = this.model.GetDonateInfo();
                if (!donate_info) {
                    return;
                }
                donate_info.donate_times = scmd.donate_times;
                donate_info.gactivity = scmd.gactivity;
                this.model.SetFunds(scmd.gfunds);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40025 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40025);
            this.resManager_model.LoadGameConfig(this, 'config_guild_activity_gift', false, null, (guild_activity_gift) => {
                if (scmd.error_code == 1) {
                    this.model.Fire(GuildEvent.GET_DONATE_AWARD, scmd.gift_id);
                    let donate_info = this.model.GetDonateInfo();
                    if (!donate_info) {
                        this.resManager_model.DestoryGameConfig(this, 'config_guild_activity_gift');
                        return;
                    }
                    for (let _tmpi in donate_info.this_gift_list) {
                        var info = donate_info.this_gift_list[_tmpi];
                        if (scmd.gift_id != info.gift_id) {
                            break;
                        }
                        info.gift_status = 1;
                        break;
                    }
                    this.model.SetDonateInfo(donate_info);
                    // [ts2lua]config_guild_activity_gift下标访问可能不正确
                    let cfg = guild_activity_gift[scmd.gift_id];
                    let goods_list = this.erlangParser.parse(cfg.reward);
                    let success_view = new CongratulationObtainView(goods_list, 10);
                    success_view.Open();
                } else {
                    Util.ErrorCodeShow(scmd.error_code);
                }
                this.resManager_model.DestoryGameConfig(this, 'config_guild_activity_gift');
            });
            // model.GetGameConfig("config_guild_activity_gift", (config_guild_activity_gift?) => {

            // 	model.DestoryGameConfig("config_guild_activity_gift")
            // }
            // 	, false)
        };

        let on40026 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40026);
            let donate_info = this.model.GetDonateInfo();
            if (!donate_info) {
                return;
            }
            for (let _tmpi in scmd.donate_record) {
                var info = scmd.donate_record[_tmpi];
                table.insert(donate_info.donate_record, 1, info);
                //donate_info.donate_record.unshift(info)
            }
            this.model.SetDonateInfo(donate_info);
        };

        let on40027 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40027);
            if (scmd.error_code == 1) {
                Message.show('解散结社成功');
                this.model.Fire(GuildEvent.CLOSE_VIEW, 'GuildMainBaseView');
                this.role_mgr.GetMainRoleVo().ChangeVar('guild_id', 0);
                GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
                this.SendFmtToGame(15718);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40028 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40028);
            this.model.SetActivity(scmd.gactivity);
        };

        let on40029 = () => {};

        let on40039 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40039);
            this.model.SetDonate(scmd.donate);
            if (!this.model.CheckSkillRedDotAll()) {
                LoadLuaConfigAB('Guildskillresearch', () => {
                    let Guildskill = null;
                    let skill_research = null;
                    let func = () => {
                        if (!Guildskill || !skill_research) {
                            return;
                        }
                        this.model.RefreshSkillRedDot(skill_research, Guildskill);
                    };
                    this.resManager_model.LoadGameConfig(this, 'config_guild_skill', false, null, (guild_skill) => {
                        Guildskill = guild_skill;
                        func();
                        this.resManager_model.DestoryGameConfig(this, 'config_guild_skill');
                    });

                    this.resManager_model.LoadGameConfig(this, 'config_guild_skill_research', false, null, (guild_skill_research) => {
                        skill_research = guild_skill_research;
                        func();
                        this.resManager_model.DestoryGameConfig(this, 'config_guild_skill_research');
                    });
                });
            }
        };

        let on40040 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40040);
            let guild_skill = Config.PRELOAD_SERVER_CONFIG.config_guild_skill;
            this.model.SetDonate(scmd.donate);
            this.model.SetSkillInfo(scmd, guild_skill);
        };

        let on40041 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40041);
            if (scmd.error_code == 1) {
                this.model.SetFunds(scmd.gfunds);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40042 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40042);
            let guild_skill = Config.PRELOAD_SERVER_CONFIG.config_guild_skill;
            if (scmd.error_code == 1) {
                Message.show('升级技能成功');
                this.model.SetDonate(scmd.donate);
                let skill_info = this.model.GetSkillInfo();
                if (!skill_info) {
                    return;
                }
                for (let _tmpi in skill_info.skill_list) {
                    var info = skill_info.skill_list[_tmpi];
                    if (info.skill_id == scmd.skill_id) {
                        info.learn_lv = scmd.learn_lv;
                        info.cur_power = scmd.cur_power;
                        info.next_power = scmd.next_power;
                        break;
                    }
                }
                this.model.SetSkillInfo(skill_info, guild_skill);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40043 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40043);
            if (scmd.error_code == 1) {
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40015);
                this.model.Fire(GuildEvent.RENAME_SUCCESS, scmd.new_name);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40044 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40044);
            this.model.Fire(GuildEvent.UPDATE_RENAME_VIEW, scmd);
        };

        let on40061 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40061);
            RedDotController.ins.up(RedKey.GUILD_MERGE_APPLY, scmd.guild_list.length > 0 && this.model.GetGuildInfo()?.is_in_merge === 0&&GuildModel.IsGuildMaster());
            this.model.Fire(GuildEvent.UPDATE_MERGE_VIEW, scmd.guild_list);
        };
        let on40062 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40062);
            if (scmd.error_code == 1) {
                this.model.Fire(GuildEvent.MERGE_APPLY, scmd.guild_id, 0);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };
        let on40063 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40063);
            if (scmd.error_code == 1) {
                if (this.op == 1) {
                    this.model.Fire(GuildEvent.MERGE_APPLY, scmd.guild_id, 1);
                } else {
                    this.model.Fire(GuildEvent.MERGE_APPLY, scmd.guild_id, 2);
                }
                //更新公会基本信息
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40005);
                //更新下合并请求列表
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40061);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };
        let on40100 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40100);
            Util.ErrorCodeShow(scmd.error_code);
            this.model.Fire(GuildEvent.REQUEST_40100,scmd.error_code);
        };

        let on40101 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40101);
            let goods = Config.PRELOAD_SERVER_CONFIG.config_goods;
            this.model.SetDepotScore(scmd.depot_score);
            this.model.SortDepotGoods(scmd.depot_goods, goods);
            table.sort(scmd.exchange_records, (a?, b?) => {
                return b.time < a.time;
            });
            for (let _tmpi in scmd.depot_goods) {
                let info = scmd.depot_goods[_tmpi];
                this.goods_model.AddDynamic(info, true);
                this.goods_model.SetBaseInfo(info);
            }
            for (let _tmpi in scmd.exchange_records) {
                let info = scmd.exchange_records[_tmpi];
                info = this.goods_model.SetBaseInfo(scmd.exchange_records[_tmpi]);
            }
            this.model.SetDepotInfo(scmd);
            this.model.CheckExchangeRed();
        };

        let on40102 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40102);
            Message.show('捐献成功');
            this.model.SetDepotScore(scmd.depot_score);
            this.model.CheckExchangeRed();
        };

        let on40103 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40103);
            if (scmd.error_code == 1) {
                Message.show('兑换成功');
                this.model.SetDepotScore(scmd.depot_score);
                this.model.CheckExchangeRed();
            } else {
                this.SendFmtToGame(40101);
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40104 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40104);
            if (scmd.error_code == 1) {
                if (scmd.op_type == 3) {
                    Message.show('操作成功，共清理' + scmd.depot_num + '件装备');
                } else if (scmd.op_type == 4) {
                    Message.show('结社仓管自动清理' + scmd.depot_num + '件装备');
                }
            } else {
                this.SendFmtToGame(40101);
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40105 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40105);
            let depot_info = this.model.GetDepotInfo();
            if (!depot_info) {
                return;
            }
            let info: IGuildDepoGoods;
            for (let _tmpi in scmd.depot_goods) {
                info = scmd.depot_goods[_tmpi] as any;
                this.goods_model.AddDynamic(info, true);
                this.goods_model.SetBaseInfo(info);
                table.insert(depot_info.depot_goods, info);
            }
            this.model.SetDepotInfo(depot_info);
        };

        let on40106 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40106);
            let depot_info = this.model.GetDepotInfo();
            if (!depot_info) {
                return;
            }
            let obj ={}
            for (let _tmpi in scmd.depot_goods) {
                let v = scmd.depot_goods[_tmpi];
                obj[v.goods_id]=v.num
            }

            let new_list=[]
                for (let _tmpi in depot_info.depot_goods) {
                    let vv = depot_info.depot_goods[_tmpi];
                vv.goods_num = obj[vv.goods_id]!=null?Number(obj[vv.goods_id]):vv.goods_num;
                if (vv.goods_num>0) {
                    vv.goods_num = Number(obj[vv.goods_id]);
                    new_list.push(depot_info.depot_goods[_tmpi])
                }
            }
            depot_info.depot_goods=new_list
            this.model.SetDepotInfo(depot_info);
        };

        let on40107 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40107);
            let depot_info = this.model.GetDepotInfo();
            if (!depot_info) {
                return;
            }
            for (let _tmpi in scmd.exchange_records) {
                let info = scmd.exchange_records[_tmpi];
                this.goods_model.SetBaseInfo(info);
                table.insert(depot_info.exchange_records, 1, info);
                //depot_info.exchange_records.unshift(info)
            }
            this.model.SetDepotInfo(depot_info);
        };

        let on40108 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40108);
            if (scmd.change == 1) {
                this.SendFmtToGame(40101);
            }
        };

        let on40109 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40108);
            if (scmd.change == 1) {
                this.SendFmtToGame(40101);
            }
        };

        let on40110 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40110);
            this.model.Fire(GuildEvent.UPDATE_CLEAN_VIEW, scmd);
        };

        let on40050 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40050);
            if (scmd.code == 1) {
                table.sort(scmd.score_gift_list, (a?, b?) => {
                    return a.gift_id < b.gift_id;
                });
                this.model.SetExploreInfo(scmd);
                GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
            } else {
                Util.ErrorCodeShow(scmd.code);
            }
        };

        let on40051 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40051);
            this.resManager_model.LoadGameConfig(this, 'config_guild_dun_score_reward', false, null, (guild_dun_score_reward) => {
                if (scmd.code == 1) {
                    let explore_info = this.model.GetExploreInfo();
                    if (!explore_info) {
                        ResManager.GetInstance().DestoryGameConfig(this.model, 'config_guild_dun_score_reward');
                        return;
                    }
                    for (let _tmpi in explore_info.score_gift_list) {
                        let info = explore_info.score_gift_list[_tmpi];
                        if (scmd.gift_id != info.gift_id) {
                            break;
                        }
                        info.gift_status = 1;
                    }
                    this.model.SetExploreInfo(explore_info);
                    if (guild_dun_score_reward) {
                        let info = guild_dun_score_reward[scmd.gift_id];
                        let goods_list = this.erlangParser.parse(info.reward);
                        let success_view = new CongratulationObtainView(goods_list, 10);
                        success_view.Open();
                    }
                } else {
                    Util.ErrorCodeShow(scmd.code);
                }
                this.resManager_model.LoadGameConfig(this, 'config_guild_dun_score_reward');
            });
        };

        let on40052 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40052);
            this.model.Fire(GuildEvent.EXPOLORE_UDPATE_FIGHT_TIME, scmd);
        };

        let on40053 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40053);
            if (scmd.code == 1) {
            } else {
                Util.ErrorCodeShow(scmd.code);
            }
        };

        let on40054 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40054);
            if (scmd.code == 1) {
                Message.show('退出成功');
            } else {
                Util.ErrorCodeShow(scmd.code);
            }
        };

        let on40055 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40055);
            this.model.SetResultInfo(scmd);
            if (scmd.type == 1) {
                this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildExploreBoxView');
                this.model.Fire(GuildEvent.EXPOLORE_GET_BOX);
                this.SendFmtToGame(40050);
                this.SendFmtToGame(40058);
            } else {
                this.model.Fire(GuildEvent.EXPOLORE_UDPATE_RESULT);
                this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildExploreResultView');
            }
        };

        let on40056 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40056);
            table.sort(scmd.challenge_list, (a?, b?) => {
                return b.role_score < a.role_score;
            });
            for (let _tmpi in scmd.challenge_list) {
                let info = scmd.challenge_list[_tmpi];
                info.level = Math.min(info.level, GuildDefine.MAX_LAYER);
            }
            this.model.Fire(GuildEvent.EXPOLORE_UDPATE_RECORD, scmd);
        };

        let on40057 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40057);
            if (scmd.code == 1) {
                Message.show('通风报信成功');
                this.SendFmtToGame(40058);
            } else {
                Util.ErrorCodeShow(scmd.code);
            }
        };

        let on40058 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40058);
            table.sort(scmd.notify_list, (a?, b?) => {
                return b.time < a.time;
            });
            this.model.SetNoticeInfo(scmd);
        };

        let on40060 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40060);
            if (!this.model.boss_mark && scmd.role_id != this.role_mgr.GetMainRoleId()) {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'HelpTipsBossView', scmd);
            }
        };

        let on40230 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40230);
            if (scmd.errcode != 1) {
                Util.ErrorCodeShow(scmd.errcode);
            }
        };

        let on40231 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40231);
            this.model.SetactInfo(scmd);
        };

        let on40232 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40232);
            this.model.Fire(GuildEvent.GUARD_WAVE, scmd.wave_num);
        };

        let on61031 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(61031);
            this.model.SetguardKillNum(scmd.kill_count);
        };

        let on61032 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(61032);
            this.model.setDamageRank(scmd);
        };

        let on61033 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(61033);
            this.model.setGuardInfoByType(scmd);
        };

        let on61034 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(61034);
            this.model.setGuardInfo(scmd);
        };

        let on61035 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(61035);
            this.model.setRoundData(scmd);
        };

        let on61041 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(61041);
            this.model.SetexpData(scmd);
        };

        let on40300 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40300);
            Util.ErrorCodeShow(scmd.error_code);
        };

        let on40301 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40301);
            this.model._rewardBoxViewData = scmd;
            this.model.Fire(GuildEvent.REWARD_BOX_DATA_UPDATE);
            this.model.RefreshRewardBoxRed();
        };

        let on40302 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40302);
            if (scmd.code == 1) {
                this.model.setRewardBoxGet(scmd);
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40301);
            } else {
                Util.ErrorCodeShow(scmd.code);
            }
        };

        let on40303 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40303);
            this.model.updateRewardBox(scmd);
            this.model.RefreshRewardBoxRed();
        };

        let on40304 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40304);
            this.model.delRewardBox(scmd.auto_id);
            this.model.RefreshRewardBoxRed();
        };

        let on40305 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40305);
            this.model.updateRewardBoxTask(scmd);
        };

        let on40030 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40030);
            this.model.SetPrestigeData(scmd);
            let tdata = this.model.GetPrestigetToday();
            if (tdata) {
                tdata.all_prestige = scmd.all_prestige;
                this.model.SetPrestigetToday(tdata);
            }
            if (this.model.last_max_title < scmd.title_id) {
                this.RequestGuildIdol(); //武魂信息
            }
            this.model.last_max_title = scmd.title_id;
        };

        let on40031 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40031);
            this.model.SetPrestigetToday(scmd);
        };

        let on40500 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40500);
            if (scmd.errcode != 1) {
                Util.ErrorCodeShow(scmd.errcode);
            }
        };

        let on40501 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40501);
            this.model.idol_view_info = scmd;
            this.model.setActRed();
            this.model.setAwakenRed();
            if (!this.model.reqIdolRune) {
                this.model.reqIdolRune = true;
                this.model.reqRuneData();
            } else {
                this.model.setRuneRed();
            }
            this.model.Fire(GuildEvent.IDOL_VIEW_INFO);
        };

        let on40502 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40502);
            this.model.setIdolRune(scmd);
        };

        let on40503 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40503);
            this.model.idolUp(scmd);
        };

        let on40504 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40504);
            this.model.idolAwaken(scmd);
        };

        let on40505 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40505);
            if (scmd.code != 1) {
                Util.ErrorCodeShow(scmd.code);
            }
        };

        let on40507 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40507);
            if (scmd.code != 1) {
                Util.ErrorCodeShow(scmd.code);
            }
        };

        let on40508 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40508);
            if (scmd.code == 1) {
                this.model.Fire(GuildEvent.IDOL_RUNE_UP);
            }
        };

        let on40509 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40509);
            if (scmd.code == 1) {
                this.model.Fire(GuildEvent.IDOL_RUNE_LV_ACT);
            }
        };

        let on40401 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40401);
            if (scmd.error_code == 1) {
                Message.show('已请求协助');
                this.model.SetReqData(scmd);
                this.model.Fire(GuildEvent.REQ_SUCCESS, scmd);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40402 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40402);
            if (scmd.error_code == 1) {
                Message.show('正在前往协助');
                GlobalEventSystem.Fire(EventName.CLOSE_VIEW, 'GuildHelpTipsView');
                GlobalEventSystem.Fire(EventName.CLOSE_VIEW, 'GuildHelpView');
                this.model.Fire(GuildEvent.HELP_SUCCESS);
                // 不是璀璨之海
                if (scmd.type != 3) {
                    this.model.SetAssistData(scmd);
                }
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40403 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40403);
            if (scmd.error_code == 1) {
                if (scmd.ask_id == RoleManager.GetInstance().GetMainRoleId()) {
                    Message.show('协助请求已取消');
                    this.model.SetReqData(null);
                } else {
                    Message.show('已取消协助');
                    this.model.SetAssistData(null);
                }
                this.model.Fire(GuildEvent.CANCEL_HELP_SUCCESS, scmd, scmd.ask_id);
            } else {
                Util.ErrorCodeShow(scmd.error_code);
            }
        };

        let on40404 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40404);
            this.model.Fire(GuildEvent.UPDATE_ASSIST_COUNT, scmd);
        };

        let on40405 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40405);
            this.model.SetHelpData(scmd);
            if (!this.model._help_mark) {
                this.model._help_mark = true;
                this.model.CheckHelpTips(scmd);
            }
        };

        let on40406 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40406);
            let hdata = this.model.GetHelpData();
            if (hdata) {
                table.insert(hdata.assist_list, scmd);
                this.model.SetHelpData(hdata);
            }
            let is_show = RoleManager.GetInstance().GetMainRoleId() != scmd.role_id;
            let can_assist = this.model.IsCanOpenAssist();
            if ((scmd.type == 1 || scmd.type == 2) && !can_assist) {
                //1 2类型协助，未达到等级要求
                return;
            }
            this.model.Fire(GuildEvent.HAVE_HELP, is_show);
        };

        let on40407 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40407);
            let hdata = this.model.GetHelpData();

            if (hdata) {
                let i = 0;
                do {
                    let vo = hdata.assist_list[i];
                    if (vo && vo.assist_id == scmd.assist_id) {
                        // let a = table.remove([1, 2, 3], i);
                        hdata.assist_list.splice(i, 1)
                        break;
                    }
                    i = i + 1;
                } while (i < hdata.assist_list.length);
                this.model.SetHelpData(hdata);
                this.model.CheckHelpTips(hdata);
            }
            //正在协助的目标取消请求
            let adata = this.model.GetAssistData();
            if (adata && adata.assist_id == scmd.assist_id) {
                this.model.SetAssistData(null);
                this.model.Fire(GuildEvent.CANCEL_HELP_SUCCESS, scmd, adata.role_id);
            }
            let rdata = this.model.GetReqData();
            if (rdata && rdata.assist_id == scmd.assist_id) {
                this.model.SetReqData(null);
                this.model.Fire(GuildEvent.CANCEL_HELP_SUCCESS, scmd, rdata.role_id);
            }
            this.model.Fire(GuildEvent.DEL_HELP_DATA, scmd);
        };

        let on40408 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40408);
            if (!this.model._assist_data) {
                this.model._assist_data = scmd;
            }
            this.model.Fire(GuildEvent.UPDATE_HELP_OBJ, scmd);
        };

        let on40409 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40409);
            this.model.Fire(GuildEvent.ASSIST_SUCCESS, scmd);
        };

        let on40410 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(40410);
            Message.show(scmd.name + '接受了你的协助请求');
        };

        let on11016 = () => {
            this.SendFmtToGame(40008);
        };

        this.RegisterProtocal(40000, on40000);
        this.RegisterProtocal(40001, on40001);
        this.RegisterProtocal(40002, on40002);
        this.RegisterProtocal(40003, on40003);
        this.RegisterProtocal(40004, on40004);
        this.RegisterProtocal(40005, on40005);
        this.RegisterProtocal(40006, on40006);
        this.RegisterProtocal(40007, on40007);
        this.RegisterProtocal(40008, on40008);
        this.RegisterProtocal(40009, on40009);
        this.RegisterProtocal(40010, on40010);
        this.RegisterProtocal(40011, on40011);
        this.RegisterProtocal(40012, on40012);
        this.RegisterProtocal(40013, on40013);
        this.RegisterProtocal(40014, on40014);
        this.RegisterProtocal(40015, on40015);
        this.RegisterProtocal(40016, on40016);
        this.RegisterProtocal(40017, on40017);
        this.RegisterProtocal(40018, on40018);
        this.RegisterProtocal(40019, on40019);
        this.RegisterProtocal(40020, on40020);
        this.RegisterProtocal(40021, on40021);
        this.RegisterProtocal(40023, on40023);
        this.RegisterProtocal(40024, on40024);
        this.RegisterProtocal(40025, on40025);
        this.RegisterProtocal(40026, on40026);
        this.RegisterProtocal(40027, on40027);
        this.RegisterProtocal(40028, on40028);
        this.RegisterProtocal(40029, on40029);
        this.RegisterProtocal(40039, on40039);
        this.RegisterProtocal(40040, on40040);
        this.RegisterProtocal(40041, on40041);
        this.RegisterProtocal(40042, on40042);
        this.RegisterProtocal(40043, on40043);
        this.RegisterProtocal(40044, on40044);
        this.RegisterProtocal(40061, on40061);
        this.RegisterProtocal(40062, on40062);
        this.RegisterProtocal(40063, on40063);

        this.RegisterProtocal(40100, on40100);
        this.RegisterProtocal(40101, on40101);
        this.RegisterProtocal(40102, on40102);
        this.RegisterProtocal(40103, on40103);
        this.RegisterProtocal(40104, on40104);
        this.RegisterProtocal(40105, on40105);
        this.RegisterProtocal(40106, on40106);
        this.RegisterProtocal(40107, on40107);
        this.RegisterProtocal(40108, on40108);
        this.RegisterProtocal(40109, on40109);
        this.RegisterProtocal(40110, on40110);

        //结社副本
        this.RegisterProtocal(40050, on40050);
        this.RegisterProtocal(40051, on40051);
        this.RegisterProtocal(40052, on40052);
        this.RegisterProtocal(40053, on40053);
        this.RegisterProtocal(40054, on40054);
        this.RegisterProtocal(40055, on40055);
        this.RegisterProtocal(40056, on40056);
        this.RegisterProtocal(40057, on40057);
        this.RegisterProtocal(40058, on40058);

        //结社求助
        this.RegisterProtocal(40060, on40060);

        //结社守卫
        this.RegisterProtocal(40230, on40230);
        this.RegisterProtocal(40231, on40231);
        this.RegisterProtocal(40232, on40232);
        this.RegisterProtocal(61031, on61031);
        this.RegisterProtocal(61032, on61032);
        this.RegisterProtocal(61033, on61033);
        this.RegisterProtocal(61034, on61034);
        this.RegisterProtocal(61035, on61035);
        this.RegisterProtocal(61041, on61041);

        //结社宝箱
        this.RegisterProtocal(40300, on40300);
        this.RegisterProtocal(40301, on40301);
        this.RegisterProtocal(40302, on40302);
        this.RegisterProtocal(40303, on40303);
        this.RegisterProtocal(40304, on40304);
        this.RegisterProtocal(40305, on40305);

        //结社头衔声望
        this.RegisterProtocal(40030, on40030);
        this.RegisterProtocal(40031, on40031);

        //结社武魂
        this.RegisterProtocal(40500, on40500);
        this.RegisterProtocal(40501, on40501);
        this.RegisterProtocal(40502, on40502);
        this.RegisterProtocal(40503, on40503);
        this.RegisterProtocal(40504, on40504);
        this.RegisterProtocal(40505, on40505);
        this.RegisterProtocal(40507, on40507);
        this.RegisterProtocal(40508, on40508);
        this.RegisterProtocal(40509, on40509);

        //结社协助
        this.RegisterProtocal(40401, on40401);
        this.RegisterProtocal(40402, on40402);
        this.RegisterProtocal(40403, on40403);
        this.RegisterProtocal(40404, on40404);
        this.RegisterProtocal(40405, on40405);
        this.RegisterProtocal(40406, on40406);
        this.RegisterProtocal(40407, on40407);
        this.RegisterProtocal(40408, on40408);
        this.RegisterProtocal(40409, on40409);
        this.RegisterProtocal(40410, on40410);

        //推送给会长
        //this.RegisterProtocal(11016, on11016)
    }
}

window['GuildController'] = GuildController;
