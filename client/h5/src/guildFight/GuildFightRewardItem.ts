import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"

export class GuildFightRewardItem extends BaseItem1 {
    InitItem
    Scr_Scroller1
    SetCfg
    itemList
    rewardCfg
    type

    public constructor(parent?, type?, reward?) {
        super(parent)

        this.base_file = "guildFight"
        this.layout_file = "GuildFightRewardItem"
        this.type = type
        this.rewardCfg = reward
        let gmodel = GoodsModel.GetInstance()
        this.load_callback = () => {
            this._Scroller1.hScrollBarSkin=""
            this.InitItem()
        }

        this.SetCfg = (type?, cfg?) => {
            this.type = type
            this.rewardCfg = cfg
        }

        this.InitItem = () => {
            // [ts2lua]lua中0和空字符串也是true，此处this.type需要确认
            let sp_name = (this.type == 1 && ("ui_Guild Wars_16") || ("ui_Guild Wars_15"))
            ResManager.GetInstance().SetImageSprite(this, this.typeImg, "guildFight", sp_name, true)
            if (!this.itemList) {
                this.itemList = []
            }
            if (this.rewardCfg) {
                let list = JSON.parse(this.rewardCfg)
                let i = 0
                do {
                    let item = new BaseAwardItem(this.Content)
                    item.Load()
                    item.SetItemSize(86, 86)
                    let typeid, bind 
                    [typeid, bind ]= gmodel.GetMappingTypeId(list[i][0], list[i][1])
                    let goodsBasic = gmodel.GetGoodsBasicByTypeId(typeid)
                    if (goodsBasic) {
                        item.SetData(goodsBasic.type_id, list[i][2])
                    }
                    this.itemList[i] = item
                    i = i + 1
                } while ((i < list.length)
                )
            }

        }


    }

    public DeleteMe(){
        if (this.itemList) {
            for (let _tmpi in this.itemList) {
                var vo = this.itemList[_tmpi]
                vo.DeleteMe()
            }
            this.itemList = null
        }
        super.DeleteMe()
    }



    bg: Laya.Image
    typeImg: Laya.Image
    _Scroller1: Laya.Panel
    Content: Laya.HBox
    public GetComponents() {
        [
            this.bg,
            this.typeImg,
            this._Scroller1,
            this.Content,
        ]
            = this.GetChildrenByNames([

                "bg",
                "typeImg",
                "_Scroller1",
                "Content",
            ])
    }
}
window["GuildFightRewardItem"] = GuildFightRewardItem