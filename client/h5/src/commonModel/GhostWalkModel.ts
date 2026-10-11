import { Alert, Alert_Type } from '../alert/Alert';
import { Config } from '../common/Config';
import { CookieWrapper } from '../common/CookieWrapper';
import { EventName } from '../common/EventName';
import { RedDotController } from '../common/RedDotController';
import { RedKey } from '../common/RedDotDefine';
import { ResManager } from '../common/ResManager';
import { CrossServerViewIndex } from '../commonController/BossController';
import { SceneManager } from '../scene/SceneManager';
import { SceneObj } from '../scene/sceneobj/SceneObj';
import { ServerTimeModel } from '../serverTime/ServerTimeModel';
import { Message } from '../sysInfo/SysInfoController';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { ErlangParser } from '../util/ErlangParser';
import { EventDispatcher } from '../util/EventDispatcher';
import { GameMath } from '../util/GameMath';
import { Util } from '../util/Util';
import { Vector2 } from '../util/Vector2';
import { RoleManager } from './RoleManager';
import { TeamModel } from './TeamModel';

export interface IGhostWalkPointInfo {
    /** 坐标 */
    [0]: { [axis: number]: number };
    /** 地点名字 */
    [1]: string;
    /** 场景ID */
    [2]: number;
}
export interface IGhostWalkBossInfo {
    bossId;
    bossNum;
    sceneId;
    appearPoint: IGhostWalkPointInfo[];
}
export interface IGhostWalkBossTeamHurtInfo {
    teamHurt: number;
    teamHurtPercent: string;
    teamName: string;
    teamId: number;
    isTeam: boolean;
    playerInfo: {
        player_id: number;
        player_name: string;
        server_id: number;
        server_num: number;
        server_name: string;
        team_id: number;
        team_position: number;
        damage: number;
        assist_id: number;
    }[];
}
export const GhostWalkEvent = {
    SendFmt20601: 'SendFmt20601',
    SendFmt20602: 'SendFmt20602',
    SendFmt20603: 'SendFmt20603',
    SendFmt20604: 'SendFmt20604',
    SendFmt20605: 'SendFmt20605',

    RecvFmt20601: 'RecvFmt20601',
    RecvFmt20602: 'RecvFmt20602',
    RecvFmt20603: 'RecvFmt20603',
    RecvFmt20604: 'RecvFmt20604',
    RecvFmt20605: 'RecvFmt20605',

    UPDATE_SERVER_INFO: 'UPDATE_SERVER_INFO',
    GO_POINT: 'GO_POINT',
    FIND_WAY: 'FIND_WAY',
    SCENE_COMPLETE: 'SCENE_COMPLETE',
    UPDATE_DUNGEON_END_TIME: 'UPDATE_DUNGEON_END_TIME',
    GET_DAMAGE_LIST: 'GET_DAMAGE_LIST',
    UPDATE_DAMAGE: 'UPDATE_DAMAGE',
    ENTER_SCENE: 'ENTER_SCENE',
    UPDATE_SELECT: 'UPDATE_SELECT',
    CLICK_GROUP_BTN: 'CLICK_GROUP_BTN'
};
export class GhostWalkModel extends EventDispatcher {
    private static _ins: GhostWalkModel;
    public serInfo: ProtoRecvVObj<20601>;

