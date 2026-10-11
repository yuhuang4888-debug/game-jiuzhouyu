import { findConfigFile, forEachTrailingCommentRange } from "../../node_modules/typescript/lib/typescript"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { FriendEvent, FriendModel } from "../commonModel/FriendModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { OutWardBaseModel, enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { RoleManager } from "../commonModel/RoleManager"
import { HolySealEquipItem } from "../holySeal/HolySealEquipItem"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { Util } from "../util/Util"
import { CommonManager } from "../common/CommonManager"


export class PlayerMessageHolySealView extends BaseItem1 {

    DesFunc
    InitView
    attr_box
    InitEvent
    UpdateView
    SetData
    need_refreshData
    select
    GetEquipTypeByPos
    InitEquipitem
    equip_list
    data
    role_data

    public constructor(parent?) {
        super(parent)
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageHolySealView"
        this.layer_value = Enum_UILayer.Activity
        let common_mgr = CommonManager.GetInstance()
        let local_roleVo = RoleManager.GetInstance().GetMainRoleVo()
        let local_resMgr = ResManager.GetInstance()
        this.equip_list = []
        let illuItemList_ = {},
            propItemList_ = [],
            costItem_
        this.preload_client_config = {

        }

        this.load_callback = () => {
            this.InitEvent()
            this.InitView()
            this.InitEquipitem()
        }

        // this.SetData = (select?) => {
        //     this.select = select
        //     if (this.is_loaded) {

        //     } else {
        //         this.need_refreshData = true
        //     }
        // }
        this.InitEvent = () => {
            this.BindEvent(FriendModel.GetInstance(), FriendEvent.UPDATE_PLAYERMESSAGE_HOLYSEAL, (scmd?) => {
                this.UpdateView(scmd)
            })

            Util.AddClickEvent(this._gp_holyseal, () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HolySealOtherAttrView",this.data)
            }, this, true)

        }

        this.InitView = () => {
            local_resMgr.SetTexture(this, this.big_bg, GameResPath.GetIcon("playerMessage", "ui_rwxx_bg_02"))
            local_resMgr.SetTexture(this, this.bg, GameResPath.GetIcon("playerMessage", "ui_seal_01"))
            local_resMgr.SetTexture(this,this.none_1,GameResPath.GetIcon("playerMessage","none_1"))
            local_resMgr.SetOutsideImageSprite(this, this.image_bg, GameResPath.GetIcon("playerMessage", "ui_none_bg"), true)
        }

        this.InitEquipitem = () => {
            let item = null
            let i = 1
            do {
                item = new HolySealEquipItem(this["item_" + i])
                item.Load()
                this.equip_list[i] = item
                i = i + 1
            } while ((i <= HolySealModel.EQUIP_COUNT))
        }

        this.UpdateView = (scmd?) => {
            let view_name = "HolySealView"
            if(common_mgr.CheckOtherPlayerFuncOpenState(view_name, this.role_data)){
                this.show_Info.visible = true
                this.none.visible = false
                this.data = scmd
                let list = scmd.pos_list
                let i = 1
                let equip
                let sub_type
                let info_list = []
                do {
                    equip = list[i - 1]
                    if (equip) {
                        sub_type = equip.pos
                        let cell = equip.cell
                        equip =Object.assign({}, GoodsModel.GetInstance().GetGoodsBasicByTypeId(equip.type_id))
                        equip["cell"] = cell
                        equip["equip_type"] = sub_type
                    }
                    if(!info_list[sub_type] ){
                        info_list[sub_type] = equip//.push(equip)
                    }
                    i++
                } while ((i <= HolySealModel.EQUIP_COUNT))
                i = 1
                do {
                    sub_type = this.GetEquipTypeByPos(i)
                    equip = { equip_type: sub_type, type_id: 0 }
                    if(!info_list[sub_type] ){
                        info_list[sub_type] = equip
                    }
                    i++
                } while ((i <= HolySealModel.EQUIP_COUNT))
                i = 1
                do {
                    let info = info_list[i]
                    this.equip_list[i].SetData(info)
                    i++
                } while ((i <= HolySealModel.EQUIP_COUNT))
                this.lb_fight.text = scmd.rating
            }else{
                this.show_Info.visible = false
                this.none.visible = true
            }
        }

