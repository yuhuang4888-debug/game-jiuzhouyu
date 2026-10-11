import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem";
import { EventName } from "../common/EventName";
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";
import { InstructionType } from "../common/InstructionType";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { LuaSoundManager } from "../common/SoundManager";
import { table } from "../common/table";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { AtlasUrl, SetHtmlCenter, Util } from "../util/Util";
import { RuneAwakeBagItem } from "./RuneAwakeBagItem";
import { RuneAwakenAttrItem } from "./RuneAwakenAttrItem";
import { RuneAwakenItem } from "./RuneAwakenItem";

export class RuneAwakenView extends BaseView1 {

    InitEvent
    UpdateEffecet
    DeleteCall
    LoadSuccess
    initItem
    tabTouchHandler
    updateView
    attrTouchHandler
    updateCost
    loop_mgr: LoopScrowViewMgr
    item_loop_mgr: LoopScrowViewMgr
    attr_loop_mgr: LoopScrowViewMgr
    _fight_show: FightingShowSmallItem
    public constructor() {
        super();
        this.base_file = "rune";
        this.layout_file = "RuneAwakenView";
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true;
        this.use_background = true;
        this.destroy_imm = true;
        this.click_bg_toClose = true;
        let _model = RuneModel.GetInstance(),
            local_Util = Util,
            local_Message = Message,
            local_RuneEvent = RuneEvent,
            goods_model = GoodsModel.GetInstance(),
            res_mgr = ResManager.GetInstance(),
            _item_arr_: Laya.List,
            _attr_arr_: Laya.List,
            bagArr_: Laya.List,
            _item_: EquipmentItem,
            _select_index_ = -1,
            _select_attr_ = 0,
            _tab_list_ = [],
            costItemList_ = [],
            canAwaken_ = false,
            fullAwaken_ = false,
            isBag_ = false,
            tabTouch_ = true,
            allSelect_ = false,
            _selectId_,
            awakeList_,
            bagLength_ = 0

        this.preload_server_config = {
            "config_rune_wake_up_lv": false,
            "config_rune_wake_up_exp": false,
            "config_rune_wake_up": false,
			"config_rune_attr_coefficient": false
        }

        this.load_callback = function () {
            this.InitEvent();
            this.LoadSuccess();
        }
        this.close_callback = function () {
            this.DeleteCall()
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_close, () => {
                this.Close();
            }, this, true);

            local_Util.AddClickEvent(this._btn, () => {
                if (fullAwaken_) {
                    local_Message.show("觉醒等级已满");
                    return;
                }
                // if (!canAwaken_) {
                //     local_Message.show("物品不足");
                //     return;
                // }
                let list = []
                for (let key in _model.awakeSelect) {
                    if (_model.awakeSelect[key]) {
                        list.push(key)
                    }
                }
                if (list.length == 0) {
                    local_Message.show(`未选择吞噬御魂`)
                    return
                }
                _model.Fire(local_RuneEvent.RUNE_AWAKEN, this._attr_list.selectedItem.goods_id, this._attr_list.selectedItem[0], list);
            }, this, true);

            this.BindEvent(_model, local_RuneEvent.RUNE_AWAKEN_RETURN, (id, vo, changeLv) => {
                if (vo && awakeList_) {
                    let up = false
                    let list = vo.attr_list || vo.awake_list
                    if (list) {
                        if (awakeList_.length == 0 && list.length > 0) {
                            up = true
                        } else {
                            for (let awakeInfo of list) {
                                for (let oldInfo of awakeList_) {
                                    if ((oldInfo.attr_type || oldInfo.attr_id) == (awakeInfo.attr_type || awakeInfo.attr_id) && awakeInfo.awake_lv > oldInfo.awake_lv) {
                                        up = true
                                        break
                                    }
                                }
                            }
                        }
                    }
                    if (up) {
                        this.UpdateEffecet();
                    }
                    awakeList_ = vo.awake_list || vo.attr_list
                }
                this.updateView();
            });

            local_Util.AddClickEvent(this.selectGp, () => {
                if (bagLength_ == 0) return
                allSelect_ = !allSelect_
                this.selectImg.skin = allSelect_ ? AtlasUrl("common4", "ui_26_2") : AtlasUrl("common4", "ui_26")
                let goodsList = this.loop_mgr.data_list
                if (allSelect_) {
                    for (let vo of goodsList) {
                        if (vo&&!vo.is_faker) {
                            _model.awakeSelect[vo.goods_id] = true
                        }
                    }
                } else {
                    _model.awakeSelect = {}
                }
                _model.Fire(local_RuneEvent.SELECT_AWAKE_MAT)
            }, this, true)

            local_Util.AddClickEvent(this.tipsImg, () => {
                GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.RuneAwake)
            }, this, true)

