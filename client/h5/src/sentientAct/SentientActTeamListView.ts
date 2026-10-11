import { Alert, Alert_Type } from '../alert/Alert';
import { BaseItem1 } from '../common/BaseItem1';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { table } from '../common/table';
import { DUN_TYPE } from '../commonModel/BaseDungeonModel';
import { GuildEvent, GuildModel } from '../commonModel/GuildModel';
import { RoleManager } from '../commonModel/RoleManager';
import { TeamEvent, TeamModel } from '../commonModel/TeamModel';
import { Message } from '../sysInfo/SysInfoController';
import { Util } from '../util/Util';
import { SentientActMainView } from './SentientActMainView';
import { SentientActTeamListItem } from './SentientActTeamListItem';
export class SentientActTeamListView extends BaseItem1 {
    MatchFunc;
    FireEvent;
    InitEvent;
    InitView;
    LocalDeleteMe;
    Scr_Scroller1;
    SetData;
    UpdateView;
    _list_item;
    param_
    RequestHelp
    BuildTeam
    loop_mgr: LoopScrowViewMgr;
    /**41001 众生之门组队前无法知道副本ID,所有的副本ID公用次数，用其中一个写死即可 */
    public static HELP_DUN_ID = 41001
    protected teamSubType: number;
    protected teamActivityType: number;
    protected alertContent: string;
    protected teamListItem: new (...args: any[]) => BaseItemRenderer;

