import { BaseItem1 } from '../common/BaseItem1';
import { EventName } from '../common/EventName';
import { OpenFun } from '../common/OpenFun';
import { WordManager } from '../common/WordManager';
import { ReincarnationModel } from '../commonModel/ReincarnationModel';
import { TaskModel, TaskTipType, TaskType, TaskTypeColor } from '../commonModel/TaskModel';
import { RoleManager } from '../commonModel/RoleManager';
import { Scene } from '../scene/Scene';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { PoseState } from '../util/StateMachineManager';
import { Status } from '../util/Status';
import { TimeUtil } from '../util/TimeUtil';
import { Util, SetLocalScale } from '../util/Util';
import { Config } from '../common/Config';
import { MainUIModel } from '../commonModel/MainUIModel';
import { AutoBrushModel } from '../commonModel/AutoBrushModel';
import { StoryModel } from '../commonModel/StoryModel';
import { PlatformManager } from '../PlatformManager';
import { SpecialCharKey } from '../common/SpecialCharKey';

enum EMainUITaskItemLayer {
    MAINUIIMG = 1,
    TEXT,
    FINGER,
    EFFECT
}
let local_TaskType
let local_TaskModel
export class MainUITaskItem extends BaseItem1 {
    static taskDescFont

    task;
    data;
    need_refresh_data;
    select_cache = null;
    update_size_call;
    height_cache;
    needSetLayer = true;
    lblList: Laya.Text[] = [];
    has_set_effect = false
    mainUI_model:MainUIModel
    layerIconArr: any[]
    public constructor(parent) {
        super(parent);
        local_TaskModel = TaskModel
        local_TaskType = TaskType
        this.base_file = 'mainUI';
        this.layout_file = 'MainUITaskItem';
        this.mainUI_model = MainUIModel.GetInstance()
		this.not_cache_display_obj = true
        this.load_callback = () => {
            this.LoadSuccess();
        };
    }

    public LoadSuccess() {
        if(PlatformManager.IsEyouEnPlatform()){
            this.lblTaskTitle.fontSize = 16
            this.lblTaskTitle2.fontSize = 16
        }
		this.not_cache_display_obj = true
        this._box_finger_con.visible = false;
        this.SetLayer();
        this.InitEvent();
    }

