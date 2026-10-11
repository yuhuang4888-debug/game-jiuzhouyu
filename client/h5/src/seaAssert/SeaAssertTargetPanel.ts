import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { MonsterVo } from "../sharedata/MonsterVo"
import { Message } from "../sysInfo/SysInfoController"
import { SeaAssertTargetPanelItem } from "./SeaAssertTargetPanelItem"

export class SeaAssertTargetPanel extends BaseItem1 {
    Dispose
    InitEvent
    Scr_item_scroller
    UpdateItem
    itemTouchHandler
    item_list
    setData

    public constructor(parent?) {
        super(parent)
        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertTargetPanel"
        let roleMgr = RoleManager.GetInstance()
        let local_atuoMgr = AutoFightManager.GetInstance()
        let model = SeaHegemonyModel.GetInstance()
        let local_scene = Scene.GetInstance()
        let main_role_vo = roleMgr.GetMainRoleVo()
        let local_sceneType = SceneBaseType
        let main_role = Scene.Instance.GetMainRole()
        let local_msg = Message
        //let item_arraycollection_ = null
        let item_loop_list = null
        let item_loop_mgr: LoopScrowViewMgr = null
        let _data_ = []
        let need_refresh_data_ = null
        this.load_callback = () => {
            this.InitEvent()
        }

        this.InitEvent = () => {
            this.BindEvent(model, SeaHegemonyModel.CHOSE_TARGET, (data?) => {
                this.itemTouchHandler(data)
            })
            if (need_refresh_data_) {
                this.UpdateItem()
                need_refresh_data_ = false
            }
        }

        this.Dispose = () => {
            if (item_loop_mgr) {
                item_loop_mgr.DeleteMe()
                item_loop_mgr = null
            }
        }

        this.setData = (data?) => {
            _data_ = data
            if (this.is_loaded) {
                this.UpdateItem()
            } else {
                need_refresh_data_ = true
            }
        }

        this.UpdateItem = () => {
            if (!item_loop_mgr) {
                item_loop_list = _data_
                item_loop_mgr = new LoopScrowViewMgr()
                item_loop_mgr.SetData(this._item_list, SeaAssertTargetPanelItem, item_loop_list, LoopScrCon.Vertical)
            } else {
                item_loop_list = _data_
                item_loop_mgr.replaceAll(_data_)
            }
        }

        this.itemTouchHandler = (item_data?) => {
            if (SceneManager.GetInstance().IsSeaAsserScene()) {
                let isSea: boolean = SeaHegemonyModel.GetInstance().seaHegemonyData?.camp == SeaHegemonyModel.GetInstance().assertSceneData?.sea_id;
                if (main_role.vo.brick_id > 0) {
                    return Message.show('搬砖状态下无法攻击海域怪物');
                }
                if (isSea) {
                    return Message.show('无法攻击己方海域怪物');
                }
            }
            let vo = item_data
            let attackObj = null
            if (vo?._type == local_sceneType.Monster) {
                attackObj = local_scene.GetMonster(vo.vo.instance_id)
            } else {
                attackObj = local_scene.GetRole(vo.role_id)
            }
            if (attackObj) {
                if (vo?.vo_type == local_sceneType.Role) {
                    let canFight = main_role_vo.camp != attackObj.vo.camp
                    if (!canFight) {
                        local_msg.show("同海域成员，不能发起攻击")
                        return
                    }
                }
                else if (vo?.vo_type == local_sceneType.MainRole) {
                    local_msg.show("无法攻击自己!")
                    return
                }
                local_scene.clearGoToData()
                local_scene.SetClickTarget(attackObj)
                local_atuoMgr.SetAutoFight(true)
            }
        }
    }

    public DeleteMe() {
        this.Dispose()
        super.DeleteMe();
    }


    _Image1: Laya.Image
    _Image2: Laya.Image
    _num_lb: Laya.Label
    _item_list: Laya.List
    _img: Laya.Image
    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._num_lb,
            this._item_list,
            this._img,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "_num_lb",
                "_item_list",
                "_img",
            ])
    }
}
window["SeaAssertTargetPanel"] = SeaAssertTargetPanel