            this.BindEvent(_model, local_RuneEvent.SELECT_AWAKE_MAT, () => {
                if (bagLength_ > 0) { 
                    if (local_Util.TableSize(_model.awakeSelect) == bagLength_) { 
                        allSelect_ = true; this.selectImg.skin = AtlasUrl("common4", "ui_26_2") 
                    } else if (allSelect_) {
                         allSelect_ = false; this.selectImg.skin = AtlasUrl("common4", "ui_26")
                    }
                }
            })

            this.BindEvent(goods_model, GoodsModel.CHANGE_RUNE_BAG_LIST, () => {
                if (!this.use_delete_method) {
                    let selectIndex
                    let selectData = this._attr_list.selectedItem;
                    if (selectData) {
                        let bagList = _model.RuneAwakeBagList(_selectId_, RuneModel.RuneAttrToSubType[selectData[0]] || selectData[0])
                        let haveList = {}
                        for (let vo of bagList) {
                            haveList[vo.goods_id] = true
                        }
                        for (let i = 0; i < this.bagGp.numChildren; i++) {
                            let item: RuneAwakeBagItem = <RuneAwakeBagItem>this.bagGp.getChildAt(i)
                            if (item && item[`data`] && !haveList[item[`data`].goods_id]) {
                                item["base_item"].AddUIEffect("ui_achievementglow1", item.awakeExpGp, undefined, 0.75, undefined, undefined, undefined, undefined, undefined, false)
                            }
                        }
                    }
                    _tab_list_ = _model.GetRunesAwakenInBag();
                    for (let i = 0; i < _tab_list_.length; i++) {
                        if (_tab_list_[i].goods_id == _selectId_) {
                            selectIndex = i
                            break
                        }
                    }
                    this.item_loop_mgr.replaceAll(_tab_list_);
                    if (selectIndex != undefined) {
                        this._item_list.selectedIndex = selectIndex
                        if (selectIndex > 2) {
                            let value = (RuneAwakenItem._WIDTH) * (selectIndex + 1) - this._item_list.width
                            this._item_list.scrollTo(selectIndex)
                        }
                    }
                    this.updateCost()
                }
            })