    SetLayer() {
        if (!this.needSetLayer) return;
        let y = this.display_obj.y;
        let x = this.display_obj.x;
        this.display_obj.y = -1;
        this.display_obj.x = -1;
        this.layerIconArr = [this._img_bg, this._img_done, this._img_select, this.lblTaskTitle, this.lblTaskTitle2, this._box_finger_con, this._box_effect];
        // layerIconArr = layerIconArr.concat(this.lblList);
        this.layerIconArr.forEach((icon) => {
            icon['_ox_'] = icon.x;
            icon['_oy_'] = icon.y;
            icon['_old_visible_'] = icon.visible;
            // 单独给layer设置visible的时候也要考虑到displayobj的visible
            icon['_old_set_visible'] = icon['set_visible'];
            icon['set_visible'] = (value) => {
                icon["_old_visible_"] = value
                value = value && this.display_obj.visible;
                icon['_old_set_visible'](value);
            };
            if(this._parent.getChildIndex(icon) == -1){
                // icon.removeSelf();
                this._parent.addChild(icon);
            }
            
        });
        this._img_bg.zOrder = this._img_done.zOrder = this._img_select.zOrder = EMainUITaskItemLayer.MAINUIIMG;
        this.lblTaskTitle.zOrder = this.lblTaskTitle2.zOrder = EMainUITaskItemLayer.TEXT;
        this._box_finger_con.zOrder = EMainUITaskItemLayer.FINGER;
        this._box_effect.zOrder = EMainUITaskItemLayer.EFFECT

        if (!this.display_obj) return;
        this.display_obj.mouseThrough = true;
        this.display_obj['_oSetX'] = this.display_obj['_setX'];
        
        this.display_obj['_setX'] = (x) => {
            if (this.display_obj) this.display_obj['_x'] = x;
            this.layerIconArr.forEach((icon) => {
                icon && (icon.x = x + icon['_ox_']);
            });
            if (this.lblTaskTitle2 && this.lblTaskTitle) this.lblTaskTitle2.x = this.lblTaskTitle.x + this.lblTaskTitle.textWidth;
        };

        this.display_obj['_oSetY'] = this.display_obj['_setY'];
        this.display_obj['_setY'] = (y) => {
            if (this.display_obj) this.display_obj['_y'] = y;
            this.layerIconArr.forEach((icon) => {
                icon && (icon.y = y + icon['_oy_']);
                icon['_setY'] = (y) => {
                    icon['_y'] = y;
                };
            });
        };
        Object.defineProperty(this.display_obj, 'alpha', {
            get: () => {
                if (this.display_obj) {
                    return this.display_obj['_getAlpha']();
                }
                return 0;
            },
            set: (value) => {
                if (this.display_obj) {
                    value = value < 0 ? 0 : value > 1 ? 1 : value;
                    this.display_obj['_setAlpha'](value);
                }
                this.layerIconArr.forEach((icon) => icon && (icon.alpha = value));
            },
            configurable: true
        });
        Object.defineProperty(this.display_obj, 'visible', {
            get: () => {
                if (this.display_obj) {
                    return this.display_obj.get_visible();
                }
                return 0;
            },
            set: (value) => {
                if (this.display_obj) {
                    if (this.display_obj.get_visible() === value) {
                        return;
                    }
                    this.display_obj.set_visible(value);
                }
                if (!value) {
                    this.layerIconArr.forEach((icon) => {
                        if (icon) {
                            var temp_visible = icon.visible;
                            icon.visible = false;
                            icon['_old_visible_'] = temp_visible;
                        }
                    });
                } else {
                    this.layerIconArr.forEach((icon) => icon && (icon.visible = value && icon['_old_visible_']));
                }
            },
            configurable: true
        });

        this.display_obj.visible = !this.display_obj.visible
        this.display_obj.visible = !this.display_obj.visible
        this.display_obj.x = x;
        this.display_obj.y = y;
    }

    ResetLayer() {
        if (!this.needSetLayer) return;
        if (this.display_obj) {
            this.display_obj['_setX'] = this.display_obj['_oSetX'];
            this.display_obj['_setY'] = this.display_obj['_oSetY'];
        }
        this.layerIconArr.forEach((icon) => {
            icon['set_visible'] = icon['_old_set_visible'];
            if(this._parent.getChildIndex(icon) > -1){
                this.display_obj.addChild(icon);
            }
            icon.x = icon['_ox_'];
            icon.y = icon['_oy_'];
            if(icon['_old_visible_'] != null){
                icon.visible = icon['_old_visible_']
            }
            
        });
        this.layerIconArr = undefined
    }

    public InitEvent() {
        Util.AddClickEvent(this._img_bg, this.OnClick.bind(this), this, false);
        Util.AddClickEvent(this._box_finger_con, this.OnClick.bind(this), this, false);
        this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.CHANGE_LEVEL, this.LvUpFunc.bind(this));
        this.BindEvent(this.task_model, local_TaskModel.CLICK_DO_TASK, this.ClickDoTask.bind(this));
        this.BindEvent(this.task_model, local_TaskModel.UPDATE_ONE_TASK, this.UpdateFunc.bind(this));
        this.BindEvent(this.task_model, local_TaskModel.UPDATE_CIRCLE_TASK_REWARD, this.UpdateReward.bind(this));
        this.BindEvent(this.task_model, local_TaskModel.FINISH_TASK, this.TaskSuccessFunc.bind(this));
        this.BindEvent(this.task_model, local_TaskModel.UPDATE_CIRCLE_TASK_PROGRESS, this.UpdateCircleTaskProgress.bind(this));
        if (this.need_refresh_data) {
            this.SetData(this.data);
            this.need_refresh_data = undefined;
        }

