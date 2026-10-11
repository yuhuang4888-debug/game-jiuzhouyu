import { BaseItem1 } from "../common/BaseItem1";
import { CommonManager } from "../common/CommonManager";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { FriendEvent, FriendModel } from "../commonModel/FriendModel";
import { LungModel } from "../commonModel/LungModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { SetLocalPosition, SetSizeDelta, Util } from "../util/Util";
import { PlayerMessageRuneItem } from "./PlayerMessageRuneItem";

export class PlayerMessageRuneView extends BaseItem1 {
    bg: Laya.Image
    lb_fight: Laya.Label
    propBtn: Laya.HBox
    itemGP: Laya.Box
    rune_9: Laya.Box
    item_bg_9: Laya.Image
    rune_10: Laya.Box
    item_bg_10: Laya.Image
    rune_1: Laya.Box
    item_bg_1: Laya.Image
    rune_2: Laya.Box
    item_bg_2: Laya.Image
    rune_3: Laya.Box
    item_bg_3: Laya.Image
    rune_4: Laya.Box
    item_bg_4: Laya.Image
    rune_5: Laya.Box
    item_bg_5: Laya.Image
    rune_6: Laya.Box
    item_bg_6: Laya.Image
    rune_7: Laya.Box
    item_bg_7: Laya.Image
    rune_8: Laya.Box
    item_bg_8: Laya.Image
    none:Laya.Box
    none_1: Laya.Image
    show_Info: Laya.Box
    image_bg: Laya.Image
    LoadSuccess
    InitEvents
    SetData
    UpdateView
    role_data
    data
    need_refresh
    items
    public constructor(parent) {
        super(parent)
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageRuneView"
        let local_resMgr = ResManager.GetInstance()
        let common_mgr = CommonManager.GetInstance()
        let model = LungModel.GetInstance(),
            _friendmodel = FriendModel.GetInstance(),
            res_mgr = ResManager.GetInstance(),
            style_item_list_
        this.items = []
        let url = "resource/game/runeIcon/rune_back.png"
        let url_pink = "resource/game/runeIcon/rune_pink.png"
        let url_empty = "resource/game/runeIcon/ui_yuhun_empty.png"
        this.load_callback = function () {
            this.InitEvents()
            this.LoadSuccess()
        }

        this.DeleteMe = () => {
            if (this.items) {
                for (let key in this.items) {
                    this.items[key].DeleteMe()
                }
                this.items = []
            }

            if (style_item_list_) {
                for (let item of style_item_list_) {
                    item.DeleteMe()
                }
                style_item_list_ = null
            }
            super.DeleteMe()
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetTexture(this, this.bg, GameResPath.GetIcon("playerMessage", "ui_rwxx_bg"))
            local_resMgr.SetTexture(this,this.none_1,GameResPath.GetIcon("playerMessage","none_1"))
            local_resMgr.SetOutsideImageSprite(this, this.image_bg, GameResPath.GetIcon("playerMessage", "ui_none_bg"), true)

            if (this.need_refresh) {
                _friendmodel.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this.role_data.server_id, this.role_data.role_id, 12)
                this.need_refresh = false
            }
          
        }

        this.InitEvents = () => {
            this.BindEvent(_friendmodel, FriendEvent.UPDATE_PLAYERMESSAGE_RUNE, (scmd?) => {
                this.UpdateView(scmd)
            })

            Util.AddClickEvent(this.propBtn, () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "PlayerMessageRunePropertyView", this.data)
            }, this, true)
        }

        this.SetData = (data) => {
            this.role_data = data
            if (this.is_loaded) {
                _friendmodel.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this.role_data.server_id, this.role_data.role_id, 12)
            } else {
                this.need_refresh = true
            }
        }

        this.UpdateView = (scmd) => {
            let view_name = "SecretTreasureMainView"
            if(common_mgr.CheckOtherPlayerFuncOpenState(view_name, this.role_data)){
                this.none.visible = false
                this.show_Info.visible = true
                this.lb_fight.text = scmd.all_power
                this.data = scmd
                //初始化格子
                for (let i = 1; i <= 10; i++) {
                    this["item_bg_" + i].visible = true
                    if( i == 9 || i == 10){
                        res_mgr.SetTexture(this, this["item_bg_" + i], url_pink)
                    }
                    else{
                        res_mgr.SetTexture(this, this["item_bg_" + i], url)
                    }
                }
                for (let key in scmd.rune_list) {
                    let data = scmd.rune_list[key]
                    //首先处理pos_id不是0,goods_id不为0的情况
                    //然后处理pos_id不是0,goods_id为0的情况，剩下的就是不用处理的，就在一开始保持原样就好
                    if(data.pos_id != 0 && data.goods_id != 0){
                        this["item_bg_" + data.pos_id].visible = false
                        let item = this.items[Number(key)]
                        if (!item) {
                            item = new PlayerMessageRuneItem(this["rune_" + data.pos_id])
                            item.Load()
                            item.SetData(data)
                            this.items[Number(key)] = item
                            item.ExcuteCallback(() => {
                                if (data.pos_id < 9) {
                                    item.display_obj.scaleX = 0.7
                                    item.display_obj.scaleY = 0.7
                                } else {
                                    item.display_obj.scaleX = 0.9
                                    item.display_obj.scaleY = 0.9
                                }
                            })
                        }
                    }else if(data.pos_id != 0 && data.goods_id == 0){
                        // this["item_bg_" + data.pos_id].visible = false
                        if(data.pos_id < 9){
                            res_mgr.SetTexture(this, this["item_bg_" + data.pos_id], url_empty)
                            SetSizeDelta(this["item_bg_" + data.pos_id], 130, 160)
                            SetLocalPosition(this["item_bg_" + data.pos_id], 8, 8)
                        // }else{
                        //     SetSizeDelta(this["item_bg_" + data.pos_id], 190, 220)
                        //     res_mgr.SetTexture(this, this["item_bg_" + data.pos_id], url_pink)
                        }
                    }
                }
            }else{
                this.show_Info.visible = false
                this.none.visible = true
            }
        }
    }

    public GetComponents() {
        [
            this.bg,
            this.lb_fight,
            this.propBtn,
            this.itemGP,
            this.rune_9,
            this.item_bg_9,
            this.rune_10,
            this.item_bg_10,
            this.rune_1,
            this.item_bg_1,
            this.rune_2,
            this.item_bg_2,
            this.rune_3,
            this.item_bg_3,
            this.rune_4,
            this.item_bg_4,
            this.rune_5,
            this.item_bg_5,
            this.rune_6,
            this.item_bg_6,
            this.rune_7,
            this.item_bg_7,
            this.rune_8,
            this.item_bg_8,
            this.none,
            this.none_1,
            this.show_Info,
            this.image_bg
        ]
            = this.GetChildrenByNames([

                "bg",
                "lb_fight",
                "propBtn",
                "itemGP",
                "rune_9",
                "item_bg_9",
                "rune_10",
                "item_bg_10",
                "rune_1",
                "item_bg_1",
                "rune_2",
                "item_bg_2",
                "rune_3",
                "item_bg_3",
                "rune_4",
                "item_bg_4",
                "rune_5",
                "item_bg_5",
                "rune_6",
                "item_bg_6",
                "rune_7",
                "item_bg_7",
                "rune_8",
                "item_bg_8",
                "none",
                "none_1",
                "show_Info",
                "image_bg"
            ])
    }
}
window["PlayerMessageRuneView"] = PlayerMessageRuneView