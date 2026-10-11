import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { RefBoxChildsLayout } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { HolyBattleTargetItem } from "./HolyBattleTargetItem"

export class HolyBattleTargetPanel extends BaseItem1 {
    InitEvent
    SwitchItem
    UpdateItem
    _data
    _list
    boss_scene_mgr
    holy_battle_model
    need_refresh_data
    setData
    item_list
    public constructor(parent?) {
        super(parent)

        this.base_file = "boss"
        this.layout_file = "BossTargetPanel"
        this.layer_value = "Main"
        this._data = []
        this.need_refresh_data = null
        this.boss_scene_mgr = BossSceneManager.GetInstance()
        this.holy_battle_model = HolyBattleModel.GetInstance()

        let roleMgr = RoleManager.GetInstance()
        let local_atuoMgr = AutoFightManager.GetInstance()
        let local_scene = Scene.GetInstance()
        let local_sceneType = SceneBaseType
        let local_msg = Message
        this.preload_server_config = { "config_role_holy_spirit_battlefield_group": false }
        this.load_callback = () => {
            this._scroller.hScrollBarSkin = ""
            this.InitEvent()
        }

        this.InitEvent = () => {

            this.BindEvent(this.holy_battle_model, HolyBattleModel.SWITCH_ITEM, (index?) => {
                this.SwitchItem(index)
            })

            this.BindVar(roleMgr.GetMainRoleVo(), "pk_status", (event_name?, pk_status?) => {
                if (this.boss_scene_mgr.GetAttackTarget() && this.boss_scene_mgr.GetAttackTarget().obj_type == local_sceneType.Role) {
                    local_atuoMgr.SetAutoFight(false)
                    this.boss_scene_mgr.SetAttackTarget(null)
                }
            }
            )

            if (this.need_refresh_data) {
                this.UpdateItem()
                this.need_refresh_data = false
            }
        }

        this.setData = (data?) => {
            this._data = data
            if (this.is_loaded) {
                this.UpdateItem()
            } else {
                this.need_refresh_data = true
            }
        }

        this.UpdateItem = () => {

            // if (!this.item_arraycollection) {
            //     this.item_arraycollection = new LoopScrowViewMgr()
            //     this.item_arraycollection.SetData(this.Content, HolyBattleTargetItem, this._data, LoopScrCon.Horizontal)
            // } else {
            //     this.item_arraycollection.replaceAll(this._data)
            // }

            if (!this.item_list) this.item_list = []
            let len = this._data.length
            for (let i = 0; i < len; i++) {
                let item: HolyBattleTargetItem = this.item_list[i]
                if (!item) {
                    item = new HolyBattleTargetItem(this.Content)
                    item.Load()
                    this.item_list[i] = item
                }
                item.SetVisible(true)
                item.SetData(this._data[i], i)
            }


            for (let p = len ; p < this.item_list.length; p++) {
                if(this.item_list[p])this.item_list[p].SetVisible(false)
            }
            RefBoxChildsLayout(this.Content, 4, 73, true, "left")
            this.Content.width = len * 73 + (len - 1) * 4

        }

        this.SwitchItem = (index?) => {

            let vo = this._data[index]
            let attackObj = null
            if (vo.vo_type == local_sceneType.Monster) {
                attackObj = local_scene.GetMonster(vo.instance_id)
            } else {
                attackObj = local_scene.GetRole(vo.role_id)
            }

            if (attackObj) {
                if (attackObj.obj_type == local_sceneType.Monster) {
                    if (attackObj.vo && attackObj.vo.warGroup == roleMgr.GetMainRoleVo().warGroup) {
                        local_msg.show("无法攻击己方占领的据点")
                        return
                    }
                    this.boss_scene_mgr.SetAttackTarget(attackObj)
                } else if (attackObj.obj_type == local_sceneType.Role) {
                    let canFight = SceneManager.GetInstance().IsCanAttackByMainRole(attackObj.vo, false, true)
                    if (!canFight) {
                        return
                    }
                } else if (attackObj.obj_type == local_sceneType.MainRole) {
                    local_msg.show("无法攻击自己!")
                    return
                }
                this.boss_scene_mgr.SetAttackTarget(attackObj)
                local_scene.clearGoToData()
                local_scene.SetClickTarget(attackObj)
                local_atuoMgr.SetAutoFight(true)
            }
        }


    }

    public DeleteMe() {

        if(this.item_list){
        for (let i = 0; i < this.item_list.length; i++) {
            this.item_list[i].DeleteMe()
            this.item_list[i] = null
        }
        this.item_list = []
        }
        super.DeleteMe()
    }


    _Image1: Laya.Image
    _Image2: Laya.Image
    _num_lb: Laya.Label
    _scroller: Laya.Panel
    Content:Laya.Box
    _img: Laya.Image
    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._num_lb,
            this._scroller,
            this.Content,
            this._img,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "_num_lb",
                "_scroller",
                "Content",
                "_img",
            ])
    }
}
window["HolyBattleTargetPanel"] = HolyBattleTargetPanel