            let update_fun = () => {
				this.updateView();
			};
			this.BindEvent(_model, RuneEvent.UPDATE_RUNE_DATA, update_fun);
        }

        this.DeleteCall = () => {
            _item_arr_ = undefined;
            _attr_arr_ = undefined;
            _tab_list_ = [];
            for (let key in costItemList_) {
                let item = costItemList_[key];
                item.DeleteMe();
            }
            costItemList_ = [];
            canAwaken_ = false;
            if (_item_) {
                _item_.DeleteMe()
                _item_ = null
            }

            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe()
                this.loop_mgr = undefined
            }
            if (this.item_loop_mgr) {
                this.item_loop_mgr.DeleteMe()
                this.item_loop_mgr = undefined
            }
            if (this.attr_loop_mgr) {
                this.attr_loop_mgr.DeleteMe()
                this.attr_loop_mgr = undefined
            }
            if (this._fight_show) {
				this._fight_show.DeleteMe()
				this._fight_show = null
			}
        }

        this.LoadSuccess = () => {
            // res_mgr.SetTexture(this, this._bg, "resource/game/common/texture/uisy_023.png");
            // res_mgr.SetTexture(this, this._img, "resource/game/rune/texture/ui_rare_09.jpg");
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img, GameResPath.GetIcon("rune", "ui_rare_09"))
            this._attr_list.scrollBar.visible = false
            this.bagGp.scrollBar.visible = false
            this._item_list.scrollBar.visible = false

            this.initItem();
        }

        this.initItem = () => {
            _tab_list_ = _model.GetRunesAwakenInBag();
            let config_rune_wake_up_lv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_wake_up_lv", false)
			let config_rune_wake_up_exp = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_wake_up_exp", false)
			let config_rune_wake_up = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_wake_up", false)

            let index = _model.RuneAwakeTabIndex(_tab_list_, config_rune_wake_up, config_rune_wake_up_exp, config_rune_wake_up_lv);

            if (!this.item_loop_mgr) {
                this.item_loop_mgr = new LoopScrowViewMgr()
                this.item_loop_mgr.SetData(this._item_list, RuneAwakenItem, _tab_list_, LoopScrCon.Horizontal, 1, (index?) => {
                    this.tabTouchHandler(index)
                })
                this._item_list.selectedIndex = index
            } else {
                this.item_loop_mgr.replaceAll(_tab_list_)
            }
            this._item_list.scrollTo(index)
            this.updateView();
        }

        this.tabTouchHandler = (index) => {
            if (index == _select_index_) return;
            _select_index_ = index;
            let data = this.item_loop_mgr.data_list[index]
            if (data){
                _model.attr_select_index = 0
                _selectId_ = this.item_loop_mgr.data_list[index].goods_id
                _model.awake_select_goods_id = _selectId_
                awakeList_ = data.awake_list || data.attr_list
                tabTouch_ = true;
                this.updateView();
            }
        }

        this.updateView = () => {
            if (!this._fight_show) {
				this._fight_show = new FightingShowSmallItem(this._fight_con);
				this._fight_show.Load();
				this._fight_show.ExcuteCallback(() => {
				});
			}
            this._fight_show.Updatefighting(0);
            this._fight_show.UpdatefightingUp(0);
            this._fight_show.IsCenter(true, false);
            if (!_item_) {
                _item_ = new EquipmentItem(this._gp_show);
                _item_.SetItemSize(85, 85);
                _item_.Load();
                _item_.SetShowTips(false)
            }
            allSelect_ = false
            this.selectImg.skin = AtlasUrl("common4", "ui_26")
            _model.awakeSelect = {}
            let info = _tab_list_[this._item_list.selectedIndex];
            if (!info) return;
            let goods_id = info.goods_id;
            let awakenDic = {};
            let awaken = false
            let awakenList = info.attr_list ? info.attr_list : info.awake_list;
            for (let key in awakenList) {
                let awakeninfo = awakenList[key];
                if (awakeninfo.awake_lv > 0)
                    awaken = true;
                let attr_id = awakeninfo.attr_id ? awakeninfo.attr_id : awakeninfo.attr_type;
                awakenDic[attr_id] = [awakeninfo.awake_lv, awakeninfo.awake_exp, awakeninfo.cur_power, awakeninfo.next_power];
            }
            this._img_awaken.visible = awaken;
            isBag_ = info.subtype != undefined;
            if (!isBag_) {
                let goos_vo = goods_model.GetGoodsBasicByTypeId(info.goods_type_id);
                if (goos_vo)
                    info = goos_vo;
            }
            // this._lb_name.text = `${info.goods_name}`;
            this._lb_name.style.fontSize = 24
            this._lb_name.innerHTML = Util.StrToHTML(GoodsModel.GetGoodsNameWithColorDark(info.type_id))
            SetHtmlCenter(this._lb_name, {x:0, w:657})

            _item_.SetData(info.type_id);

            let attr_coefficient = res_mgr.GetGameConfigFromCache(this, "config_rune_attr_coefficient", false);
            let attrConfig
            if (attr_coefficient) {
                attrConfig = attr_coefficient[`${info.subtype}@${info.color}`]
            }
            if (!attrConfig) {
                return
            }
            let attrList = JSON.parse(attrConfig.attr_coefficient_list);
            if (attrList){
                let sort_fun = (a?, b?) => {
                    return a[0] - b[0]
                }
                attrList.sort(sort_fun)
                for (let i = attrList.length - 1; i >= 0; i--) {
                    let attrInfo = attrList[i];
                    if (attrInfo[0] == 27 || attrInfo[0] == 28 || attrInfo[0] == 17 || attrInfo[0] == 45) {
                        attrList.splice(i, 1)
                        continue
                    }
                    attrInfo["sub_type"] = attrConfig.sub_type;
                    attrInfo["quality"] = attrConfig.quality;
                    attrInfo["goods_id"] = goods_id;
                    attrInfo["type_id"] = info.type_id;
                    let awake_lv = awakenDic[attrInfo[0]] ? awakenDic[attrInfo[0]][0] : 0
                    let awake_exp = awakenDic[attrInfo[0]] ? awakenDic[attrInfo[0]][1] : 0
                    let cur_power = awakenDic[attrInfo[0]] ? awakenDic[attrInfo[0]][2] : 0
                    let next_power = awakenDic[attrInfo[0]] ? awakenDic[attrInfo[0]][3] : 0
                    attrInfo["awake_lv"] = awake_lv;
                    attrInfo["awake_exp"] = awake_exp;
                    attrInfo["cur_power"] = cur_power;
                    attrInfo["next_power"] = next_power;
                    attrInfo["isBag"] = isBag_;
                }
            }
            // _tab_list_ = _model.GetSoulsAwakenInBag();
            // if (!_attr_arr_) {
            //     _attr_arr_ = new Laya.ArrayCollection(attrList);
            //     this._attr_list.dataProvider = _attr_arr_;
            //     this._attr_list.itemRenderer = RuneAwakenAttrItem;
            //     this._attr_list.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.attrTouchHandler, this);
            //     tabTouch_ = true;
            // } else
            //     _attr_arr_.replaceAll(attrList);

                if (!this.attr_loop_mgr) {
                    this.attr_loop_mgr = new LoopScrowViewMgr()
                    this.attr_loop_mgr.SetData(this._attr_list, RuneAwakenAttrItem, attrList, LoopScrCon.Vertical, 1, (index?) => {
                        this.attrTouchHandler(index)
                    })
                    tabTouch_ = true;
                } else {
                    this.attr_loop_mgr.replaceAll(attrList)
                }

            if (tabTouch_) {
                let wakeuplvCfg = res_mgr.GetGameConfigFromCache(this, "config_rune_wake_up_lv", false)
                let runeExpCfg = res_mgr.GetGameConfigFromCache(this, "config_rune_wake_up_exp", false)
                let index = _model.souldAwakeAttrIndex(attrList, runeExpCfg, wakeuplvCfg);
                this._attr_list.selectedIndex = index;
                tabTouch_ = false;
            }
            _select_attr_ = this._attr_list.selectedIndex;
            this.updateCost();
        }


        this.attrTouchHandler = (index) => {
            if (index == _select_attr_) return;
            _select_attr_ = index;
            _model.awakeSelect = {}; 
            _model.attr_select_index = index
            _model.Fire(local_RuneEvent.SELECT_AWAKE_MAT); 
            allSelect_ = false; 
            this.selectImg.skin = AtlasUrl("common4", "ui_26")
            this.updateCost();
        }

        this.updateCost = () => {
            let data = this._attr_list.selectedItem; 
            if (!data) {
                return
            }
            let cur_power = data.cur_power ? data.cur_power : 0;
            let next_power = data.next_power ? data.next_power : 0;
            this._fight_show.Updatefighting(cur_power);
            if (next_power == 0) {
                this._fight_show.UpdatefightingUp(0);
                this._fight_show.IsCenter(true, false);
            } else {
                this._fight_show.UpdatefightingUp(next_power - cur_power);
                this._fight_show.SetPowerOffset(this._fight_show.display_obj.width / 4);
            }

            let soul_attr_num_cfg = res_mgr.GetGameConfigFromCache(this, "config_rune_wake_up", false);
            let costConfig = soul_attr_num_cfg[`${data["quality"]}@${data[0]}@${data["awake_lv"] + 1}`];
            this._red.visible = false;
            canAwaken_ = false;
            fullAwaken_ = !costConfig;
            let wakeuplvCfg = res_mgr.GetGameConfigFromCache(this, "config_rune_wake_up_lv", false)
            let runeExpCfg = res_mgr.GetGameConfigFromCache(this, "config_rune_wake_up_exp", false)
            // let NextLvExp = wakeuplvCfg[data.awake_lv + 1]

            let list = _model.RuneAwakeBagList(data.goods_id, RuneModel.RuneAttrToSubType[data[0]] || data[0])
            bagLength_ = list.length;
            //压入空数据
            let null_num = 0
            let max_num = this.bagGp.repeatX*this.bagGp.repeatY
            if(bagLength_<max_num){
                null_num = max_num - bagLength_
            }else{
                let temp = bagLength_%this.bagGp.repeatX
                null_num = temp=0? null_num+this.bagGp.repeatX:(this.bagGp.repeatX-temp)
            }

            for(let i=0;i<null_num;i++){
                table.insert(list,{color:999,is_faker:true})
            }

            
            //list.length = (Math.ceil(list.length / 6) + 2) * 6


            list.sort((a, b) => { return a.color - b.color })
            // bagArr_.source = list

            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this.bagGp, RuneAwakeBagItem, list, LoopScrCon.Vertical, 1)
            }else{
                this.loop_mgr.replaceAll(list)
            }



           
            // bagArr_.refresh()
            canAwaken_ = data.sub_type != undefined && _model.RuneAttrCanAwake(data.awake_lv, data.awake_exp || 0, data.goods_id, RuneModel.RuneAttrToSubType[data[0]] || data[0], runeExpCfg, wakeuplvCfg);

            this._red.visible = !fullAwaken_ && canAwaken_ && !isBag_;
        }

        this.UpdateEffecet = () => {
            this.AddUIEffect("ui_shengjichenggong_glow", this._group_eff)
        }
    }


