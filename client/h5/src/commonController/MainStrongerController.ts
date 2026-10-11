import { MainStrongerModel, MainStrongerEvent } from '../commonModel/MainStrongerModel';
import { ActivityIconManager } from './../commonModel/ActivityIconManager';
import { EventName, SceneEventType } from './../common/EventName';
import { RedKey, RedEvent } from './../common/RedDotDefine';
import { RedDotController } from './../common/RedDotController';
import { BaseController } from './../common/BaseController';
import { SceneManager } from '../scene/SceneManager';
import { BaseDungeonModel, DUN_TYPE } from '../commonModel/BaseDungeonModel';

import './../mainUI/MainUIStrongerView';
import { TaskModel } from '../commonModel/TaskModel';
import { MainRole } from '../scene/sceneobj/MainRole';
import { RoleManager } from '../commonModel/RoleManager';
import { CommonManager } from '../common/CommonManager';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';

export class MainStrongerController extends BaseController {
    private model: MainStrongerModel;
    constructor() {
        super();
        this.model = MainStrongerModel.ins;
        this.initEvent();
    }
    initEvent() {
        this.model.Bind(MainStrongerEvent.INIT_CONFIG_SUCCESS, () => {
            this.initRedDotChange();
            RedDotController.ins.Bind(RedEvent.RED_DOT_UPDATE, (key, state) => {
                // 自己的红点变更就不需要更新了，不然每次别的红点触发后都会走两边这里的逻辑
                if (key == RedKey.MAIN_STRONGER) return;
                this.redDotUpdate(key, state);
            });
            TaskModel.GetInstance().Bind(TaskModel.UPDATE_ALL_TASK_FROM_30000, () => {
                //获取到了已接受的觉醒任务列表，每次收到任务列表的时候加入列表或从列表中删除
                let receiveMap = TaskModel.GetInstance().GetHasReceiveTaskList();
                if(!receiveMap) return
                let combat = RoleManager.GetInstance().GetMainRoleVo().fighting;
                let taskId = Object.keys(receiveMap).find((task_id) => combat >= this.model.cfg.SkillAwakeTask[Number(task_id)]?.combat);
                this.model.taskVo = taskId ? receiveMap[Number(taskId)][0] : undefined;
                let spliceIndex = this.model.featureList.findIndex((f) => f.id == 10001);
                let changeFlag = false;
                if (taskId) {
                    if (spliceIndex == -1) {
                        changeFlag = true;
                        this.model.insertFeature(this.model.cfg.FeatureBinding[10001]);
                    }
                } else {
                    if (spliceIndex != -1) {
                        changeFlag = true;
                        this.model.featureList.splice(spliceIndex, 1);
                    }
                }
                changeFlag && this.updateStrongNum(this.model.featureList.length);
            });
        });

        this.Bind(SceneEventType.SCENE_CHANGED, () => {
            let sceneMgr = SceneManager.GetInstance();
            let lastSceneId = sceneMgr.GetLastSceneId();
            if (sceneMgr.IsMainCityAndFieldScene() && sceneMgr.IsMainLineDungeonScene(lastSceneId)) {
                // 从副本回到野外和主城
                let result_info = BaseDungeonModel.GetInstance().GetDungeonResultInfo();
                // 重新弹出气泡
                if (result_info && !isNaN(result_info.result) && result_info.result != 1) {
                    let typeDict = {
                        [DUN_TYPE.ReincarnationDun]: true,
                        [DUN_TYPE.Main_Line]: true,
                        [DUN_TYPE.New_Main_Line]: true
                    };
                    // 战斗失败
                    if (result_info.dun_type in typeDict) {
                        // 转生、主线副本
                        this.model.isBubbleOpen = false;
                        this.updateStrongNum(this.model.featureList.length);
                    }
                }
            }
        });
        this.Bind(EventName.GAME_START, () => {
            this.model.isBubbleOpen = false;
            this.model.strongerNum = 0;
            this.model.featureList = [];
            if(this.model.FeatureBindingCfg){
                GlobalEventSystem.Fire(EventName.CLOSE_VIEW, 'MainUIStrongerView');
                this.initRedDotChange()
            }
        });
        GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID, (value?) => {
            this.updateIcon()
        });
    }
    initRedDotChange() {
        let changeFlag = false;
        // 监听配置中的红点变化
        this.model.FeatureBindingCfg.forEach((f) => {
            switch (f.id) {
                case 10001:
                    //获取到了已接受的觉醒任务列表，每次收到任务列表的时候加入列表或从列表中删除
                    let receiveMap = TaskModel.GetInstance().GetHasReceiveTaskList();
                    if (!receiveMap) return;
                    let combat = RoleManager.GetInstance().GetMainRoleVo().fighting;
                    let taskId = Object.keys(receiveMap).find((task_id) => combat >= this.model.cfg.SkillAwakeTask[Number(task_id)]?.combat);
                    this.model.taskVo = taskId ? receiveMap[Number(taskId)][0] : undefined;
                    if (taskId) {
                        changeFlag = true;
                        this.model.insertFeature(this.model.cfg.FeatureBinding[10001]);
                    }
                    break;
                default:
                    if (RedDotController.ins.get(f.red_model_type)) {
                        changeFlag = true;
                        this.model.insertFeature(f);
                    }
                    break;
            }
        });
        if (changeFlag) this.updateStrongNum(this.model.featureList.length);
    }
    redDotUpdate(key: string, state: number) {
        let changeFlag = false;
        let feature = this.model.FeatureBindingCfg.find((f) => f.red_model_type == key);
        if (feature && this.model.featureList) {
            let findIndex = this.model.featureList.findIndex((f) => f.red_model_type == feature.red_model_type);
            if (state > 0) {
                if (findIndex == -1) {
                    // 触发了并且不在
                    changeFlag = true;
                    this.model.insertFeature(feature);
                }
            } else {
                if (findIndex != -1) {
                    // 销毁了并且在
                    changeFlag = true;
                    this.model.featureList.splice(findIndex, 1);
                }
            }
        }
        if (changeFlag) this.updateStrongNum(this.model.featureList.length);
    }
    updateStrongNum(num) {
        this.model.strongerNum = num;
        RedDotController.ins.up(RedKey.MAIN_STRONGER, this.model.strongerNum);
        this.Fire(MainStrongerEvent.UPDATE, this.model.strongerNum);
        this.updateIcon()
    }
    updateIcon(){
        if (CommonManager.GetInstance().CheckFuncOpenState("MainStronger", true) && this.model.strongerNum > 0) {
            ActivityIconManager.GetInstance().addIcon('158');
        } else {
            ActivityIconManager.GetInstance().deleteIcon('158');
        }
    }
    UpdateTalkBoard() {
        this.Fire(MainStrongerEvent.UPDATE, this.model.strongerNum);
    }
}

window['MainStrongerController'] = MainStrongerController;
