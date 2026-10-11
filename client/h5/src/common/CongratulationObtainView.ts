import { BaseView1 } from "./BaseView1";
import { GoodsModel } from "../commonModel/GoodsModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { PlayBigEffect, Util } from "../util/Util";
import { CongratulationObtainItem, CongratulationObtainItemVo } from "./CongratulationObtainItem";
import { CongratulationRareView } from "./CongratulationRareView";
import { EquipmentItem } from "./EquipmentItem";
import { EventName } from "./EventName";
import { Enum_UILayer } from "./LayerManager";
import { ResManager } from "./ResManager";
import { TaskFinishView } from "../task/TaskFinishView";
import { TempleAwakenEvent } from "../commonModel/TempleAwakenModel";
import { LoopScrCon, LoopScrowViewMgr } from "./LoopScrowViewMgr";
import { BaseAwardItem } from "./BaseAwardItem";
import "../common/CongratulationObtainItem2"
import { CongratulationObtainItem2 } from "../common/CongratulationObtainItem2";
import { SoundManager } from "./SoundManager";
import { Message, SysInfoController, SysInfoType } from "../sysInfo/SysInfoController";
import { SysInfoMiniMgr } from "../sysInfo/SysInfoMiniMgr";
import { Mathf } from "../util/Mathf";
import { RoleManager } from "../commonModel/RoleManager";
import { GameResPath } from "../util/GameResPath";
import { OnHookModel } from "../commonModel/OnHookModel";
import { RuneModel } from "../commonModel/RuneModel";
import { PlatformManager } from "../PlatformManager";
import { TranslationManager } from "../commonController/TranslationManager";

export enum enum_CongratulaionType {
    goods_id,
    additional,
    rare_reward
}
window["enum_CongratulaionType"] = enum_CongratulaionType;
export class CongratulationObtainView extends BaseView1 {


    //goods_data物品列表 ,Countdown?倒计时时间 effect_str特效名字 award_type奖励类型:礼包type_ID, 
    //use_goods_id 由于会出现同一个道具类型有不同的goods_id ,为了保证优先使用同一个道具，所以传入之前使用的goods_id
    //sohw_goods_effect 显示奖励的时候 是否
    //specail_type  针对某些需要特殊处理的item  可以在goods_data里面的元素第四位传入特殊处理的内容 以下为特殊处理类型
    //specail_type "goods_id" 传入goods_id可以让装备显示实际属性。（默认） additional 传入元素第四位为true时 显示额外图标 rare_reward 显示奖励中珍稀奖励的特效
    //point 显示倍数
    Load_Callback
    Open_Callback
    Calculate_ItemNUM
    Init
    LoadSuccess
    updateItem
    CreateOneItem
    SetSpecType
    ItemAnimation
    addListItem
    CreateItem
    CreateOver
    OpenAnimation
    StarTimer
    on_time
    CancelTime
    Close_callback
    DeleteItem
    SetData
    SpecialItemSet
    Reset
    SetExpGp
    percentWidth
    percentHeight
    create_Item_time
    goods_items_list
    down_time//下拉动画需要的时间
    item_num_size_time_dic //
    is_double
    exp_data

    Local_Open

