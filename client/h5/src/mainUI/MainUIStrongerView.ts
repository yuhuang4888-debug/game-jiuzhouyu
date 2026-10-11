import { MainStrongerModel } from "./../commonModel/MainStrongerModel"
import { FirstRechargeModel } from "./../commonModel/FirstRechargeModel"
import { MainUIStrongerBtn } from "./MainUIStrongerBtn"
import { LoopScrCon, LoopScrowViewMgr } from "./../common/LoopScrowViewMgr"
import { Util, AtlasUrl } from "./../util/Util"
import { BaseView1 } from "./../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager";
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { ResManager } from "../common/ResManager"
import { OpenFun } from "../common/OpenFun"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"

export class MainUIStrongerView extends BaseView1 {
    loopMgr: LoopScrowViewMgr
    clickPos: Laya.Point;
    resMgr: ResManager = ResManager.GetInstance()

    ad_data_list
    ad_data_len
    ad_img_list: Laya.Image[]

    real_img_index = 0
    cur_page_index = 0

    delay_refresh_img_id
    is_moving = false
    is_click
    touch_begin_x
    ad_time_id
    max_move_x
    move_offset_x
    now_move_x
    toggle_list
    round_index = 0
    last_move_dis



    /**
     * 实际拖动距离和广告移动距离的比例
     */
    adDragScale = 1

    /**
     * 广告图片宽度
     */
    adWdith = 172
    /**
     * 自动轮播间隔
     */
    loop_time = 2.4
    /**
     * 每帧移动多少像素，控制自动移动的速度
     */
    adMoveOffset = 17.2

    public constructor() {
        super()
        this.base_file = "mainStronger"
        this.layout_file = "MainUIStrongerView"
        this.layer_value = Enum_UILayer.Activity
        this.not_show_main_msg = true
        this.use_background = true
        // this.is_center = true
        this.background_alpha = 0
        this.click_bg_toClose = true
        this.preload_client_config = {
            "ConfigFeatureBinding": false
        }
        this.load_callback = () => {
            this.loadSuccess();
        }
        this.open_callback = () => {
            this.initView();
        }
        this.close_callback = () => {
            Laya.timer.clearAll(this)
        }
        this.destroy_callback = () => {
            if (this.loopMgr) {
                this.loopMgr.DeleteMe()
                this.loopMgr = undefined
            }
            if (this.delay_refresh_img_id) {
                clearTimeout(this.delay_refresh_img_id)
                this.delay_refresh_img_id = undefined
            }

            this.removeUpdateBeat()
            this.stopAd()
            this.is_moving = false
            this.ad_img_list = undefined
            this.ad_data_list = undefined
            this.toggle_list = false
            this.cur_page_index = 0

        }
    }

    Open(...args) {
        this.clickPos = args[0];
        super.Open()
    }

    loadSuccess() {
        this.initAd()
        this.initEvent();
    }

    initAd() {
        let list = MainStrongerModel.ins.getBannerList()
        list = list.slice(0, MainStrongerModel.BannerMaxNum)
        this.ad_data_list = list
        this.ad_data_len = list.length
        this.ad_img_list = [this._img_left, this._img_center, this._img_right]

        if(this.ad_data_len > 0){
            this._panel_ad.visible = true
            this.updateAdImg()
            this._panel_toggle.visible = true
            
            this.setToggleState()
            this.startPlayAd()

            let is_click = false

            let mouse_down = (e: Laya.Event) => {
                is_click = true
                this.onMouseDown(e.stageX)

            }
            this._panel_ad.on(Laya.Event.MOUSE_DOWN, this, mouse_down)

            let mouse_move = (e: Laya.Event) => {
                if (is_click) {
                    this.onMouseMove(e.stageX)
                }
            }
            this._panel_ad.on(Laya.Event.MOUSE_MOVE, this, mouse_move)

            let mouse_up = (e: Laya.Event) => {
                if (is_click) {
                    is_click = false
                    this.onMouseUp(e.stageX)
                }
            }
            this._panel_ad.on(Laya.Event.MOUSE_UP, this, mouse_up)
            this._panel_ad.on(Laya.Event.MOUSE_OUT, this, mouse_up);
            
        }
        else{
            this._panel_ad.visible = false
            this._panel_toggle.visible = false
        }
    }