    public constructor(parent?) {
        super(parent);

        this.base_file = 'sentientAct';
        this.layout_file = 'SentientActTeamListView';
        let team_model = TeamModel.GetInstance();
        this.preload_server_config = {};
        this.teamActivityType = 9
        this.teamSubType = 1;
        this.alertContent = '当前队伍目标不是众生之门<br>是否退出队伍匹配';
        this.teamListItem = SentientActTeamListItem;
        this.param_ = null
        let request_help = 0
        this.load_callback = () => {
            team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24010);
            team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24012, 'cci', this.teamActivityType, this.teamSubType, 0);
            this.InitView();
            this.InitEvent();
        };

        this.LocalDeleteMe = () => {
            request_help = 0
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe();
                this.loop_mgr = null;
            }
            super.DeleteMe();
        };

        this.InitView = () => { };

        this.FireEvent = () => {

            if (this.param_ && this.param_[0] == SentientActMainView.PARAM_TYPE_CREAT_TWAM) {
                //创建队伍
                let cfg = team_model.GetTaegetCfgById(this.teamActivityType, this.teamSubType);
                if (cfg) {

                    let have_team = team_model.team_info && team_model.team_info.activity_id == this.teamActivityType
                    if (!have_team) {

                        if (team_model.GetAutoMatch()) {
                            Message.show("正在匹配中～")
                            return
                        }

                        request_help = 1
                        this.BuildTeam()
                    } else {
                        //有队伍就请求协助
                        this.RequestHelp()
                    }

                }

            }
        };


        this.BuildTeam = () => {
            let cfg = team_model.GetTaegetCfgById(this.teamActivityType, this.teamSubType);
            if (cfg)
                team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24000, 'ccihhi', this.teamActivityType, this.teamSubType, 0, cfg.default_lv_min, cfg.default_lv_max, 0);
        }


        this.RequestHelp = () => {

            //41001 众生之门组队前无法知道副本ID,所有的副本ID公用次数，用其中一个写死即可
            GuildModel.GetInstance().Fire(GuildEvent.REQUEST_PROTO, 40401, "chil", 2, DUN_TYPE.SentientAct, SentientActTeamListView.HELP_DUN_ID, 0)
        }


        this.InitEvent = () => {
            Util.AddClickEvent(
                this.group_btn,
                () => {
                    if (team_model.team_info && team_model.team_info.activity_id == this.teamActivityType) {
                        team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24005);
                    } else if (team_model.team_info && team_model.team_info.activity_id != this.teamActivityType) {
                        let cfg = team_model.GetTaegetCfgById(this.teamActivityType, this.teamSubType);
                        if (cfg)
                            team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24017, 'ccihhi', this.teamActivityType, this.teamSubType, 0, cfg.default_lv_min, cfg.default_lv_max, 0);
                    } else {
                        this.BuildTeam()
                    }
                },
                this,
                true
            );

            Util.AddClickEvent(
                this.pipei_btn,
                () => {
                    this.MatchFunc();
                },
                this,
                true
            );


            this.BindEvent(
                team_model,
                TeamEvent.TEAM_UPDATE_TERAM_INFO, () => {
                    if (request_help > 0) {
                        this.RequestHelp()
                        request_help = 0
                    }
                }
            )


            this.BindEvent(team_model, TeamEvent.QUIT_TEAM_SUCCESS, () => {
                if (team_model.quit_team_match == this.teamActivityType) {
                    this.MatchFunc();
                    team_model.quit_team_match = false;
                }
            });

            this.BindEvent(team_model, TeamEvent.TEAM_UPDATE_TERAM_HALL, (activity_id?, subtype?) => {
                if (activity_id == this.teamActivityType && subtype == this.teamSubType) {
                    this.UpdateView();
                }
            });
            this.BindEvent(team_model, TeamEvent.TEAM_UPDATE_TERAM_INFO, () => {
                if (team_model.team_info && team_model.team_info.activity_id == this.teamActivityType) {
                    this.group_lab.text = '退出队伍';
                }
                team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24012, 'cci', this.teamActivityType, this.teamSubType, 0);
            });
            this.BindEvent(team_model, TeamEvent.TEAM_BUILD_SUCCESS, () => {
                team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24012, 'cci', this.teamActivityType, this.teamSubType, 0);
                if (team_model.single_match_state == this.teamActivityType) {
                    team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24020, 'ic', this.teamActivityType, this.teamSubType);
                    team_model.single_match_state = false;
                }
            });
            this.BindEvent(team_model, TeamEvent.QUIT_TEAM_SUCCESS, () => {
                team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24012, 'cci', this.teamActivityType, this.teamSubType, 0);
            });
        };

        this.UpdateView = () => {
            let team_hall = team_model.team_hall;
            if (team_hall) {
                let list = [];
                let have_mine_team = false;
                for (let _tmpi in team_hall) {
                    let vo = team_hall[_tmpi];
                    if (!have_mine_team) have_mine_team = this.IsMineTeam(vo.members);
                    table.insert(list, { vo: vo, sub_type: 1 });
                }
                this._gp_none.visible = list.length == 0;
                this.group_lab.text = have_mine_team ? '退出队伍' : '创建队伍';
                if (!this.loop_mgr) {
                    this.loop_mgr = new LoopScrowViewMgr();
                    this.loop_mgr.SetData(this.group_list, this.teamListItem, list, LoopScrCon.Vertical);
                } else {
                    this.loop_mgr.replaceAll(list);
                }
            }
        };

        this.SetData = (...new_args) => {
            this.param_ = new_args;
            this.FireEvent();
            // this.UpdateView()
        };

        this.MatchFunc = () => {
            let team_info = team_model.team_info;
            if (team_info) {
                if (team_info.activity_id != this.teamActivityType) {
                    let call_back = () => {
                        team_model.quit_team_match = this.teamActivityType;
                        team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24005);
                    };

                    Alert.Show(this.alertContent, Alert_Type.Two, call_back, null, '毅然前往', '我再想想', null, null, null, null, null, null, null, null, null, null, false);
                    return;
                }
                let auto_match = team_model.GetAutoMatch();
                if (auto_match) {
                    team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24048, 'c', 0);
                } else {
                    if (team_model.IsLeaderInTeam(RoleManager.GetInstance().GetMainRoleId())) {
                        if (team_info.team_member_list.length <= 3) {
                            team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24048, 'c', 1);
                        } else {
                            Message.show('队伍已满请进入场景战斗吧');
                        }
                    } else {
                        Message.show('你不是队长，没有此权限');
                    }
                }
            } else {
                let auto_match = team_model.GetAutoMatch();
                if (auto_match) {
                    team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24048, 'c', 0);
                } else {
                    team_model.SetCancelMatchText('匹配失败');
                    team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24023, 'cc', this.teamActivityType, this.teamSubType);
                }
            }
        };
    }
    public IsMineTeam(members?) {
        let is_mine = false;
        if (members) {
            for (let _tmpi in members) {
                let vo = members[_tmpi];
                if (vo.id == RoleManager.GetInstance().GetMainRoleId()) {
                    is_mine = true;
                    break;
                }
            }
        }
        return is_mine;
    }
    public DeleteMe() {

        this.LocalDeleteMe();
    }

    group_list: Laya.List;
    group_btn: Laya.Box;
    group_lab: Laya.Label;
    _gp_none: Laya.Box;
    pipei_btn: Laya.Box;
    public GetComponents() {
        [this.group_list, this.group_btn, this.group_lab, this._gp_none, this.pipei_btn] = this.GetChildrenByNames([
            'group_list',
            'group_btn',
            'group_lab',
            '_gp_none',
            'pipei_btn'
        ]);
    }
}
window['SentientActTeamListView'] = SentientActTeamListView;