    // 对应ConfigBanner.json的引导图配置，通过this.SetBannerType(type:string)设置
    banner_view_type: string;
    public constructor(goods_data, count_down?, effect_str?, award_type?, use_goods_id?, sohw_goods_effect?, specail_type?, point?, not_allow_anim?, isdoule?, exp_data?) {
        super()
        this.append_to_ctl_queue = true
        let res_mgr = ResManager.GetInstance(),
            local_GlobalEventSystem = GlobalEventSystem,
            local_EventName = EventName,
            local_Util = Util,
            local_laya = Laya,
            goods_model = GoodsModel.GetInstance(),
            use_bag_goods_event = GoodsModel.USE_BAG_GOODS,
            local_enum_CongratulaionType = enum_CongratulaionType,
            _goods_data,
            _count_down,
            _timer_id,
            _effect_str,
            _award_type,
            _use_goods_id,

            _timeout_id_list = [],
            _item_data,
            _goods_item_num,
            _item_info_dic = {},
            _count = 0,
            _is_jump_animation = false,
            _gift_reward,
            _sohw_goods_effect,
            _is_play_bg_anime = true,
            _is_on_use_btn = false,
            // _is_create_over = false,
            _specail_type,
            _open_num,
            _cur_create_item_info,
            _point,
            _not_allow_anim,
            _show_anim_end = false,
            _first_load = true,
            _is_stop = false,
            _add_data,
            _cur_index = 0
        this.not_show_main_msg = true
        this.create_Item_time = 180
        this.base_file = "common"
        this.layout_file = "CongratulationObtainView"
        this.item_num_size_time_dic = { "10": 800, "25": 2600, "50": 4200, "75": 5500, "150": 8000, "250": 12000, "500": 15000, }

        this.layer_value = Enum_UILayer.Activity
        _goods_data = goods_data
        _count_down = count_down
        _effect_str = effect_str
        _award_type = award_type
        _use_goods_id = use_goods_id
        _specail_type = specail_type
        _sohw_goods_effect = sohw_goods_effect
        _point = point
        _not_allow_anim = not_allow_anim
        this.background_alpha = 1
        //this.show_open_movie = true
        this.is_center = true
        this.use_background = true
        this.destroy_imm = true
        this.click_bg_toClose = true
        this.percentWidth = 100
        this.percentHeight = 100
        this.not_show_item_use = true
        this.is_double = isdoule
        this.exp_data = exp_data
        this.load_callback = function () {
            this.LoadCallback()
        }
        this.open_callback = function () {

            this.OpenCallback()

        }
        this.close_callback = function () {
            this.Close_callback()
        }
        this.Load_Callback = () => {

            this.Init()
            this.LoadSuccess()
            this.PlaySound()
        }

        this.Open_Callback = () => {

            // // SoundManager.GetInstance().PlaySoundEffect("3_huode")
            SysInfoMiniMgr.GetInstance().ResetItem()
            this.bottom_label.visible = false
            if (_effect_str) {
                this.AddUIEffect(_effect_str, this.effect_group)
            }
            if (!_goods_data || _goods_data.length == 0) {
                this.click_bg_toClose = true
            }
            this.OpenAnimation()
        }


        //当显示装备的时候goods_data[i][3]有一个装备的goodsid
        this.Init = () => {
            this.title.visible = false
            // res_mgr.SetTexture(this, this.title, "resource/game/common2/texture/uijs_061.png")
            // res_mgr.SetTexture(this, this._img_item_bg_left, "resource/game/common4/texture/uijs_064.png")
            // res_mgr.SetTexture(this, this._img_item_bg_right, "resource/game/common4/texture/uijs_064.png")
            //ResManager.GetInstance().SetTexture(this, this.light, "resource/game/common4/texture/uich_008.png")
            if (this.is_double) {
                this.right_bg.visible = true
                this.right_bg.skin = "resource/game/dungeonCommon/texture/uipj_046.png"
            }
            res_mgr.SetTexture(this, this.left_bg, "resource/game/common4/texture/uijs_062.png", () => {
                // this.CalculateItemNUM()
            }, this)
            // res_mgr.SetTexture(this, this.right_bg, "resource/game/common4/texture/uijs_062.png")
            // this.AddUIEffect("ui_aperture1", this._gp_blackline_effect, undefined, undefined, true)


            this.BindEvent(local_GlobalEventSystem, local_EventName.INTERRUPT_CONGRA, () => {
                for (let i = _count + 1; i < _goods_item_num; i++) {
                    _count++
                    this.CreateOneItem(i, false)
                }
                this.CreateOver()
            })

            local_Util.AddClickEvent(this.click_bg, () => {
                if (_not_allow_anim) {
                    if (_show_anim_end)
                        this.Close()
                } else {
                    // if(_is_jump_animation){
                    //     _is_jump_animation = false
                    // }
                    // else{
                    //     _is_jump_animation = true
                    // }
                    // _is_jump_animation = _is_jump_animation ? false : true
                    if (_is_jump_animation) {// && _is_create_over) {
                        this.Close()
                    } else {
                        GlobalEventSystem.Fire(EventName.GET_GOODS_VIEW_STOP_ANIMATION)
                        this.CreateOver()
                        Laya.timer.clearAll(this)
                        Laya.Tween.clearAll(this.goods_list.scrollBar)
                    }
                }

            }, this, false)

            local_Util.AddClickEvent(this.left_bg, () => {
                if (_not_allow_anim) {
                    if (_show_anim_end)
                        this.Close()
                } else {
                    // if(_is_jump_animation){
                    //     _is_jump_animation = false
                    // }
                    // else{
                    //     _is_jump_animation = true
                    // }
                    // _is_jump_animation = _is_jump_animation ? false : true
                    if (_is_jump_animation) {// && _is_create_over) {
                        this.Close()
                    } else {
                        GlobalEventSystem.Fire(EventName.GET_GOODS_VIEW_STOP_ANIMATION)
                        this.CreateOver()
                        Laya.timer.clearAll(this)
                        Laya.Tween.clearAll(this.goods_list.scrollBar)
                    }
                }
            }, this, false)

            local_Util.AddClickEvent(this._gp_hit, () => {
                if (_not_allow_anim) {
                    if (_show_anim_end)
                        this.Close()
                } else {
                    // if(_is_jump_animation){
                    //     _is_jump_animation = false
                    // }
                    // else{
                    //     _is_jump_animation = true
                    // }
                    // _is_jump_animation = _is_jump_animation ? false : true
                    if (_is_jump_animation) {// && _is_create_over) {
                        this.Close()
                    } else {
                        GlobalEventSystem.Fire(EventName.GET_GOODS_VIEW_STOP_ANIMATION)
                        this.CreateOver()
                        Laya.timer.clearAll(this)
                        Laya.Tween.clearAll(this.goods_list.scrollBar)
                    }
                }
            }, this, false)

            let use_btn_click = (open_num) => {
                if (!_is_jump_animation && _is_on_use_btn) {
                    _is_jump_animation = true
                    if (_count != _goods_item_num) {
                        _is_on_use_btn = false
                        let onTimeOut = () => {
                            _is_on_use_btn = true
                        }
                        let id = local_laya.timer.once(200, this, onTimeOut)//local_laya.setTimeout(onTimeOut, this, 200)
                        _timeout_id_list.push(id)
                    }
                    return
                }
                if (!_is_on_use_btn) {
                    return
                }
                if (_use_goods_id) {
                    goods_model.Fire(use_bag_goods_event, _use_goods_id, open_num);
                } else {
                    goods_model.Fire(use_bag_goods_event, goods_model.GetOneGoodsByTypeId(_award_type), open_num);
                }
                if (_timeout_id_list.length > 0) {
                    for (let id of _timeout_id_list) {
                        if (id)
                            id.clearAll(this)
                    }
                    _timeout_id_list = []
                    _timeout_id_list.length = 0
                }

                this.Reset()
            }

            local_Util.AddClickEvent(this.bt_use_ten, () => {
                _open_num = _open_num > 10 ? 10 : _open_num
                use_btn_click(_open_num)
            }, this, true)

            local_Util.AddClickEvent(this.bt_use, () => {
                use_btn_click(1)
            }, this, true)

            this.BindEvent(local_GlobalEventSystem, local_EventName.CONGRA_RARE_VIEW, () => {
                _is_stop = false
                _cur_index++
                // this.CreateItem()
                this.addListItem()
            })
            this.BindEvent(local_GlobalEventSystem, local_EventName.ADD_LIST_ITEM, () => {
                if (!_is_stop) {
                    _cur_index++
                    this.addListItem()
                }
            })
            this.BindEvent(local_GlobalEventSystem, local_EventName.CLOSE_CONGRATULATION_VIWE, () => {
                GlobalEventSystem.Fire(EventName.GET_GOODS_VIEW_STOP_ANIMATION)
                this.CreateOver()
                Laya.timer.clearAll(this)
                Laya.Tween.clearAll(this.goods_list.scrollBar)
                this.Close()
            })

        }

        this.LoadSuccess = () => {
            // this.goods_scroller.hScrollBar.visible = false;
            this.goods_list.itemRender = CongratulationObtainItem
            this.goods_list.vScrollBarSkin = ""
            this.goods_list.renderHandler = Laya.Handler.create(this, this.updateItem);
            this.goods_scroller.vScrollBar.visible = false;
            this.goods_scroller.vScrollBar.touchScrollEnable = false
            Laya.timer.frameOnce(1, this, () => {
                if (this.use_delete_method) return
                this.bottom_label.y = 50
            })
            // this.goods_scroller.hScrollBar.touchScrollEnable = false
            if (_award_type) {
                let onTimeOut = () => {
                    _is_on_use_btn = true
                }
                let id = local_laya.timer.once(400, this, onTimeOut)//local_laya.setTimeout(onTimeOut, this, 400)
                _timeout_id_list.push(id)
                let award_num
                if (_use_goods_id) {
                    let goodsVo = goods_model.GetGoodsVoByGoodsId(_use_goods_id)
                    if (goodsVo) {
                        award_num = goodsVo.goods_num
                    }
                } else {
                    award_num = goods_model.GetTypeGoodsNum(_award_type)
                }
                if (award_num > 0) {
                    this._gp_hit.mouseEnabled = true
                    this.gp_gift.visible = true // this.gp_gift.includeInLayout = true
                    if (!_gift_reward) {
                        _gift_reward = new EquipmentItem(this.gp_gift_award)
                        _gift_reward.Load()
                        this.gp_gift_award.scaleX = this.gp_gift_award.scaleY = 0.75
                        this.gp_gift_award.visible = true//this.gp_gift_award.includeInLayout = true
                    }
                    _gift_reward.SetData(_award_type, award_num, false)
                    _open_num = award_num
                    this.bt_use_ten.visible = _open_num > 1 ? true : false
                    this.labelDisplay2.text = _open_num > 10 ? `一键10开` : `一键全开`
                    this.gp_gift.width = this.bt_use_ten.visible ? 407 : 251
                    //_gift_reward.scaleX= _gift_reward.scaleY = 0.75
                } else {
                    if (_gift_reward) {
                        _gift_reward.DeleteMe()
                        _gift_reward = null
                    }
                    this._gp_hit.mouseEnabled = false
                    this.gp_gift.visible = false//this.gp_gift.includeInLayout = false
                    this.gp_gift_award.visible = false// this.gp_gift_award.includeInLayout = false
                }
            }

            if (_point && _point > 0) {
                this._img_point.visible = true;
                res_mgr.SetImageSprite(this, this._img_point, "turntable", `point_${_point}`)
            }
            this.CalculateItemNUM()
            if (this.exp_data)
                this.SetExpGp()
        }
        this.SetExpGp = () => {
            let data = this.exp_data
            this.gp_lv.visible = this.exp_data ? true : false
            if (data && data.old_lv && Number(data.old_lv_ratio) >= 0) {
                ResManager.GetInstance().SetOutsideImageSprite(this, this.gp_lv, GameResPath.GetIconOtherPath("common", "white"))
                this.exp_old.style.fontSize = 20
                this.exp_old.style.color = "#663915"
                this.exp_old.style.wordWrap = false
                this.exp_new.style.fontSize = 20
                this.exp_new.style.color = "#663915"
                this.exp_new.style.wordWrap = false
                let lv = data.old_lv
                let exp = data.old_lv_ratio
                let str_lv = lv > 370 ? "神创" + Number(lv - 370) + "级" : lv + "级"
                let exp_str = Mathf.Floor(exp / 10) + "%"
                this.exp_old.innerHTML = str_lv + "&nbsp;&nbsp;<font color='#0a953e'>" + exp_str + "</font>"
                lv = RoleManager.GetInstance().GetMainRoleLevel()
                str_lv = lv > 370 ? "神创" + Number(lv - 370) + "级" : lv + "级"
                let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
                exp = main_role_vo.exp
                let exp_lim = main_role_vo.exp_lim
                let persent = Mathf.Floor(100 * exp / exp_lim)
                this.exp_new.innerHTML = str_lv + "&nbsp;&nbsp;<font color='#0a953e'>" + persent + "%</font>"
                TranslationManager.GetInstance().HelptoHriLayout(
                    [this.exp_old,this.img_arrow,this.exp_new],
                    this.gp_lv,
                    5
                )
            }
        }

        this.Calculate_ItemNUM = () => {

            //_goods_data
            //_goods_data[0]  type_id 
            //_goods_data[1]  lock
            //_goods_data[2]  num
            //_goods_data[3]  goods_id
            //_goods_data[4]  is_zhouka  周卡
            //_goods_data[5]  is_yueka   月卡
            //_goods_data[6]  double     额外奖励
            //_goods_data[7]  is_tv     是否有传闻
            let good_item_num = 0
            let data: Array<CongratulationObtainItemVo> = []
            this._gp_effect.x = this.goods_scroller.x
            this._gp_effect.y = this.goods_scroller.y
            let count = 0
            for (let i = 0; i < _goods_data.length; i++) {
                let [type_id, lock] = goods_model.GetMappingTypeId(_goods_data[i][0], _goods_data[i][1])
                let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
                let max_overlap = goods_vo && goods_vo.max_overlap ? goods_vo.max_overlap : 999
                let goods_num = goods_vo && goods_vo.max_overlap == 0 ? 1 : _goods_data[i][2]
                let create_num = goods_vo && goods_vo.max_overlap == 0 ? _goods_data[i][2] : 1
                good_item_num += Number(create_num)

                for (let j = 0; j < create_num; j++) {
                    count++ //先自增
                    let vo: CongratulationObtainItemVo = new CongratulationObtainItemVo()
                    vo.type_id = type_id
                    vo.goods_num = goods_num
                    vo.lock = lock
                    vo.goods_id = _goods_data[i] ? (_goods_data[i][3] ? _goods_data[i][3] : null) : null //如果[3]物品稀有度判断 为1则弹珍稀弹窗
                    vo.is_first_show = true
                    vo.count = count
                    vo.is_zhouka = _goods_data[i] ? (_goods_data[i][4] ? _goods_data[i][4] : false) : false
                    vo.is_yueka = _goods_data[i] ? (_goods_data[i][5] ? _goods_data[i][5] : false) : false
                    vo.double = _goods_data[i] ? (_goods_data[i][6] ? _goods_data[i][6] : 0) : 0
                    vo.is_tv = _goods_data[i] ? (_goods_data[i][7] ? _goods_data[i][7] : 0) : 0
                    data.push(vo)
                }

            }

            //数量少时，手动设置时间
            switch (data.length) {
                case 1:
                    this.goods_list.width = 145
                    this.down_time = 150
                    break;
                case 2:
                    this.goods_list.width = 290
                    this.down_time = 300
                    break;
                case 3:
                    this.goods_list.width = 435
                    this.down_time = 450
                    break;
                case 4:
                    this.goods_list.width = 584
                    this.down_time = 600
                    break;
                default:
                    for (let key in this.item_num_size_time_dic) {
                        if (data.length <= Number(key)) {
                            this.down_time = this.item_num_size_time_dic[key]
                            break
                        }
                    }
                    break;
            }

            let temp_time = this.down_time / data.length
            for (let key in data) {
                data[key].anim_time = temp_time
            }

            _goods_item_num = good_item_num
            _item_data = data

            let x = 0
            let y = 0
            let interval_x = 0
            let interval_y = 0
            let item_size = 115
            let item_limit = 5
            let add_exp_height = this.exp_data ? 60 : 0
            if (_goods_item_num > item_limit && _goods_item_num <= 10) {
                x = 42
                y = 20
                interval_x = 30
                interval_y = 30
                if (PlatformManager.IsEyouPlatform()) {
                    this.goods_list.height = 300
                    this.goods_list.y = 225
                } else {
                this.goods_list.height = 260
                this.goods_list.y = 235
                }
                // this.right_bg.height = 350
                this.left_bg.height = 475 + add_exp_height
                this._gp_blackline_effect.y = -60
            }
            else if (good_item_num > item_limit) {
                x = 42
                y = 20
                interval_x = 30
                interval_y = 30
                this.goods_list.height = 260
                this.goods_list.y = 235
                // this.right_bg.height = 350
                this.left_bg.height = 470 + add_exp_height
                this._gp_blackline_effect.y = -50
            } else {
                interval_y = 15
                interval_x = 30
                this.goods_list.height = 120 + y * 2
                x = this.goods_list.width / 2 - item_size * good_item_num / 2 - interval_x * (good_item_num - 1) / 2
                // this.right_bg.height = (this.goods_scroller.y - this.right_bg.y) + 45 + this.goods_scroller.height// - interval_y
                this.left_bg.height = (this.goods_list.y - this.left_bg.y) + 76 + this.goods_list.height + add_exp_height// - interval_y
                //this._gp_blackline_effect.y = 264
            }
            this._gp_hit.y = this.left_bg.y + this.left_bg.height
            // if (data) {
            //     if (!this.goods_items_list) {
            //         this.goods_items_list = new LoopScrowViewMgr()
            //         this.goods_items_list.SetData(this.goods_list, CongratulationObtainItem, data, LoopScrCon.Vertical, null)
            //     } else {
            //         this.goods_items_list.replaceAll(data)
            //     }
            // }

            if (data) {
                _cur_index = 0
                _add_data = data.concat()
                this.addListItem()
            }
            // //滑动
            // if (data.length > 10) {
            //     temp_time = temp_time * 10
            //     Laya.timer.once(temp_time, this, () => {
            //         if (this.use_delete_method) return
            //         this.goods_list.tweenTo(data.length - 1, this.down_time)
            //     })
            // }
        }



        this.addListItem = () => {
            if (_cur_index > _add_data.length - 1) {
                this.CreateOver()
                return
            }
            if (_add_data[_cur_index].is_tv == 1) { //有传闻或者稀有(稀有必有传闻)
                _is_stop = true
            }
            this.goods_list.addItem(_add_data[_cur_index])
            if (_cur_index >= 10 && _cur_index % 5 == 0) { //滚动
                if (_is_stop) {
                    this.goods_list.tweenTo(_cur_index + 1, 200)
                } else {
                    _is_stop = true
                    this.goods_list.tweenTo(_cur_index + 1, 200, Laya.Handler.create(this, () => {
                        _cur_index++
                        _is_stop = false
                        this.addListItem()
                    }))
                }
            }


        }
        this.updateItem = (cell: CongratulationObtainItem, index) => {
            cell.updateItem(cell.dataSource, index)
        }
        this.CreateOver = () => {
            // _is_create_over = true
            // if (!this.use_delete_method) {
            if (_cur_index < _add_data.length) {
                _cur_index = _add_data.length + 1
                this.goods_list.array = _add_data
                this.goods_list.refresh()
                // this.goods_list.tweenTo(_add_data.length - 4,200)
            }
            if (this.bottom_label && !_award_type || _use_goods_id || (_award_type && goods_model.GetTypeGoodsNum(_award_type) == 0)) {
                this.bottom_label.visible = true
                if (_count_down >= 0) {
                    this.bottom_label.text = `点击任意位置关闭(${_count_down})`
                    this.StarTimer(_count_down)
                } else {
                    this.bottom_label.text = `点击任意位置关闭`
                }
            }
            _is_jump_animation = true
            this.goods_scroller.vScrollBar.touchScrollEnable = true
            if (_timeout_id_list) {
                for (let id of _timeout_id_list) {
                    if (id)
                        id.clearAll(this)
                }
                _timeout_id_list = []
                _timeout_id_list.length = 0
            }

            let onTimeOut = () => {
                //_is_jump_animation = true
                if (_not_allow_anim)
                    _show_anim_end = true
            }
            local_laya.timer.once(400, this, onTimeOut)

        }

        this.OpenAnimation = () => {

            if (_is_jump_animation) return
            if (_is_play_bg_anime) {
                this.display_obj.scaleY = 0.5
                this.display_obj.alpha = 0
                local_laya.Tween.to(this.display_obj, { scaleX: 1, scaleY: 1, alpha: 1 }, 100)
            }
            this.AddUIEffect("ui_ZiTi_Huode", this._gp_blackline_effect, null, 128 / 40, true)
            let wait_time = 100
            local_laya.timer.once(wait_time, this, this.CreateOneItem)
        }

        this.StarTimer = (countdoentime) => {

            this.CancelTime()
            Laya.timer.loop(1000, this, this.on_time)
        }

        this.on_time = () => {

            _count_down--
            if (this.bottom_label)
                this.bottom_label.visible = true
            this.bottom_label.text = `点击任意位置关闭(${_count_down})`
            if (!this.bottom_label || _count_down <= 0) {
                this.Close()
            }
        }
        this.CancelTime = () => {

            if (_timer_id) {
                _timer_id.clear(this, this.on_time)
                _timer_id = null
            }
            if (_timeout_id_list) {
                for (let id of _timeout_id_list) {
                    if (id)
                        id.clearAll(this)
                }
                _timeout_id_list = []
                _timeout_id_list.length = 0
            }
        }

        this.Close_callback = () => {
            local_laya.timer.clearAll(this)
            this.CancelTime()
            this.DeleteItem()
            if (_gift_reward) {
                _gift_reward.DeleteMe()
                _gift_reward = null
            }
            if (this.goods_items_list) {
                this.goods_items_list.DeleteMe()
                this.goods_items_list = null
            }
            if (_add_data.length > 0) {
                _add_data = []
            }
            local_GlobalEventSystem.Fire(local_EventName.CONGRATULATION_VIEW_CLOSE, this.hashCode);
            if (this.exp_data) {
                let exp = OnHookModel.GetInstance().auto_smelt_exp
                if (exp) {
                    PlayBigEffect("ui_tunshichenggong")
                    Message.show(`获得<font color='#a376ff'>吞噬经验x${exp}</font>`)
                    OnHookModel.GetInstance().auto_smelt_exp = 0
                }

            }

            if (RuneModel.GetInstance().is_request_composite) {
                RuneModel.GetInstance().is_request_composite = false

                if(_goods_data&&_goods_data[0]&&_goods_data[0][3]){
                    let goods_vo = GoodsModel.GetInstance().GetGoodsVoByGoodsId(_goods_data[0][3])
                    local_GlobalEventSystem.Fire(local_EventName.OPEN_ITEM_USE_VIEW, goods_vo)
                }
            }
        }

        this.DeleteItem = () => {

            if (_timeout_id_list) {
                for (let id of _timeout_id_list) {
                    if (id)
                        id.clearAll(this)
                }
                _timeout_id_list = []
                _timeout_id_list.length = 0
            }

        }

        this.SetData = (goods_data, count_down?, effect_str?, award_type?, use_goods_id?, sohw_goods_effect?) => {

            _goods_data = goods_data
            _count_down = count_down
            _effect_str = effect_str
            _award_type = award_type
            _use_goods_id = use_goods_id
            _sohw_goods_effect = sohw_goods_effect
            this.Reset()
        }

        this.SpecialItemSet = (item, item_data, size) => {

            if (!_specail_type || _specail_type == local_enum_CongratulaionType.goods_id || _specail_type == local_enum_CongratulaionType.rare_reward) {
                item.SetData(item_data[0], item_data[1], item_data[2], item_data[3], size)
            } else if (_specail_type == local_enum_CongratulaionType.additional) {
                item.SetData(item_data[0], item_data[1], item_data[2], null, size)
                item.AddAdditionalImg()
            }
        }

        this.Reset = () => {

            _item_data = null
            _goods_item_num = null
            _item_info_dic = {}
            _count = 0
            _is_jump_animation = false
            if (this.goods_scroller && this.goods_scroller.viewport)
                // this.goods_scroller.viewport.scrollV = 0
                _is_play_bg_anime = false
            //_is_create_over = false
            _is_on_use_btn = false
            let onTimeOut = () => {
                _is_on_use_btn = true
            }
            let id = local_laya.timer.once(150, this, onTimeOut)//local_laya.setTimeout(onTimeOut, this, 150)
            _timeout_id_list.push(id)
            if (this.click_bg) {
                // this.click_bg.mouseEnabled = false
            }
            this.DeleteItem()
        }



        this.CreateItem = () => {

            if (!_cur_create_item_info) return
            let index = _cur_create_item_info.index
            let scale = _cur_create_item_info.scale
            let time_add = _cur_create_item_info.time_add
            if (_is_jump_animation) {
                local_GlobalEventSystem.Fire(local_EventName.INTERRUPT_CONGRA)
                return
            }


            _count = index + 1
            this.CreateOneItem(_count)


        }

        this.CreateOneItem = (count, is_anim = true) => {
            if (!count) {
                _count = count = 0
            }

            if (_count >= _goods_item_num) {
                // this.CreateOver()
                return
            }


            if (count >= _goods_item_num) { return }
            let interval_x = _item_info_dic["interval_x"]
            let interval_y = _item_info_dic["interval_y"]
            let item_limit = _item_info_dic["item_limit"]
            let item_size = _item_info_dic["item_size"]
            let scale = 1.8
            let time_add = 200
            if (_not_allow_anim) {
                this.ItemAnimation(null, count, item_limit, item_size, this.goods_scroller.height, interval_y, time_add, scale)
            } else {
                if (is_anim)
                    this.ItemAnimation(null, count, item_limit, item_size, this.goods_scroller.height, interval_y, time_add, scale)
            }
        }

        this.SetSpecType = () => {
            _specail_type = local_enum_CongratulaionType.rare_reward
        }

        this.ItemAnimation = (item, index, item_limit, item_size, scrollHeigth, interval_y, time_add, scale) => {

            if (_is_jump_animation) {
                local_GlobalEventSystem.Fire(local_EventName.INTERRUPT_CONGRA)
                return
            }
            if (index >= item_limit && index % item_limit == 0 && this.goods_scroller && this._gp_effect) {
                local_laya.Tween.to(this.goods_scroller.vScrollBar, { value: (index / item_limit + 1) * (item_size + interval_y) - scrollHeigth + 25 }, 180)//+ interval_y  
                local_laya.Tween.to(this._gp_effect, { y: this.goods_scroller.y - ((index / item_limit + 1) * (item_size + interval_y) - scrollHeigth + 25) }, 180)
            }
            _cur_create_item_info = {}
            //_cur_create_item_info.item = item
            _cur_create_item_info.index = index
            _cur_create_item_info.scale = scale
            _cur_create_item_info.time_add = time_add
            let data = _item_data[index]
            if (data[3] && _specail_type == local_enum_CongratulaionType.rare_reward) {
                if (_is_jump_animation) {
                    local_GlobalEventSystem.Fire(local_EventName.INTERRUPT_CONGRA)
                    return
                }
                let view = new CongratulationRareView()
                view.SetData(data, 1)
                view.Open()
            } else {
                let timeOut = () => {
                    if (_is_jump_animation) {
                        local_GlobalEventSystem.Fire(local_EventName.INTERRUPT_CONGRA)
                        return
                    }
                    // if (!_is_create_over)
                    this.CreateItem()
                }
                if (index >= 30) {
                    this.create_Item_time = 50
                }
                else if (index > 15 && index < 30) {
                    this.create_Item_time = 100
                } else {
                    this.create_Item_time = 180
                }
                local_laya.timer.once(this.create_Item_time, this, timeOut)

            }

        }

        this.Local_Open=(param?)=>{
            if(param&&param.length>0){
                _goods_data = param[0]
                _count_down = param[1]
            }

        }

    }

