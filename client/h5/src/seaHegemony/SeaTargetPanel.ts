import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { BossModel } from "../commonModel/BossModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Scene } from "../scene/Scene"
import { SceneBaseType, MonsterType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { RefBoxChildsLayout } from "../util/Util"
import { SeaTargetItem } from "./SeaTargetItem"

export class SeaTargetPanel extends BaseItem1 {
    InitEvent
    itemTouchHandler
    setData
    UpdateItem
    Dispose
    item_list
    public constructor(parent?) {
        super(parent)

        this.base_file = "seaHegemony"
        this.layout_file = "SeaTargetPanel"
        this.dependent_res = ["head"]
        let roleMgr = RoleManager.GetInstance()
        let local_atuoMgr = AutoFightManager.GetInstance()
        let local_scene = Scene.GetInstance()
        let local_sceneType = SceneBaseType
        let local_modelIns = SeaHegemonyModel.GetInstance()
        let boss_scene_mgr = BossSceneManager.GetInstance()
        let local_msg = Message
        let _data_ = []
        let need_refresh_data_ = null
        this.load_callback = () => {
            this._item_scroller.hScrollBarSkin = ""
            this.item_list = []
            this.InitEvent()
        }

        this.InitEvent = () => {
            this.BindVar(roleMgr.GetMainRoleVo(), "pk_status", (event_name?, pk_status?) => {
                let target = BossSceneManager.GetInstance().GetAttackTarget()
                if (target && target.obj_type == local_sceneType.Role) {
                    local_atuoMgr.SetAutoFight(false)
                    BossSceneManager.GetInstance().SetAttackTarget(null)
                }
            }
            )
            this.BindEvent(local_modelIns, SeaHegemonyModel.CHOSE_TARGET, (data?) => {
                this.itemTouchHandler(data)
            })
            if (need_refresh_data_) {
                this.UpdateItem()
                need_refresh_data_ = false
            }
        }

        this.Dispose = () => {
            for (let i = 0; i < this.item_list.length; i++) {
                this.item_list[i].DeleteMe()
                this.item_list[i] = null
            }
            this.item_list = []
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


            if (!_data_) {
                return
            }

            //_data_=_data_.concat(_data_).concat(_data_).concat(_data_)
            for (let i = 0; i < _data_.length; i++) {
                let item: SeaTargetItem = this.item_list[i]
                if (!item) {
                    item = new SeaTargetItem(this.Content)
                    item.Load()
                    this.item_list[i] = item
                }
                item.SetVisible(true)
                item.SetData(_data_[i], i)
            }


            for (let p = _data_.length; p < this.item_list.length; p++) {
                if (this.item_list[p]) this.item_list[p].SetVisible(false)
            }

            RefBoxChildsLayout(this.Content, 4, 73, true, "left")
            this.Content.width = _data_.length * 73 + (_data_.length - 1) * 4
        }

        this.itemTouchHandler = (item_data?) => {
            let vo = item_data
            let attackObj = null
            if (vo.vo_type == local_sceneType.Monster) {
                attackObj = local_scene.GetMonster(vo.instance_id)
            } else {
                attackObj = local_scene.GetRole(vo.role_id)
            }
            if (attackObj) {

                let canFight =SceneManager.GetInstance().IsCanAttackByMainRole(attackObj.vo, false, true)
                || SeaHegemonyModel.GetInstance().CanAttackRole(attackObj.vo)

                //防守方  塔坏了，需要整一下
                if (vo.vo_type == local_sceneType.Monster) {
                    if ((local_modelIns.fightType == 0 && attackObj.vo) && attackObj.vo.type == MonsterType.COLLECT) {
                        canFight = true
                    }
                }


                if (vo.vo_type == local_sceneType.Role) {
                    canFight = SeaHegemonyModel.GetInstance().CanAttackRole(attackObj.vo)
                }




                if (!canFight) {
                    Message.show("同一阵营无法攻击")
                    return
                }

                //同类型的船才能攻击
                if (vo.vo_type == local_sceneType.Role) {
                    let _mainrole_vo = RoleManager.GetInstance().GetMainRoleVo()
                    let camp1 = _mainrole_vo.warGroup
                    let camp2 = vo.warGroup
                    if (camp1 != camp2) {
                        Message.show("不同类型的船无法攻击")
                        return
                    }

                }




                if (vo.vo_type == local_sceneType.Monster) {
                    if ((local_modelIns.fightType == 1 && attackObj.vo) && attackObj.vo.type == MonsterType.COLLECT) {
                        Message.show("只有防守方可以修复！")
                        return
                    }

                    //要塞攻击限制
                    if ((local_modelIns.fightType == 1 && attackObj.vo) && attackObj.vo.type != MonsterType.COLLECT) {
                        if (!SeaHegemonyModel.GetInstance().CanAttackMonster(attackObj.vo)) {
                            Message.show("摧毁哨塔后可攻击要塞")
                            return
                        }
                    }

                }
                else if (vo.vo_type == local_sceneType.MainRole) {
                    local_msg.show("无法攻击自己!")
                    return
                }


                local_scene.clearGoToData()
                local_scene.SetClickTarget(attackObj)
                AutoFightManager.GetInstance().SetAutoFight(true)

            }
        }

    }

    public DeleteMe() {

        this.Dispose()
        super.DeleteMe()
    }



    _Image1: Laya.Image
    _item_scroller: Laya.Panel
    Content: Laya.Box
    public GetComponents() {
        [
            this._Image1,
            this._item_scroller,
            this.Content,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_item_scroller",
                "Content",
            ])
    }
}
window["SeaTargetPanel"] = SeaTargetPanel