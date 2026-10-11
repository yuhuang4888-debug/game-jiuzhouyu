///@描述:VipTopCardItem
///@作者:fengning
///@Laya版本:2.12.2
///@日期:2022-08-02 11:26
import { BaseItem1 } from "../common/BaseItem1"
import { VipModel } from "../commonModel/VipModel"
import { ResManager } from "../common/ResManager"
import { Util } from "../util/Util"
import { GameResPath } from "../util/GameResPath"

// import { EventDefine } from "../commonModel/EventDefine"

export class VipTopCardItem extends BaseItem1 {
    /*----这里定义变量-----*/
    _Image_top_bg_vip_1: Laya.Image
    _Image_top_select_vip_1: Laya.Image
    _Image_vip_level_1: Laya.Image
    _Image_discount_bg_1: Laya.Image
    _lable_time_1: Laya.Label
    _Image_top_bg_vip_2: Laya.Image
    _Image_top_select_vip_2: Laya.Image
    _Image_vip_level_2: Laya.Image
    _Image_discount_bg_2: Laya.Image
    _lable_time_2: Laya.Label
    _Image_top_bg_vip_4: Laya.Image
    _Image_top_select_vip_4: Laya.Image
    _Image_vip_level_4: Laya.Image
    _Image_discount_bg_4: Laya.Image
    _lable_time_4: Laya.Label
    vip_btn_1_index
    vip_btn_2_index
    vip_btn_4_index
    select_btn_list
    model
    InitShow
    InitDefaultData
    Show_Select
    InitEvent
    ChangeDiscountImage
    _Image_time_bg_1
    _Image_time_bg_2
    _Image_time_bg_4
 
