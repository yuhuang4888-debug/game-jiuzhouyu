import { Alert, AlertConfig, Alert_Type } from '../alert/Alert';
import { AutoFightManager } from '../autofight/AutoFightManager';
import { BaseView1 } from '../common/BaseView1';
import { EventName, SceneEventType } from '../common/EventName';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { MainUIManager } from '../common/MainUIManager';
import { ResManager } from '../common/ResManager';
import { ChatModel, ChatModelEvent, CHAT_TYPE } from '../commonModel/ChatModel';
import { GhostWalkEvent, GhostWalkModel, IGhostWalkBossTeamHurtInfo, IGhostWalkPointInfo } from '../commonModel/GhostWalkModel';
import { RoleManager } from '../commonModel/RoleManager';
import { MainUITaskTeamView } from '../mainUI/MainUITaskTeamView';
import { Scene } from '../scene/Scene';
import { SceneManager } from '../scene/SceneManager';
import { SceneObj } from '../scene/sceneobj/SceneObj';
import { Message } from '../sysInfo/SysInfoController';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { Runner } from '../util/Runner';
import { SYTweenFunc } from '../util/SYTweenFunc';
import { SYTweenLite } from '../util/SYTweenLite';
import { TimeUtil } from '../util/TimeUtil';
import { GetSizeDeltaX, GlobalTimerQuest, HtmlColorTxt, RefBoxChildsLayout, Util } from '../util/Util';
import { Vector2 } from '../util/Vector2';
import { GhostWalkSceneDamageItem } from './GhostWalkSceneDamageItem';
import { GhostWalkScenePointItem } from './GhostWalkScenePointItem';
import { Config } from '../common/Config';
import { Enum_ColorUtil_Dark } from '../util/ColorUtil';

export class GhostWalkSceneView extends BaseView1 {
    _model: GhostWalkModel;
    time_id_: any[];
    time_func_: any[];
    last_time: number;
    scene_id: number;
    damageLoopMgr: LoopScrowViewMgr;
    wayFindingLoopMgr: LoopScrowViewMgr;
    scene: Scene;
    hurtList: IGhostWalkBossTeamHurtInfo[] = [];
    pointList: IGhostWalkPointInfo[] = [];
    tween_id;
    tween_id2;
    tween_id3;
    bossNum
    scene_info


    is_pop = false
    is_pop2 = false

    constructor() {
        super();

        this.base_file = 'ghostWalk';
        this.layout_file = 'GhostWalkSceneView';
        this.layer_value = Enum_UILayer.Main;
        this.destroy_imm = true;
        this.back_login_toClose = true;
        this._model = GhostWalkModel.ins;
        this.scene = Scene.GetInstance();
        this.bossNum = 0

        this.preload_server_config = {
            config_dungeon: false,
            config_dungeon_ui_content: false.valueOf,
        };
        this.load_callback = () => {
            this.LoadSuccsss();
            this.InitEvent();
        };

        this.open_callback = () => {
            this._model.Fire(GhostWalkEvent.SendFmt20601);
            this.updateSceneView();
        };

        this.close_callback = () => {
        };

        this.destroy_callback = () => {
            this.Remove();
        }
    }
    public Open() {
        super.Open();
        this._model.Fire(GhostWalkEvent.SCENE_COMPLETE);
    }
    public LoadSuccsss() {
        this.htmlBossLeftNum.style.color = '#ffffff';
        this.htmlBossLeftNum.style.fontSize = 18;
        this.htmlBossLeftNum.style.wordWrap = false;

        this.boxMine.visible = false;

        MainUIManager.GetInstance().AddMoveComponent(this, this._box_wayfinding, false, MainUIManager.MOVE_TYPE.Stay);
        MainUIManager.GetInstance().AddMoveComponent(this, this._box_exit, false, MainUIManager.MOVE_TYPE.Left);
        MainUIManager.GetInstance().AddMoveComponent(this, this._box_damage, false, MainUIManager.MOVE_TYPE.Left);
        MainUIManager.GetInstance().AddMoveComponent(this, this._box_boss, false, MainUIManager.MOVE_TYPE.Right);
    }