        if (this.select_cache != null) {
            this.SetSelect(this.select_cache);
            this.select_cache = null;
        }
    }

    public DeleteMe() {
        this.update_size_call = undefined;
        this.height_cache = undefined;
        this.has_set_effect = false
        this.ResetLayer();
        super.DeleteMe();
    }

    protected OnClick() {
        if (!this.is_loaded || !this.task || (this.task_model.last_click_main_ui_task_time && Status.NowTime - this.task_model.last_click_main_ui_task_time <= 0.8)) return;
        if (Scene.GetInstance().GetMainRole().IsInState(PoseState.FLY_SHOE_EFFECT)) {
            return;
        }

        this.HideMainLineArrow();
        this.task_model.has_show_daily_task_finger = this.task.task_type == local_TaskType.DAILY;

        this.task_model.Fire(local_TaskModel.CLICK_DO_TASK, this.task.task_id, this.task.task_type);
        let finish = this.task_model.IsAllStepFinish(this.task.task_id);
        if (finish && !this.task_model.IsFindNpcTask(this.task.task_tips_type)) {
            if (this.task_model.ThisTaskTypeCanShowView(this.task)) {
                if(this.task_model.IsCircleTask(this.task.task_type)){
                    this.task_model.Fire(local_TaskModel.TASK_OPEN_VIEW, 'TaskCircleFinishView', this.task);
                }
                else{
                    this.task_model.Fire(local_TaskModel.TASK_OPEN_VIEW, 'TaskFinishView', this.task);
                }
            } else if (this.task.task_type == local_TaskType.REINCARNATION && ReincarnationModel.GetInstance().IsFinishStageTask() && this.task.task_tips_type != TaskTipType.Outside_kill_lv) {
                OpenFun.OpenFunHandler(18);
            } else {
                local_TaskModel.GetInstance().Fire(local_TaskModel.REQUEST_CCMD_EVENT, 30004, this.task.task_id);
            }
        } else {
            this.task_model.DoTask(this.task, null, null, true, true);
        }
        if (this.task_model.IsMainTask(this.task.task_id) && this.task.task_tips_type == TaskTipType.LV) {
            this.task_model.click_lv_arrow_time = TimeUtil.getServerTime();
        }

        this.task_model.last_click_main_ui_task_time = Status.NowTime;
    }

    ClickDoTask(task_id?, task_type?) {
        if (this.task && task_type && task_id) {
            let bool = this.task.task_id == task_id || (task_type == this.task.task_type && (task_type == local_TaskType.GUILD || task_type == local_TaskType.DAILY));
            this.SetSelect(bool);
        }
    }

    UpdateCircleTaskProgress(scmd?) {
        if (this.task && scmd) {
            if (this.task.task_type == scmd.task_type) {
                this.SetTipsMsg(this.task);
            }
        }
    }

    protected UpdateFunc(task_id?, task_tips_list?) {
        if (this.data && this.task && this.data.task_id == task_id && this.task.task_id == task_id && task_tips_list) {
            this.data.tips_list = task_tips_list;
            if (this.data.tips_list[0]) {
                this.task = this.FindUnFinishTask(this.data.tips_list);
                if (this.task) {
                    this.SetTipsMsg(this.task);
                }
            }
        }
    }

    LvUpFunc() {
        if (this.data && this.task && this.task.task_type == local_TaskType.REINCARNATION) {
            this.SetTipsMsg(this.task);
        }
    }

    UpdateReward(task_id?) {
        if (this.data && this.data.task_id == task_id) {
            this.data.tips_list = this.task_model.GetHasReceiveTaskList(task_id);
            this.task = this.FindUnFinishTask(this.data.tips_list);
        }
    }

    TaskSuccessFunc(task_id?) {
        if (this.task && this.task.task_id == task_id && this.display_obj) {
            SetLocalScale(this.display_obj, 1);
        }
    }

    public SetData(data) {
        this.data = data;
        if (this.is_loaded) {
            this.UpdateItem();
        } else {
            this.need_refresh_data = true;
        }
    }

    public UpdateItem() {
        if (this.data) {
            let task = this.FindUnFinishTask(this.data.tips_list);
            if (task) {
                this.task = task;
                this.SetTaskData(task);
            }
        }
    }

    public FindUnFinishTask(tips_list?) {
        if (tips_list) {
            let task = tips_list[0];
            for (let _tmpi in tips_list) {
                var vo = tips_list[_tmpi];
                if (vo.has_finish != 1) {
                    task = vo;
                    break;
                }
            }
            return task;
        }
    }

    public SetTaskData(task?) {
        if (task) {
            this.SetTitle(task);
            this.SetTipsMsg(task);

            this.UpdateFinishEffect(task)
        }
    }


    public UpdateFinishEffect(task){
        

        let bool = false
        if(this.task_model.IsAllStepFinish(task.task_id)){
            bool = true
        }

        if(this.has_set_effect != bool){
            this.has_set_effect = bool
            this.mainUI_model.Fire(MainUIModel.UPDATE_TASK_VIEW_CACHE_AS_STATE)
        }

        this.ClearUIEffect(this._box_effect)
        if(this.has_set_effect){
            let height = this._img_bg.height
            let y = - (this._box_effect.height - height) / 2

            if(this.needSetLayer)
            {
                this._box_effect["_oy_"] = y
                let local_y = this._box_effect.y
                this._box_effect.y = -1
                this._box_effect.y = local_y
            }
            else{
                this._box_effect.y = y
            }

            //缩小0.97倍
            let scale = 1280 / this._box_effect.height * 0.96
            let y_scale = scale * height / 54
            // console.warn("------------UpdateFinishEffect", height, y, scale)
            this.AddUIEffect("ui_renwulan", this._box_effect, {x:0, y:0}, {x: scale, y:y_scale, z:scale})
        }
    }

    public SetTitle(task?) {
        if (!task) return;
        let tagName = this.task_model.GetTaskTagName(task.task_type);
        let color = TaskTypeColor[task.task_type] || '';
        
        let subTitleColor = '';
        let subTitle = '';

        if (task.task_type == local_TaskType.GUILD || task.task_type == local_TaskType.DAILY) {
            let [finishNum, allNum] = this.task_model.GetCicleTaskProgressByTaskType(task.task_type);
            if (finishNum != null && allNum != null) {
                subTitleColor = (allNum == finishNum && '#00fa64') || '#ffffff';
                subTitle = `(${finishNum}/${allNum})`;
            }
        } else if (task.task_type == local_TaskType.MAIN_LINE) {
            if (task.task_id <= 101410) {
                subTitleColor = TaskTypeColor[task.task_type];
                subTitle = task.main_line_order;
            }
        //副本技能觉醒特殊处理
		} else if(task.task_type == local_TaskType.EXTENSION_LINE && task.task_tips_type == TaskTipType.FinDungeon){
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_learn_skill && Config.PRELOAD_SERVER_CONFIG.config_dungeon_learn_skill[task.id]
            if(cfg){
                tagName = "技"//this.task_model.GetTaskTagName(local_TaskType.REINCARNATION)
                color = TaskTypeColor[local_TaskType.REINCARNATION]
            }
        }


        let taskTitle = `[${tagName}] ${task.task_name}`;

        this.lblTaskTitle.text = taskTitle;
        this.lblTaskTitle.color = color?.replace(SpecialCharKey.MainUITaskItem1, '');
        this.lblTaskTitle2.text = subTitle;
        this.lblTaskTitle2.color = subTitleColor?.replace(SpecialCharKey.MainUITaskItem1, '');
        if(PlatformManager.IsEyouEnPlatform()){
            this.lblTaskTitle.fontSize = 16
            this.lblTaskTitle2.fontSize = 16
        }
        this.lblTaskTitle2.x = this.lblTaskTitle.x + this.lblTaskTitle.textWidth;
    }

    public SetTipsMsg(task?) {
        if (!task) return;
        if (!this.display_obj.visible) return
        // this.ResetLayer();
        this.lblList.forEach((lbl) => {
            if(lbl){
                if(this.needSetLayer && this.layerIconArr){
                    var index = this.layerIconArr.indexOf(lbl)
                    if(index > -1){
                        this.layerIconArr.splice(index, 1)
                    }
                }
                lbl.removeSelf().destroy()
            }
        });
        // this.lblList.length = 0
        const createText = (text, color?) => {
            // let lbl = this.lblList.shift();
            let lbl = new Laya.Text();
            if(this.needSetLayer)
            {
                lbl['_old_visible_'] = lbl.visible;
                // 单独给layer设置visible的时候也要考虑到displayobj的visible
                lbl['_old_set_visible'] = lbl['set_visible'];
                lbl['set_visible'] = (value) => {
                    lbl["_old_visible_"] = value
                    value = value && this.display_obj.visible;
                    lbl['_old_set_visible'](value);
                };
            }
            lbl.color = color || '#ffffff';
            lbl.fontSize = 18
            lbl.leading = 5;
            lbl.text = text;
            lbl.name = 'MainUITaskItemTaskDesc__';
            if(MainUITaskItem.taskDescFont == null){
                //@ts-ignore
                var fontStr = lbl._getContextFont()
                if (fontStr.indexOf('italic') >= 0) {// 先判断一下效率会高一些
                    MainUITaskItem.taskDescFont = fontStr.replace('italic', '');
                } else {
                    MainUITaskItem.taskDescFont = fontStr;
                }
            }
            
            return lbl;
        };
        const layoutLbl = (lblList: Laya.Text[]) => {
             // 拆分list
            let startX = 6
            let nextX = startX, line = 0;
           
            let total = 0, splitText: Laya.Text, lineMaxWdith = 215, lbl

            let len = lblList.length
            
            

            for(let spliceIndex = 0; spliceIndex < len; spliceIndex ++){
                lbl = lblList[spliceIndex]
                var i = lbl.text.split('').findIndex(txt => {
                    //@ts-ignore
                    total +=Laya.Context._textRender.charRender.getWidth(MainUITaskItem.taskDescFont, txt)
                    // total += WordManager.strSize(txt);
                    return total > lineMaxWdith;
                });
                if (i != -1) {
                    if(i > 0){
                        splitText = createText(lbl.text.slice(i), lbl.color);
                        lbl.text = lbl.text.slice(0, i);
                        lblList.splice(spliceIndex + 1, 0, splitText);
                        len ++
                    }
                    else{
                        spliceIndex --
                    }
                    total = 0
                }
            }

            for (const lbl of lblList) {
                if(this.needSetLayer && this.layerIconArr)
                {
                    if(this._parent.getChildIndex(lbl) == -1){
                        this._parent.addChild(lbl);
                        this.layerIconArr.push(lbl)
                    }
                    
                    lbl.zOrder = EMainUITaskItemLayer.TEXT;
                }
                else{
                    this.display_obj.addChild(lbl)
                }
                if (nextX + lbl.width > lineMaxWdith + startX) {
                    line++;
                    nextX = startX;
                }
                var x = nextX
                var y = line * 18 + 32
                lbl['_ox_'] = x
                lbl['_oy_'] = y
                lbl.pos(x, y);
                nextX += lbl.width;
            }
            return (line + 1) * 18 + line * 5;
        };
        let finish = this.task_model.IsAllStepFinish(task.task_id);
        let reinSpeTips;
        let lineHeight;
        if (task.task_type == local_TaskType.REINCARNATION) {
            // if (Number(task.now_num) < Number(task.need_num)) {
            let lv = ReincarnationModel.GetInstance().needStageList[task.task_id] || 0;
            if (RoleManager.GetInstance().GetMainRoleVo().level < lv) {
                reinSpeTips = lv;
                if (task.show_num <= 0) {
                    this.lblList = [];
                    this.lblList.push(createText(`人物达到${reinSpeTips}级`));
                    this.lblList.push(createText(' (0/1)', '#ffef67'));
                    lineHeight = layoutLbl(this.lblList);
                }
            }
            // }
        }
        if (!lineHeight) {
            this.lblList = this.task_model.GetTaskTipsMsgByMainUITaskItem(task, createText);
            if (finish) {
                if (!this.task_model.IsFindNpcTask(task.task_tips_type)) {
                    if (PlatformManager.IsEyouThPlatform()) {
                        this.lblList.push(createText('(สำเร็จ)', '#00fa64'));
                    }else{
                    this.lblList.push(createText('(完成)', '#00fa64'));
                    }
                }
            } else {
                if (task.show_num > 0) {
                    let now_str = Number(task.show_num);
                    this.lblList.push(createText(` (0/${now_str})`, '#ffef67'));
                } else {
                    let now_str = Number(task.now_num);
                    let need_str = Number(task.need_num);
                    let color_str = (task.need_num == task.now_num && '#00fa64') || '#ffef67';
                    this.lblList.push(createText(` (${now_str}/${need_str})`, color_str));
                }
            }
            lineHeight = layoutLbl(this.lblList);
        }

        let x = this.display_obj.x
        let y = this.display_obj.y
        this.display_obj.y = -1;
        this.display_obj.x = -1;

        this.display_obj.x = x;
        this.display_obj.y = y;

        this._box_finger_con.height = this._img_select.height = this._img_bg.height = this.display_obj.height = lineHeight + 32 + 5;

        if (!this.height_cache || this.height_cache != this.display_obj.height) {
            if (this.update_size_call) {
                this.update_size_call();
            }
            this.height_cache = this.display_obj.height;
        }

        this._img_done.visible = finish;
        let bool = this.task.task_id == this.task_model.now_select_task_id || (this.task_model.now_do_task_type == this.task.task_type && (this.task_model.now_do_task_type == local_TaskType.GUILD || this.task_model.now_do_task_type == local_TaskType.DAILY));
        this.SetSelect(bool);
        this.task_model.SendProtoToFinsh(task);
    }
    
    public ShowMainLineArrow(step_cfg?, force?) {
        // GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_finger_con, 'Main', null, null, true, null, step_cfg, force);
        // this._box_finger_con.visible = true;
    }

    public HideMainLineArrow() {
        if(this._box_finger_con){
            GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_finger_con);
            this._box_finger_con.visible = false;
        }
    }

    public SetSelect(bool?) {
        if (this.is_loaded) {
            this._img_select.visible = bool;
        } else {
            this.select_cache = bool;
        }
    }

    public GetHeight() {
        if (this.is_loaded) {
            return this.display_obj.height;
        } else {
            return 78;
        }
    }

    public SetUpdateSizeCall(call_func) {
        this.update_size_call = call_func;
    }

    _img_bg: Laya.Image;
    _img_done: Laya.Image;
    _img_select: Laya.Image;
    lblTaskTitle: Laya.Text;
    lblTaskTitle2: Laya.Text;
    _box_finger_con: Laya.Box;
    _box_effect:Laya.Box
    public GetComponents() {
        [
            this._img_bg, 
            this._img_done, 
            this._img_select, 
            this.lblTaskTitle, 
            this.lblTaskTitle2, 
            this._box_finger_con,
            this._box_effect
        ] = this.GetChildrenByNames(
            [
                '_img_bg', 
                '_img_done', 
                '_img_select',
                'lblTaskTitle',
                'lblTaskTitle2',
                '_box_finger_con',
                "_box_effect"
            ]);
    }
}
window['MainUITaskItem'] = MainUITaskItem;