_bg:Laya.Image
_Image1:Laya.Image
_img:Laya.Image
_Image2:Laya.Image
_btn_close:Laya.Image
tipsImg:Laya.Image
_Group1:Laya.Box
_img_title:Laya.Image
label1:Laya.Label
_Group2:Laya.Box
img2:Laya.Image
label0:Laya.Label
_attr_list:Laya.List
_Scroller1:Laya.Panel
_Group3:Laya.Box
_Image6:Laya.Image
label2:Laya.Label
_btn:Laya.Box
_Image111:Laya.Image
labelDisplay:Laya.Label
_Group4:Laya.Box
_Image9:Laya.Image
label3:Laya.Label
_Image11:Laya.Image
_Image0:Laya.Image
_tab_scroller:Laya.Panel
_item_list:Laya.List
_lb_name:Laya.HTMLDivElement
_gp_show:Laya.Box
bagGp:Laya.List
nothingLb:Laya.Label
_img_awaken:Laya.Image
_red:Laya.Image
selectGp:Laya.Box
selectImg:Laya.Image
_Label1:Laya.Label
_group_eff:Laya.Box
_fight_con: Laya.HBox
public GetComponents() {
[
this._bg,
this._Image1,
this._img,
this._Image2,
this._btn_close,
this.tipsImg,
this._Group1,
this._img_title,
this.label1,
this._Group2,
this.img2,
this.label0,
this._attr_list,
this._Scroller1,
this._Group3,
this._Image6,
this.label2,
this._btn,
this._Image111,
this.labelDisplay,
this._Group4,
this._Image9,
this.label3,
this._Image11,
this._Image0,
this._tab_scroller,
this._item_list,
this._lb_name,
this._gp_show,
this.bagGp,
this.nothingLb,
this._img_awaken,
this._red,
this.selectGp,
this.selectImg,
this._Label1,
this._group_eff,
this._fight_con,
]
 = this.GetChildrenByNames([

"_bg",
"_Image1",
"_img",
"_Image2",
"_btn_close",
"tipsImg",
"_Group1",
"_img_title",
"label1",
"_Group2",
"img2",
"label0",
"_attr_list",
"_Scroller1",
"_Group3",
"_Image6",
"label2",
"_btn",
"_Image111",
"labelDisplay",
"_Group4",
"_Image9",
"label3",
"_Image11",
"_Image0",
"_tab_scroller",
"_item_list",
"_lb_name",
"_gp_show",
"bagGp",
"nothingLb",
"_img_awaken",
"_red",
"selectGp",
"selectImg",
"_Label1",
"_group_eff",
"_fight_con",
])
}
}
 window["RuneAwakenView"]= RuneAwakenView