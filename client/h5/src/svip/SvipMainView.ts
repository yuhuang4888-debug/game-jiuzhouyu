///@描述:view
///@作者:fengning
///@Laya版本:2.12.2
///@日期:2022-08-16 11:49

import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SvipDefine, SvipMainModel } from "../commonModel/SvipMainModel"
import { PlatformManager } from "../PlatformManager"
import { Sprite } from "../scene/sceneobj/Sprite"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { SvipMainItem } from "./SvipMainItem"

export class SvipMainView extends BaseView1 {
    /*----这里定义变量-----*/
    image_bg: Laya.Image
    image_title: Laya.Image
    btn_close: Laya.Image
    image_desc: Laya.Image
    image_middle_tittle: Laya.Image
    image_add_customer: Laya.Image
    btn_bg: Laya.Image
    image_contact_us: Laya.Image
    lable_line: Laya.Label
    lable_content: Laya.Label
    box_middle: Laya.Box
    sprite_mask: Laya.Sprite
    sprite_texture: Laya.Sprite
    image_role_frame: Laya.Image
    image_role_icon: Laya.Image
    model
    item_list
    LoadSuccess
    CreatItems
    config_svip
    config_svip_content
    SetViewData
    /*---------------------*/
    public constructor() {
        super()
        this.base_file = "svip"
        this.layout_file = "SvipMainView"
        this.layer_value = Enum_UILayer.Activity
        let local_resManager_instance = ResManager.GetInstance()
        this.is_center = true
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.model = SvipMainModel.GetInstance()
        this.item_list = []
        this.preload_server_config = {
			// "config_english_super_vip": false,
			"config_english_super_vip_content": false
		}
        this.load_callback = () => {
            // this.config_svip = local_resManager_instance.GetGameConfigFromCache(this, "config_english_super_vip", false)
            this.config_svip_content = local_resManager_instance.GetGameConfigFromCache(this, "config_english_super_vip_content", false)
            this.LoadSuccess()
            this.InitEvent()
        }
        
        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.image_bg, GameResPath.GetIcon("svip", "ui_svip_bg_01"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.image_title, GameResPath.GetIcon("svip", "ui_svip_basal_01"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.btn_close, GameResPath.GetIcon("svip", "btn_close"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.image_middle_tittle, GameResPath.GetIcon("svip", "ui_svip_basal_04"), true)
            //ResManager.GetInstance().SetOutsideImageSprite(this, this.image_add_customer, GameResPath.GetIcon("svip", "ui_svip_basal_13"), true)
            //ResManager.GetInstance().SetOutsideImageSprite(this, this.btn_bg, GameResPath.GetIcon("svip", "btn_contact_bg"), true)
            //ResManager.GetInstance().SetOutsideImageSprite(this, this.image_contact_us, GameResPath.GetIcon("svip", "ui_svip_basal_12"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.image_role_frame, GameResPath.GetIcon("svip", "ui_svip_basal_03"), true)
        }


        this.open_callback = () => {
            this.SetViewData()
        }


        this.SetViewData = () => {
            let act_id = this.model.GetOpenActId()
            let server_data = this.model.GetContentList()
            let cfg = this.config_svip_content
            for (let key in server_data) {
                let value = server_data[Number(key)]
                if (Number(key) == SvipDefine.CONTENT_AD){          //广告语
                    let adv_image = cfg[value].content
                    ResManager.GetInstance().SetOutsideImageSprite(this, this.image_desc, GameResPath.GetIcon("svip", adv_image), true)
                }else if(Number(key) == SvipDefine.CONTENT_PIC){    //客服人物图片
                    let role_icon = cfg[value].content
                    ResManager.GetInstance().SetOutsideImageSprite(this, this.image_role_icon, GameResPath.GetIcon("svip", role_icon), true)
                }else if(Number(key) == SvipDefine.CONTENT_PRI){    //特权内容
                    for (let index in value) {
                        this.CreatItems(Number(index), cfg[value[Number(index)]])
                    }
                }else if(Number(key) == SvipDefine.CONTENT_CON){    //联系方式
                    if(PlatformManager.IsEyouPlatform()){
                        this.lable_content.text =  this.RelaceStr(cfg[value].content)
                    }else{
                        this.lable_content.text = cfg[value].content
                    }
                }
            }
        }


        this.Open = () => {
            super.Open()
        }

        this.destroy_callback = () => {
            this.DestroyCallback()
        }

        this.CreatItems = (index, data) => {
            let item = this.item_list[index]
            if(!item){
                item = new SvipMainItem(this.box_middle)
                this.item_list[index] = item
                item.SetPosition(0, index * 80 + 40)
                item.Load()
            }
            item.ExcuteCallback(() => {
                item.SetDate(index, data)
            })
        }
    }

    public RelaceStr(str){
        let re = "<br/>"
        let new_str = str.replace(re, "\n")
        return new_str
    }
    
    public InitEvent() {

        let click_func = () => {
            this.Close()
        }
        Util.AddClickEvent(this.btn_close, click_func, this, true)

        // this.BindEvent(this.model, EventDefine.EVENT.XXXXXX,() =>{})
    }
    
    public DestroyCallback() {
        if (this.item_list ) {
            for (let item in this.item_list) {
                let vo = this.item_list[item]
                vo.DeleteMe()
            }
            this.item_list = []
        }
    }
    
    public GetComponents() {
        [
            this.image_bg,
            this.image_title,
            this.btn_close,
            this.image_desc,
            this.image_middle_tittle,
            this.image_add_customer,
            this.btn_bg,
            this.image_contact_us,
            this.lable_line,
            this.lable_content,
            this.box_middle,
            this.image_role_frame,
            this.image_role_icon
        ]
        = this.GetChildrenByNames([
            "image_bg",
            "image_title",
            "btn_close",
            "image_desc",
            "image_middle_tittle",
            "image_add_customer",
            "btn_bg",
            "image_contact_us",
            "lable_line",
            "lable_content",
            "box_middle",
            "image_role_frame",
            "image_role_icon"
        ])
    }
}
window["SvipMainView"] = SvipMainView