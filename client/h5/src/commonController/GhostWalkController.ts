import { GhostWalkModel, GhostWalkEvent, IGhostWalkPointInfo, IGhostWalkBossTeamHurtInfo } from './../commonModel/GhostWalkModel';
import { UserMsgAdapter } from './../common/UserMsgAdapter';
import { BaseController } from './../common/BaseController';
import { kfStageModel } from '../commonModel/kfStageModel';
import { SceneManager } from '../scene/SceneManager';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventName } from '../common/EventName';
import { MainUIModel } from '../commonModel/MainUIModel';
import { Util } from '../util/Util';
import { BossModel } from '../commonModel/BossModel';
import { RedKey } from '../common/RedDotDefine';
import { RedDotController } from '../common/RedDotController';
import { TeamEvent, TeamModel } from '../commonModel/TeamModel';
import { RoleManager } from '../commonModel/RoleManager';
import { Alert, AlertConfig, Alert_Type } from '../alert/Alert';

import '../ghostWalk/GhostWalkView';
import '../ghostWalk/GhostWalkSceneView';
import '../ghostWalk/GhostWalkChatMenuView'

export class GhostWalkController extends BaseController {
    private static _ins: GhostWalkController;
    private _model: GhostWalkModel;
    private cfg: {};
    constructor() {
        super();
        this._model = GhostWalkModel.ins;
        this.initEvent();
        this.registerProtocal();
    }
    static getInstance() {
        if (!GhostWalkController._ins) {
            GhostWalkController._ins = new GhostWalkController();
        }
        return GhostWalkController._ins;
    }
    initEvent() {
        this._model.Bind(GhostWalkEvent.SendFmt20601, this.send20601.bind(this));
        this._model.Bind(GhostWalkEvent.SendFmt20602, this.send20602.bind(this));
        this._model.Bind(GhostWalkEvent.SendFmt20603, this.send20603.bind(this));
        this._model.Bind(GhostWalkEvent.SendFmt20604, this.send20604.bind(this));
        this._model.Bind(GhostWalkEvent.SendFmt20605, this.send20605.bind(this));
        this._model.Bind(GhostWalkEvent.GET_DAMAGE_LIST, (bossId) => {
            UserMsgAdapter.GetInstance().SendAllFmtToGame(12025, 'i', [bossId]);
        });

        this._model.Bind(GhostWalkEvent.GO_POINT, this.goPoint.bind(this));
        this._model.Bind(GhostWalkEvent.SCENE_COMPLETE, this.goPoint.bind(this));

        TeamModel.GetInstance().Bind(TeamEvent.BEFORE_TEAMMATE_CHANGE_SCENE, this.beforeTeammateChangeScene.bind(this));

        GlobalEventSystem.Bind(EventName.UPDATE_BOSS_DAMAGE_DATA, this.UpdateBossDamage.bind(this));
        GlobalEventSystem.Bind(EventName.ADD_BOSS_DAMAGE_DATA, this.AddBossDamage.bind(this));
        GlobalEventSystem.Bind(EventName.REMOVE_BOSS_DAMAGE_DATA, this.RemoveDamage.bind(this));
        GlobalEventSystem.Bind(SceneManager.START, this.changeScene.bind(this));


        GlobalEventSystem.Bind(EventName.GAME_START, () => {
            GhostWalkModel.ins.CheckDayFristLogin()
            RedDotController.ins.up(RedKey.GHOST_WALK_CAN_FIGHT, 0);
            this._model.Fire(GhostWalkEvent.SendFmt20601);
        }
        )


    }
    changeScene() {
        const isGhostWalkScene = SceneManager.GetInstance().IsGhostWalkScene();
        if (isGhostWalkScene) {
            this.EnterSceneHandle();
        } else {
            this.ExitSceneHandle();
        }
    }
    public EnterSceneHandle() {
        BossModel.GetInstance().main_ui_setting_flag = true;
        this._model.Fire(GhostWalkEvent.ENTER_SCENE, true);
        MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false);
        GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GhostWalkSceneView');
    }

    public ExitSceneHandle() {
        GlobalEventSystem.Fire(EventName.CLOSE_VIEW, 'GhostWalkSceneView');
    }
    goPointArgv: IGhostWalkPointInfo;
    goPoint(argv: IGhostWalkPointInfo) {
        argv = argv || this.goPointArgv;
        if (!argv) return;
        this._model.goPointArgv = argv
        let nowSceneId = SceneManager.GetInstance().GetSceneId();
        if (SceneManager.GetInstance().IsGhostWalkScene()) {
            if (nowSceneId == argv[2]) {
                this._model.Fire(GhostWalkEvent.FIND_WAY, argv);
                this.goPointArgv = null;
            } else {
                this._model.Fire(GhostWalkEvent.SendFmt20604);
                this._model.Fire(GhostWalkEvent.SendFmt20603, argv[2]);
                this.goPointArgv = argv;
            }
        } else {
            this._model.Fire(GhostWalkEvent.SendFmt20603, argv[2]);
            this.goPointArgv = argv;
        }
    }
    UpdateDamagePercent(teamDict: { [key: number]: IGhostWalkBossTeamHurtInfo }) {
        let totalHurt = 0
        let vo: IGhostWalkBossTeamHurtInfo
        for (var key in teamDict) {
            vo = teamDict[key]
            if (vo) {
                totalHurt += vo.teamHurt
            }
        }
        for (let teamID in teamDict) {
            let maxDmgPlayerName = '';
            let maxDmg = 0;
            let team = teamDict[teamID];

            team.playerInfo.forEach((p) => {
                if (p && (p.damage > maxDmg || maxDmg == 0)) {
                    maxDmgPlayerName = p.player_name;
                    maxDmg = p.damage;
                }
            });
            team.teamName = maxDmgPlayerName;
            team.teamHurtPercent = ((team.teamHurt / totalHurt) * 100).toFixed(2);
        }
    }
    UpdateBossDamage(monster_id, list) {
        if (!SceneManager.GetInstance().IsGhostWalkScene()) return;
        let teamDict: { [key: number]: IGhostWalkBossTeamHurtInfo } = {};
        for (const player of list) {
            let teamId = player.team_id || player.player_id;
            let team = teamDict[teamId];
            if (!team) {
                teamDict[teamId] = {
                    isTeam: player.team_id != 0,
                    teamHurt: 0,
                    teamHurtPercent: '0',
                    teamId,
                    playerInfo: [],
                    teamName: ''
                };
                team = teamDict[teamId];
            }
            team.teamHurt += player.damage;
            let teammateIndex = team.playerInfo.findIndex((teammate) => teammate.player_id == player.player_id);
            if (teammateIndex == -1) {
                team.playerInfo.push(player);
            } else {
                team.playerInfo[teammateIndex] = player;
            }
        }
        this.UpdateDamagePercent(teamDict);
        this._model.bossDmgDict[monster_id] = teamDict;
        this._model.Fire(GhostWalkEvent.UPDATE_DAMAGE);
    }
    AddBossDamage(vo) {
        if (!SceneManager.GetInstance().IsGhostWalkScene()) return;
        let teamDict = this._model.bossDmgDict[vo.monster_id];
        if (!teamDict) {
            teamDict = {};
            this._model.bossDmgDict[vo.monster_id] = teamDict;
        }
        let team: IGhostWalkBossTeamHurtInfo = teamDict[vo.team_id];
        if (!team) {
            team = {
                isTeam: vo.team_id != 0,
                teamHurt: 0,
                teamHurtPercent: '',
                teamName: '',
                teamId: vo.team_id || vo.player_id,
                playerInfo: []
            };
            teamDict[vo.team_id] = team;
        }
        team.teamHurt += vo.damage;

        if (team && team.playerInfo && team.playerInfo.length > 0) {

            let player = team.playerInfo.find((player_)=>{
				if(!player_)return false
				return player_.player_id == vo.player_id
			});
            
            if (player) {
                player.damage += vo.damage;
                player.team_position = vo.team_position;
                player.player_name = vo.player_name;
            } else {
                team.playerInfo.push(Util.DeepCopy(vo));
            }
        } else {
            delete teamDict[vo.team_id]
        }

        this.UpdateDamagePercent(teamDict);
        this._model.Fire(GhostWalkEvent.UPDATE_DAMAGE);
    }
    RemoveDamage(monster_id, list) {
        if (!SceneManager.GetInstance().IsGhostWalkScene()) return;
        let teamDict = this._model.bossDmgDict[monster_id];
        if (!teamDict) return;
        for (let teamID in teamDict) {
            const team = teamDict[teamID];
            for (const player of list) {

                let teammateIndex = team.playerInfo.findIndex((teammate)=>{
                    if(!teammate)return false
                    return teammate.player_id == player.player_id
                });

                //let teammateIndex = team.playerInfo.findIndex((teammate) => teammate.player_id == player.player_id);

                if (teammateIndex == -1) continue;
                team.teamHurt -= team.playerInfo[teammateIndex].damage;
                team.playerInfo.splice(teammateIndex, 1);
                if (team.playerInfo.length == 0) {
                    delete teamDict[teamID]
                    break;
                }
            }
        }
        this.UpdateDamagePercent(teamDict);
        this._model.Fire(GhostWalkEvent.UPDATE_DAMAGE);
    }
    beforeTeammateChangeScene(role_id, scene_id) {
        let sceneMgr = SceneManager.GetInstance();
        // 不是移动到百鬼场景就直接寄
        if (!sceneMgr.IsGhostWalkScene(scene_id)) return;
        let teamInfo = TeamModel.GetInstance().team_info;
        if (!teamInfo) return;
        // 不是队长就直接寄
        let teamLeader = teamInfo.team_member_list.find((mem) => mem.id == role_id && mem.team_position == 1);
        if (!teamLeader) return;
        // 是队长而且是自己就直接寄
        if (RoleManager.GetInstance().GetMainRoleId() == role_id) return;
        // 已经在当前场景就直接寄
        if (sceneMgr.GetSceneId() == scene_id) return;

        let cfg = new AlertConfig();
        cfg.show_content = `小队队长邀请您一同进入${sceneMgr.GetSceneInfo(scene_id)?.name || '百鬼夜行'}`;
        cfg.ok_callback = () => {
            // 离开当前场景，去队长那里
            if (sceneMgr.IsGhostWalkScene()) {
                this._model.Fire(GhostWalkEvent.SendFmt20604);
            }
            this._model.Fire(GhostWalkEvent.SendFmt20603, scene_id);
        };
        cfg.type = Alert_Type.Two;
        Alert.ShowWithConfig(cfg);
    }

    registerProtocal() {
        this.RegisterProtocal(20600, this.on20600.bind(this));
        this.RegisterProtocal(20601, this.on20601.bind(this));
        this.RegisterProtocal(20602, this.on20602.bind(this));
        this.RegisterProtocal(20603, this.on20603.bind(this));
        this.RegisterProtocal(20604, this.on20604.bind(this));
        this.RegisterProtocal(20605, this.on20605.bind(this));
    }
    on20600() {
        let scmd = UserMsgAdapter.GetInstance().GetSCMD(20600);
        if (scmd) {
            Util.ErrorCodeShow(scmd.code);
        }
    }
    send20601() {
        this.SendFmtToGame(20601);
    }
    on20601() {
        let scmd = UserMsgAdapter.GetInstance().GetSCMD(20601);
        if (scmd) {
            // kfStageModel.GetInstance().SetGhostWalkData(scmd);
            this._model.serInfo = scmd;
            this._model.Fire(GhostWalkEvent.RecvFmt20601);
            this._model.Fire(GhostWalkEvent.SendFmt20602, 0);
        }
    }
    send20602(scene_id: number) {
        this.SendFmtToGame(20602, 'i', scene_id);
    }
    on20602() {
        let scmd = UserMsgAdapter.GetInstance().GetSCMD(20602);
        if (scmd) {
            let boss_num = 0
            if (scmd.scene_list && scmd.scene_list.length > 0) {
                for (let i = 0; i < scmd.scene_list.length; i++) {
                    boss_num += scmd.scene_list[i].num
                }
            }

            let state = boss_num > 0 ? 1 : 0
            RedDotController.ins.up(RedKey.GHOST_WALK_CAN_FIGHT, state);
            this._model.setRed()
            this._model.Fire(GhostWalkEvent.RecvFmt20602, scmd);
        }
    }
    send20603(scene_id: number) {
        this.SendFmtToGame(20603, 'i', scene_id);
    }
    on20603() { }
    send20604(scene_id: number) {
        this.SendFmtToGame(20604);
    }
    on20604() { }
    nowBossId: number;
    send20605(boss_id: number) {
        this.nowBossId = boss_id;
        this.SendFmtToGame(20605, 'i', boss_id);
    }
    on20605() {
        let scmd = UserMsgAdapter.GetInstance().GetSCMD(20605);
        if (scmd) {
        }
    }
}

window['GhostWalkController'] = GhostWalkController;
