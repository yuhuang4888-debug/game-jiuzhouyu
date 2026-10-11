import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { BanquetModel } from "../commonModel/BanquetModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { BanquetGoodsItem } from "./BanquetGoodsItem"

export class BanquetGoodsView extends BaseView1 {
    // BG1
    InitInfo
    InitView
    // ItemGroup
    Local_Open
    // _Image3
    // change_scene_close
    // closeBtn
    // destroy_callback
    // destroy_imm
    // is_center
    itemList
    model
    // preload_server_config
    // title
    type
    // use_background

    public constructor() {
        super()


        this.model = BanquetModel.GetInstance();
        this.base_file = "marriage2"
        this.layout_file = "BanquetGoodsView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.use_background = true
        this.destroy_imm = true
        this.change_scene_close = true
        this.click_bg_toClose = true;

        this.preload_server_config = {
            "config_wedding_candies": false,
            "config_wedding_fires": false
        }
        this.load_callback = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("marriage2", "uijh_118"))
            this.InitInfo()
        }

        this.destroy_callback = () => {
            if (this.itemList) {
                for (let _tmpi in this.itemList) {
                    var vo = this.itemList[_tmpi]
                    if (vo) {
                        vo.DeleteMe()
                        vo = null
                    }
                }
                this.itemList = null    
            }
        }

        this.InitInfo = () => {
            this.itemList = []
            Util.AddClickEvent(this.closeBtn, () => {
                this.Close()
            }
                , this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
            this.InitView()
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("marriage2", "uijh_118"))
        }

        this.Local_Open = (parms?) => {
            if (parms) {
                this.type = parms[0]
                this.InitView()
            }
            super.Open()
        }

        this.InitView = () => {
            if (!this.itemList) {
                this.itemList = []
            }
            if (this.type && this.is_loaded) {
                let Cfg = null
                if (this.type == 1) {
                    ResManager.GetInstance().SetImageSprite(this, this.title, "marriage2_asset", "uijh_180", true)
                    //this.title.source = "marriage2_asset.uijh_180"
                    Cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_wedding_candies", false)
                } else if (this.type == 2) {
                    ResManager.GetInstance().SetImageSprite(this, this.title, "marriage2_asset", "uijh_181", true)
                    //this.title.source = "marriage2_asset.uijh_181"
                    Cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_wedding_fires", false)
                }
                let count = 0
                if (Cfg) {
                    for (let index in Cfg) {

                        // [ts2lua]this.itemList下标访问可能不正确
                        let item = this.itemList[count]
                        if (!item) {
                            item = new BanquetGoodsItem(this.ItemGroup)
                            item.Load()
                            // [ts2lua]this.itemList下标访问可能不正确
                            this.itemList[count] = item
                        }
                        item.ExcuteCallback(() => {
                            // [ts2lua]Cfg下标访问可能不正确
                            item.SetData(this.type, Cfg[index])
                        }
                        )
                        count = count + 1
                    }
                }
            }
        }
    }

    public Open(...new_args) {

        this.Local_Open(new_args)
    }

  
_Image2:Laya.Image
title:Laya.Image
BG1:Laya.Image
closeBtn:Laya.Image
ItemGroup:Laya.HBox
public GetComponents() {
[
this._Image2,
this.title,
this.BG1,
this.closeBtn,
this.ItemGroup,
]
 = this.GetChildrenByNames([

"_Image2",
"title",
"BG1",
"closeBtn",
"ItemGroup",
])
}
}
 window["BanquetGoodsView"]= BanquetGoodsView