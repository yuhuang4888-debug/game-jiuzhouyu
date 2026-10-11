import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";
import { MaterialsTool } from "../common/MaterialsTool";
import { ModuleType } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { UIModelClass3D } from "../common/UIModelClass3D";
import { WordManager } from "../common/WordManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MarriageModel, MarriageEvent, MarriageDefine } from "../commonModel/MarriageModel";
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Runner } from "../util/Runner";
import { AtlasUrl, PlayBigEffect, Util } from "../util/Util";
import { Vector2 } from "../util/Vector2";

export class MarriageRingView extends BaseItem1 {

    private fight_num: FightingShowSmallItem;

    LoadSuccess
    InitEvent
    GetNextRingStarDataByInfo
    UpdateView
    setCost
    ClickBtnHandle
    UpdateMateState
    UpdateUM
    CreateStarByIndex
    UpdateStar
    UpdateProgress
    StartProAction
    ClearProAction
    UpdateAttrItems
    AddStarEffect
    Update
    FinishAction
    StartUpdate
    StopUpdate
    ShowAnimation
    ShowAnimation2
    init_pos = 0
    AddSuccessEffect
    public constructor(parent) {
        super(parent)
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageRingView"
        let _model = MarriageModel.GetInstance(),
            local_MarriageEvent = MarriageEvent,
            res_mgr = ResManager.GetInstance(),
            // local_egret = egret,
            local_MarriageDefine = MarriageDefine,
            local_GlobalEventSystem = GlobalEventSystem,
            local_EventName = EventName,
            goods_model = GoodsModel.GetInstance(),
            local_Util = Util,
            MARRIAGE_RING = ModuleType.MARRIAGE_RING,
            local_JSON = JSON,
            local_WordManager = WordManager,
            runner = Runner.GetInstance(),
            _um_ring_: UIModelClass3D,
            _cost_item_: BaseAwardItem,
            _res_id_,
            _attr_item_list_: Array<Laya.HTMLDivElement>,
            _star_item_list_: Array<Laya.Image>,
            _cost_type_id_,
            _sending_ = false,
            _timer_,
            _tween_speed_ = 361 / 0.7, //328像素(进度条总长度)需要0.7秒跑完
            _tweening_ = false,
            _next_pary_num_ = 0,
            _update_id_: number,
            _play_ani_count_: number,
            _cur_star_index_: number,
            _cur_stage_: number,
            _move_x_: number,
            _cur_move_x_: number,
            _cur_star_data_,
            _max_width_: number,
            _activate_ = false

        this.load_callback = function () {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("marriage", "ui_marry_bg2"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this.ring_icon, GameResPath.GetIcon("marriage", "UI_1801"))
            this.LoadSuccess()
            this.InitEvent()
        }

        this.DeleteMe = () => {
            Laya.Tween.clearAll(this)
            Laya.timer.clearAll(this)
            if (_attr_item_list_) {
                _attr_item_list_.length = 0
            }
            if (_star_item_list_) {
                _star_item_list_ = []

            }
            if (_cost_item_) {
                _cost_item_.DeleteMe()
                _cost_item_ = undefined
            }
            if (this.fight_num) {
                this.fight_num.DeleteMe()
                this.fight_num = null
            }
            if (this._group_heart) {
                let num = this._group_heart.numChildren
                let child: Laya.Node
                for (let i = 0; i < num; i++) {
                    child = this._group_heart.getChildAt(i)
                    if (child) {
                        child.removeSelf()
                    }
                }
            }
            this.ClearUIEffect(this.effect_box)
            // this.ClearProAction()
            this.StopUpdate()
            super.DeleteMe()
        }

        this.LoadSuccess = () => {
            this.scroll1.vScrollBar.visible = false
            this.scroll.vScrollBar.visible = false

            this.init_pos = this.ring_icon.y
            _model.Fire(local_MarriageEvent.REQUEST_PROTO, 17210)
            _attr_item_list_ = []
            _star_item_list_ = []
            this.ShowAnimation()
            this.UpdateMateState()

            // this.AddUIEffect("ui_progressbar_glow", this._group_eff_pro, null, null, true)
            _max_width_ = this._img_progress.width
        }

        this.InitEvent = () => {
            this.BindVar(_model, "_ring_info", (scmd, bool1, boo2, show_animation) => {
                this.UpdateView(show_animation)
            })

            this.BindVar(_model, "_mate_info", () => {
                this.UpdateMateState()
            })

            // this.BindEvent(_model, local_MarriageEvent.STOP_RING_UPGRADE, () => {
            //     this.ClickBtnHandle(false)
            // })

            // this.BindEvent(_model, local_MarriageEvent.RING_UPGRADE_SUCCESS, (over_count) => {
            //     let rinfo = _model.GetRingInfo()
            //     if (!rinfo) return
            //     let nsdata = this.GetNextRingStarDataByInfo()
            //     let max = nsdata ? nsdata.upgrade_pray_num : 0
            //     _next_pary_num_ = max
            //     this.StartProAction(rinfo.pray_num, max, over_count)
            // })

            // this.BindEvent(_model, local_MarriageEvent.RING_UPGRADE_STAR, (show) => {
            //     if (!show) return
            //     let rinfo = _model.GetRingInfo()
            //     if (!rinfo) return
            //     this.AddStarEffect(rinfo.star - 1)
            // })

            this.BindEvent(_model, local_MarriageEvent.RING_UPGRADE_SUCCESS, (old_stage, old_star) => {
                console.warn("RING_UPGRADE_SUCCESS------------：", old_stage, old_star)
                let rinfo = _model.GetRingInfo()
                if (!rinfo) return
                let nsdata = this.GetNextRingStarDataByInfo()
                let max = nsdata ? nsdata.upgrade_pray_num : 0
                _next_pary_num_ = max

                let count = (rinfo.stage - old_stage) * local_MarriageDefine.STAR_MAX_COUNT + (rinfo.star - old_star)
                _cur_move_x_ = 0
                _play_ani_count_ = count
                _cur_star_index_ = old_star
                _cur_stage_ = old_stage
                _cur_star_data_ = _model.GetNextRingStarData(old_stage, old_star)
                this.StartProAction(rinfo.pray_num, max, count)
                if (old_star == 0) {
                    _tweening_ = false
                    this.UpdateView()


                    let data = {
                        _type: 172,
                        id: _cur_stage_,
                      /*   cb: () => {
                            babyModel.Fire(local_BabyEvent.REQUEST_PROTO, 18214, "ci", 1, scmd.baby_id)
                        } */
                    }
                    OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data)
                    // local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageRingChangeView", _cur_stage_)
                    PlayBigEffect("ui_ZiTi_Jihuo")
                } else {
                    if (count > 0) {
                        let upstage = (rinfo.stage - old_stage) > 0
                        Laya.timer.frameOnce(5,this, this.AddSuccessEffect,[upstage])
                        //this.AddSuccessEffect(upstage)
                    }
                }
            })

            local_Util.AddClickEvent(this._btn_go, () => {
                let own = goods_model.GetTypeGoodsNum(_cost_type_id_)
                if (own > 0) {
                    _tweening_ = true
                    this.ClickBtnHandle()
                } else {
                    // Message.show("物品不足")
                    MaterialsTool.GetInstance().materialsTips(_cost_type_id_)
                }
            }, this, true)

            this.BindEvent(local_GlobalEventSystem, local_EventName.UPDATE_REDDOT, (mType, rType) => {
                if (mType != MARRIAGE_RING) return
                let type_id
                if (!_activate_) {
                    type_id = _model.GetConstantData(31)
                } else {
                    let costData = _model.GetConstantData(7)
                    type_id = local_JSON.parse(costData)[0][0]
                }
                this.setCost(type_id)
                this._reddot.visible = _model.CheckRedStatus(MARRIAGE_RING, 1)
            })
        }