    public SendLocPostion(channel) {
        let scene_info = SceneManager.GetInstance().scene_Info
        if (!scene_info) {
            return
        }
        let roleVo = RoleManager.GetInstance().GetMainRoleVo()
        let bossId = this._model.getNearBoss();
        let scene_id = SceneManager.GetInstance().GetSceneId()

        let cus_args = [`{ng_boss_broadcast,${channel},${scene_id},${bossId}}`]
        let content = ChatModel.GetInstance().positionChat(scene_info)
        ChatModel.GetInstance().Fire(ChatModelEvent.CHAT_SEND_MSG, 11001, channel, roleVo.province, roleVo.city, 0, content, cus_args, 0, "", true)
        Message.show("发出召集")
    }

    InitEvent() {
        Util.AddClickEvent(this._box_exit, this.ExitScene.bind(this), this, true);
        Util.AddClickEvent(
            this.btnBoss,
            () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GhostWalkBossEntryView');
            },
            this,
            true
        );

        Util.AddClickEvent(this.imgArrow, this.ShowDamagePanel.bind(this, false), this, true);
        Util.AddClickEvent(this._img_rank, this.ShowDamagePanel.bind(this, true), this, true);

        Util.AddClickEvent(this._img_call, () => {
            this.SendLocPostion(CHAT_TYPE.WORLD)
        }, this, true);

        Util.AddClickEvent(this._img_call_kf, () => {
            //发到百鬼夜行频道  客户端再接入到跨服频道
            this.SendLocPostion(CHAT_TYPE.GHOST_WALK)
        }, this, true);

        this.BindEvent(GlobalEventSystem, EventName.SHOW_MAIN_UI_TASK, (show?) => {
            if (this.tween_id) {
                SYTweenLite.Stop(this.tween_id);
            }
            let endValue = (show && 6) || -GetSizeDeltaX(this._box_wayfinding);

            let tween_type = (show && SYTweenFunc.EASE_IN_BACK) || SYTweenFunc.EASE_OUT_BACK;

            let interval = MainUITaskTeamView.MoveInterval * 0.6;
            this.tween_id = SYTweenLite.to(
                this,
                this._box_wayfinding,
                SYTweenLite.UiAnimationType.ANCHORED_POSX,
                endValue,
                interval,
                () => {
                    SYTweenLite.Stop(this.tween_id);
                    this.tween_id = null;
                },
                tween_type
            );
        });
        this.BindEvent(GlobalEventSystem, EventName.SHOW_BOSS_WAY_PANEL, this.ShowBossPanel.bind(this));
        this.BindEvent(GlobalEventSystem, SceneEventType.MONSTER_VO_REMOVE, this.updateSceneView.bind(this));
        this.BindEvent(this._model, GhostWalkEvent.ENTER_SCENE, this.updateSceneView.bind(this));
        this.BindEvent(this._model, EventName.SHOW_BOSS_WAY_PANEL, this.ShowBossPanel.bind(this));
        this.BindEvent(this._model, GhostWalkEvent.FIND_WAY, (argv) => {
            let { 0: x, 1: y } = argv[0];
            this.selectIndex = this.pointList.findIndex((point) => point[0][0] == x && point[0][1] == y);
            if (this.wayFindingLoopMgr) {
                this.wayFindingList.selectedIndex = -1
                this.wayFindingLoopMgr.SetSelectIndex(this.selectIndex)
                this.wayFindingList.scrollTo(this.selectIndex)
            }
        });
        this.BindEvent(this._model, GhostWalkEvent.UPDATE_DAMAGE, this.updateDamageItem.bind(this));

        this.BindEvent(this._model, GhostWalkEvent.RecvFmt20601, this.updateView.bind(this));
        this.BindEvent(this._model, GhostWalkEvent.RecvFmt20602, (vo) => {
            this.updatePointList(vo);
            if (!this.is_pop2 && vo.scene_list.length >= 3) {
                this.is_pop2 = true
                this.ShowAlert(vo)
            }

        });

        this.BindEvent(this._model, GhostWalkEvent.UPDATE_SELECT, (selet_index?) => {
            if (this.wayFindingLoopMgr) {
                this.selectIndex = selet_index
                this.wayFindingList.selectedIndex = -1
                // this.wayFindingLoopMgr.SetSelectIndex(this.selectIndex)
            }
        });


        this.BindEvent(GlobalEventSystem, SceneEventType.SCENE_CHANGED, () => {
            console.warn("测试@切换一次场景")
            this.is_pop = false
        })