    /*---------------------*/
    public constructor(parent?) {
        super(parent)
        this.base_file = "vip"
        this.layout_file = "VipTopCardItem"
        this.model = VipModel.GetInstance()
        this.load_callback = () => {
            this.InitDefaultData()
            this.InitShow()
            this.InitEvent()
        }

        this.InitDefaultData = () => {
            this.select_btn_list = [this._Image_top_select_vip_1, this._Image_top_select_vip_2, this._Image_top_select_vip_4]
            this.vip_btn_1_index = 0
            this.vip_btn_2_index = 1
            this.vip_btn_4_index = 2
        }

        this.InitEvent = ()=>{
            let change_discount_img = () => {
                this.ChangeDiscountImage()
            }
            this.BindEvent(this.model ,VipModel.CHANGE_DISCOUNT_IMG_AND_REFRESH_CARD_ITEM, change_discount_img)


            let onClick_Image_top_1 = () => {
                this.Show_Select(this.vip_btn_1_index)
                VipModel.GetInstance().Fire(VipModel.UPDATA_VIPCARD_ITEM,this.vip_btn_1_index)
            }
            Util.AddClickEvent(this._Image_top_bg_vip_1, onClick_Image_top_1, this,true)

            let onClick_Image_top_2 = () => {
                this.Show_Select(this.vip_btn_2_index)
                VipModel.GetInstance().Fire(VipModel.UPDATA_VIPCARD_ITEM,this.vip_btn_2_index)
            }
            Util.AddClickEvent(this._Image_top_bg_vip_2, onClick_Image_top_2, this,true)

            let onClick_Image_top_4 = () => {
                this.Show_Select(this.vip_btn_4_index)
                VipModel.GetInstance().Fire(VipModel.UPDATA_VIPCARD_ITEM,this.vip_btn_4_index)
            }
            Util.AddClickEvent(this._Image_top_bg_vip_4, onClick_Image_top_4, this,true)
        }

        this.Show_Select = (index?) => {
            for (let key in this.select_btn_list) {
                if(key == index){
                    this.select_btn_list[key].visible = true
                }
                else{
                    this.select_btn_list[key].visible = false
                }
            } 
        }

        this.InitShow = () => {
            if (this.is_loaded) {
                ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_top_select_vip_1, GameResPath.GetIcon("vip", "uivip_select_25a"), false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_top_select_vip_2, GameResPath.GetIcon("vip", "uivip_select_27a"), false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_top_select_vip_4, GameResPath.GetIcon("vip", "uivip_select_28a"), false)

                ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_top_bg_vip_1, GameResPath.GetIcon("vip", "uivip_bg_25"), false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_top_bg_vip_2, GameResPath.GetIcon("vip", "uivip_bg_27"), false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_top_bg_vip_4, GameResPath.GetIcon("vip", "uivip_bg_28"), false)

				ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_vip_level_1, GameResPath.GetIcon("vip", "uivip_030b"), false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_vip_level_2, GameResPath.GetIcon("vip", "uivip_030c"), false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_vip_level_4, GameResPath.GetIcon("vip", "uivip_031b"), false)

				ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_time_bg_1, GameResPath.GetIcon("vip", "uivip_time_bg"), true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_time_bg_2, GameResPath.GetIcon("vip", "uivip_time_bg"), true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_time_bg_4, GameResPath.GetIcon("vip", "uivip_time_bg"), true)

                this._Image_top_select_vip_1.visible = false
                this._Image_top_select_vip_2.visible = false
                this._Image_top_select_vip_4.visible = true

                this._Image_discount_bg_1.visible = false
                this._Image_discount_bg_2.visible = false
                this._Image_discount_bg_4.visible = true
            }

            this.Show_Select(this.vip_btn_4_index)
            this._lable_time_1.text = "30天"
            this._lable_time_2.text = "90天"
            this._lable_time_4.text = "180天"
        }

        this.ChangeDiscountImage = () =>{
            let vip_lv = this.model.GetVipLevel()
            if(vip_lv == 1){
				ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_discount_bg_4, GameResPath.GetIcon("vip", "ui_Recharge_28"), false)
            }else if(vip_lv == 2){
				ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_discount_bg_4, GameResPath.GetIcon("vip", "ui_Recharge_29"), false)
            }else if(vip_lv > 2){
				ResManager.GetInstance().SetOutsideImageSprite(this, this._Image_discount_bg_4, GameResPath.GetIcon("vip", "ui_Recharge_29"), false)
                this._Image_discount_bg_4.visible = false
            }
        }
    }


    
    public DeleteMe() {
        super.DeleteMe()
    }
    
    public GetComponents() {
        [
            this._Image_top_bg_vip_1,
            this._Image_top_select_vip_1,
            this._Image_vip_level_1,
            this._Image_discount_bg_1,
            this._Image_time_bg_1,
            this._lable_time_1,
            this._Image_top_bg_vip_2,
            this._Image_top_select_vip_2,
            this._Image_vip_level_2,
            this._Image_discount_bg_2,
            this._Image_time_bg_2,
            this._lable_time_2,
            this._Image_top_bg_vip_4,
            this._Image_top_select_vip_4,
            this._Image_vip_level_4,
            this._Image_discount_bg_4,
            this._Image_time_bg_4,
            this._lable_time_4,
        ]
        = this.GetChildrenByNames([
            "_Image_top_bg_vip_1",
            "_Image_top_select_vip_1",
            "_Image_vip_level_1",
            "_Image_discount_bg_1",
            "_Image_time_bg_1",
            "_lable_time_1",
            "_Image_top_bg_vip_2",
            "_Image_top_select_vip_2",
            "_Image_vip_level_2",
            "_Image_discount_bg_2",
            "_Image_time_bg_2",
            "_lable_time_2",
            "_Image_top_bg_vip_4",
            "_Image_top_select_vip_4",
            "_Image_vip_level_4",
            "_Image_discount_bg_4",
            "_Image_time_bg_4",
            "_lable_time_4",
        ])
    }
}
window["VipTopCardItem"] = VipTopCardItem