        this.GetNextRingStarDataByInfo = () => {
            let rinfo = _model.GetRingInfo()
            if (!rinfo) return
            return _model.GetNextRingStarData(rinfo.stage, rinfo.star)
        }

        this.UpdateView = (show_animation = false) => {
            if (_tweening_) return
            let rinfo = _model.GetRingInfo()
            if (!rinfo) return
            // this._fight_item.Updatefighting(rinfo.ring_combat_power)
            if (!this.fight_num) {
                this.fight_num = new FightingShowSmallItem(this.fight_con)
                this.fight_num.Load()
            }
            this.fight_num.Updatefighting(rinfo.ring_combat_power)


            let sdata = _model.GetRingStarData(rinfo.stage, rinfo.star)
            let nsdata = this.GetNextRingStarDataByInfo()
            if (!sdata) return
            let attr_list = local_JSON.parse(sdata.marriage_attr)
            let nattr_list = nsdata ? local_JSON.parse(nsdata.marriage_attr) : []
            let attr_str = _model.GetRingAttrStr(attr_list, nattr_list, Enum_ColorUtil_Dark.GREEN)
            this._lb_sub_attr.style.color = "#663915"
            this._lb_sub_attr.style.fontSize = 22
            this._lb_sub_attr.style.bold = true
            this._lb_sub_attr.width = 195
            this._lb_sub_attr.style.leading = 10

            this._lb_sub_attr.innerHTML = local_Util.StrToHTML(attr_str)

            attr_list = local_JSON.parse(sdata.attr_list)
            nattr_list = nsdata ? local_JSON.parse(nsdata.attr_list) : []
            this.UpdateAttrItems(attr_list, nattr_list)
            // attr_str = _model.GetRingAttrStr(attr_list, nattr_list, Enum_ColorUtil_Light.GREEN)
            // this._lb_sub_attr.text = attr_str
            let num = 0;
            let type_id;
            let config = res_mgr.GetGameConfigFromCache(this, "config_ring_stage", false)
            let stage_data = _model.GetRingStageData(rinfo.stage, config)
            let show = true;
            _activate_ = rinfo.star != 0
            if (!_activate_) {
                this._lb_name.text = "未解锁"
                // this._img_text.skin =  AtlasUrl("marriage", "uijh_118b")
                this.txt.text = "道具数："
                this._lb_btn.text = "解锁"
                type_id = _model.GetConstantData(31)
                // num = Math.min(goods_model.GetTypeGoodsNum(type_id), 1);
                num = goods_model.GetTypeGoodsNum(type_id);
                show = false;
                _next_pary_num_ = 1;
            } else {
                this._lb_name.text = stage_data.name
                // this._img_text.skin = AtlasUrl("marriage", "uijh_118")
                this.txt.text = "培养值："
                this._lb_btn.text = "一键提升"
                let costData = _model.GetConstantData(7)
                type_id = local_JSON.parse(costData)[0][0]
                num = rinfo.pray_num;
                _next_pary_num_ = nsdata ? nsdata.upgrade_pray_num : 0
            }
            this._reddot.visible = _model.CheckRedStatus(MARRIAGE_RING, 1)
            this.UpdateUM(stage_data.resource_id)
            this.setCost(type_id)
            this.UpdateStar(rinfo.star)
            if (!show_animation) {
                this.UpdateProgress(num, _next_pary_num_, show)
            }
        }