        this.GetEquipTypeByPos = (pos) => {
            return ({
                [1]: 6,
                [2]: 5,
                [3]: 4,
                [4]: 3,
                [5]: 2,
                [6]: 1,
                [7]: 7,
                [8]: 8,
                [9]: 9,
                [10]: 10,
                [11]: 11
            })[pos]
        }

        this.SetData = (data?) => {
            this.role_data = data
            if (this.is_loaded) {

            } else {
                this.need_refreshData = true
            }
        }

        this.DesFunc = () => {
            if (costItem_) {
                costItem_.DeleteMe()
                costItem_ = null
            }
            if (propItemList_) {
                for (let vo of propItemList_) {
                    vo.DeleteMe()
                    vo = null
                }
                propItemList_ = []
            }
            if (illuItemList_) {
                for (let key in illuItemList_) {
                    illuItemList_[key].DeleteMe()
                    delete illuItemList_[key]
                }
                illuItemList_ = {}
            }
            if (this.equip_list) {
                for (let key in this.equip_list) {
                    this.equip_list[key].DeleteMe()
                }
                this.equip_list = null
            }
        }
    }

    GetPos(index?) {
		return ([
			//外圈 右到左
			{ x: 479, y: 117 },
			{ x: 348, y: 41 },
			{ x: 199, y: 68 },
			{ x: 101, y: 184 },
			{ x: 101, y: 335 },
			{ x: 199, y: 452 },
			//内圈 上左下右
			{ x: 374, y: 202 },
			{ x: 254, y: 324 },
			{ x: 374, y: 444 },
			{ x: 494, y: 324 },
			//中间

			{ x: 374, y: 324 }])[index]
	}

    public DeleteMe() {
        this.DesFunc()
        super.DeleteMe()
    }



    lb_fight: Laya.Label
    _gp_holyseal: Laya.Box
    _btn_holyseal: Laya.Image
    itemGp: Laya.Box
    item_1: Laya.Box
    item_2: Laya.Box
    item_3: Laya.Box
    item_4: Laya.Box
    item_5: Laya.Box
    item_6: Laya.Box
    item_7: Laya.Box
    item_8: Laya.Box
    item_9: Laya.Box
    item_10: Laya.Box
    item_11: Laya.Box
    bg: Laya.Image
    big_bg: Laya.Image
    none:Laya.Box
    none_1: Laya.Image
    show_Info: Laya.Box
    image_bg: Laya.Image

    public GetComponents() {
        [
            this.lb_fight,
            this._gp_holyseal,
            this._btn_holyseal,
            this.itemGp,
            this.item_1,
            this.item_2,
            this.item_3,
            this.item_4,
            this.item_5,
            this.item_6,
            this.item_7,
            this.item_8,
            this.item_9,
            this.item_10,
            this.item_11,
            this.bg,
            this.big_bg,
            this.none,
            this.none_1,
            this.show_Info,
            this.image_bg
        ]
            = this.GetChildrenByNames([

                "lb_fight",
                "_gp_holyseal",
                "_btn_holyseal",
                "itemGp",
                "item_1",
                "item_2",
                "item_3",
                "item_4",
                "item_5",
                "item_6",
                "item_7",
                "item_8",
                "item_9",
                "item_10",
                "item_11",
                "bg",
                "big_bg",
                "none",
                "none_1",
                "show_Info",
                "image_bg",
            ])
        ResManager.GetInstance().LoadFont(this, "fighting_font", this.lb_fight, null, false)
    }
}
window["PlayerMessageHolySealView"] = PlayerMessageHolySealView