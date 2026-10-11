import { BaseItem1 } from "../common/BaseItem1"
import { DownDropBtn } from "../common/DownDropBtn"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import "../unreal/UnrealEnterView"
import "../unreal/UnrealDismantleView"
import "../unreal/UnrealDecomposeView"
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { UnrealEquipItem } from "../unreal/UnrealEquipItem"
import { FriendEvent, FriendModel } from "../commonModel/FriendModel"
import { SceneModelScale } from "../scene/SceneConfig"
import { PlayerMessageUnrealItem } from "./PlayerMessageUnrealItem"
import { GameResPath } from "../util/GameResPath"
import { CommonManager } from "../common/CommonManager"

//蜃妖
export class PlayerMessageUnreal extends BaseItem1 {
    LoadSuccess
    InitEvent
    InitView
    UpdateBag
    UpdateEquip
    UpdateLv
    bag_loop_mgr: LoopScrowViewMgr
    SetData
    role_data
    need_refresh
    UpdateView
    public constructor(parent) {
        super(parent)
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageUnreal"
        let local_resMgr = ResManager.GetInstance()
        let common_mgr = CommonManager.GetInstance()
        let model = UnrealModel.GetInstance(),
        res_mgr = ResManager.GetInstance(),
        local_Util = Util,
        local_GlobalEventSystem = GlobalEventSystem,
        local_EventName = EventName,
        goods_model = GoodsModel.GetInstance(),
        local_GoodsModel = GoodsModel,
        local_UnrealModel = UnrealModel,
        equip_list_,
        offset_ = 6,
        friend_model = FriendModel.GetInstance(),
        equip_pos_ = [
            { x: 3, y: 64 },
            { x: 175, y: 0 },
            { x: 346, y: 65 },
            { x: 346, y: 258 },
            { x: 173, y: 351 },
            { x: 2, y: 257 },
        ]

        this.load_callback = function () {
            this._Group2.visible = false
            this.LoadSuccess()
            this.InitEvent()
            if(this.need_refresh){
                friend_model.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this.role_data.server_id, this.role_data.role_id, 8)
                this.need_refresh = false
            }
        }

        this.DeleteMe = () => {
            if (equip_list_) {
                for (let item of equip_list_) {
                    item.DeleteMe()
                    item = null
                }
                equip_list_ = []
            }
            super.DeleteMe()
        }

        this.LoadSuccess = async () => {
            // this.InitView()
            local_resMgr.SetTexture(this,this.none_1,GameResPath.GetIcon("playerMessage","none_1"))
            ResManager.GetInstance().SetTexture(this,this.bg,GameResPath.GetIcon("playerMessage","ui_rwxx_bg"))
            ResManager.GetInstance().SetTexture(this,this.bg_1,GameResPath.GetIcon("playerMessage","ui_rwxx_ls01"))
            local_resMgr.SetOutsideImageSprite(this, this.image_bg, GameResPath.GetIcon("playerMessage", "ui_none_bg"), true)
        }

        this.InitEvent = () => {
            this.BindEvent(friend_model, FriendEvent.UPDATE_PLAYERMESSAGE_UNREAL, (scmd?) => {
                this.UpdateView(scmd)
            })

        }

        this.UpdateView = (scmd?) => {
            let view_name = "UnrealBagView"
            if(common_mgr.CheckOtherPlayerFuncOpenState(view_name, this.role_data)){
                this.show_Info.visible = true
                this.none.visible = false
                this.lb_fight.text = scmd.score
                if (!equip_list_)
                    equip_list_ = []
                let item
                for (let i = 0; i < local_UnrealModel.equip_count; i++) {
                    item = new PlayerMessageUnrealItem(this._gp_equips)
                    equip_list_[i] = item
                    let pos = equip_pos_[i]
                    item.SetPosition(pos.x, pos.y)
                    item.SetEquipType(i + 1)
                    item.Load()
                }
                this.UpdateEquip(scmd)
            }else{
                this.show_Info.visible = false
                this.none.visible = true
            }
           
        }

        this.UpdateEquip = (scmd) => {
            let vo = null
            let list = []
            for(let key in scmd.decoration_list){
                vo =  Object.assign({}, GoodsModel.GetInstance().GetGoodsBasicByTypeId(scmd.decoration_list[key].goods_id))
                if(vo ==undefined){
                    vo = {}
                }
                vo["cell"] = scmd.decoration_list[key].pos
                vo["lv"] = scmd.decoration_list[key].lv
                vo["stren"] = scmd.decoration_list[key].stren_score
                vo["equip_extra_attr"] =scmd.decoration_list[key].equip_extra_attr
                vo["other_info"] = 1
                list.push(vo)
            }
            // let list = goods_model.wear_unreal_list
            for (let i = 0; i < local_UnrealModel.equip_count; i++) {
                let equip = list[i]
                equip_list_[i].SetData(equip)
                equip_list_[i].ExcuteCallback(()=>{
                    Util.AddClickEvent( equip_list_[i].con,()=>{
                        this.UpdateLv(equip)
                    },equip_list_[i],true)
                })
            }
        }

        this.UpdateLv = (equip_info) => {
            this._lb_sten_lv.text = "+"+equip_info.lv
        }

        this.SetData = (data) => {
            this.role_data = data
            if (this.is_loaded) {
                friend_model.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this.role_data.server_id, this.role_data.role_id, 8)
            } else {
                this.need_refresh = true
            }
        }


    }

    lb_fight: Laya.Label
    _gp_equips: Laya.Box
    _Group2: Laya.Box
    img1: Laya.Image
    _Group1: Laya.HBox
    img2: Laya.Image
    _lb_sten_lv: Laya.Label
    bg: Laya.Image
    bg_1: Laya.Image
    none:Laya.Box
    none_1: Laya.Image
    show_Info: Laya.Box
    image_bg: Laya.Image
    public GetComponents() {
        [
            this.lb_fight,
            this._gp_equips,
            this._Group2,
            this.img1,
            this._Group1,
            this.img2,
            this._lb_sten_lv,
            this.bg,
            this.bg_1,
            this.none,
            this.none_1,
            this.show_Info,
            this.image_bg
        ]
            = this.GetChildrenByNames([

                "lb_fight",
                "_gp_equips",
                "_Group2",
                "img1",
                "_Group1",
                "img2",
                "_lb_sten_lv",
                "bg",
                "bg_1",
                "none",
                "none_1",
                "show_Info",
                "image_bg"
            ])
    }
}
window["PlayerMessageUnreal"] = PlayerMessageUnreal