import { BaseEnterDefine } from "../baseEnterView/BaseEnterDefine";
import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { TaskModel } from "../commonModel/TaskModel";
import { PlatformManager } from "../PlatformManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { AtlasUrl, RefBoxChildsLayout, RefBoxVLayout, SetAnchoredPositionX, SetLocalPosition, Util } from "../util/Util";
import { TaskUpAlerStartItem } from "./TaskUpAlerStartItem";

export class TaskUpAlertItem extends BaseItem1 {

    cfg_finish
    info
    InitEvent
    InitView
    SetData
    index
    star_item_list

    public constructor(parent?) {
        super(parent)
        this.dependent_res = ["mainUI"]
        this.base_file = "task"
        this.layout_file = "TaskUpAlertItem"
        this.cfg_finish = false;
        let local_Util = Util
        let local_GlobalEventSystem = GlobalEventSystem
        let local_EventName = EventName
        this.star_item_list = []
        this.load_callback = () => {
            this.InitEvent()

            if (this.cfg_finish) {
                this.SetData(this.info, this.index)
                this.cfg_finish = false
            }

            if (PlatformManager.IsEyouEnPlatform()) {
                this._Label2.visible = false
                SetAnchoredPositionX(this._gp_star, 135)
                this._lb_desc.fontSize = 18
                this._Label1.fontSize = 18
                this._lb_reward.fontSize = 18
            }
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_go, () => {
                if (this.info.jump_id) {
                    if(this.info.jump_id == 48){
                        local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().Arena)
                    }else{
                        OpenFun.OpenFunHandler(this.info.jump_id)
                    }
                }
                TaskModel.GetInstance().Fire(TaskModel.CLOSE_UPALERT_VIEW)
            }, this, true)
        }

        this.InitView = () => {
            if (!this.info) {
                return
            }
            this.ClearUIEffect(this._gp_effect)
            
            if(this.index == 0 && (this.info.is_finish == false)){
                this.AddUIEffect("ui_renwulan", this._gp_effect, {x:0, y:0}, {x:12,y:20,z:20})
            }
            
            let pos_y = 30
            // this.img_finish.visible = false
            // this.box_limit.visible = false
            if(this.info.icon_name){
                this._img_icon.skin =  AtlasUrl("task", this.info.icon_name)
            }else{
                this._img_icon.skin =  AtlasUrl("icon", this.info.ac_icon)
            }

            if (this.info.desc) {
                this._lb_desc.text = (this.info.desc).trim()
            }

            if (this.info.output) {
                this._lb_reward.text = (this.info.output).trim()
            }

            if (this.info.star) {
                // let i = 0
                // let img
                // do {
                //     img = new Laya.Image()
                //     img.skin = AtlasUrl("task", "uixrw_016")
                //     this._gp_star.addChild(img)
                //     i = i + 1
                // } while ((i < this.info.star))
                for(let i = 0; i < this.info.star; i++){
                    let item = this.star_item_list[i]
                    if(!item){
                        item = new TaskUpAlerStartItem(this._gp_star)
                        item.Load()
                        this.star_item_list.push(item)
                    }
                    item.SetVisible(true)
                }
            }

            Util.SetImageGray(this._Image1, this.info.is_finish == true)
           

            if(this.info.is_limit_activity){
                this._gp_btn.visible = false
                this.box_limit.visible = true
                this.img_finish.visible = false
            }else{
                this.img_finish.visible = this.info.is_finish
                this._gp_btn.visible = !this.info.is_finish
                this.box_limit.visible = false
            }

            if(this.info.week_limit){
                this.week_limit.text = this.info.week_limit
            }else{
                pos_y = 15
            }

            if(this.info.time_limit){
                this.time_limit.text = this.info.time_limit
            }else{
                pos_y = 42
            }
            RefBoxVLayout(this.box_limit, 0, true, true)
            SetLocalPosition(this.box_limit, 403, pos_y)
        }

        this.SetData = (info?, index?) => {

            this.info = info
            this.index = index
            if (this.is_loaded) {
                this.InitView()
            } else {
                this.cfg_finish = true
            }
        }
    }

    public DeleteMe() {
        if (this.star_item_list.length > 0) {
            for (let _tmpi in this.star_item_list) {
                var item = this.star_item_list[_tmpi]
                item.DeleteMe()
            }
            this.star_item_list = []
        }
        super.DeleteMe()
    }




    _Image11: Laya.Image
    _img_icon: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Image4: Laya.Image
    _lb_desc: Laya.Label
    _Label1: Laya.Label
    _lb_reward: Laya.Label
    _Label2: Laya.Label
    _gp_btn: Laya.Box
    _btn_go: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    _gp_effect: Laya.Box
    _gp_star: Laya.HBox
    img_finish: Laya.Image
    box_limit: Laya.Box
    week_limit: Laya.Label
    time_limit: Laya.Label

    public GetComponents() {
        [
            this._Image11,
            this._img_icon,
            this._Image2,
            this._Image3,
            this._Image4,
            this._lb_desc,
            this._Label1,
            this._lb_reward,
            this._Label2,
            this._gp_btn,
            this._btn_go,
            this._Image1,
            this.labelDisplay,
            this._gp_effect,
            this._gp_star,
            this.img_finish,
            this.box_limit,
            this.week_limit,
            this.time_limit,
        ]
            = this.GetChildrenByNames([

                "_Image11",
                "_img_icon",
                "_Image2",
                "_Image3",
                "_Image4",
                "_lb_desc",
                "_Label1",
                "_lb_reward",
                "_Label2",
                "_gp_btn",
                "_btn_go",
                "_Image1",
                "labelDisplay",
                "_gp_effect",
                "_gp_star",
                "img_finish",
                "box_limit",
                "week_limit",
                "time_limit"
            ])
    }
}
window["TaskUpAlertItem"] = TaskUpAlertItem