    count_num = 0



    public LoadCallback() {
        this.Load_Callback()
    }
    public OpenCallback() {
        // Laya.timer.once(100,this,this.Open_Callback)
        this.Open_Callback()
    }
    public CalculateItemNUM() {
        this.Calculate_ItemNUM()
    }
    public PlaySound() {
        SoundManager.GetInstance().PlaySoundEffect("fighting_up", true, null, "role")
    }


    public Open(...new_args) {
        let parms = new_args
        this.Local_Open(parms)
        super.Open()
    }




    _gp_view: Laya.Box
    _gp_borderglow_effect: Laya.Box
    click_bg: Laya.Image
    mainGp: Laya.Box
    _gp_got_img: Laya.Box
    light: Laya.Image
    _img_item_bg_left: Laya.Image
    _img_item_bg_right: Laya.Image
    left_bg: Laya.Image
    gp_lv: Laya.Image
    img_arrow: Laya.Image
    exp_old: Laya.HTMLDivElement
    exp_new: Laya.HTMLDivElement
    title: Laya.Image
    effect_group: Laya.Box
    _gp_blackline_effect: Laya.Box
    goods_scroller: Laya.Panel
    goods_group: Laya.Box
    goods_list: Laya.List
    _gp_effect: Laya.Box
    right_bg: Laya.Image
    _gp_hit: Laya.VBox
    gp_gift: Laya.Box
    gp_gift_award: Laya.Box
    bt_use: Laya.Box
    _Image1: Laya.Image
    labelDisplay1: Laya.Label
    bt_use_ten: Laya.Box
    _Image2: Laya.Image
    labelDisplay2: Laya.Label
    bottom_label: Laya.Label
    _img_point: Laya.Image
    public GetComponents() {
        [
            this._gp_view,
            this._gp_borderglow_effect,
            this.click_bg,
            this.mainGp,
            this._gp_got_img,
            this.light,
            this._img_item_bg_left,
            this._img_item_bg_right,
            this.left_bg,
            this.gp_lv,
            this.img_arrow,
            this.exp_old,
            this.exp_new,
            this.title,
            this.effect_group,
            this._gp_blackline_effect,
            this.goods_scroller,
            this.goods_group,
            this.goods_list,
            this._gp_effect,
            this.right_bg,
            this._gp_hit,
            this.gp_gift,
            this.gp_gift_award,
            this.bt_use,
            this._Image1,
            this.labelDisplay1,
            this.bt_use_ten,
            this._Image2,
            this.labelDisplay2,
            this.bottom_label,
            this._img_point,
        ]
            = this.GetChildrenByNames([

                "_gp_view",
                "_gp_borderglow_effect",
                "click_bg",
                "mainGp",
                "_gp_got_img",
                "light",
                "_img_item_bg_left",
                "_img_item_bg_right",
                "left_bg",
                "gp_lv",
                "img_arrow",
                "exp_old",
                "exp_new",
                "title",
                "effect_group",
                "_gp_blackline_effect",
                "goods_scroller",
                "goods_group",
                "goods_list",
                "_gp_effect",
                "right_bg",
                "_gp_hit",
                "gp_gift",
                "gp_gift_award",
                "bt_use",
                "_Image1",
                "labelDisplay1",
                "bt_use_ten",
                "_Image2",
                "labelDisplay2",
                "bottom_label",
                "_img_point",
            ])
        this.goods_list.scrollBar.visible = false
    }
}
window["CongratulationObtainView"] = CongratulationObtainView