    private modelKVCfg;
    private bossCfg;
    private bossCfg_Id_SceneId;
    private rewardCfg;
    public bossDmgDict: { [bossID: number]: { [teamID: number]: IGhostWalkBossTeamHurtInfo } } = {};
    goPointArgv: IGhostWalkPointInfo;
    select_index=-1
    login_red = false
    static get ins() {
        if (!GhostWalkModel._ins) {
            GhostWalkModel._ins = new GhostWalkModel();
            GhostWalkModel._ins.initCfg();
        }
        return GhostWalkModel._ins;
    }
    async initCfg() {
        this.bossCfg = Config.PRELOAD_SERVER_CONFIG.config_night_ghost_boss
        let bossCfg_Id_SceneId = {};
        for (let key in this.bossCfg) {
            let c = this.bossCfg[key];
            if (!bossCfg_Id_SceneId[c.ser_mod]) {
                bossCfg_Id_SceneId[c.ser_mod] = {};
            }
            bossCfg_Id_SceneId[c.ser_mod][`${c.mon_id}_${c.scene_id}`] = c;
        }
        this.bossCfg_Id_SceneId = bossCfg_Id_SceneId;
        this.rewardCfg = Config.PRELOAD_SERVER_CONFIG.config_night_ghost_reward
        this.modelKVCfg = Config.PRELOAD_SERVER_CONFIG.config_night_ghost_kv
    }
    parse(cfg): any[] {
        return ErlangParser.GetInstance().parse(cfg);
    }
    getBossList(vo: ProtoRecvVObj<20602>) {
        let cfg = this.bossCfg_Id_SceneId[this.serInfo.ser_mod];
        let bossList: IGhostWalkBossInfo[] = [];
        for (const id_sceneid in cfg) {
            let [bossId, sceneId] = id_sceneid.split('_');
            bossList.push({
                bossId,
                bossNum: 0,
                sceneId: Number(sceneId),
                appearPoint: this.parse(cfg[id_sceneid].loc_list).map((item) => {
                    item[0][0] = Number(item[0][0]);
                    item[0][1] = Number(item[0][1]);
                    return Object.assign(item, { [2]: Number(sceneId) });
                })
            });
        }
        for (const scene of vo.scene_list) {
            for (const boss of scene.boss_list) {
                let result = bossList.find((b) => boss.boss_id == b.bossId && b.sceneId == scene.scene_id);
                if (result) {
                    result.bossNum++;
                }
            }
        }
        return bossList;
    }
    getPointList(scene: ArrayElement<ProtoRecvVObj<20602>['scene_list']>): IGhostWalkPointInfo[] {
        if (!scene) return;
        let cfg = this.bossCfg_Id_SceneId[this.serInfo.ser_mod];
        let pointList: IGhostWalkPointInfo[] = [];
        for (const id_sceneid in cfg) {
            let [_, sceneId] = id_sceneid.split('_');
            if (Number(sceneId) == scene.scene_id) {
                pointList.push(
                    ...this.parse(cfg[id_sceneid].loc_list).map((item) => {
                        item[0][0] = Number(item[0][0]);
                        item[0][1] = Number(item[0][1]);
                        return Object.assign(item, { [2]: Number(scene.scene_id) });
                    })
                );
            }
        }
        return pointList;
    }
    getDamageList(bossId) {
        if (!this.bossDmgDict || !this.bossDmgDict[bossId]) return [];
        let teamDict = this.bossDmgDict[bossId];
        return Object.values(teamDict)
            .filter((team) => !!team)
            .sort((a, b) => {
                return b.teamHurt - a.teamHurt;
            });
    }
    isMyInfo(hurtInfo: IGhostWalkBossTeamHurtInfo) {
        if (hurtInfo.teamId == 0) {
            return !!hurtInfo.playerInfo.find((info) => info.player_id == RoleManager.GetInstance().GetMainRoleId());
        } else {
            return TeamModel.GetInstance()?.team_info?.team_id == hurtInfo.teamId;
        }
    }
    getFakeRewardList(size) {
        let rewardList = this.parse(this.modelKVCfg[4].value).map((vo) => {
            return {
                size,
                vo: {
                    style: vo[0],
                    typeId: vo[1],
                    count: vo[2]
                }
            };
        });
        return rewardList;
    }
    getRewardList(size) {
        let open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
        let cfgList: any = Object.values(this.rewardCfg).filter((reward: any) => reward.min_opday <= open_day && open_day <= reward.max_opday);
        let rewardList: {
            type: number;
            rank: number;
            nextRank?: number;
            reward: {
                size: any;
                vo: {
                    style: any;
                    typeId: any;
                    count: any;
                };
            }[];
        }[] = cfgList
            .map((cfg) => {
                return {
                    type: cfg.type as number,
                    rank: cfg.highest_rank as number,
                    reward: (this.parse(cfg.reward) as any[]).map((vo) => {
                        return {
                            size,
                            vo: {
                                style: vo[0],
                                typeId: vo[1],
                                count: vo[2]
                            }
                        };
                    })
                };
            })
            .sort((a, b) => {
                if (a.type != b.type) {
                    return b.type - a.type;
                }
                return a.rank - b.rank;
            });
        for (let i = 1, len = rewardList.length; i < len; i++) {
            if (i + 1 == len) {
                rewardList[i].nextRank = Infinity;
                break;
            }
            if (rewardList[i].rank + 1 == rewardList[i + 1].rank) continue;
            rewardList[i].nextRank = rewardList[i + 1].rank - 1;
        }
        return rewardList;
    }
    getRewardCfg() {
        return this.rewardCfg;
    }
    distance = 600 * 600;
    // 在场景中获取需要显示出伤害列表的bossid
    getNearBoss(): number {
        let scene_id = SceneManager.GetInstance().GetSceneId()
        let monCfg 
        for(let key in this.bossCfg){
            let cfg_vo = this.bossCfg[key]
            if(cfg_vo&&cfg_vo.scene_id == scene_id){
                monCfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, cfg_vo.mon_id, false);
                break
            }
        }
        if(!monCfg)return 0
        let list = SceneManager.GetInstance().getMonsterList();
        let dis;
        let mainRoleVo = RoleManager.GetInstance().GetMainRoleVo();
        for (let k in list) {
            var v = list[k];
            if (v.boss_type == monCfg.boss) {
                dis = GameMath.GetDistance(mainRoleVo.pos_x, mainRoleVo.pos_y, v.pos_x, v.pos_y, false);
                if (dis <= this.distance) {
                    return v.instance_id;
                }
            }
        }
        return 0;
    }
    setRed() {
        let red_state = RedDotController.ins.get(RedKey.GHOST_WALK_CAN_FIGHT) || this.GetDayFirstLoginStatus()
        let open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
        if (open_day > 7) {
            GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, 'CrossServerEnterView', CrossServerViewIndex.GhostWalk, red_state);
        } else GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, 'WorldBattleEnterViewTwo', 1, red_state);
        GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, '241@1@0');
        GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
        GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 241)
    }
    getRed(){
        return this.GetActiveIconRed()
    }
    public GetActiveIconRed(){
        return RedDotController.ins.get(RedKey.GHOST_WALK_CAN_FIGHT) || this.GetDayFirstLoginStatus()
    }
    /**前往链接指引的地图 */
    public SkipToMap(target_sceneId: number, pos: Vector2) {
        if (!this.bossCfg) {
            return
        }
        let ok_func = () => {
            let min_dis = -1
            let argv = null
            let select_index=0 //更新战斗界面选中
            for (let key in this.bossCfg) {
                let vo = this.bossCfg[key]
                if (vo && vo.scene_id == target_sceneId&&this.serInfo.ser_mod ==vo.ser_mod) {
                    let list = ErlangParser.GetInstance().parse(vo.loc_list)
                    for (let i = 0; i < list.length; i++) {
                        let map_vo = list[i]
                        let x0 = Number(map_vo[0][0])/ SceneObj.LogicRealRatio2D.x;
                        let y0 = Number(map_vo[0][1])/ SceneObj.LogicRealRatio2D.y;
                        let x_step = x0 - pos.x;
                        let y_step = y0 - pos.y;
                        let val = x_step * x_step + y_step * y_step;
                        if (min_dis == -1) {
                            min_dis = val
                            //
                            argv = Util.DeepCopy(map_vo)
                            select_index=i
                        } else {
                            if (min_dis > val) {
                                min_dis = val
                                argv = Util.DeepCopy(map_vo)
                                select_index=i
                            }
                        }
                    }
                    break;
                }
            }
            if (!argv) {
                Message.show("地图已经变化")
                return
            }
            argv["2"] = target_sceneId
            this.Fire(GhostWalkEvent.GO_POINT, argv, true);
            this.Fire(GhostWalkEvent.UPDATE_SELECT, select_index);
        }
        if (this.serInfo && this.serInfo.state == 0) {
            // 活动未开启
            Alert.Show('所有场景中未有boss入侵迹象，是否仍要进入？', Alert_Type.Two, () => {
                ok_func()
            });
        }else{
            ok_func()
        }
    }
    //**
    //* 检测玩家是否是当天第一次登陆
    //*
    public CheckDayFristLogin = () => {
        let cookie_wrapper = CookieWrapper.GetInstance()
        let last_date = cookie_wrapper.GetCookie(CookieWrapper.COOKIE_GHOST_WALK_RED)
        let now_date = new Date()
        let date = `${now_date.getFullYear()}-${now_date.getMonth() + 1}-${now_date.getDate()}`
        if (last_date != date) {
            this.login_red = true
        }
    }
    public SaveEduDayFristLogin(){
        let now_date = new Date()
        let date = `${now_date.getFullYear()}-${now_date.getMonth() + 1}-${now_date.getDate()}`
        CookieWrapper.GetInstance().SaveCookie(CookieWrapper.COOKIE_GHOST_WALK_RED, date)
    }
    public GetDayFirstLoginStatus = () => {
        return this.login_red 
    }
}

window['GhostWalkModel'] = GhostWalkModel;
