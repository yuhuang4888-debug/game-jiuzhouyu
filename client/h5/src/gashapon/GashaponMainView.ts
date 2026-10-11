import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIEffect } from "../common/UIEffect"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetAnchoredPositionX, GlobalTimerQuest, HtmlColorTxt, GetSizeDeltaX, SetSizeDeltaX } from "../util/Util"
import { GashaponMainItem } from "./GashaponMainItem"

export class GashaponMainView extends BaseItem1 {
    imgBg: Laya.Image
    _record_bg: Laya.Image
    _btn_reward: Laya.Image
    _btn_ten: Laya.Box
    _btn_one: Laya.Box
    _con_record1: Laya.Box
    _select1: Laya.Image
    _lbl_label: Laya.Label
    _con_record2: Laya.Box
    _select2: Laya.Image
    _lbl_label1: Laya.Label
    _gp_record: Laya.Box
    countLb: Laya.Label
    img_chassis: Laya.Image
    img_show_content: Laya.Image
    _con_item_list: Laya.Box
    item_pos0: Laya.Box
    Image: Laya.Image
    Image2: Laya.Image
    item_pos1: Laya.Box
    item_pos2: Laya.Box
    item_pos3: Laya.Box
    item_pos4: Laya.Box
    item_pos5: Laya.Box
    item_pos6: Laya.Box
    item_pos7: Laya.Box
    item_pos8: Laya.Box
    item_pos9: Laya.Box
    item_pos10: Laya.Box
    img_progressbg: Laya.Image
    img_progress: Laya.Image
    _lbl_luck: Laya.Label
    _img_passbg: Laya.Image
    _img_pass: Laya.Image
    _lbl_label11: Laya.Label
    time_bg: Laya.Image
    _btn_gashapon_auto: Laya.Box
    _bg_01: Laya.Image
    _name_0: Laya.Label
    _btn_gashapon_once: Laya.Box
    _btn_0: Laya.Box
    _bg_0: Laya.Image
    _name_01: Laya.Label
    _red_0: Laya.Image
    _free_0: Laya.Label
    _gp_cost_0: Laya.Box
    _img_cost_0: Laya.Image
    _lb_have_0: Laya.Label
    _lb_cost_0: Laya.Label
    _img_have: Laya.Image
    _lb_have: Laya.Label
    _con_effect: Laya.Box
    _Image: Laya.Image
    _effect_mask: Laya.Box
    _con_effect2: Laya.Box
    Image1: Laya.Image
    Text1: Laya.Label
    lb_time: Laya.Label
    eff_bg : Laya.Image
    AddProgressEffect
    AddTween
    CheckCostAndShowAlert
    CheckCostEnough
    CheckOverTime
    ClearTimer
    ClearTween
    CustomMehod
    Dispose
    Emp_btn_gashapon_auto
    Emp_btn_gashapon_once
    Emp_con_record1
    Emp_con_record2
    InitEffectMats
    InitEvent
    LoadSuccess
    OpenRewardPreView
    Out_free_0
    Out_lbl_luck
    Out_name_0
    Out_name_01
    PlayAnimAndSendProto
    PlayGashaponAnimation
    ReOpen_callback
    RemoveTimer
    SetEffectMask
    SetMaskRectParam
    ShowCostAlert
    ShowGoodsNotEnoughAlert
    UdpateShowItems
    UpdateBtn
    UpdateProgress
    UpdateView
    _pos_list
    act_type
    cost_need_num
    cost_type_id
    end_time
    is_play_anim
    item_sorting_order
    mats
    max_slider_value
    onTimer
    start_posY
    tween_id

    DIAMOND_COST = 40
    ComActRecordType = {
        this_record: 2,
        all_record: 1
    }

