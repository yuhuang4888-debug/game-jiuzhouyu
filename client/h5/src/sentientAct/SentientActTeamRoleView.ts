import { Alert, Alert_Type } from '../alert/Alert';
import { BaseItem1 } from '../common/BaseItem1';
import { EventName } from '../common/EventName';
import { ResManager } from '../common/ResManager';
import { table } from '../common/table';
import { DUN_TYPE } from '../commonModel/BaseDungeonModel';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { RoleManager } from '../commonModel/RoleManager';
import { SentientActEvent, SentientActModel } from '../commonModel/SentientActModel';
import { TeamEvent, TeamModel } from '../commonModel/TeamModel';
import { SceneManager } from '../scene/SceneManager';
import { Message } from '../sysInfo/SysInfoController';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { GameResPath } from '../util/GameResPath';
import { Util } from '../util/Util';
import { SentientActTeamListView } from './SentientActTeamListView';
import { SentientActTeamRoleItem } from './SentientActTeamRoleItem';

export class SentientActTeamRoleView extends BaseItem1 {

    FireEvent;
    InitEvent;
    InitView;
    LocalDeleteMe;
    Scr_Scroller1;
    SetData;
    UpdateView;
    UpdateTeamInfo;
    EnterFunc;
    guild_model

    UpdateAutoAddState;
    OpenClumpView;
    _list_item;
    loop_mgr;
    protected teamActivityType: number;
    protected teamSubType: number;
    protected alertContent: string;
    protected is_show_asssit: boolean;
    public static RolePos = [
        [180, 102],
        [-10, 180],
        [370, 180]
    ];
    public constructor(parent?) {
        super(parent);

        this.base_file = 'sentientAct';
        this.layout_file = 'SentientActTeamRoleView';
        this.teamActivityType = 9;
        this.teamSubType = 1;
        this.is_show_asssit=true
        this.guild_model = GuildModel.GetInstance()
        this.alertContent = '当前队伍目标不是众生之门<br>是否退出队伍匹配';
        let model = SentientActModel.GetInstance();
        let team_model = TeamModel.GetInstance();
        let role_item_list_;
        let now_dun_id_ = null;
        this.preload_server_config = {};
        this.load_callback = () => {
            this.InitView();
            this.InitEvent();

            this._btn_assist.visible = this.is_show_asssit&&this.guild_model.IsCanOpenAssist()
        };

        this.LocalDeleteMe = () => {
            if (role_item_list_ && role_item_list_.length) {
                for (let i = 0; i < role_item_list_.length; i++) {
                    role_item_list_[i].DeleteMe()
                    role_item_list_[i] = null
                }
                role_item_list_ = []
            }

            super.DeleteMe();
        };

        this.InitView = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIconJpg('sentientAct', 'ui_zong_bg1'));
            this.UpdateTeamInfo();
            this.UpdateAutoAddState();
        };

        this.EnterFunc = () => {
            if (SceneManager.GetInstance().IsSentientActScene()) {
                model.Fire(SentientActEvent.FIND_WAY);
                GlobalEventSystem.Fire(EventName.CLOSE_VIEW, 'SentientActTeamView');
            } else model.Fire(SentientActEvent.REQUEST_PROTO, 24108);
        };

        this.OpenClumpView = () => {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'DungeonEquipClumpView', model.dungeon_id);
        };

        this.InitEvent = () => {

            this.BindEvent(this.guild_model, GuildEvent.CHANGED_CONDS_ASSIST, () => {
                this._btn_assist.visible = this.guild_model.IsCanOpenAssist()
            })


            

            Util.AddClickEvent(this._btn_assist, () => {
                GuildModel.GetInstance().Fire(GuildEvent.REQUEST_PROTO, 40401, "chil", 2, DUN_TYPE.SentientAct, SentientActTeamListView.HELP_DUN_ID, 0)

            }, this,true);


            Util.AddClickEvent(this._img_clump, this.OpenClumpView, this,true);
            Util.AddClickEvent(
                this._img_gx,
                () => {
                    let team_info = team_model.team_info;
                    if (team_info) {
                        // [ts2lua]lua中0和空字符串也是true，此处team_info.join_type == 1需要确认
                        let index = (team_info.join_type == 1 && 2) || 1;
                        team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24018, 'c', index);
                    }
                },
                this,
                true
            );

            Util.AddClickEvent(
                this.go_btn,
                () => {
                    //model.Fire(SentientActEvent.REQUEST_PROTO, 24104)
                    this.EnterFunc();
                },
                this,
                true
            );
            Util.AddClickEvent(
                this.pipei_btn,
                () => {
                    let team_info = team_model.team_info;
                    if (team_info) {
                        if (team_info.activity_id != this.teamActivityType) {
                            let call_back = () => {
                                team_model.quit_team_match = this.teamActivityType;
                                team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24005);
                            };

                            Alert.Show(
                                this.alertContent,
                                Alert_Type.Two,
                                call_back,
                                null,
                                '毅然前往',
                                '我再想想',
                                null,
                                null,
                                null,
                                null,
                                null,
                                null,
                                null,
                                null,
                                null,
                                null,
                                false
                            );
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
                },
                true
            );
            this.BindEvent(team_model, TeamEvent.TEAM_UPDATE_TERAM_INFO, () => {
                this.UpdateTeamInfo();
            });
            this.BindEvent(team_model, TeamEvent.TEAM_CHANGE_TARGET_SUCCESS, () => {
                this.UpdateTeamInfo();
            });
            this.BindEvent(team_model, TeamEvent.TEAM_CHANGE_JOIN_TYPE, () => {
                this.UpdateAutoAddState();
            });
        };

        this.UpdateTeamInfo = () => {
            let team_info = team_model.team_info;
            if (!team_info) return;
            let list = [];
            let i = 0;
            // if (team_info && team_info.team_member_list && Util.TableSize(team_info.team_member_list) >= 3) {
            //     team_model.Fire(TeamEvent.TEAM_CLOSE_VIEW, "TeamMatchView")
            //     Alert.Show("众生之门队伍已满员，是否进入玩法场景？", Alert_Type.Two, () => {
            //         this.EnterFunc()
            //     }, null, "确定", "取消", null, null, null, null, null, null, null, null, null, null, false)
            // }
            do {
                let vo = team_info && team_info.team_member_list[i];
                if (vo) {
                    table.insert(list, vo);
                } else {
                    table.insert(list, { none: true });
                }
                i = i + 1;
            } while (i < 3);
            if (!role_item_list_) {
                role_item_list_ = [];
            }
            let item = null;
            let vo = null;

            let cfg = team_model.GetTaegetCfgById(team_info.activity_id, team_info.subtype);
            if (cfg) {
                now_dun_id_ = cfg.dun_id;
            }

            for (let key in list) {
                item = role_item_list_[key];
                vo = list[key];
                if (!item) {
                    item = new SentientActTeamRoleItem(this._gp_role_con);
                    role_item_list_[key] = item;
                    item.Load();
                    item.SetPosition(SentientActTeamRoleView.RolePos[key][0], SentientActTeamRoleView.RolePos[key][1]);
                }
                item.SetData(vo, team_info.activity_id, now_dun_id_);
            }
        };

        this.SetData = (...new_args) => {
            let parms = new_args;

            //this.FireEvent()
            // this.UpdateView()
        };

        this.UpdateAutoAddState = () => {
            if (team_model.IsLeaderInTeam(RoleManager.GetInstance().GetMainRoleId())) {
                this._gp_auto_add.visible = true;
                let team_info = team_model.team_info;
                if (team_info) {
                    // [ts2lua]lua中0和空字符串也是true，此处team_info.join_type == 1需要确认
                    let sprite_name = (team_info.join_type == 1 && 'com_ui_gx') || 'com_ui_gx1';
                    ResManager.GetInstance().SetImageSprite(this, this._img_gx, 'common_asset', sprite_name, true);
                }
            } else {
                this._gp_auto_add.visible = false;
            }
        };
    }
    public DeleteMe() {
        this.LocalDeleteMe();
    }


    bg: Laya.Image
    _Image12: Laya.Image
    _Image13: Laya.Image
    _Image14: Laya.Image
    _Image15: Laya.Image
    _gp_role_con: Laya.Box
    _gp_auto_add: Laya.Box
    _Label5: Laya.Label
    _img_gx: Laya.Image
    pipei_btn: Laya.Box
    go_btn: Laya.Box
    _img_clump: Laya.Image
    _btn_assist: Laya.Image
    public GetComponents() {
        [
            this.bg,
            this._Image12,
            this._Image13,
            this._Image14,
            this._Image15,
            this._gp_role_con,
            this._gp_auto_add,
            this._Label5,
            this._img_gx,
            this.pipei_btn,
            this.go_btn,
            this._img_clump,
            this._btn_assist,
        ]
            = this.GetChildrenByNames([

                "bg",
                "_Image12",
                "_Image13",
                "_Image14",
                "_Image15",
                "_gp_role_con",
                "_gp_auto_add",
                "_Label5",
                "_img_gx",
                "pipei_btn",
                "go_btn",
                "_img_clump",
                "_btn_assist",
            ])
    }
}
window["SentientActTeamRoleView"] = SentientActTeamRoleView