        this.setCost = (type_id) => {
            if (!_cost_item_) {
                _cost_item_ = new BaseAwardItem(this._group_item)
                _cost_item_.Load()
                _cost_item_.SetItemSize(69, 69)
            }
            let own = goods_model.GetTypeGoodsNum(type_id)
            _cost_item_.ForceSetNumber(own)
            if (_cost_type_id_ == type_id) return;
            _cost_type_id_ = type_id
            _cost_item_.SetData(_cost_type_id_, own)
        }

        this.ClickBtnHandle = () => {
            if (_activate_)
                _model.Fire(local_MarriageEvent.REQUEST_PROTO, 17213)
            else
                _model.Fire(local_MarriageEvent.REQUEST_PROTO, 17211)
        }

        this.UpdateMateState = () => {
            let role_vo = RoleManager.GetInstance().GetMainRoleVo()
            let active = role_vo.is_marriage != 0
            this._img_active.visible = active
            this._img_lose.visible = !active
        }

        this.UpdateUM = (res_id) => {
            if (_res_id_ == res_id) return
            _res_id_ = res_id
            // this.AddUIEffect(res_id, this._group_um, null, null, true)

            this.ring_icon.skin = AtlasUrl("marriage", _res_id_)
        }

        this.CreateStarByIndex = (index): Laya.Image => {
            let image = _star_item_list_[index]
            if (!image) {
                image = new Laya.Image()
                this._group_heart.addChild(image)
                _star_item_list_[index] = image
            }
            return image
        }