    updateAdImg() {
        let index = this.cur_page_index

        let left_index = this.getIndex(index - 1)
        let left_data = this.ad_data_list[left_index]
        let img = this.ad_img_list[0]
        this.resMgr.SetOutsideImageSprite(this, img, GameResPath.GetIconOtherPath("mainStronger", left_data.banner))

        let center_data = this.ad_data_list[index]
        img = this.ad_img_list[1]
        this.resMgr.SetOutsideImageSprite(this, img, GameResPath.GetIconOtherPath("mainStronger", center_data.banner))

        let right_index = this.getIndex(index + 1)
        let right_data = this.ad_data_list[right_index]
        img = this.ad_img_list[2]
        this.resMgr.SetOutsideImageSprite(this, img, GameResPath.GetIconOtherPath("mainStronger", right_data.banner))
    }

    setToggleState() {
        if (!this.toggle_list) {
            this.toggle_list = []
        }
        let img
        let len = this.ad_data_list.length
        for (let i = 0; i < len; i++) {
            img = this.toggle_list[i]
            if (!img) {
                img = new Laya.Image()
                this._panel_toggle.addChild(img)
                this.toggle_list[i] = img
                img.x = i * 21
            }
            img.skin = GameResPath.GetIcon("mainStronger", i == this.cur_page_index ? "ui_bq_xz_01" : "ui_bq_xz_02")
        }
        let width = len * 12 + (len - 1) * 9
        this._panel_toggle.width = width
        this._panel_toggle.x = (this.adWdith - width) / 2 + 3
    }

    getImgIndex() {
        let index = this.cur_page_index
        index = index % this.ad_data_len
        return index
    }


    onMouseDown(x) {
        this.is_moving = false
        this.is_click = true
        this.touch_begin_x = x
        this.last_move_dis = 0
        this.round_index = 0
        this.stopAd()
    }

    onMouseMove(x) {
        this.is_click = false
        var move_dis = x - this.touch_begin_x
        move_dis = move_dis * this.adDragScale

        let offset_x = move_dis - this.last_move_dis

        let len = this.ad_img_list.length

        for (let i = 0; i < len; i++) {
            var img = this.ad_img_list[i]
            img.x += offset_x
        }

        //取正负
        let p = move_dis / this.adWdith

        let index = Math.round(p)
        if (index != this.round_index) {
            let left_img = this.ad_img_list[0]
            let right_img = this.ad_img_list[len - 1]
            if (index < this.round_index) {
                this.cur_page_index++
                left_img.x = right_img.x + this.adWdith
            }
            else {
                this.cur_page_index--
                right_img.x = left_img.x - this.adWdith
            }
            this.cur_page_index = this.getIndex(this.cur_page_index)
            this.adImgSort()
            this.updateAdImg()
            this.setToggleState()
            this.round_index = index
        }

        this.last_move_dis = move_dis
    }

    onMouseUp(x) {
        this.updateAdPos()
        if (this.is_click) {
            // console.log("------------------openAd", this.cur_page_index)
            this.startPlayAd()
            let ad_data = this.ad_data_list[this.cur_page_index]
            if (ad_data) {
                if(MainStrongerModel.ins.checkBannerState(ad_data, true)){
                    if(ad_data.skip_id){
                        OpenFun.OpenFunHandler(ad_data.skip_id)
                    }else if(ad_data.act_skip != '[]'){
                        let icon_type = ad_data.act_skip
                        let id

                        if (icon_type == "331@98@0" || icon_type == "331@98@1" || icon_type == "331@100@0") {
                            id = icon_type.replace("331@", "")
                            id = id.replace("@0", "")
                            id = id.replace("@1", "")
                            icon_type = "331@100"
                            let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
                            if (open_day > 5 && id == 100) {
                                id = "101"
                            }
                            if (open_day > 7) {
                                icon_type = "331@110"

                            }
                        }
                        GlobalEventSystem.Fire(EventName.OPEN_ACT_VIEW, icon_type, id);
                    }

                }
            }
            this.Close()
        } else {
            this.setItemMoveState()
        }
    }

    adImgSort() {
        this.ad_img_list.sort((a, b) => {
            return a.x - b.x
        })
    }

