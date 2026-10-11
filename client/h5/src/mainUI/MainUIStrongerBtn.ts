import { OpenFun } from './../common/OpenFun';
import { IFeature, MainStrongerModel } from './../commonModel/MainStrongerModel';
import { EventName } from './../common/EventName';
import { GlobalEventSystem } from './../util/DeclareGlobalVar';
import { BaseItemRenderer } from './../common/BaseItemRenderer';
import { Util } from './../util/Util';
import { TaskModel } from '../commonModel/TaskModel';

export class MainUIStrongerBtn extends BaseItemRenderer {
    need_refresh = false;
    argv: IFeature;
    WIDTH = 150;
    HEIGT = 52;
    model: MainStrongerModel;
    public constructor() {
        super();

        this.base_file = 'mainStronger';
        this.layout_file = 'MainUIStrongerBtn';
        this.model = MainStrongerModel.ins;
        this.load_callback = () => {
            this.InitEvent();
        };
        this.Load();
    }

    public InitEvent() {
        Util.AddClickEvent(
            this.imgBtn,
            () => {
                this.sureCbk();
                GlobalEventSystem.Fire(EventName.CLOSE_VIEW, 'MainUIStrongerView');
            },
            this,
            true
        );
    }

    dataChanged() {
        if(super.dataChanged()){
            this.lblName.text = this.data.name;
        }
    }

    // 跳转到对应功能
    public sureCbk() {
        if(this.data){
            switch (this.data.id) {
                case 10001:
                    let taskModel = TaskModel.GetInstance();
                    if (this.model.taskVo) {
                        taskModel.now_select_task_id = this.model.taskVo.task_id;
                        taskModel.now_do_task_type = this.model.taskVo.task_type;
                        taskModel.DoTask(this.model.taskVo, true);
                    }
                    break;
                default:
                    OpenFun.OpenFunHandler(this.data.func);
                    break;
            }
        }
    }

    public DeleteMe() {
        super.DeleteMe();
    }
    imgBtn: Laya.Image;
    lblName: Laya.Label;
    public GetComponents() {
        [this.imgBtn, this.lblName] = this.GetChildrenByNames(['imgBtn', 'lblName']);
    }
}
window['MainUIStrongerBtn'] = MainUIStrongerBtn;