        this.UpdateStar = (star) => {
            for (let i = 0; i < star; i++) {
                let image = this.CreateStarByIndex(i)
                image.skin = AtlasUrl("marriage", "uijh_112a")
            }
            for (let i = star; i < local_MarriageDefine.STAR_MAX_COUNT; i++) {
                let image = this.CreateStarByIndex(i)
                image.skin = AtlasUrl("marriage", "uijh_112b")
            }
        }

        this.UpdateProgress = (now, max, show = true) => {
            let can_up = max > 0
            this._group_eff_pro.visible = can_up && show
            this._group_eff_pro.x = can_up ? this._img_progress.x + (Math.min(now / max, 1) * _max_width_) : 0
            this._lb_progress.text = can_up ? `${now}/${max}` : "MAX"
            // this._img_progress.mask.width = can_up ? Math.min(now / max, 1) * _max_width_ : _max_width_
            let width = can_up ? Math.min(now / max, 1) * _max_width_ : _max_width_
            this._img_progress.width = width
            // this._img_progress.mask.graphics.clear()
            // this._img_progress.mask.graphics.drawRect(0, 0, width, this._img_progress.height, "#ffffff");

        }

        this.StartProAction = (now, max, over_count) => {
            let img = this._img_progress
            // let mask_width = this._img_progress.mask.width
            let mask_width = this._img_progress.width

            let width = max <= 0 || now <= 0 ? _max_width_ : now / max * _max_width_
            // let width = max <= 0 || now <= 0 ? img.width : now / max * _max_width_
            let move_x = mask_width > width ? _max_width_ - mask_width + width : width - mask_width

            _move_x_ = over_count ? (over_count - 1) * img.width + move_x : move_x
            this.StartUpdate()
        }

        this.ClearProAction = () => {
            // if (this._img_progress && this._img_progress.mask) {
            //     Laya.Tween.clearAll(this._img_progress.mask)
            // }
            if (this._img_progress && this._img_progress) {
                Laya.Tween.clearAll(this._img_progress)
            }
            if (this._group_eff_pro) {
                Laya.Tween.clearAll(this._group_eff_pro)
            }
        }