        Runner.GetInstance().AddRunObj(this);
    }
    public Remove() {
        this.CancelCountTime();
        Runner.GetInstance().RemoveRunObj(this.hashCode);
        SYTweenLite.Stop(this.tween_id);
        SYTweenLite.Stop(this.tween_id2);
        SYTweenLite.Stop(this.tween_id3);
        MainUIManager.GetInstance().RemoveMoveComponent(this);

        if (this.wayFindingLoopMgr) {
            this.wayFindingLoopMgr.DeleteMe();
            this.wayFindingLoopMgr = null;
        }
        if (this.damageLoopMgr) {
            this.damageLoopMgr.DeleteMe();
            this.damageLoopMgr = null;
        }


    }
    updateView() {
        let inScene = SceneManager.GetInstance().IsGhostWalkScene();
        this._gp_count_down.visible = !!this._model.serInfo.etime || !inScene;
        this.ShowQuitTime(this._model.serInfo.etime, () => { });
        this.scene_id = SceneManager.GetInstance().GetSceneId();
        this.updateSceneView();
    }
    StartCountTime(index?, func?) {
        if (!this.time_id_) {
            this.time_id_ = [];
        }
        if (!this.time_func_) {
            this.time_func_ = [];
        }
        this.CancelCountTime(index);
        // [ts2lua]time_func_下标访问可能不正确
        this.time_func_[index] = func;
        this.time_id_[index] = GlobalTimerQuest.AddPeriodQuest(func, 1);

        func();
    }

    CancelCountTime(index?) {
        if (index == null) {
            if (!this.time_id_) {
                return;
            }
            for (let key in this.time_id_) {
                GlobalTimerQuest.CancelQuest(this.time_id_[key]);
            }
            this.time_id_ = null;
            this.time_func_ = null;
        } else {
            // [ts2lua]time_id_下标访问可能不正确
            if (!this.time_id_ || !this.time_id_[index]) {
                return;
            }
            GlobalTimerQuest.CancelQuest(this.time_id_[index]);
            // [ts2lua]time_id_下标访问可能不正确
            this.time_id_.splice(index, 1);
            this.time_func_.splice(index, 1);
        }
    }
    ShowQuitTime(end_time?, end_func?) {
        // if (!this._gp_quit_time.visible) {
        //     this._gp_quit_time.visible = true;
        // }
        // this.ShowCountDown(false);
        this._gp_count_down.visible = false;
        this.StartCountTime(4, () => {
            let left_time = end_time - TimeUtil.getServerTime();
            // 30走配置
            if (left_time < 30) {
                this._gp_count_down.visible = true;
            }
            if (left_time < 0) {
                this._gp_count_down.visible = false;
                this.CancelCountTime(4);
                if (end_func) {
                    end_func();
                }
                return;
            }
            if (this._lb_count_down) {
                this._lb_count_down.changeText(`${TimeUtil.timeConvert8(left_time)}`);
            }
        });
    }
    nearBossId: number;
    update_times_index = 0;
    is_out_of_range=false
    public Update() {
        let bossId = this._model.getNearBoss();
        this.nearBossId = bossId;

        this._img_call.visible = bossId && bossId > 0
        let level = RoleManager.GetInstance().GetMainRoleVo().level
        this._img_call_kf.visible = (bossId && bossId > 0) && this._model.serInfo.ser_mod >= 2 && level >= ChatModel.GetInstance().ViewClassCFG[CHAT_TYPE.SMALL_KUAFU].openLevel
        RefBoxChildsLayout(this._box_call, 10, 72, true, "center")

        if (!bossId){
            if(!this.is_out_of_range){
                this.is_out_of_range=true
                if(this.damageLoopMgr)this.damageLoopMgr.replaceAll([]);
                console.warn("测试@脱离范围")
            }
            return
        }
        this.update_times_index = this.update_times_index + 1;
        if (this.update_times_index % 20 == 0) {
            this.is_out_of_range =false
            this._model.Fire(GhostWalkEvent.GET_DAMAGE_LIST, bossId);
            this.update_times_index = 0;
        }


        //进入一定范围 显示召集按钮
        // let monster_list = Scene.GetInstance().FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, 400, null, null, null)[0]
        // this._img_call.visible = monster_list && monster_list.length > 0

    }

    private updatePointList(vo: ProtoRecvVObj<20602>) {
        if (!vo.scene_list?.length) return;

        //根据场景 拿到对应秘境的数据
        let scene_id = SceneManager.GetInstance().GetSceneId()
        this.scene_info = null
        for (let i = 0; i < vo.scene_list.length; i++) {
            let vo1_ = vo.scene_list[i]
            if (vo1_.scene_id == scene_id) {
                this.scene_info = vo1_
                break;
            }
        }
        if (!this.scene_info) return


        this.bossNum = this.scene_info.boss_list.length;
        this.htmlBossLeftNum.innerHTML = `Boss剩余数量: <font color='#00fa64'>${this.scene_info.boss_list.length}</font>`;
        this.pointList = this._model.getPointList(this.scene_info);


        if (this._model.goPointArgv) {
            let argv = this._model.goPointArgv
            let { 0: x, 1: y } = argv[0];
            this.selectIndex = this.pointList.findIndex((point) => point[0][0] == x && point[0][1] == y);
            this._model.goPointArgv = null
        } else {
            this.selectIndex = this.selectIndex || 0
        }

        if (!this.wayFindingLoopMgr) {
            this.wayFindingLoopMgr = new LoopScrowViewMgr();
            this.wayFindingLoopMgr.SetData(this.wayFindingList, GhostWalkScenePointItem, this.pointList, LoopScrCon.Vertical, 6, (index) => {
                // 寻路
                if (!this.pointList[index]) return;
                this.selectIndex = index
                this.StartFindWay(this.pointList[index])
                // GhostWalkModel.ins.Fire(GhostWalkEvent.GO_POINT, this.pointList[index]);
            }, this.selectIndex);
        } else {
            this.wayFindingLoopMgr.replaceAll(this.pointList);
            this.wayFindingLoopMgr.SetSelectIndex(this.selectIndex)
        }

        const loop = () => {
            let end_time = this._model.serInfo.etime;
            let left_time = end_time - TimeUtil.getServerTime();
            if (left_time < 30) {
                this._model.Fire(GhostWalkEvent.UPDATE_DUNGEON_END_TIME);
                Laya.timer.clear(this, loop);
            }
            if (left_time < 0) {
                Laya.timer.clear(this, loop);
            }
        };
        Laya.timer.loop(1000, this, loop);


        if (this.bossNum == 0) {
            if (this.is_pop) {
                return
            }

            this.is_pop = true
            this.is_pop2 = false
            this._model.Fire(GhostWalkEvent.SendFmt20602, 0);

        }
    }


    private ShowAlert(vo: ProtoRecvVObj<20602>) {
        if (this.bossNum > 0) return
        Scene.GetInstance().ClearMainRoleFindWayState();

        //判断其他场景是否有剩余的boss
        let bossList = GhostWalkModel.ins.getBossList(vo);
        let num_count = 0
        let vo_temp
        for (let i = 0; i < bossList.length; i++) {
            let vo1_ = bossList[i]
            if (vo1_.bossNum > num_count) {
                num_count = vo1_.bossNum
                vo_temp = vo1_
            }
        }

        let cfg = new AlertConfig();
        if (!vo_temp) {
            cfg.show_content = '此活动所有场景Boss已被全部封印<br>是否退出场景？'
            cfg.ok_text = '确定'
            cfg.cancel_text = '取消'
            cfg.ok_callback = () => {
                GhostWalkModel.ins.Fire(GhostWalkEvent.SendFmt20604)
            }
            cfg.left_time = 10
            Alert.ShowWithConfig(cfg)
        } else {


            let sceneCfg = SceneManager.GetInstance().GetSceneInfo(vo_temp.sceneId);
            let scene_str = HtmlColorTxt(sceneCfg.name, Enum_ColorUtil_Dark.ORANGE)
            let left_num = HtmlColorTxt(vo_temp.bossNum, Enum_ColorUtil_Dark.GREEN)


            cfg.show_content = `此场景Boss已被全部封印，是否前往<br>${scene_str}(存活:${left_num})？`
            cfg.ok_text = '立即前往'
            cfg.cancel_text = '退出秘境'
            cfg.ok_callback = () => {
                GhostWalkModel.ins.Fire(GhostWalkEvent.GO_POINT, vo_temp.appearPoint[0], true);
            }
            cfg.cancel_callback = (bool?) => {
                if (!bool) {
                    GhostWalkModel.ins.Fire(GhostWalkEvent.SendFmt20604)
                }

            }
            cfg.type = Alert_Type.Two
            Alert.ShowWithConfig(cfg)
        }
    }



    private ShowDamagePanel(show?) {
        if (this.tween_id2) {
            SYTweenLite.Stop(this.tween_id2);
            this.tween_id2 = null;
        }

        let endValue = show ? 4 : -GetSizeDeltaX(this._box_damage);

        let tween_type = (show && SYTweenFunc.EASE_IN_BACK) || SYTweenFunc.EASE_OUT_BACK;
        let interval = MainUITaskTeamView.MoveInterval * 0.6;

        this.tween_id2 = SYTweenLite.to(
            this,
            this._box_damage,
            SYTweenLite.UiAnimationType.ANCHORED_POSX,
            endValue,
            interval,
            () => {
                this.tween_id2 = false;
            },
            tween_type
        );

        if (this.tween_id3) {
            SYTweenLite.Stop(this.tween_id3);
            this.tween_id3 = null;
        }
        endValue = (show && -GetSizeDeltaX(this._img_rank)) || 0;

        tween_type = (show && SYTweenFunc.EASE_OUT_BACK) || SYTweenFunc.EASE_IN_BACK;

        interval = MainUITaskTeamView.MoveInterval * 0.6;
        this.tween_id3 = SYTweenLite.to(
            this,
            this._img_rank,
            SYTweenLite.UiAnimationType.ANCHORED_POSX,
            endValue,
            interval,
            () => {
                this.tween_id3 = false;
            },
            tween_type
        );
    }
    private ShowBossPanel(show?) {
        this._box_wayfinding.visible = show;
        if (show) {
            MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._box_wayfinding);
            MainUIManager.GetInstance().AddMoveComponent(this, this._box_wayfinding, false, MainUIManager.MOVE_TYPE.Stay);
        } else {
            MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._box_wayfinding, false);
        }
    }
    selectIndex;
    private StartFindWay(argv: IGhostWalkPointInfo) {
        if (!argv[0] || !SceneManager.GetInstance().IsGhostWalkScene()) return;

        let { 0: x, 1: y } = argv[0];
        this.selectIndex = this.pointList.findIndex((point) => point[0][0] == x && point[0][1] == y);
        if (this.wayFindingLoopMgr)
            this.wayFindingLoopMgr.SetSelectIndex(this.selectIndex);
        Scene.GetInstance().MainRoleMove(new Vector2(x / SceneObj.GetLogicRealRatio().x, y / SceneObj.GetLogicRealRatio().y), 3, () => {
            if (!this._model.getNearBoss()) {
                let cfg = new AlertConfig();
                cfg.show_content = '当前坐标暂未发现怪物，是否前往其他可能坐标？';
                cfg.ok_text = '确定';
                cfg.cancel_text = '终止寻路';
                cfg.ok_callback = () => {
                    GhostWalkModel.ins.Fire(GhostWalkEvent.GO_POINT, this.pointList[(this.selectIndex + 1) % this.pointList.length]);
                };
                Alert.ShowWithConfig(cfg);
            } else {
                AutoFightManager.GetInstance().SetAutoFight(true);
            }
        });
    }
    private updateDamageItem() {
        this.hurtList = this._model.getDamageList(this.nearBossId);
        this.boxMine.visible = false;
        if (!this.damageLoopMgr) {
            this.damageLoopMgr = new LoopScrowViewMgr();
            this.damageLoopMgr.SetData(this.listDamage, GhostWalkSceneDamageItem, this.hurtList, LoopScrCon.Vertical);
        } else {
            this.damageLoopMgr.replaceAll(this.hurtList);
        }
        let dataIndex = this.hurtList.findIndex((hurtInfo) => this._model.isMyInfo(hurtInfo));
        if (dataIndex == -1) return;
        let data = this.hurtList[dataIndex];
        this.boxMine.visible = true;
        if (dataIndex > 2) {
            this.imgRank.visible = false;
            this.lblRank.visible = true;
            this.lblRank.text = `${dataIndex + 1}`;
        } else {
            this.lblRank.visible = false;
            this.imgRank.visible = true;
            ResManager.GetInstance().SetImageSprite(this, this.imgRank, 'ghostWalk', `ui_phb_1${dataIndex + 1}`);
        }
        if (data.teamId) {
            this.lblName.text = `${data.teamName.slice(0, 3)}${data.teamName.length > 3 ? '...' : ''}队伍`;
        } else {
            this.lblName.text = data.teamName;
        }
        this.lblDamage.text = `${data.teamHurtPercent}%`;
    }
    private updateSceneView() {
        Laya.timer.once(48, this, () => {
            this.scene_id = SceneManager.GetInstance().GetSceneId();
            this._model.Fire(GhostWalkEvent.SendFmt20602, 0);
        })
    }

    private ExitScene() {
        if (this.bossNum <= 0) {
            this._model.Fire(GhostWalkEvent.SendFmt20604, this.scene_id);
            return
        }
        let cfg = new AlertConfig();
        cfg.show_content = '主动退出该场景，您将无法获得该场景的结算奖励，是否确认退出？';
        cfg.type = Alert_Type.Two;
        cfg.ok_callback = () => {
            this._model.Fire(GhostWalkEvent.SendFmt20604, this.scene_id);
        };
        cfg.ok_text = '确定';
        cfg.cancel_text = '取消';
        Alert.ShowWithConfig(cfg);
    }


    _gp_count_down: Laya.Box
    _Image1: Laya.Image
    _Group1: Laya.HBox
    _Label1: Laya.Label
    _lb_count_down: Laya.Label
    _gp_quit_time: Laya.Box
    _img_quit_bg: Laya.Image
    _Image6: Laya.Image
    _lb_quit_time: Laya.Label
    _box_wayfinding: Laya.Box
    pannel_bg: Laya.Image
    wayFindingList: Laya.List
    htmlBossLeftNum: Laya.HTMLDivElement
    _box_damage: Laya.Box
    _img_bg: Laya.Image
    _img_bg2: Laya.Image
    _img_bg3: Laya.Image
    imgArrow: Laya.Image
    listDamage: Laya.List
    _lb_title: Laya.Label
    boxMine: Laya.Box
    imgRank: Laya.Image
    lblRank: Laya.Label
    lblName: Laya.Label
    lblDamage: Laya.Label
    _box_boss: Laya.Box
    btnBoss: Laya.Image
    _box_exit: Laya.Box
    _img_exit: Laya.Image
    _img_rank: Laya.Image
    _box_call: Laya.Box
    _img_call: Laya.Image
    _img_call_kf: Laya.Image
    public GetComponents() {
        [
            this._gp_count_down,
            this._Image1,
            this._Group1,
            this._Label1,
            this._lb_count_down,
            this._gp_quit_time,
            this._img_quit_bg,
            this._Image6,
            this._lb_quit_time,
            this._box_wayfinding,
            this.pannel_bg,
            this.wayFindingList,
            this.htmlBossLeftNum,
            this._box_damage,
            this._img_bg,
            this._img_bg2,
            this._img_bg3,
            this.imgArrow,
            this.listDamage,
            this._lb_title,
            this.boxMine,
            this.imgRank,
            this.lblRank,
            this.lblName,
            this.lblDamage,
            this._box_boss,
            this.btnBoss,
            this._box_exit,
            this._img_exit,
            this._img_rank,
            this._box_call,
            this._img_call,
            this._img_call_kf,
        ]
            = this.GetChildrenByNames([

                "_gp_count_down",
                "_Image1",
                "_Group1",
                "_Label1",
                "_lb_count_down",
                "_gp_quit_time",
                "_img_quit_bg",
                "_Image6",
                "_lb_quit_time",
                "_box_wayfinding",
                "pannel_bg",
                "wayFindingList",
                "htmlBossLeftNum",
                "_box_damage",
                "_img_bg",
                "_img_bg2",
                "_img_bg3",
                "imgArrow",
                "listDamage",
                "_lb_title",
                "boxMine",
                "imgRank",
                "lblRank",
                "lblName",
                "lblDamage",
                "_box_boss",
                "btnBoss",
                "_box_exit",
                "_img_exit",
                "_img_rank",
                "_box_call",
                "_img_call",
                "_img_call_kf",
            ])
    }
}
window["GhostWalkSceneView"] = GhostWalkSceneView