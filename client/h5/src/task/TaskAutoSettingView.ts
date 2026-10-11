import { BaseView1 } from "../common/BaseView1";
import { EquipmentItem } from "../common/EquipmentItem";
import { SceneEventType } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { WordManager } from "../common/WordManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { TaskModel, TaskType } from "../commonModel/TaskModel";
import { RoleManager } from "../commonModel/RoleManager";
import { SceneManager } from "../scene/SceneManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { GlobalTimerQuest, Util } from "../util/Util";
import { CheckBox } from "../alert/CheckBox";
import { StoryModel } from "../commonModel/StoryModel";
import { ResManager } from "../common/ResManager";
import { GameResPath } from "../util/GameResPath";
import { SettingModel } from "../commonModel/SettingModel";
import { PlatformManager } from "../PlatformManager";

export class TaskAutoSettingView extends BaseView1 {

    model: TaskModel
    close_time = 15
    time_event_id
    local_auto_task_state

    auto_check:CheckBox
    manual_check:CheckBox
    setting_model = SettingModel.GetInstance()
    public constructor() {
        super()
        this.base_file = "task"
        this.layout_file = "TaskAutoSettingView"
        this.layer_value = Enum_UILayer.Activity

        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        this.is_delay_callback = false
        this.is_center = true

        this.model = TaskModel.GetInstance()

        this.load_callback = () => {
            this.LoadSuccess()
        }

        this.open_callback = () => {
            this.UpdateView()
        }

        this.close_callback = () => {
            this.CancelTime()
            if(this.model.auto_setting_view_lock_obj){
                delete StoryModel.RestoreFingerLock[this.model.auto_setting_view_lock_obj.hashCode] 
                this.model.auto_setting_view_lock_obj = null
            }

            let auto_task_state = this.setting_model.GetBlockProperty(SettingModel.SettingType.SysSetting, SettingModel.BlockSubType.auto_task)
            if(auto_task_state != this.local_auto_task_state){
                let is_open = 1
                if(!this.local_auto_task_state){
                    is_open = 0
                }
                this.setting_model.SetBlockProperty(SettingModel.SettingType.SysSetting, "auto_task", is_open)

                let setting_list = []
                setting_list.push(this.setting_model.Package10203ItemData(SettingModel.BlockSubType.auto_task, is_open))
                this.setting_model.PackageAndSend10203(setting_list)
            }
            this.close_time = 15
            if(this.auto_check){
                this.auto_check.DeleteMe()
                this.auto_check = null
            }
    
            if(this.manual_check){
                this.manual_check.DeleteMe()
                this.manual_check = null
            }
        }
    }

    public LoadSuccess = () => {
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("alert", "uisy_023"))

        this.InitEvent()
    }

    public InitEvent = () => {
        Util.AddClickEvent(this._img_confirm, () => {
            this.Close()
        }, this, true)

        Util.AddClickEvent(this._img_close, () => {
            this.Close()
        }, this, true)
    }

    public UpdateView = () => {
        if(!this.auto_check){
            this.auto_check = new CheckBox(this.display_obj, this.AutoCheckCall, '自动任务', this.AutoCheckCondCall, function(){
                if(PlatformManager.IsEyouPlatform()){
                    this.checkLabel.x = 25
                }else{
                    this.checkLabel.x = 10
                }
                // this.checkLabel.y = 3
            })
            this.auto_check.SetPosition(100, 225)
            this.auto_check.Load()
        }

        if(!this.manual_check){
            this.manual_check = new CheckBox(this.display_obj, this.ManualCheckCall, '手动任务', this.ManualCheckCondCall, function(){
                if(PlatformManager.IsEyouPlatform()){
                    this.checkLabel.x = 25
                }else{
                    this.checkLabel.x = 10
                }
                // this.checkLabel.y = 3
            })
            this.manual_check.SetPosition(394, 225)
            this.manual_check.Load()
        }
        this.local_auto_task_state = SettingModel.GetInstance().GetBlockProperty(SettingModel.SettingType.SysSetting, SettingModel.BlockSubType.auto_task)
        this.UpdateState()
        this.StartTime()
    }

    public AutoCheckCall = (state) =>{
        if(state){
            this.local_auto_task_state = 1
            this.UpdateState()
        }
    }

    public AutoCheckCondCall = () =>{
        if(this.local_auto_task_state){
            return false
        }
        return true
    }

    public ManualCheckCall = (state) =>{
        if(state){
            this.local_auto_task_state = 0
            this.UpdateState()
        }
    }

    public ManualCheckCondCall = () =>{
        if(!this.local_auto_task_state){
            return false
        }
        return true
    }

    public UpdateState(){
        
        this.auto_check.selected = !!this.local_auto_task_state
        if(this.auto_check.is_loaded){
            this.auto_check.UpdateCheckImg()
        }

        this.manual_check.selected = !this.local_auto_task_state
        if(this.manual_check.is_loaded){
            this.manual_check.UpdateCheckImg()
        }
    }

    public StartTime = () => {
        this.CancelTime()
        var peorid_func = () => {
            if (!this.use_delete_method) {
                this.OnTime()
            }
        }
        this.time_event_id = GlobalTimerQuest.AddPeriodQuest(peorid_func, 1, -1)
        peorid_func()
    }

    public OnTime = () => {
        this.close_time = this.close_time - 1
        if (this.close_time <= 0) {
            this._lb_count_down.text = ""
            this.Close()
            return
        }
        this._lb_count_down.text = this.close_time + "s后自动提交任务"
    }

    public CancelTime = () => {
        if (this.time_event_id) {
            GlobalTimerQuest.CancelQuest(this.time_event_id)
            this.time_event_id = null
        }
    }

    public Open(...params) {
        super.Open()
    }
    _img_bg: Laya.Image
    _img_bg2: Laya.Image
    _img_title: Laya.Image
    _lb_desc: Laya.Label
    _lb_count_down: Laya.Label
    _img_close: Laya.Image
    _img_confirm: Laya.Image
    _lb_ok: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._img_bg2,
            this._img_title,
            this._lb_desc,
            this._lb_count_down,
            this._img_close,
            this._img_confirm,
            this._lb_ok,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_bg2",
                "_img_title",
                "_lb_desc",
                "_lb_count_down",
                "_img_close",
                "_img_confirm",
                "_lb_ok",
            ])
    }
}
window["TaskAutoSettingView"] = TaskAutoSettingView