    setItemMoveState() {
        this.is_moving = true
        this.touch_begin_x = this.last_move_dis = this.now_move_x = 0
        let img = this.ad_img_list[1]
        this.max_move_x = -img.x
        this.move_offset_x = this.max_move_x > 0 && this.adMoveOffset || -this.adMoveOffset
        this.round_index = 0
        this.startUpdateBeat()
    }

    stopAd() {
        if (this.ad_time_id) {
            clearTimeout(this.ad_time_id)
            this.ad_time_id = undefined
        }
    }

    startPlayAd() {
        this.stopAd()
        let onTimer = () => {
            this.is_moving = true
            this.touch_begin_x = this.last_move_dis = 0
            this.max_move_x = -this.adWdith / this.adDragScale
            this.move_offset_x = -this.adMoveOffset
            this.now_move_x = this.round_index = 0
            this.startUpdateBeat()
        }
        this.ad_time_id = setTimeout(onTimer, this.loop_time * 1000);
    }

    startUpdateBeat() {
        Runner.GetInstance().AddRunObj(this, 1)
    }

    removeUpdateBeat() {
        Runner.GetInstance().RemoveRunObj(this.hashCode)
    }

    initView() {
        let pos = this.clickPos || { x: 0, y: 0 }
        let featureList = MainStrongerModel.ins.featureList;
        if (!this.loopMgr) {
            this.loopMgr = new LoopScrowViewMgr()
            this.loopMgr.SetData(this.listStrongBtn, MainUIStrongerBtn, featureList, LoopScrCon.Vertical)
        } else {
            this.loopMgr.replaceAll(featureList)
        }

        let { x, y } = pos
        this.display_obj.pos(x - this.display_obj.width, y - this.display_obj.height)
    }

    initEvent() {
        Util.AddClickEvent(this.btnClose, () => {
            this.Close()
        }, this, true)
    }


    Update = (now_time, elapse_time) => {
        if (this.is_moving) {
            this.now_move_x += this.move_offset_x
            this.onMouseMove(this.now_move_x)
            if (Math.abs(this.now_move_x - this.max_move_x) <= this.adMoveOffset) {
                this.is_moving = false
                this.onMouseMove(this.max_move_x)
                this.removeUpdateBeat()
                this.startPlayAd()
            }
        }
    }


    getIndex(index) {
        if (index >= this.ad_data_len) {
            index = 0
        }

        if (index < 0) {
            index = this.ad_data_len - 1
        }
        return index
    }


    updateAdPos(){
        let center_img = this.ad_img_list[1]
        if(Math.abs(center_img.x) > this.adWdith * 0.5){
            let left_img = this.ad_img_list[0]
            let right_img = this.ad_img_list[2]
            if (center_img.x < 0) {
                left_img.x = right_img.x + this.adWdith
            }
            else {
                right_img.x = left_img.x - this.adWdith
            }
            this.adImgSort()
        }
    }

    // test(){
    //     // 检查是否已经手冲过
    //     let hasFirstCharge = FirstRechargeModel.GetInstance().IsDoneFirstRecharge();
    //     this.imgFirstChargeAd.visible = !hasFirstCharge
    //     this.idxAdImg = Math.floor(Math.random() * 2) + 4;
    //     this.imgFirstChargeAd.skin = AtlasUrl("mainStronger", `ui_bq_0${this.idxAdImg}`);
    //     Laya.timer.clearAll(this)
    //     Laya.timer.loop(2500, this, () => {
    //         this.idxAdImg = (this.idxAdImg + 1) % 2 + 4
    //         this.imgFirstChargeAd.skin = AtlasUrl("mainStronger", `ui_bq_0${this.idxAdImg}`);
    //     })
    // }

    // idxAdImg: number;

    btnClose: Laya.Box
    listStrongBtn: Laya.List
    _panel_ad: Laya.Panel
    _img_left: Laya.Image
    _img_center: Laya.Image
    _img_right: Laya.Image
    _panel_toggle: Laya.Panel
    public GetComponents() {
        [
            this.btnClose,
            this.listStrongBtn,
            this._panel_ad,
            this._img_left,
            this._img_center,
            this._img_right,
            this._panel_toggle,
        ]
            = this.GetChildrenByNames([

                "btnClose",
                "listStrongBtn",
                "_panel_ad",
                "_img_left",
                "_img_center",
                "_img_right",
                "_panel_toggle",
            ])
    }
}
window["MainUIStrongerView"] = MainUIStrongerView