        this.UpdateAttrItems = (attr_list, nattr_list) => {
            if (!attr_list) return
            let dic = {}
            for (let i = 0; i < nattr_list.length; i++) {
                let attr = nattr_list[i]
                dic[attr[0]] = attr[1]
            }
            let str = ""
            for (let i = 0; i < attr_list.length; i++) {
                let attr = attr_list[i]
                let value = dic[attr[0]] || 0
                let pname = local_WordManager.GetProperties(attr[0])
                let dvalue = value - attr[1]
                value = local_WordManager.ConvertToPercentValue(attr[0], attr[1])
                if (dvalue > 0) {
                    let svalue = `&nbsp;+${local_WordManager.ConvertToPercentValue(attr[0], dvalue)}`
                    // svalue = local_Util.HtmlColorTxt(svalue, "'#ffffff'")
                    svalue = local_Util.HtmlColorTxt(svalue, Enum_ColorUtil_Dark.GREEN)

                    str = `${pname}:${value} ${svalue}`
                } else {
                    str = `${pname}:${value}`
                }
                let label = _attr_item_list_[i]
                if (!label) {
                    label = new Laya.HTMLDivElement()
                    _attr_item_list_[i] = label
                    label.x = i % 2 * 180
                    label.y = Math.floor(i / 2) * 30
                    this._group_attr.addChild(label)
                }
                label.width = 250
                label.style.fontSize = 22
                label.style.color = "#ffffff"
                label.innerHTML = local_Util.StrToHTML(str)
            }
        }

        this.AddStarEffect = (index) => {
            // let pos = { x: index * 31 + 15.5 + index * 6 + 0.8, y: 15 - 2 }
            // this.AddUIEffect("ui_Married_love", this._group_heart, pos, null, null, null, null, null, null, true)
        }

        //刷新进度长度/文字/特效位置
        //计算所需变化长度，大于目标长度即完成动画，否则根据升级数量添加特效和动画
        this.Update = (now_time, elapse_time) => {
            if (!_move_x_) { this.StopUpdate(); return; }
            _cur_move_x_ += _tween_speed_ * elapse_time
            console.warn("elapse_time----------:", elapse_time)
            if (_cur_move_x_ >= _move_x_) {
                this.FinishAction();
                return;
            } else {
                // let tar_width = this._img_progress.mask.width + _tween_speed_ * elapse_time
                let tar_width = this._img_progress.width + _tween_speed_ * elapse_time
                console.warn("tar_width----------:", tar_width, _max_width_)
                if (tar_width - 10 > _max_width_) {
                    _play_ani_count_--
                    let over = _cur_star_index_ + 1 > local_MarriageDefine.STAR_MAX_COUNT
                    _cur_star_index_ = over ? 1 : _cur_star_index_ + 1
                    if (over) { //进阶成功
                        _cur_stage_++
                        // local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageRingChangeView", _cur_stage_)
                    }
                    this.AddStarEffect(_cur_star_index_ - 1)
                    this.UpdateStar(_cur_star_index_)
                    // this._img_progress.mask.width = 0
                    // this._img_progress.mask.graphics.clear()
                    // this._img_progress.mask.graphics.drawRect(0, 0, 0, this._img_progress.height, "#ffffff");
                    this._img_progress.width = 0
                    this._group_eff_pro.x = 4

                    over = _cur_star_index_ + 1 > local_MarriageDefine.STAR_MAX_COUNT
                    let index = over ? 2 : _cur_star_index_ + 1
                    _cur_star_data_ = _model.GetRingStarData(_cur_stage_, index)
                } else {
                    // this._img_progress.mask.width = tar_width
                    // this._img_progress.mask.graphics.clear()
                    // this._img_progress.mask.graphics.drawRect(0, 0, tar_width, this._img_progress.height, "#ffffff");
                    this._img_progress.width = tar_width
                    this._group_eff_pro.x = 4 + tar_width
                    let max = _cur_star_data_.upgrade_pray_num
                    let now = Math.round(tar_width / _max_width_ * max)
                    this._lb_progress.text = `${now}/${max}`
                }
            }
        }

        this.AddSuccessEffect = (is_up_stage) => {
            if (this.use_delete_method) return
            if (is_up_stage) {
                PlayBigEffect("ui_ZiTi_ShengJie")
                this.AddUIEffect("ui_jinjiechenggong", this.stage_effect, new Vector2(2, -3), 3.5, false, undefined, undefined, undefined, this)
            } else {
                PlayBigEffect("ui_shengjitexiao")
                //this.AddUIEffect("ui_shengjitexiao", this.effect_box, new Vector2(0, 0), 3, false, 1.5, undefined, undefined, this)
            }

        }