    // 消耗原因，检测优先级 低->高
    CostNotEnoughReason = {
        None: 0,
        GoodsEnough: 1,
        DiamondEnough: 2,
        DiamondNotEnough: 3,
    }
    public constructor(parent?) {
        super(parent)

        this._pos_list = [{ size: 95, count: 3 }, { size: 70, count: 5 }, { size: 70, count: 6 }]
        this.act_type = 0
        this.base_file = "gashapon"
        this.layout_file = "GashaponMainView"
        this.layer_value = Enum_UILayer.UI
        let local_EVENT = CustomActivityDefine.EVENT
        let local_goodsmodel = GoodsModel.GetInstance()
        let _model = CustomActivityModel.GetInstance()
        let erlang_parser = ErlangParser.GetInstance()
        let custom_event = CustomActivityDefine.EVENT
        let local_Config = Config
        let _item_list = null
        let record_item = null
        let time_item = null
        let one_btn = null
        let ten_btn = null
        let rare_item_list = []
        let _data = null
        let info = null
        let local_Util = Util
        let _ac_item_loop_list = null
        let _ac_item_loop_mgr = null
        let record_index = this.ComActRecordType.all_record
        let count_time_id_
        let cost_reason = this.CostNotEnoughReason.None
        let timerid2
        this.preload_server_config = {
            "config_goods_price": false
        }
        this.load_callback = () => {
            CustomActivityModel.GetInstance().CloseACTRed(info.base_type, info.sub_type)
            _model.Fire(custom_event.SCMD_REQUEST, 33245, info.base_type, info.sub_type)
            if (PlatformManager.IsEyouThPlatform()) {
                SetAnchoredPositionX(this._lb_have, 318)
            }
            this.InitEvent()
            this.LoadSuccess()
        }

        this.ClearTimer = () => {
            if (count_time_id_) {
                GlobalTimerQuest.CancelQuest(count_time_id_)
                count_time_id_ = null
            }
        }

        this.OpenRewardPreView = () => {
            if (_data && _data.draw_list) {
                let list = []
                let reward
                for (let _tmpi in _data.draw_list) {
                    var reward_info = _data.draw_list[_tmpi]
                    let reward_str = reward_info.reward
                    if (reward_str) {
                        reward = erlang_parser.Parse(reward_str)[0]
                    }
                    let [type_id, lock] = local_goodsmodel.GetMappingTypeId(reward[0], reward[1])
                    // table.insert(list, { type_id: Number(reward[1]), g_id: reward_info.grade_id })
                    table.insert(list,[type_id,reward[2],lock,reward_info.grade_id])
                }
                if (list.length > 0) {
                    table.sort(list, (r1?, r2?) => {
                        if (r1[3] != r2[3]) {
                            return r1[3] < r2[3]
                        }
                        return false
                    })
                    //console.log("________排序")
                    //PrintTable(list)
                    _model.Fire(local_EVENT.OPEN_CUSTOM_VIEW, "CommonActRewardPreview", "customActivity", list, true)

                }
            }
        }
        this.ShowCostAlert = (is_auto?, ok_callback?) => {
            let show_alert = is_auto && "show_alert_auto" || "show_alert"
            let is_openAlert = _model.getKeyDicValue(info.base_type, info.sub_type, show_alert)

            if (is_openAlert == false) {
                return
            }

            let basic = local_goodsmodel.GetGoodsBasicByTypeId(this.cost_type_id)
            if (!basic) {
                return
            }
            let str1 = "是否进行扭蛋\n道具不足时消耗勾玉补齐<font color='#639c12'>（每个" + this.DIAMOND_COST + "勾玉）</font>"
            let str2 = "自动扭蛋<font color='#639c12'>10次</font>，获得大奖时<font color='#639c12'>停止</font>\n道具不足时消耗勾玉补齐<font color='#639c12'>（每个" + this.DIAMOND_COST + "勾玉）</font>"
            let str = is_auto && str2 || str1
            let show_alert_box = false
            let ok_func = () => {
                if (ok_callback) {
                    ok_callback()
                }
                if (show_alert_box) {
                    _model.setKeyDicValue(info.base_type, info.sub_type, show_alert, false)
                }
            }
            let check_alert = () => {
                show_alert_box = !show_alert_box
            }
            Alert.Show(str, Alert_Type.AlertTypeCheckBox, ok_func, null, null, null, null, null, check_alert)
        }

        this.InitEvent = () => {
            if (this._btn_reward) {
                Util.AddClickEvent(
                    this._btn_reward, () => {
                        if (_model.send_proto) { return }
                        this.OpenRewardPreView()
                    },
                    this,
                    true
                )
            }

            Util.AddClickEvent(
                this._img_passbg, () => {
                    let now_value = _model.getKeyDicValue(info.base_type, info.sub_type, "need_pass_anim")
                    _model.setKeyDicValue(info.base_type, info.sub_type, "need_pass_anim", !now_value)
                    now_value = _model.getKeyDicValue(info.base_type, info.sub_type, "need_pass_anim")
                    this._img_pass.visible = now_value
                },
                this,
                true
            )

            Util.AddClickEvent(
                this.Image, () => {
                    this.OpenRewardPreView()
                },
                this,
                true
            )

            Util.AddClickEvent(
                this._con_record1, () => {
                    record_index = this.ComActRecordType.all_record
                    record_item.ResetRecord(record_index)
                    this.UpdateView()
                },
                this,
                true
            )

            Util.AddClickEvent(
                this._con_record2, () => {
                    record_index = this.ComActRecordType.this_record
                    record_item.ResetRecord(record_index)
                    this.UpdateView()
                },
                this,
                true
            )

            this.BindEvent(
                _model,
                local_EVENT.UPDATE_VIEW, (base_type?, sub_type?) => {
                    if (info.base_type != base_type || info.sub_type != sub_type) {
                        return
                    }
                    _data = _model.GetActData(info.base_type, info.sub_type)
                    //this:UpdateView()
                    this.UpdateProgress()
                }
            )

            this.BindEvent(_model, CustomActivityDefine.EVENT.SEND_GASHAPON_OP, (base_type?, sub_type?) => {
                if (base_type == info.base_type && sub_type == info.sub_type) {
                    _model.Fire(custom_event.SCMD_REQUEST, 33246, info.base_type, info.sub_type, 1, 1, 1)
                }
            })

            this.BindEvent(_model, CustomActivityDefine.EVENT.STOP_AUTO, (base_type?, sub_type?) => {
                _model.send_proto = false
                if (base_type == info.base_type && info.sub_type == sub_type) {
                    _model.StopGashaponSendOp()
                }
            })

            this.CheckOverTime = () => {
                if (this.end_time) {
                    let duration_time = this.end_time - TimeUtil.getServerTime()
                    if (duration_time <= 0) {
                        Message.show("活动已关闭")
                        return true
                    }
                }
                return false
            }

            Util.AddClickEvent(
                this._btn_gashapon_once, () => {
                    if (this.CheckOverTime()) {
                        return
                    }
                    if (this.is_play_anim) { return }
                    if (_model.send_proto) { return }
                    //this:ShowCostAlert(null,() => {
                    // 第一步： 检查消耗
                    let is_pass = this.CheckCostAndShowAlert(false, () => {
                        // 用勾玉购买且勾玉足够
                        this.PlayAnimAndSendProto(false)
                    })
                    if (is_pass) {
                        // 播动画发送协议
                        this.PlayAnimAndSendProto(false)
                    }
                    //})
                },
                this,
                true
            )

            Util.AddClickEvent(
                this._btn_gashapon_auto, () => {
                    _model.ResetGashaponSendOp()
                    if (this.CheckOverTime()) {
                        return
                    }
                    if (this.is_play_anim) { return }
                    if (_model.send_proto) {
                        Message.show("请勿频繁点击")
                        return
                    }
                    //_model:StopGashaponSendOp()
                    //this:ShowCostAlert(true,() => {
                    // 第一步： 检查消耗
                    let is_pass = this.CheckCostAndShowAlert(true, () => {
                        // 用勾玉购买且勾玉足够
                        this.PlayAnimAndSendProto(true)
                    })
                    if (is_pass) {
                        // 播动画发送协议
                        this.PlayAnimAndSendProto(true)
                    }
                    //})
                },
                this,
                true
            )
        }

        /*
            物品不足提示框
        */
        this.ShowGoodsNotEnoughAlert = (is_auto?, diamond_callback?, fail_need_callback?) => {
            let cost_rate = is_auto && 10 || 1
            let have_num = local_goodsmodel.GetTypeGoodsNum(this.cost_type_id) || 0
            let price_info = this.preload_server_config["config_goods_price"][Number(this.cost_type_id)]
            let count = this.cost_need_num * cost_rate - have_num
            if (!price_info) {
                Message.show("物品不足，不能兑换~")
                return false
            }
            let price = price_info.price
            let total_price = count * price

            let auto_str = is_auto && "自动扭蛋10次，获得大奖时停止<br/>" || ""
            let basic = local_goodsmodel.GetGoodsBasicByTypeId(this.cost_type_id)
            let str = auto_str + HtmlColorTxt(basic.goods_name, "'#639c12'") + "还差" + HtmlColorTxt(count + '个', "'#639c12'") + "<br/>是否消耗" + HtmlColorTxt(total_price + '勾玉', "'#639c12'") + "自动购买"

            let is_check = false
            let show_alert = is_auto && "show_alert_auto" || "show_alert"
            let is_openAlert = _model.getKeyDicValue(info.base_type, info.sub_type, show_alert)
            if (is_openAlert != false) {
                let check_callback = () => {
                    is_check = is_check && false || true
                }
                Alert.Show(Util.StrToHTML(str), Alert_Type.AlertTypeCheckBox, () => {
                    if (is_check) {
                        _model.setKeyDicValue(info.base_type, info.sub_type, show_alert, false)
                    }
                    if (diamond_callback) {
                        diamond_callback()
                    }
                }, null, null, null, null, null, check_callback)
                // 展示对话框，终止连续动作，都当做单抽
                return false
            }
            return true
        }
        /*
            检查消耗且弹出不足对话框
        */
        this.CheckCostAndShowAlert = (is_auto?, diamond_callback?) => {
            let cost_rate = is_auto && 10 || 1
            let cost_reason = this.CheckCostEnough(is_auto)
            if (cost_reason == this.CostNotEnoughReason.DiamondEnough) {
                let have_num = local_goodsmodel.GetTypeGoodsNum(this.cost_type_id) || 0
                let price_info = this.preload_server_config["config_goods_price"][Number(this.cost_type_id)]
                let count = this.cost_need_num * cost_rate - have_num
                if (!price_info) {
                    Message.show("物品不足，不能兑换~")
                    return false
                }
                return this.ShowGoodsNotEnoughAlert(is_auto, diamond_callback)
            }
            else if (cost_reason == this.CostNotEnoughReason.DiamondNotEnough) {
                let show_alert = is_auto && "show_alert_auto" || "show_alert"
                let is_openAlert = _model.getKeyDicValue(info.base_type, info.sub_type, show_alert)
                if (is_openAlert != false) {
                    this.ShowGoodsNotEnoughAlert(is_auto, () => {
                        Alert.Show("勾玉不足，是否前往充值？", Alert_Type.Two, () => {
                            let state = CustomActivityModel.GetInstance().GetSuperGiftBuyState()
                            if(state){
                                OpenFun.OpenFunHandler(21)
                            }else{
                                OpenFun.OpenFunHandler(249)
                            }
                            // VipModel.GetInstance().Fire(VipModel.OPEN_VIEW, "RechargeView")
                        })
                    })
                } else {
                    Alert.Show("勾玉不足，是否前往充值？", Alert_Type.Two, () => {
                        let state = CustomActivityModel.GetInstance().GetSuperGiftBuyState()
                        if(state){
                            OpenFun.OpenFunHandler(21)
                        }else{
                            OpenFun.OpenFunHandler(249)
                        }
                        // VipModel.GetInstance().Fire(VipModel.OPEN_VIEW, "RechargeView")
                    })
                }
                return false
            } else {
                return true
            }
            return false
        }

        /*
            前提是cost验证后
        */
        this.PlayAnimAndSendProto = (is_auto?) => {

            let cost_rate = 1
            let auto = is_auto && 1 || 0

            if (is_auto) {
                _model.send_proto = true
                _model.ClearGashaponRewardList()
            }
            if (_model.getKeyDicValue(info.base_type, info.sub_type, "need_pass_anim")) {
                this.is_play_anim = false
                _model.PlayGashaponAutoAnimEnd()
                _model.Fire(custom_event.SCMD_REQUEST, 33246, info.base_type, info.sub_type, 1, 1, auto)
            } else {
                if (is_auto) {
                    _model.Fire(custom_event.SCMD_REQUEST, 33246, info.base_type, info.sub_type, 1, 1, auto)
                }
                this.PlayGashaponAnimation(false, () => {
                    this.is_play_anim = false
                    if (!is_auto) {
                        _model.Fire(custom_event.SCMD_REQUEST, 33246, info.base_type, info.sub_type, 1, 1, auto)
                    }
                    _model.PlayGashaponAutoAnimEnd()
                })
            }
        }

        /*
            消耗检查逻辑
        */
        this.CheckCostEnough = (is_auto?) => {
            let cost_rate = 1
            if (is_auto) {
                cost_rate = cost_rate * 10
            }
            let lack_num = 0
            var CheckDiamond = () => {
                let have_diamond = RoleManager.GetInstance().mainRoleInfo.jin
                if (lack_num > 0) {
                    cost_rate = lack_num
                }
                if (have_diamond >= (this.DIAMOND_COST * cost_rate)) {
                    return this.CostNotEnoughReason.DiamondEnough
                }
                return this.CostNotEnoughReason.DiamondNotEnough
            }
            cost_reason = this.CostNotEnoughReason.None
            if (this.cost_type_id && this.cost_need_num) {
                let have_num = local_goodsmodel.GetTypeGoodsNum(this.cost_type_id) || 0
                if (have_num >= (this.cost_need_num * cost_rate)) {
                    cost_reason = this.CostNotEnoughReason.GoodsEnough
                    return cost_reason
                } else {
                    lack_num = (this.cost_need_num * cost_rate) - have_num
                }
            }
            return CheckDiamond()
        }

        this.AddTween = () => {
            this.ClearTween()
            if (!this.tween_id) {
                this.tween_id = SYTweenLite.to(this, this.item_pos0, SYTweenLite.UiAnimationType.ANCHORED_POSY, this.start_posY + 5, 2, null, SYTweenFunc.PINGPONG, true)
            }
        }

        this.ClearTween = () => {
            if (this.tween_id) {
                SYTweenLite.Stop(this.tween_id)
                this.tween_id = null
            }
        }

        this.CustomMehod = (index?, _info?) => {
            info = _info
        }

        this.ReOpen_callback = () => {
            _model.send_proto = false
            this.AddProgressEffect()
        }

        this.AddProgressEffect = () => {
            // let cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
            // this.item_sorting_order = cur_sorting_order + 1
            // let data = {
            // custom_sorting_order = cur_sorting_order,
            // let load_call_back = (obj?) => {
                // UIEffect.ReplaceStencilShader(obj)
                // this.InitEffectMats(obj, world_rect, 0)
                this.UpdateProgress()
                // this.CoverEffect(this._lbl_luck, this.layer_value, cur_sorting_order + 1)
                // this.CoverEffect(this._con_effect2, this.layer_value, cur_sorting_order + 1)
            // }
            // }
            // this.AddUIEffect("UI_2043", this._con_effect, null, 5, true, load_call_back)

        }

        this.LoadSuccess = () => {
            _model.send_proto = false
            _model.ResetGashaponSendOp()
            this.max_slider_value = GetSizeDeltaX(this._effect_mask)
            // let world_rect = GetWorldCorners(this._effect_mask)

            this.AddProgressEffect()
            if (!info) {
                return
            }
            _data = _model.GetActData(info.base_type, info.sub_type)
            if (!_data) {
                return
            }

            _item_list = []
            this._img_pass.visible = _model.getKeyDicValue(info.base_type, info.sub_type, "need_pass_anim")
            if (!record_item) {
                record_item = _model.LoadActRecord(this._gp_record, info.base_type, info.sub_type, this.ComActRecordType.this_record,null,null,"#ffffff")
            }
            this.is_play_anim = false
            this.start_posY = this.item_pos0.y
            this.AddTween()
            this.UdpateShowItems(_data.draw_list)
            this.UpdateView()

            let actInfo = _model.GetActInfo(info.base_type, info.sub_type)
            this.end_time = actInfo.etime
            if (this.end_time) {
                timerid2 = GlobalTimerQuest.AddPeriodQuest(() => {
                    this.onTimer()
                }, 1)
                this.onTimer()
            }
        }

        this.InitEffectMats = (obj?, world_rect?, mask_id?) => {
            // this.mats = []
            // let renders = obj.GetComponentsInChildren(typeof (UnityEngine.Renderer))
            // let renders_length = renders.Length - 1
            // for (let i = 0; i <= renders_length; i++) {
            //     let mats = renders[i].sharedMaterials
            //     let mats_length = mats.Length - 1
            //     for (let j = 0; j <= mats_length; j++) {
            //         if (mats[j]) {
            //             mats[j].renderQueue = 3000 + i
            //             this.SetMaskRectParam(mats[j], world_rect)
            //             mats[j].SetFloat("_Stencil", mask_id || 1)
            //             table.insert(this.mats, mats[j])
            //         }
            //     }
            // }
        }

        this.SetEffectMask = (value?) => {
            if (!this.mats) {
                return
            }

            let width = this.max_slider_value * value
            SetSizeDeltaX(this._effect_mask, width)
            // LayoutRebuilder(this._effect_mask)
            // let world_rect = GetWorldCorners(this._effect_mask)
            // for (let _ = 0; _ < this.mats.length; _++) {
            //     var mat = this.mats[_]
            //     this.SetMaskRectParam(mat, world_rect)
            // }
        }

        this.SetMaskRectParam = (material?, world_rect?) => {
            let minX = (world_rect && world_rect[0].x) || -10
            let minY = (world_rect && world_rect[0].y) || -10
            let maxX = (world_rect && world_rect[2].x) || 10
            let maxY = (world_rect && world_rect[2].y) || 10
            material.SetFloat("_MinX", minX)
            material.SetFloat("_MinY", minY)
            material.SetFloat("_MaxX", maxX)
            material.SetFloat("_MaxY", maxY)
        }

        this.UpdateView = () => {
            this.UpdateBtn()
            ResManager.GetInstance().SetOutsideImageSprite(this, this._record_bg, GameResPath.GetIcon("gashapon", "hbnd_017"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.img_chassis, GameResPath.GetIcon("gashapon", "hbnd_008"), true)
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._Image, GameResPath.GetIcon("gashapon", "hbnd_008a"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.img_show_content, GameResPath.GetIcon("gashapon", "hbnd_012"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.img_progressbg, GameResPath.GetIcon("gashapon", "hbnd_0010"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.img_progress, GameResPath.GetIcon("gashapon", "hbnd_009"), true)
            ResManager.GetInstance().SetImageSprite(this, this.time_bg, "gashapon", "hbnd_016", false)

            this.UpdateProgress()

            if (record_index == this.ComActRecordType.all_record) {
                ResManager.GetInstance().SetImageSprite(this, this._select1, "common4", "ui_button_orange", true)
                ResManager.GetInstance().SetImageSprite(this, this._select2, "common4", "uian_003c", true)
                this._lbl_label.color='#9b572f'
                this._lbl_label1.color="#ffffff"
            } else {
                ResManager.GetInstance().SetImageSprite(this, this._select1, "common4", "uian_003c", true)
                ResManager.GetInstance().SetImageSprite(this, this._select2, "common4", "ui_button_orange", true)
                this._lbl_label1.color="#9b572f"
                this._lbl_label.color="#ffffff"
            }
        }

        this.UpdateProgress = () => {
            let have_num = local_goodsmodel.GetTypeGoodsNum(this.cost_type_id) || 0
            this._lb_have.text = have_num.toString() 

            if (_data) {
                this._lbl_luck.text = (_data.current_luck || 0) + "/" + (_data.max_luck || 1)
                //this.img_progress.fillAmount = (_data.current_luck || 0)/(_data.max_luck || 1)
                if(_data.current_luck==0){
                    this.img_progress.visible=false
                    // this.img_progress.mask.width=1/300 *510
                }else{
                    this.img_progress.visible=true
                    this.img_progress.mask.width= (_data.current_luck/_data.max_luck)*510
                }
                this.SetEffectMask((_data.current_luck || 0) / (_data.max_luck || 1))
            } else {
                this._lbl_luck.text = ""
                this.img_progress.mask.width=0
                // this.img_progress.fillAmount = 0
                this.SetEffectMask(0)
            }
        }

        this.UdpateShowItems = (list?) => {
            if (!list) { return }

            if (list) {
                table.sort(list, (item1?, item2?) => {
                    if (item1.grade_id != item2.grade_id) {
                        return item1.grade_id < item2.grade_id
                    }
                    return false
                })
            }

            let index = 1
            let len = list.length > 7 && 7 || list.length
            for (let i = 1; i <= len; i++) {
                let reward_info = list[i-1]
                let reward = reward_info.reward
                if (reward) {
                    reward = erlang_parser.Parse(reward)
                }
                let info = reward && reward[0] || null
                // is_nice 1: 大奖
                let item = _item_list[index]
                if (info) {
                    info.is_nice = reward_info.is_nice
                }
                if (info) {
                    if (!item) {
                        item = new GashaponMainItem(this["item_pos" + index])
                        //item:SetItemSize(posInfo.size, posInfo.size)
                        item.SetData(info, this._con_effect2, this.item_sorting_order)
                        item.Load()
                        _item_list[index] = item
                    }
                    index = index + 1
                }
            }
        }

        this.UpdateBtn = () => {
            let v = info
            if (!v) {
                return
            }
            let cond = _model.GetActCondition(v.base_type, v.sub_type, "info")
            if (!cond) {
                return
            }
            let key = null
            let parent = null
            let bg_source = null
            let num = null
            let btn_dic = []
            this._lb_have.text = ""
            if (cond.one_cost) {
                let cost = cond.one_cost[0]
                if (cost) {
                    let [type_id, lock] = local_goodsmodel.GetMappingTypeId(cost[0], cost[1])
                    this.cost_type_id = type_id
                    this.cost_need_num = Number(cost[2])
                    let basic = local_goodsmodel.GetGoodsBasicByTypeId(type_id)
                    if (basic) {
                        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cost_0, GameResPath.GetGoodsIconPath(basic.goods_icon))
                        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_have, GameResPath.GetGoodsIconPath(basic.goods_icon))
                    }
                    this._lb_cost_0.text = "x" + this.cost_need_num
                }
            }
        }

        this.onTimer = () => {
            if (this.end_time >= TimeUtil.getServerTime()) {
                this.lb_time.text = TimeUtil.timeConvert(this.end_time - TimeUtil.getServerTime(), "dd-hh/hh-mm/mm-ss")
            } else {
                this.lb_time.color = ColorUtil.TryParseHtmlString(Enum_ColorUtil_Dark.RED)
                this.lb_time.text = "已结束";
                this.RemoveTimer();
            }
        }

        this.RemoveTimer = () => {
            if (timerid2) {
                GlobalTimerQuest.CancelQuest(timerid2)
                timerid2 = null
            }
        }

        this.PlayGashaponAnimation = (is_auto?, play_end_cb?) => {
            //let data = {
            //	custom_sorting_order = cur_sorting_order,
            //	load_call_back =() => {
            //		this.CoverEffect(this.labelDisplay,this.layer_value,cur_sorting_order+1)
            //		this.CoverEffect(this._img_red,this.layer_value,cur_sorting_order+1)
            //	}
            //}
            if (!this._con_effect2) {
                return
            }
            this.is_play_anim = true
            _model.play_gashapon_auto_anim_end = false
            //this._con_effect.visible = true 
            this._con_effect2.visible = true
            this.eff_bg.visible=true
            this.AddUIEffect("UI_2036", this._con_effect2, null, 2, true, {
                // custom_sorting_order = this.item_sorting_order + 40
            })

            let play_end_call = play_end_cb
            this.ClearTimer()
            count_time_id_ = GlobalTimerQuest.AddDelayQuest(() => {
                //this._con_effect.visible = false 
                this._con_effect2.visible = false
                this.eff_bg.visible = false
                if (play_end_call) {
                    play_end_call()
                    play_end_call = null
                }
                //this:ClearUIEffect(this._con_effect)
                this.ClearUIEffect(this._con_effect2)
            }, 2)
        }

        this.Dispose = () => {
            _model.ResetGashaponSendOp()
            this.RemoveTimer()
            this.is_play_anim = false
            _model.ClearGashaponRewardList()
            this.ClearTimer()
            _ac_item_loop_list = []
            if (_ac_item_loop_mgr) {
                _ac_item_loop_mgr.DeleteMe()
            }
            if (_item_list) {
                for (let _tmpi in _item_list) {
                    var item = _item_list[_tmpi]
                    item.DeleteMe()
                }
            }
            _item_list = null
            if (record_item) {
                record_item.DeleteMe()
                record_item = null
            }
            if (ten_btn) {
                ten_btn.DeleteMe()
                ten_btn = null
            }
            if (one_btn) {
                one_btn.DeleteMe()
                one_btn = null
            }
            if (time_item) {
                time_item.DeleteMe()
                time_item = null
            }
            if (rare_item_list.length > 0) {
                for (let _tmpi in rare_item_list) {
                    var item = rare_item_list[_tmpi]
                    item.DeleteMe()
                }
                rare_item_list = []
            }
        }
    }
    public DeleteMe() {

        this.Dispose()
        super.DeleteMe()
    }


    public GetComponents() {
        [
            this.imgBg,
            this._record_bg,
            this._btn_reward,
            this._btn_ten,
            this._btn_one,
            this._con_record1,
            this._select1,
            this._lbl_label,
            this._con_record2,
            this._select2,
            this._lbl_label1,
            this._gp_record,
            this.countLb,
            this.img_chassis,
            this.img_show_content,
            this._con_item_list,
            this.item_pos0,
            this.Image,
            this.Image2,
            this.item_pos1,
            this.item_pos2,
            this.item_pos3,
            this.item_pos4,
            this.item_pos5,
            this.item_pos6,
            this.item_pos7,
            this.item_pos8,
            this.item_pos9,
            this.item_pos10,
            this.img_progressbg,
            this.img_progress,
            this._lbl_luck,
            this._img_passbg,
            this._img_pass,
            this._lbl_label11,
            this.time_bg,
            this._btn_gashapon_auto,
            this._bg_01,
            this._name_0,
            this._btn_gashapon_once,
            this._btn_0,
            this._bg_0,
            this._name_01,
            this._red_0,
            this._free_0,
            this._gp_cost_0,
            this._img_cost_0,
            this._lb_have_0,
            this._lb_cost_0,
            this._img_have,
            this._lb_have,
            this._con_effect,
            this._Image,
            this._effect_mask,
            this._con_effect2,
            this.Image1,
            this.Text1,
            this.lb_time,
            this.eff_bg 
        ]
            = this.GetChildrenByNames([

                "imgBg",
                "_record_bg",
                "_btn_reward",
                "_btn_ten",
                "_btn_one",
                "_con_record1",
                "_select1",
                "_lbl_label",
                "_con_record2",
                "_select2",
                "_lbl_label1",
                "_gp_record",
                "countLb",
                "img_chassis",
                "img_show_content",
                "_con_item_list",
                "item_pos0",
                "Image",
                "Image2",
                "item_pos1",
                "item_pos2",
                "item_pos3",
                "item_pos4",
                "item_pos5",
                "item_pos6",
                "item_pos7",
                "item_pos8",
                "item_pos9",
                "item_pos10",
                "img_progressbg",
                "img_progress",
                "_lbl_luck",
                "_img_passbg",
                "_img_pass",
                "_lbl_label11",
                "time_bg",
                "_btn_gashapon_auto",
                "_bg_01",
                "_name_0",
                "_btn_gashapon_once",
                "_btn_0",
                "_bg_0",
                "_name_01",
                "_red_0",
                "_free_0",
                "_gp_cost_0",
                "_img_cost_0",
                "_lb_have_0",
                "_lb_cost_0",
                "_img_have",
                "_lb_have",
                "_con_effect",
                "_Image",
                "_effect_mask",
                "_con_effect2",
                "Image1",
                "Text1",
                "lb_time",
                "eff_bg"
            ])
    }
}
window["GashaponMainView"] = GashaponMainView