        this.FinishAction = () => {
            _cur_star_data_ = undefined
            _tweening_ = false
            _move_x_ = 0
            _cur_move_x_ = 0
            this.StopUpdate()
            this.UpdateView()
        }

        this.StartUpdate = () => {
            if (!_update_id_) {
                _update_id_ = runner.AddRunObj(this, 1)
            }
        }

        this.StopUpdate = () => {
            if (_update_id_) {
                runner.RemoveRunObj(_update_id_)
                _update_id_ = undefined
            }
        }

        this.ShowAnimation = () => {
            Laya.Tween.to(this.ring_icon, { y: this.init_pos - 20 }, 800, Laya.Ease.sineInOut, Laya.Handler.create(this, () => {
                this.ShowAnimation2()
            }))
        }

        this.ShowAnimation2 = () => {
            Laya.Tween.to(this.ring_icon, { y: this.init_pos }, 800, Laya.Ease.sineInOut, Laya.Handler.create(this, () => {
                this.ShowAnimation()
            }))

        }
    }

_bg:Laya.Image
stage_effect:Laya.Box
fight_con:Laya.Box
_group_heart:Laya.HBox
group1:Laya.Box
img1:Laya.Image
_lb_name:Laya.Label
group2:Laya.Box
_img_113_2:Laya.Image
img2:Laya.Image
_img_active:Laya.Image
_img_lose:Laya.Image
label2:Laya.Label
scroll:Laya.Panel
group3:Laya.Box
_lb_sub_attr:Laya.HTMLDivElement
_group_um:Laya.Box
group4:Laya.Box
img4:Laya.Image
sxjc:Laya.Image
group5:Laya.Box
img5:Laya.Image
_img_progress:Laya.Image
_group_eff_pro:Laya.Box
_lb_progress:Laya.Label
txt:Laya.Label
_group_item:Laya.Box
_btn_go:Laya.Box
img6:Laya.Image
_lb_btn:Laya.Label
_reddot:Laya.Image
_btn_stop:Laya.Box
img7:Laya.Image
labnel7:Laya.Label
scroll1:Laya.Panel
_group_attr:Laya.Box
_lb_attr:Laya.Label
ring_icon:Laya.Image
effect_box:Laya.Box
public GetComponents() {
[
this._bg,
this.stage_effect,
this.fight_con,
this._group_heart,
this.group1,
this.img1,
this._lb_name,
this.group2,
this._img_113_2,
this.img2,
this._img_active,
this._img_lose,
this.label2,
this.scroll,
this.group3,
this._lb_sub_attr,
this._group_um,
this.group4,
this.img4,
this.sxjc,
this.group5,
this.img5,
this._img_progress,
this._group_eff_pro,
this._lb_progress,
this.txt,
this._group_item,
this._btn_go,
this.img6,
this._lb_btn,
this._reddot,
this._btn_stop,
this.img7,
this.labnel7,
this.scroll1,
this._group_attr,
this._lb_attr,
this.ring_icon,
this.effect_box,
]
 = this.GetChildrenByNames([

"_bg",
"stage_effect",
"fight_con",
"_group_heart",
"group1",
"img1",
"_lb_name",
"group2",
"_img_113_2",
"img2",
"_img_active",
"_img_lose",
"label2",
"scroll",
"group3",
"_lb_sub_attr",
"_group_um",
"group4",
"img4",
"sxjc",
"group5",
"img5",
"_img_progress",
"_group_eff_pro",
"_lb_progress",
"txt",
"_group_item",
"_btn_go",
"img6",
"_lb_btn",
"_reddot",
"_btn_stop",
"img7",
"labnel7",
"scroll1",
"_group_attr",
"_lb_attr",
"ring_icon",
"effect_box",
])
}
}
 window["MarriageRingView"]= MarriageRingView